Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2BVRmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:42:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab2BVRl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:41:59 -0500
Date: Wed, 22 Feb 2012 18:35:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] epoll: ep_unregister_pollwait() can use the freed
	pwq->whead
Message-ID: <20120222173505.GD7147@redhat.com>
References: <20120222173326.GA7139@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222173326.GA7139@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signalfd_cleanup() ensures that ->signalfd_wqh is not used, but
this is not enough. eppoll_entry->whead still points to the memory
we are going to free, ep_unregister_pollwait()->remove_wait_queue()
is obviously unsafe.

Change ep_poll_callback(POLLFREE) to set eppoll_entry->whead = NULL,
change ep_unregister_pollwait() to check pwq->whead != NULL before
remove_wait_queue(). We add the new ep_remove_wait_queue() helper
for this.

However this needs more locking. ep_remove_wait_queue() should take
ep->lock first to avoid the race and pin pwq->whead, then it needs
pwq->whead->lock for __remove_wait_queue().

This can obviously AB-BA deadlock with wake_up()->ep_poll_callback(),
so ep_remove_wait_queue() does the nasty lock + trylock-or-retry dance.

Of course, this also assumes that it is safe to take ep->lock in
ep_unregister_pollwait() paths, afaics this is true.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 442bedb..ac8bd15 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -320,6 +320,11 @@ static inline int ep_is_linked(struct list_head *p)
 	return !list_empty(p);
 }
 
+static inline struct eppoll_entry *ep_pwq_from_wait(wait_queue_t *p)
+{
+	return container_of(p, struct eppoll_entry, wait);
+}
+
 /* Get the "struct epitem" from a wait queue pointer */
 static inline struct epitem *ep_item_from_wait(wait_queue_t *p)
 {
@@ -467,6 +472,33 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+static void ep_remove_wait_queue(struct eventpoll *ep, struct eppoll_entry *pwq)
+{
+	for (;;) {
+		unsigned long flags;	/* probably unneeded */
+
+		spin_lock_irqsave(&ep->lock, flags);
+		/* can be cleared by ep_poll_callback(POLLFREE) */
+		if (!pwq->whead)
+			goto unlock;
+
+		/* _trylock to avoid the deadlock, retry if it fails */
+		if (!spin_trylock(&pwq->whead->lock))
+			goto unlock;
+
+		__remove_wait_queue(pwq->whead, &pwq->wait);
+		spin_unlock(&pwq->whead->lock);
+		pwq->whead = NULL;
+ unlock:
+		spin_unlock_irqrestore(&ep->lock, flags);
+
+		if (!pwq->whead)
+			break;
+
+		cpu_relax();
+	}
+}
+
 /*
  * This function unregisters poll callbacks from the associated file
  * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
@@ -481,7 +513,7 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
 		list_del(&pwq->llink);
-		remove_wait_queue(pwq->whead, &pwq->wait);
+		ep_remove_wait_queue(ep, pwq);
 		kmem_cache_free(pwq_cache, pwq);
 	}
 }
@@ -844,9 +876,12 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 
 	spin_lock_irqsave(&ep->lock, flags);
 
-	/* the caller holds eppoll_entry->whead->lock */
-	if ((unsigned long)key & POLLFREE)
-		list_del_init(&wait->task_list);
+	if ((unsigned long)key & POLLFREE) {
+		struct eppoll_entry *pwq = ep_pwq_from_wait(wait);
+		/* the caller holds pwq->whead->lock */
+		__remove_wait_queue(pwq->whead, wait);
+		pwq->whead = NULL;
+	}
 
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the
-- 
1.5.5.1


