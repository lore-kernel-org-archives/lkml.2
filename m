Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1BFXZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:25:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43866 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1BFXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:25:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 6 Feb 2011 15:19:58 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Nelson Elhage <nelhage@ksplice.com>
cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        security@kernel.org
Subject: Re: [PATCH] epoll: Prevent deadlock through unsafe ->f_op->poll()
 calls.
In-Reply-To: <20110206224508.GA13579@ksplice.com>
Message-ID: <alpine.DEB.2.00.1102061517370.3189@localhost6.localdomain6>
References: <1296954535-29495-1-git-send-email-nelhage@ksplice.com> <alpine.DEB.2.00.1102051916170.22851@localhost6.localdomain6> <alpine.DEB.2.00.1102061248420.3189@localhost6.localdomain6> <20110206224508.GA13579@ksplice.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011, Nelson Elhage wrote:

> Suppose thread A does epoll_ctl(e1, EPOLL_CTL_ADD, e2, evt) concurrently with
> thread B doing epoll_ctl(e2, EPOLL_CTL_ADD, e1, evt).
> 
> Since you do the recursive scan before grabbing ep->mtx, I think there is
> nothing to prevent the two scans from both succeeding, followed by the two
> inserts, so you end up with a cycle anyways.

Good point!


> One possibility is grabbing epmutex, or another global mutex, for both the scan
> and the duration of inserting one epoll fd onto another. That's really
> heavyweight, but maybe inserting an epoll fd onto another epoll fd is rare
> enough that it's Ok.

Yes, that'd be fine, since that is not a fast path.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 2 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2011-02-06 11:42:38.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2011-02-06 15:17:25.000000000 -0800
@@ -224,6 +224,9 @@
  */
 static DEFINE_MUTEX(epmutex);
 
+/* Used to check for epoll file descriptor inclusion loops */
+static struct nested_calls poll_loop_ncalls;
+
 /* Used for safe wake up implementation */
 static struct nested_calls poll_safewake_ncalls;
 
@@ -592,7 +595,6 @@
 	 */
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
-
 		ep_unregister_pollwait(ep, epi);
 	}
 
@@ -711,7 +713,6 @@
 
 	while (!list_empty(lsthead)) {
 		epi = list_first_entry(lsthead, struct epitem, fllink);
-
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
 		mutex_lock(&ep->mtx);
@@ -1198,6 +1199,82 @@
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
+					       ep, current);
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
+	int error;
+
+	/*
+	 * It needs to grab the @epmutex lock, before doing this.
+	 * This because two concurrent @ep_loop_check() might be going on,
+	 * resulting in a closed loop due to both @ep_loop_check() functions
+	 * succeeding:
+	 *
+	 * e1 = epoll_create();
+	 * e2 = epoll_create();
+	 *
+	 * THREAD-0                            THREAD-1
+	 *
+	 * epoll_ctl(e1, EPOLL_CTL_ADD, e2)    epoll_ctl(e2, EPOLL_CTL_ADD, e1)
+	 *
+	 */
+	mutex_lock(&epmutex);
+	error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+			       ep_loop_check_proc, file, ep, current);
+	mutex_unlock(&epmutex);
+
+	return error;
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1287,6 +1364,15 @@
 	 */
 	ep = file->private_data;
 
+	/*
+	 * When we insert an epoll file descriptor, inside another epoll file
+	 * descriptor, there is the change of creating closed loops, which are
+	 * better be handled here, than in more critical paths.
+	 */
+	if (unlikely(is_file_epoll(tfile) && op == EPOLL_CTL_ADD &&
+		     ep_loop_check(ep, tfile) != 0))
+		goto error_tgt_fput;
+
 	mutex_lock(&ep->mtx);
 
 	/*
@@ -1441,6 +1527,12 @@
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
 
