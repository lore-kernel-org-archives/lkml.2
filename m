Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1G0Afa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1G0AfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471175"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: ebiederm@xmission.com, dan@aloni.org, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [26/98] af_unix: Only allow recv on connected seqpacket sockets.
Message-Id: <20110727003518.6DA772403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric W. Biederman <ebiederm@xmission.com>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/unix/af_unix.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/unix/af_unix.c
===================================================================
--- linux-2.6.35.y.orig/net/unix/af_unix.c
+++ linux-2.6.35.y/net/unix/af_unix.c
@@ -504,6 +504,8 @@ static int unix_dgram_connect(struct soc
 			      int, int);
 static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t);
+static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
+				  struct msghdr *, size_t, int);
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -563,7 +565,7 @@ static const struct proto_ops unix_seqpa
 	.setsockopt =	sock_no_setsockopt,
 	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
-	.recvmsg =	unix_dgram_recvmsg,
+	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 };
@@ -1676,6 +1678,18 @@ static int unix_seqpacket_sendmsg(struct
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
