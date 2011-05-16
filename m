Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1EPH0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:26:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32813 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1EPH0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hNkYEnOVkHfEUrpbc+7+pso8bmRsu8um3tAeXyF8NQhANfUN9HoQnwqWWY9dvynNt2
         y1F2VLzyZZJDcGBSib4CbN2Bf1tdzykuAQoelPrZhf9yDBDNgz2GbuJ2ArzVZw4qWJu3
         /h3/KEEl5pejLsUehcGG3zDI2lUuy5p7TAIlc=
Subject: [PATCH net-next-2.6 v2] net: ping: dont call udp_ioctl()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: solar@openwall.com, segoon@openwall.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peak@argo.troja.mff.cuni.cz,
        kees.cook@canonical.com, dan.j.rosenberg@gmail.com, eugene@redhat.com,
        nelhage@ksplice.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
In-Reply-To: <20110515.174430.1379973540554096232.davem@davemloft.net>
References: <20110513200100.GA3875@albatros>
	 <1305447520.3120.88.camel@edumazet-laptop>
	 <20110515213018.GA26820@openwall.com>
	 <20110515.174430.1379973540554096232.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 09:26:31 +0200
Message-ID: <1305530791.3120.217.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 mai 2011 à 17:44 -0400, David Miller a écrit :

> Just get rid of ping_ioctl() entirely, as that is the effect of
> this change since inet_ioctl() returns -ENOIOCTLCMD when
> sk_prot->ioctl is NULL.
> 
> Also get rid of asm/ioctls.h since that will be no longer needed.

Sure, here is updated version, thanks.

[PATCH net-next-2.6 v2] net: ping: dont call udp_ioctl()

udp_ioctl() really handles UDP and UDPLite protocols.

1) It can increment UDP_MIB_INERRORS in case first_packet_length() finds
a frame with bad checksum.

2) It has a dependency on sizeof(struct udphdr), not applicable to
ICMP/PING

If ping sockets need to handle SIOCINQ/SIOCOUTQ ioctl, this should be
done differently.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
---
 net/ipv4/ping.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7041d09..41836ab 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -22,7 +22,6 @@
 
 #include <asm/system.h>
 #include <linux/uaccess.h>
-#include <asm/ioctls.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/socket.h>
@@ -609,23 +608,6 @@ do_confirm:
 	goto out;
 }
 
-/*
- *	IOCTL requests applicable to the UDP^H^H^HICMP protocol
- */
-
-int ping_ioctl(struct sock *sk, int cmd, unsigned long arg)
-{
-	pr_debug("ping_ioctl(sk=%p,sk->num=%u,cmd=%d,arg=%lu)\n",
-		inet_sk(sk), inet_sk(sk)->inet_num, cmd, arg);
-	switch (cmd) {
-	case SIOCOUTQ:
-	case SIOCINQ:
-		return udp_ioctl(sk, cmd, arg);
-	default:
-		return -ENOIOCTLCMD;
-	}
-}
-
 int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		 size_t len, int noblock, int flags, int *addr_len)
 {
@@ -735,7 +717,6 @@ struct proto ping_prot = {
 	.close =	ping_close,
 	.connect =	ip4_datagram_connect,
 	.disconnect =	udp_disconnect,
-	.ioctl =	ping_ioctl,
 	.setsockopt =	ip_setsockopt,
 	.getsockopt =	ip_getsockopt,
 	.sendmsg =	ping_sendmsg,


