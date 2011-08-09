Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1HISO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:14:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51601 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HISO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:14:26 -0400
From: Nelson Elhage <nelhage@nelhage.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, linux-fsdevel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Nelson Elhage <nelhage@nelhage.com>,
        stable@kernel.org
Subject: [PATCH] epoll: Fix spurious lockdep warnings
Date: Tue,  9 Aug 2011 14:11:55 -0400
Message-Id: <1312913515-432-1-git-send-email-nelhage@nelhage.com>
X-Mailer: git-send-email 1.7.4.44.gf9e72
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E417891.010E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

epoll can acquire recursively acquire ep->mtx on multiple "struct
eventpoll"s at once in the case where one epoll fd is monitoring
another epoll fd. This is perfectly OK, since we're careful about the
lock ordering, but it causes spurious lockdep warnings. Annotate the
recursion using mutex_lock_nested, and add a comment explaining the
nesting rules for good measure.

Recent versions of systemd are triggering this, and it can also be
demonstrated with the following trivial test program:

--------------------8<--------------------

int main(void) {
   int e1, e2;
   struct epoll_event evt = {
       .events = EPOLLIN
   };

   e1 = epoll_create1(0);
   e2 = epoll_create1(0);
   epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
   return 0;
}
--------------------8<--------------------

Cc: stable@kernel.org
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
---
 fs/eventpoll.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..2acaf60 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -70,6 +70,15 @@
  * simultaneous inserts (A into B and B into A) from racing and
  * constructing a cycle without either insert observing that it is
  * going to.
+ * It is necessary to acquire multiple "ep->mtx"es at once in the
+ * case when one epoll fd is added to another. In this case, we
+ * always acquire the locks in the order of nesting (i.e. after
+ * epoll_ctl(e1, EPOLL_CTL_ADD, e2), e1->mtx will always be acquired
+ * before e2->mtx). Since we disallow cycles of epoll file
+ * descriptors, this ensures that the mutexes are well-ordered. In
+ * order to communicate this nesting to lockdep, when walking a tree
+ * of epoll file descriptors, we use the current recursion depth as
+ * the lockdep subkey.
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -464,13 +473,15 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
  * @ep: Pointer to the epoll private data structure.
  * @sproc: Pointer to the scan callback.
  * @priv: Private opaque data passed to the @sproc callback.
+ * @depth: The current depth of recursive f_op->poll calls.
  *
  * Returns: The same integer error code returned by the @sproc callback.
  */
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv)
+			      void *priv,
+			      int depth)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -481,7 +492,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -670,7 +681,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -737,7 +748,7 @@ void eventpoll_release_file(struct file *file)
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		mutex_lock(&ep->mtx);
+		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
@@ -1134,7 +1145,7 @@ static int ep_send_events(struct eventpoll *ep,
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1267,7 +1278,7 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1409,7 +1420,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	}
 
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
-- 
1.7.4.44.gf9e72

