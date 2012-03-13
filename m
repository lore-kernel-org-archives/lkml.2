Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2CMAuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:50:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:48088 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868Ab2CMAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 110/196] af_unix: Only allow recv on connected seqpacket sockets.
Date: Mon, 12 Mar 2012 20:20:23 -0400
Message-Id: <1331598109-31424-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a05d2ad1c1f391c7f514a1d1e09b5417968a7d07 upstream.

This fixes the following oops discovered by Dan Aloni:

> Anyway, the following is the output of the Oops that I got on the
> Ubuntu kernel on which I first detected the problem
> (2.6.37-12-generic). The Oops that followed will be more useful, I
> guess.

>[ 5594.669852] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [ 5594.681606] IP: [<ffffffff81550b7b>] unix_dgram_recvmsg+0x1fb/0x420
> [ 5594.687576] PGD 2a05d067 PUD 2b951067 PMD 0
> [ 5594.693720] Oops: 0002 [#1] SMP
> [ 5594.699888] last sysfs file:

The bug was that unix domain sockets use a pseduo packet for
connecting and accept uses that psudo packet to get the socket.
In the buggy seqpacket case we were allowing unconnected
sockets to call recvmsg and try to receive the pseudo packet.

That is always wrong and as of commit 7361c36c5 the pseudo
packet had become enough different from a normal packet
that the kernel started oopsing.

Do for seqpacket_recv what was done for seqpacket_send in 2.5
and only allow it on connected seqpacket sockets.

Tested-by: Dan Aloni <dan@aloni.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/unix/af_unix.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 207a119..0b7148b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -503,6 +503,8 @@ static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t);
+static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
+				  struct msghdr *, size_t, int);
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -562,7 +564,7 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.setsockopt =	sock_no_setsockopt,
 	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
-	.recvmsg =	unix_dgram_recvmsg,
+	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 };
@@ -1666,6 +1668,18 @@ static int unix_seqpacket_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	return unix_dgram_sendmsg(kiocb, sock, msg, len);
 }
 
+static int unix_seqpacket_recvmsg(struct kiocb *iocb, struct socket *sock,
+			      struct msghdr *msg, size_t size,
+			      int flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return -ENOTCONN;
+
+	return unix_dgram_recvmsg(iocb, sock, msg, size, flags);
+}
+
 static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 {
 	struct unix_sock *u = unix_sk(sk);
-- 
1.7.9.3

