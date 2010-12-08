Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0LHBrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:47:33 -0500
Received: from kroah.org ([198.145.64.141]:48718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178Ab0LHBAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:08 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005728.925049894@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [076/289] phy/marvell: fix 88e1121 support
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaud Patard <arnaud.patard@rtp-net.org>

commit be8c648051048bc66fbca590d00f3e8543ec32af upstream.

Commit c477d0447db08068a497e7beb892b2b2a7bff64b added support for RGMII
rx/tx delays except that it ends up clearing rx/tx delays bit for modes
differents that RGMII*ID. Due to this, ethernet is not working anymore
on my guruplug server +. This patch is fixing that.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/phy/marvell.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -196,20 +196,27 @@ static int m88e1121_config_aneg(struct p
 			MII_88E1121_PHY_MSCR_PAGE);
 	if (err < 0)
 		return err;
-	mscr = phy_read(phydev, MII_88E1121_PHY_MSCR_REG) &
-		MII_88E1121_PHY_MSCR_DELAY_MASK;
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		mscr |= (MII_88E1121_PHY_MSCR_RX_DELAY |
-			 MII_88E1121_PHY_MSCR_TX_DELAY);
-	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-		mscr |= MII_88E1121_PHY_MSCR_RX_DELAY;
-	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-		mscr |= MII_88E1121_PHY_MSCR_TX_DELAY;
+	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII) ||
+	    (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) ||
+	    (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) ||
+	    (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)) {
 
-	err = phy_write(phydev, MII_88E1121_PHY_MSCR_REG, mscr);
-	if (err < 0)
-		return err;
+		mscr = phy_read(phydev, MII_88E1121_PHY_MSCR_REG) &
+			MII_88E1121_PHY_MSCR_DELAY_MASK;
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			mscr |= (MII_88E1121_PHY_MSCR_RX_DELAY |
+				 MII_88E1121_PHY_MSCR_TX_DELAY);
+		else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			mscr |= MII_88E1121_PHY_MSCR_RX_DELAY;
+		else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			mscr |= MII_88E1121_PHY_MSCR_TX_DELAY;
+
+		err = phy_write(phydev, MII_88E1121_PHY_MSCR_REG, mscr);
+		if (err < 0)
+			return err;
+	}
 
 	phy_write(phydev, MII_88E1121_PHY_PAGE, oldpage);
 


