Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab0LHBEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:06 -0500
Received: from kroah.org ([198.145.64.141]:33842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab0LHBDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:55 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.731207874@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [263/289] net: Limit socket I/O iovec total length to INT_MAX.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 include/linux/socket.h |    2 +-
 net/compat.c           |   10 ++++++----
 net/core/iovec.c       |   20 +++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -322,7 +322,7 @@ extern int csum_partial_copy_fromiovecen
 					  int offset, 
 					  unsigned int len, __wsum *csump);
 
-extern long verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
+extern int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
 extern int memcpy_toiovec(struct iovec *v, unsigned char *kdata, int len);
 extern int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
 			     int offset, int len);
--- a/net/compat.c
+++ b/net/compat.c
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
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -35,10 +35,9 @@
  *	in any case.
  */
 
-long verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode)
+int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode)
 {
-	int size, ct;
-	long err;
+	int size, ct, err;
 
 	if (m->msg_namelen) {
 		if (mode == VERIFY_READ) {
@@ -60,14 +59,13 @@ long verify_iovec(struct msghdr *m, stru
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


