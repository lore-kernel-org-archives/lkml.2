Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2BXTO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:14:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957Ab2BXTOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:14:25 -0500
Date: Fri, 24 Feb 2012 20:07:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] epoll: ep_unregister_pollwait() can use the freed
	pwq->whead
Message-ID: <20120224190729.GC22287@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224190651.GA22287@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signalfd_cleanup() ensures that ->signalfd_wqh is not used, but
this is not enough. eppoll_entry->whead still points to the memory
we are going to free, ep_unregister_pollwait()->remove_wait_queue()
is obviously unsafe.

Change ep_poll_callback(POLLFREE) to set eppoll_entry->whead = NULL,
change ep_unregister_pollwait() to check pwq->whead != NULL under
rcu_read_lock() before remove_wait_queue(). We add the new helper,
ep_remove_wait_queue(), for this.

This works because sighand_cachep is SLAB_DESTROY_BY_RCU and because
->signalfd_wqh is initialized in sighand_ctor(), not in copy_sighand.
ep_unregister_pollwait()->remove_wait_queue() can play with already
freed and potentially reused ->sighand, but this is fine. This memory
must have the valid ->signalfd_wqh until rcu_read_unlock().

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c |   30 +++++++++++++++++++++++++++---
 fs/signalfd.c  |    6 +++++-
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 34bbfc6..ea54cde 100644
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
@@ -467,6 +472,18 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+static void ep_remove_wait_queue(struct eppoll_entry *pwq)
+{
+	wait_queue_head_t *whead;
+
+	rcu_read_lock();
+	/* If it is cleared by POLLFREE, it should be rcu-safe */
+	whead = rcu_dereference(pwq->whead);
+	if (whead)
+		remove_wait_queue(whead, &pwq->wait);
+	rcu_read_unlock();
+}
+
 /*
  * This function unregisters poll callbacks from the associated file
  * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
@@ -481,7 +498,7 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
 		list_del(&pwq->llink);
-		remove_wait_queue(pwq->whead, &pwq->wait);
+		ep_remove_wait_queue(pwq);
 		kmem_cache_free(pwq_cache, pwq);
 	}
 }
@@ -842,9 +859,16 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	/* the caller holds eppoll_entry->whead->lock */
-	if ((unsigned long)key & POLLFREE)
+	if ((unsigned long)key & POLLFREE) {
+		ep_pwq_from_wait(wait)->whead = NULL;
+		/*
+		 * whead = NULL above can race with ep_remove_wait_queue()
+		 * which can do another remove_wait_queue() after us, so we
+		 * can't use __remove_wait_queue(). whead->lock is held by
+		 * the caller.
+		 */
 		list_del_init(&wait->task_list);
+	}
 
 	spin_lock_irqsave(&ep->lock, flags);
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 79c1eea..7ae2a57 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -33,7 +33,11 @@
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
 	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
-
+	/*
+	 * The lockless check can race with remove_wait_queue() in progress,
+	 * but in this case its caller should run under rcu_read_lock() and
+	 * sighand_cachep is SLAB_DESTROY_BY_RCU, we can safely return.
+	 */
 	if (likely(!waitqueue_active(wqh)))
 		return;
 
-- 
1.5.5.1


