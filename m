Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1ABHld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:41:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:36605 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1ABHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 193/260] tcp: Fix >4GB writes on 64-bit.
Date: Sun,  2 Jan 2011 02:18:09 -0500
Message-Id: <1293952756-15010-194-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:23:41.0854 (UTC) FILETIME=[FB7B0BE0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 01db403cf99f739f86903314a489fb420e0e254f upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/socket.h |    2 +-
 net/core/iovec.c       |    5 +++--
 net/ipv4/tcp.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 354cc56..1b5034a 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -314,7 +314,7 @@ extern int csum_partial_copy_fromiovecend(unsigned char *kdata,
 					  int offset, 
 					  unsigned int len, __wsum *csump);
 
-extern int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
+extern long verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr *address, int mode);
 extern int memcpy_toiovec(struct iovec *v, unsigned char *kdata, int len);
 extern int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
 			     int offset, int len);
diff --git a/net/core/iovec.c b/net/core/iovec.c
index 1e7f4e9..b5b28f0 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -35,9 +35,10 @@
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
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4a638f0..1b40924 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -938,7 +938,7 @@ int tcp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	sg = sk->sk_route_caps & NETIF_F_SG;
 
 	while (--iovlen >= 0) {
-		int seglen = iov->iov_len;
+		size_t seglen = iov->iov_len;
 		unsigned char __user *from = iov->iov_base;
 
 		iov++;
-- 
1.7.3.3

