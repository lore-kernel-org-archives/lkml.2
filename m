Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1DNRpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:37416 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab1DNRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 019/209] jme: Fix PHY power-off error
Date: Thu, 14 Apr 2011 13:40:49 -0400
Message-Id: <1302803039-9400-20-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c8a8684d5cfb0f110a962c93586630c0bf91ebc1 upstream.

Adding phy_on in opposition to phy_off.

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/jme.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index b705ad3..b2d190e 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -1579,6 +1579,16 @@ jme_free_irq(struct jme_adapter *jme)
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
@@ -1599,10 +1609,12 @@ jme_open(struct net_device *netdev)
 
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
 
@@ -3010,10 +3022,12 @@ jme_resume(struct pci_dev *pdev)
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
-- 
1.7.4.4

