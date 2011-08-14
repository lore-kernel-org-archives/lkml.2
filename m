Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1HNARs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 20:17:48 -0400
Received: from 5.xs4all.nl ([82.95.233.223]:42468 "EHLO capsaicin.mamane.lu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752589Ab1HNARq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 20:17:46 -0400
X-Greylist: delayed 748 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Aug 2011 20:17:45 EDT
Date: Sun, 14 Aug 2011 02:04:38 +0200
From: Lionel Elie Mamane <lionel@mamane.lu>
To: "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sit tunnels: propagate IPv6 transport class to IPv4 Type
 of Service
Message-ID: <20110814000438.GA30127@capsaicin.mamane.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: GNU/Linux
X-Request-PGP: http://www.mamane.lu/openpgp/rsa_v4_4096.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sit tunnels (IPv6 tunnel over IPv4) do not implement the "tos inherit"
case to copy the IPv6 transport class byte from the inner packet to
the IPv4 type of service byte in the outer packet. By contrast, ipip
tunnels and GRE tunnels do.

This patch, adapted from the similar code in net/ipv4/ipip.c and
net/ipv4/ip_gre.c, implements that.

This patch applies to 3.0.1, and has been tested on that version.


Signed-off-by: Lionel Elie Mamane <lionel@mamane.lu>

---
 net/ipv6/sit.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 1cca576..bbe2468 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -672,6 +672,10 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	if (skb->protocol != htons(ETH_P_IPV6))
 		goto tx_error;
 
+
+	if (tos == 1)
+		tos = ipv6_get_dsfield(iph6);
+
 	/* ISATAP (RFC4214) - must come before 6to4 */
 	if (dev->priv_flags & IFF_ISATAP) {
 		struct neighbour *neigh = NULL;
-- 
Lionel Mamane

