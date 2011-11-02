Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1KCBfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab1KCBfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:55 2011
Message-Id: <20111102221455.437927076@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nelson Elhage <nelhage@nelhage.com>,
        Jason Baron <jbaron@redhat.com>, Dave Jones <davej@redhat.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: [058/107] epoll: fix spurious lockdep warnings
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Nelson Elhage <nelhage@nelhage.com>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/eventpoll.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

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
@@ -452,13 +461,15 @@ static void ep_unregister_pollwait(struc
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
@@ -469,7 +480,7 @@ static int ep_scan_ready_list(struct eve
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -658,7 +669,7 @@ static int ep_read_events_proc(struct ev
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -724,7 +735,7 @@ void eventpoll_release_file(struct file
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		mutex_lock(&ep->mtx);
+		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
@@ -1120,7 +1131,7 @@ static int ep_send_events(struct eventpo
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
 }
 
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
@@ -1215,7 +1226,7 @@ static int ep_loop_check_proc(void *priv
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1357,7 +1368,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	}
 
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"


