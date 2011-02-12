Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1BLTFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:05:36 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51751 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1BLTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y2cezwjFk+aC/NWHzD1vo0eU3VDrBnECBSRcTUn9P5MKa+uC1IZqZUPoSLIPPm0A42
         6cHy199vYkGwPNMj5EVKk637/g8c/bvvJTDNMqFz5/y9YQUGRG8dyzB+67Y7Hmfoo6eG
         W2A5p5o45QxOTkTwbPEjOLLHJCSrOxRcYHPZk=
From: Nelson Elhage <nelhage@ksplice.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        security@kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH] epoll: Prevent creating circular epoll structures.
Date: Sat, 12 Feb 2011 14:03:35 -0500
Message-Id: <1297537415-29535-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.2.43.g36c08.dirty
In-Reply-To: <alpine.DEB.2.00.1102101700430.19682@localhost6.localdomain6>
References: <alpine.DEB.2.00.1102101700430.19682@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

On insert, check whether the inserted file is itself a struct epoll, and if so,
do a recursive walk to detect whether inserting this file would create a loop of
epoll structures, which could lead to deadlock.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
[nelhage@ksplice.com: Use epmutex to serialize concurrent inserts]
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 fs/eventpoll.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cc8a9b7..d159cb7 100644
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
@@ -224,6 +231,9 @@ static long max_user_watches __read_mostly;
  */
 static DEFINE_MUTEX(epmutex);
 
+/* Used to check for epoll file descriptor inclusion loops */
+static struct nested_calls poll_loop_ncalls;
+
 /* Used for safe wake up implementation */
 static struct nested_calls poll_safewake_ncalls;
 
@@ -1188,6 +1198,62 @@ retry:
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
@@ -1236,6 +1302,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
 	int error;
+	int did_lock_epmutex = 0;
 	struct file *file, *tfile;
 	struct eventpoll *ep;
 	struct epitem *epi;
@@ -1277,6 +1344,25 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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
@@ -1312,6 +1398,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
+	if (unlikely(did_lock_epmutex))
+		mutex_unlock(&epmutex);
+
 	fput(tfile);
 error_fput:
 	fput(file);
@@ -1431,6 +1520,12 @@ static int __init eventpoll_init(void)
 		EP_ITEM_COST;
 	BUG_ON(max_user_watches < 0);
 
+	/*
+	 * Initialize the structure used to perform epoll file descriptor
+	 * inclusion loops checks.
+	 */
+	ep_nested_calls_init(&poll_loop_ncalls);
+
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
 
-- 
1.7.2.43.g36c08.dirty

