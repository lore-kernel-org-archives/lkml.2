Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0LLXxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:53:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab0LLXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [200/223] net: Limit socket I/O iovec total length to INT_MAX.
Message-Id: <20101212234826.C0167B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David S. Miller <davem@davemloft.net>

commit 8acfe468b0384e834a303f08ebc4953d72fb690a upstream.

This helps protect us from overflow issues down in the
individual protocol sendmsg/recvmsg handlers.  Once
we hit INT_MAX we truncate out the rest of the iovec
by setting the iov_len members to zero.

This works because:

1) For SOCK_STREAM and SOCK_SEQPACKET sockets, partial
   writes are allowed and the application will just continue
   with another write to send the rest of the data.

2) For datagram oriented sockets, where there must be a
   one-to-one correspondance between write() calls and
   packets on the wire, INT_MAX is going to be far larger
   than the packet size limit the protocol is going to
   check for and signal with -EMSGSIZE.

Based upon a patch by Linus Torvalds.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/compat.c     |   10 ++++++----
 net/core/iovec.c |   15 +++++++--------
 2 files changed, 13 insertions(+), 12 deletions(-)

Index: linux/net/compat.c
===================================================================
--- linux.orig/net/compat.c
+++ linux/net/compat.c
@@ -41,10 +41,12 @@ static inline int iov_from_user_compat_t
 		compat_size_t len;
 
 		if (get_user(len, &uiov32->iov_len) ||
-		   get_user(buf, &uiov32->iov_base)) {
-			tot_len = -EFAULT;
-			break;
-		}
+		    get_user(buf, &uiov32->iov_base))
+			return -EFAULT;
+
+		if (len > INT_MAX - tot_len)
+			len = INT_MAX - tot_len;
+
 		tot_len += len;
 		kiov->iov_base = compat_ptr(buf);
 		kiov->iov_len = (__kernel_size_t) len;
Index: linux/net/core/iovec.c
===================================================================
--- linux.orig/net/core/iovec.c
+++ linux/net/core/iovec.c
@@ -59,14 +59,13 @@ int verify_iovec(struct msghdr *m, struc
 	err = 0;
 
 	for (ct = 0; ct < m->msg_iovlen; ct++) {
-		err += iov[ct].iov_len;
-		/*
-		 * Goal is not to verify user data, but to prevent returning
-		 * negative value, which is interpreted as errno.
-		 * Overflow is still possible, but it is harmless.
-		 */
-		if (err < 0)
-			return -EMSGSIZE;
+		size_t len = iov[ct].iov_len;
+
+		if (len > INT_MAX - err) {
+			len = INT_MAX - err;
+			iov[ct].iov_len = len;
+		}
+		err += len;
 	}
 
 	return err;
