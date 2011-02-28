Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1B1QhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:17 -0500
Received: from kroah.org ([198.145.64.141]:41231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab1B1QhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:07 2011
Message-Id: <20110228162407.047090187@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>,
        bonding-devel@lists.sourceforge.net,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [14/68] bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/bonding/bond_ipv6.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_ipv6.c
+++ b/drivers/net/bonding/bond_ipv6.c
@@ -66,6 +66,13 @@ static void bond_na_send(struct net_devi
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
@@ -84,7 +91,7 @@ static void bond_na_send(struct net_devi
 	}
 
 	if (vlan_id) {
-		skb = vlan_put_tag(skb, vlan_id);
+		skb = __vlan_hwaccel_put_tag(skb, vlan_id);
 		if (!skb) {
 			pr_err(DRV_NAME ": failed to insert VLAN tag\n");
 			return;


