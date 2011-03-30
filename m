Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab1C3VsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:48:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492Ab1C3VHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447612"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: bhutchings@solarflare.com, fubar@us.ibm.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [118/275] bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
Message-Id: <20110330210557.E5DF33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Hutchings <bhutchings@solarflare.com>

This is related to commit f88a4a9b65a6f3422b81be995535d0e69df11bb8
upstream, but the bug cannot be properly fixed without the other
changes to VLAN tagging in 2.6.37.

bond_na_send() attempts to insert a VLAN tag in between building and
sending packets of the respective formats.  If the slave does not
implement hardware VLAN tag insertion then vlan_put_tag() will mangle
the network-layer header because the Ethernet header is not present at
this point (unlike in bond_arp_send()).

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/bonding/bond_ipv6.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/bonding/bond_ipv6.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/bonding/bond_ipv6.c	2011-03-29 22:51:21.201180683 -0700
+++ linux-2.6.35.y/drivers/net/bonding/bond_ipv6.c	2011-03-29 23:03:00.673282942 -0700
@@ -70,6 +70,13 @@
 	};
 	struct sk_buff *skb;
 
+	/* The Ethernet header is built in ndisc_send_skb(), not
+	 * ndisc_build_skb(), so we cannot insert a VLAN tag.  Only an
+	 * out-of-line tag inserted by the hardware will work.
+	 */
+	if (vlan_id && !(slave_dev->features & NETIF_F_HW_VLAN_TX))
+		return;
+
 	icmp6h.icmp6_router = router;
 	icmp6h.icmp6_solicited = 0;
 	icmp6h.icmp6_override = 1;
@@ -88,7 +95,7 @@
 	}
 
 	if (vlan_id) {
-		skb = vlan_put_tag(skb, vlan_id);
+		skb = __vlan_hwaccel_put_tag(skb, vlan_id);
 		if (!skb) {
 			pr_err("failed to insert VLAN tag\n");
 			return;
