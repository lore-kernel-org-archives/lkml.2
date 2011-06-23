Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab1FWSUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:20:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:34278 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab1FWRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 089/247] bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
Date: Thu, 23 Jun 2011 13:32:37 -0400
Message-Id: <1308850515-15242-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/bonding/bond_ipv6.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_ipv6.c b/drivers/net/bonding/bond_ipv6.c
index 6dd64cf..a131d6f 100644
--- a/drivers/net/bonding/bond_ipv6.c
+++ b/drivers/net/bonding/bond_ipv6.c
@@ -69,6 +69,13 @@ static void bond_na_send(struct net_device *slave_dev,
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
@@ -87,7 +94,7 @@ static void bond_na_send(struct net_device *slave_dev,
 	}
 
 	if (vlan_id) {
-		skb = vlan_put_tag(skb, vlan_id);
+		skb = __vlan_hwaccel_put_tag(skb, vlan_id);
 		if (!skb) {
 			pr_err("failed to insert VLAN tag\n");
 			return;
-- 
1.7.4.4

