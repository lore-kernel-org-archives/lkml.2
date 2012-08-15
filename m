Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2HOUXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:23:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62908 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2HOTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Nelson Elhage <nelhage@nelhage.com>, Dave Jones <davej@redhat.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 070/165] epoll: fix spurious lockdep warnings
Date: Wed, 15 Aug 2012 15:46:54 -0400
Message-ID: <1345060109-9187-71-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@nelhage.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d8805e633e054c816c47cb6e727c81f156d9253d upstream.

epoll can acquire recursively acquire ep->mtx on multiple "struct
eventpoll"s at once in the case where one epoll fd is monitoring another
epoll fd.  This is perfectly OK, since we're careful about the lock
ordering, but it causes spurious lockdep warnings.  Annotate the recursion
using mutex_lock_nested, and add a comment explaining the nesting rules
for good measure.

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

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/eventpoll.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 85c5a9f..34ca5ca 100644
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
@@ -454,13 +463,15 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
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
@@ -471,7 +482,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -660,7 +671,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -726,7 +737,7 @@ void eventpoll_release_file(struct file *file)
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		mutex_lock(&ep->mtx);
+		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
@@ -1123,7 +1134,7 @@ static int ep_send_events(struct eventpoll *ep,
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
 }
 
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
@@ -1218,7 +1229,7 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1360,7 +1371,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	}
 
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
-- 
1.7.12.rc2

