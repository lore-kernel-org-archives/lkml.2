Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188Ab1FWSJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:09:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:34652 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab1FWRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Nelson Elhage <nelhage@ksplice.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 129/247] epoll: prevent creating circular epoll structures
Date: Thu, 23 Jun 2011 13:33:17 -0400
Message-Id: <1308850515-15242-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 22bacca48a1755f79b7e0f192ddb9fbb7fc6e64e upstream.

In several places, an epoll fd can call another file's ->f_op->poll()
method with ep->mtx held.  This is in general unsafe, because that other
file could itself be an epoll fd that contains the original epoll fd.

The code defends against this possibility in its own ->poll() method using
ep_call_nested, but there are several other unsafe calls to ->poll
elsewhere that can be made to deadlock.  For example, the following simple
program causes the call in ep_insert recursively call the original fd's
->poll, leading to deadlock:

 #include <unistd.h>
 #include <sys/epoll.h>

 int main(void) {
     int e1, e2, p[2];
     struct epoll_event evt = {
         .events = EPOLLIN
     };

     e1 = epoll_create(1);
     e2 = epoll_create(2);
     pipe(p);

     epoll_ctl(e2, EPOLL_CTL_ADD, e1, &evt);
     epoll_ctl(e1, EPOLL_CTL_ADD, p[0], &evt);
     write(p[1], p, sizeof p);
     epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);

     return 0;
 }

On insertion, check whether the inserted file is itself a struct epoll,
and if so, do a recursive walk to detect whether inserting this file would
create a loop of epoll structures, which could lead to deadlock.

[nelhage@ksplice.com: Use epmutex to serialize concurrent inserts]
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Reported-by: Nelson Elhage <nelhage@ksplice.com>
Tested-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/eventpoll.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..a8dfe21 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -63,6 +63,13 @@
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
  * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
+ * It is also acquired when inserting an epoll fd onto another epoll
+ * fd. We do this so that we walk the epoll tree and ensure that this
+ * insertion does not create a cycle of epoll file descriptors, which
+ * could lead to deadlock. We need a global mutex to prevent two
+ * simultaneous inserts (A into B and B into A) from racing and
+ * constructing a cycle without either insert observing that it is
+ * going to.
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -227,6 +234,9 @@ static int max_user_watches __read_mostly;
  */
 static DEFINE_MUTEX(epmutex);
 
+/* Used to check for epoll file descriptor inclusion loops */
+static struct nested_calls poll_loop_ncalls;
+
 /* Used for safe wake up implementation */
 static struct nested_calls poll_safewake_ncalls;
 
@@ -1182,6 +1192,62 @@ retry:
 	return res;
 }
 
+/**
+ * ep_loop_check_proc - Callback function to be passed to the @ep_call_nested()
+ *                      API, to verify that adding an epoll file inside another
+ *                      epoll structure, does not violate the constraints, in
+ *                      terms of closed loops, or too deep chains (which can
+ *                      result in excessive stack usage).
+ *
+ * @priv: Pointer to the epoll file to be currently checked.
+ * @cookie: Original cookie for this call. This is the top-of-the-chain epoll
+ *          data structure pointer.
+ * @call_nests: Current dept of the @ep_call_nested() call stack.
+ *
+ * Returns: Returns zero if adding the epoll @file inside current epoll
+ *          structure @ep does not violate the constraints, or -1 otherwise.
+ */
+static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
+{
+	int error = 0;
+	struct file *file = priv;
+	struct eventpoll *ep = file->private_data;
+	struct rb_node *rbp;
+	struct epitem *epi;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+		if (unlikely(is_file_epoll(epi->ffd.file))) {
+			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+					       ep_loop_check_proc, epi->ffd.file,
+					       epi->ffd.file->private_data, current);
+			if (error != 0)
+				break;
+		}
+	}
+	mutex_unlock(&ep->mtx);
+
+	return error;
+}
+
+/**
+ * ep_loop_check - Performs a check to verify that adding an epoll file (@file)
+ *                 another epoll file (represented by @ep) does not create
+ *                 closed loops or too deep chains.
+ *
+ * @ep: Pointer to the epoll private data structure.
+ * @file: Pointer to the epoll file to be checked.
+ *
+ * Returns: Returns zero if adding the epoll @file inside current epoll
+ *          structure @ep does not violate the constraints, or -1 otherwise.
+ */
+static int ep_loop_check(struct eventpoll *ep, struct file *file)
+{
+	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+			      ep_loop_check_proc, file, ep, current);
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1230,6 +1296,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
 	int error;
+	int did_lock_epmutex = 0;
 	struct file *file, *tfile;
 	struct eventpoll *ep;
 	struct epitem *epi;
@@ -1271,6 +1338,25 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 */
 	ep = file->private_data;
 
+	/*
+	 * When we insert an epoll file descriptor, inside another epoll file
+	 * descriptor, there is the change of creating closed loops, which are
+	 * better be handled here, than in more critical paths.
+	 *
+	 * We hold epmutex across the loop check and the insert in this case, in
+	 * order to prevent two separate inserts from racing and each doing the
+	 * insert "at the same time" such that ep_loop_check passes on both
+	 * before either one does the insert, thereby creating a cycle.
+	 */
+	if (unlikely(is_file_epoll(tfile) && op == EPOLL_CTL_ADD)) {
+		mutex_lock(&epmutex);
+		did_lock_epmutex = 1;
+		error = -ELOOP;
+		if (ep_loop_check(ep, tfile) != 0)
+			goto error_tgt_fput;
+	}
+
+
 	mutex_lock(&ep->mtx);
 
 	/*
@@ -1306,6 +1392,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
+	if (unlikely(did_lock_epmutex))
+		mutex_unlock(&epmutex);
+
 	fput(tfile);
 error_fput:
 	fput(file);
@@ -1424,6 +1513,12 @@ static int __init eventpoll_init(void)
 	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
+	/*
+	 * Initialize the structure used to perform epoll file descriptor
+	 * inclusion loops checks.
+	 */
+	ep_nested_calls_init(&poll_loop_ncalls);
+
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
 
-- 
1.7.4.4

