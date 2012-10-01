Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab2JAXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:11:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35553 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab2JAXCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:34 -0400
Message-Id: <20121001225203.970661730@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 150/180] epoll: ep_unregister_pollwait() can use the freed pwq->whead
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 971316f0503a5c50633d07b83b6db2f15a3a5b00 upstream.

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
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/eventpoll.c |   30 +++++++++++++++++++++++++++---
 fs/signalfd.c  |    6 +++++-
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 15a7ef3..42f2c12 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -300,6 +300,11 @@ static inline int ep_is_linked(struct list_head *p)
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
@@ -434,6 +439,18 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
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
@@ -448,7 +465,7 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
 		list_del(&pwq->llink);
-		remove_wait_queue(pwq->whead, &pwq->wait);
+		ep_remove_wait_queue(pwq);
 		kmem_cache_free(pwq_cache, pwq);
 	}
 }
@@ -814,9 +831,16 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
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
index 6339cb4..02c25d7 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -32,7 +32,11 @@
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
1.7.2.1.45.g54fbc



