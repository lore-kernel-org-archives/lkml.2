Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab0JVSt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:49:27 -0400
Received: from kroah.org ([198.145.64.141]:45767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab0JVSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:59 2010
Message-Id: <20101022183559.422660646@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [36/66] tcp: Fix >4GB writes on 64-bit.
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 01db403cf99f739f86903314a489fb420e0e254f ]

Fixes kernel bugzilla #16603

tcp_sendmsg() truncates iov_len to an 'int' which a 4GB write to write
zero bytes, for example.

There is also the problem higher up of how verify_iovec() works.  It
wants to prevent the total length from looking like an error return
value.

However it does this using 'int', but syscalls return 'long' (and
thus signed 64-bit on 64-bit machines).  So it could trigger
false-positives on 64-bit as written.  So fix it to use 'long'.

Reported-by: Olaf Bonorden <bono@onlinehome.de>
Reported-by: Daniel Büse <dbuese@gmx.de>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/socket.h |    2 +-
 net/core/iovec.c       |    5 +++--
 net/ipv4/tcp.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -304,7 +304,7 @@ extern int csum_partial_copy_fromiovecen
 					  int offset, 
 					  unsigned int len, __wsum *csump);
 
-extern int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
+extern long verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
 extern int memcpy_toiovec(struct iovec *v, unsigned char *kdata, int len);
 extern int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
 			     int offset, int len);
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -36,9 +36,10 @@
  *	in any case.
  */
 
-int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode)
+long verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode)
 {
-	int size, err, ct;
+	int size, ct;
+	long err;
 
 	if (m->msg_namelen) {
 		if (mode == VERIFY_READ) {
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -935,7 +935,7 @@ int tcp_sendmsg(struct kiocb *iocb, stru
 		goto out_err;
 
 	while (--iovlen >= 0) {
-		int seglen = iov->iov_len;
+		size_t seglen = iov->iov_len;
 		unsigned char __user *from = iov->iov_base;
 
 		iov++;


