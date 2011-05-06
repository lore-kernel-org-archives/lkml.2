Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1EFA7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:59:39 -0400
Received: from kroah.org ([198.145.64.141]:36663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab1EFAYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:08 2011
Message-Id: <20110506002208.517979528@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [034/143] af_unix: Only allow recv on connected seqpacket sockets.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 net/unix/af_unix.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -503,6 +503,8 @@ static int unix_dgram_connect(struct soc
 			      int, int);
 static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t);
+static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
+				  struct msghdr *, size_t, int);
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -562,7 +564,7 @@ static const struct proto_ops unix_seqpa
 	.setsockopt =	sock_no_setsockopt,
 	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
-	.recvmsg =	unix_dgram_recvmsg,
+	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 };
@@ -1639,6 +1641,18 @@ static int unix_seqpacket_sendmsg(struct
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


