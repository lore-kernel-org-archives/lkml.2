Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2BEWux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:50:53 -0500
Received: from 1wt.eu ([62.212.114.60]:61811 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2BEW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:08 -0500
Message-Id: <20120205220949.876475817@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 10/91] af_unix: Only allow recv on connected seqpacket sockets.
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/unix/af_unix.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/net/unix/af_unix.c
===================================================================
--- longterm-2.6.27.orig/net/unix/af_unix.c	2012-02-05 22:34:34.711914871 +0100
+++ longterm-2.6.27/net/unix/af_unix.c	2012-02-05 22:34:36.344916818 +0100
@@ -501,6 +501,8 @@
 			      int, int);
 static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t);
+static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
+				  struct msghdr *, size_t, int);
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -560,7 +562,7 @@
 	.setsockopt =	sock_no_setsockopt,
 	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
-	.recvmsg =	unix_dgram_recvmsg,
+	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 };
@@ -1617,6 +1619,18 @@
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


