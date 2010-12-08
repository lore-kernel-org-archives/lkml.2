Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0LHAqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:34 -0500
Received: from kroah.org ([198.145.64.141]:45834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0LHAqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:24 2010
Message-Id: <20101208004424.906445616@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [005/127] jme: Fix PHY power-off error
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit c8a8684d5cfb0f110a962c93586630c0bf91ebc1 upstream.

Adding phy_on in opposition to phy_off.

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/jme.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -1578,6 +1578,16 @@ jme_free_irq(struct jme_adapter *jme)
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
@@ -1598,10 +1608,12 @@ jme_open(struct net_device *netdev)
 
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
 
@@ -3013,10 +3025,12 @@ jme_resume(struct pci_dev *pdev)
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


