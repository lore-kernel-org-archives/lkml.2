Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1I3Bx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:53:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55006 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1I3Bx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:53:58 -0400
Date: Thu, 29 Sep 2011 20:53:42 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Nelson Elhage <nelhage@nelhage.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Jones <davej@redhat.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH 2/2] epoll: fix spurious lockdep warnings
Message-ID: <20110930015342.GB2455@elie.chipublib.org>
References: <20110930014334.GA2368@elie.chipublib.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930014334.GA2368@elie.chipublib.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@nelhage.com>
Date: Wed, 28 Sep 2011 10:50:51 +1000

epoll can acquire recursively acquire ep->mtx on multiple "struct
eventpoll"s at once in the case where one epoll fd is monitoring another
epoll fd.  This is perfectly OK, since we're careful about the lock
ordering, but it causes spurious lockdep warnings.  Annotate the recursion
using mutex_lock_nested, and add a comment explaining the nesting rules
for good measure.

Recent versions of systemd are triggering this, and it can also be
demonstrated with the following trivial test program:

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

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Taken from <git://github.com/sfrothwell/linux-next.git> (and I believe
Stephen got it from akpm's quilt queue somehow.  The patch seems to
have visited the list at [1] and then gone silent. :)  Anyway, it has
also been working well for me.

Thanks for reading.

[1] http://thread.gmane.org/gmane.linux.kernel/1177210

 fs/eventpoll.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index fe047d966dc5..2d1744ab5bcb 100644
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
1.7.7.rc1

