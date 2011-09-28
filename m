Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1I1WrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab1I1WrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.201146097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sorin Dumitru <sdumitru@ixiacom.com>,
        Daniel Baluta <dbaluta@ixiacom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [179/244] ipv6: Fix ipv6_getsockopt for IPV6_2292PKTOPTIONS
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Daniel Baluta <dbaluta@ixiacom.com>

[ Upstream commit 98e77438aed3cd3343cbb86825127b1d9d2bea33 ]

IPV6_2292PKTOPTIONS is broken for 32-bit applications running
in COMPAT mode on 64-bit kernels.

The same problem was fixed for IPv4 with the patch:
ipv4: Fix ip_getsockopt for IP_PKTOPTIONS,
commit dd23198e58cd35259dd09e8892bbdb90f1d57748

Signed-off-by: Sorin Dumitru <sdumitru@ixiacom.com>
Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/ipv6_sockglue.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -913,7 +913,7 @@ static int ipv6_getsockopt_sticky(struct
 }
 
 static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, int __user *optlen)
+		    char __user *optval, int __user *optlen, unsigned flags)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	int len;
@@ -962,7 +962,7 @@ static int do_ipv6_getsockopt(struct soc
 
 		msg.msg_control = optval;
 		msg.msg_controllen = len;
-		msg.msg_flags = 0;
+		msg.msg_flags = flags;
 
 		lock_sock(sk);
 		skb = np->pktoptions;
@@ -1222,7 +1222,7 @@ int ipv6_getsockopt(struct sock *sk, int
 	if(level != SOL_IPV6)
 		return -ENOPROTOOPT;
 
-	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen);
+	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen, 0);
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IPV6_2292PKTOPTIONS) {
@@ -1264,7 +1264,8 @@ int compat_ipv6_getsockopt(struct sock *
 		return compat_mc_getsockopt(sk, level, optname, optval, optlen,
 			ipv6_getsockopt);
 
-	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen);
+	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen,
+				 MSG_CMSG_COMPAT);
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IPV6_2292PKTOPTIONS) {


