Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1EOISv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:18:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56377 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1EOISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JsH36wQuMsWp/hLvPGnYzhWlFwnKivbqwVKCLauGmVADBEBd79X3VDOihm8zBd0xF7
         4kgeiMxuDmzbam8/PRSK3rCxUvY5055l6Hv2TBanQBopJBWTkPNBxKmsLWurvewILnpq
         5BK5RGqidUnFgDyUVoAOgwextuuQQGY8F+Qhg=
Subject: [PATCH net-next-2.6] net: ping: dont call udp_ioctl()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Miller <davem@davemloft.net>, solar@openwall.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
In-Reply-To: <20110513200100.GA3875@albatros>
References: <20110510.121550.112583080.davem@davemloft.net>
	 <20110513200100.GA3875@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 10:18:40 +0200
Message-ID: <1305447520.3120.88.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 mai 2011 à 00:01 +0400, Vasiliy Kulikov a écrit :

> +/*
> + *	IOCTL requests applicable to the UDP^H^H^HICMP protocol
> + */
> +
> +int ping_ioctl(struct sock *sk, int cmd, unsigned long arg)
> +{
> +	pr_debug("ping_ioctl(sk=%p,sk->num=%u,cmd=%d,arg=%lu)\n",
> +		inet_sk(sk), inet_sk(sk)->inet_num, cmd, arg);
> +	switch (cmd) {
> +	case SIOCOUTQ:
> +	case SIOCINQ:
> +		return udp_ioctl(sk, cmd, arg);
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +}

Do we really need to support SIOCOUTQ and SIOCINQ ioctls for ping
sockets ?

I ask this because udp_ioctl() assumes it handles UDP frames, and can
change UDP_MIB_INERRORS in case first_packet_length() finds a frame with
bad checksum.

[ UDP let the checksum be completed and checked when it performs the
Kernel->User copy ]

I would just remove this legacy, please shout if you believe we really
should support ioctl...

[ I actually tested that ping was still working correctly, of course ]

BTW, link
(ftp://mirrors.kernel.org/openwall/Owl/current/sources/Owl/packages/iputils/iputils-ss020927.tar.gz ) provided in http://openwall.info/wiki/people/segoon/ping is not working.

I had to manually patch iputils-s20101006.tar.bz2 instead.

Thanks

[PATCH net-next-2.6] net: ping: dont call udp_ioctl()

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
 net/ipv4/ping.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7041d09..952505a 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -610,20 +610,15 @@ do_confirm:
 }
 
 /*
- *	IOCTL requests applicable to the UDP^H^H^HICMP protocol
+ *	IOCTL requests applicable to PING sockets
  */
 
 int ping_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	pr_debug("ping_ioctl(sk=%p,sk->num=%u,cmd=%d,arg=%lu)\n",
 		inet_sk(sk), inet_sk(sk)->inet_num, cmd, arg);
-	switch (cmd) {
-	case SIOCOUTQ:
-	case SIOCINQ:
-		return udp_ioctl(sk, cmd, arg);
-	default:
-		return -ENOIOCTLCMD;
-	}
+
+	return -ENOIOCTLCMD;
 }
 
 int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,


