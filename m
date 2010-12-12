Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0LLXp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0LLXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:03 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: cooldavid@cooldavid.org, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [7/223] jme: Fix PHY power-off error
Message-Id: <20101212234502.22E5EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit c8a8684d5cfb0f110a962c93586630c0bf91ebc1 upstream.

Adding phy_on in opposition to phy_off.

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/jme.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

Index: linux/drivers/net/jme.c
===================================================================
--- linux.orig/drivers/net/jme.c
+++ linux/drivers/net/jme.c
@@ -1575,6 +1575,16 @@ jme_free_irq(struct jme_adapter *jme)
 	}
 }
 
+static inline void
+jme_phy_on(struct jme_adapter *jme)
+{
+	u32 bmcr;
+
+	bmcr = jme_mdio_read(jme->dev, jme->mii_if.phy_id, MII_BMCR);
+	bmcr &= ~BMCR_PDOWN;
+	jme_mdio_write(jme->dev, jme->mii_if.phy_id, MII_BMCR, bmcr);
+}
+
 static int
 jme_open(struct net_device *netdev)
 {
@@ -1595,10 +1605,12 @@ jme_open(struct net_device *netdev)
 
 	jme_start_irq(jme);
 
-	if (test_bit(JME_FLAG_SSET, &jme->flags))
+	if (test_bit(JME_FLAG_SSET, &jme->flags)) {
+		jme_phy_on(jme);
 		jme_set_settings(netdev, &jme->old_ecmd);
-	else
+	} else {
 		jme_reset_phy_processor(jme);
+	}
 
 	jme_reset_link(jme);
 
@@ -3006,10 +3018,12 @@ jme_resume(struct pci_dev *pdev)
 	jme_clear_pm(jme);
 	pci_restore_state(pdev);
 
-	if (test_bit(JME_FLAG_SSET, &jme->flags))
+	if (test_bit(JME_FLAG_SSET, &jme->flags)) {
+		jme_phy_on(jme);
 		jme_set_settings(netdev, &jme->old_ecmd);
-	else
+	} else {
 		jme_reset_phy_processor(jme);
+	}
 
 	jme_start_irq(jme);
 	netif_device_attach(netdev);
