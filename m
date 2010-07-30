Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab0G3Syi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:54:38 -0400
Received: from kroah.org ([198.145.64.141]:35563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759328Ab0G3ReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:05 2010
Message-Id: <20100730173104.928023725@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brandon Philips <bphilips@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [024/140] sky2: enable rx/tx in sky2_phy_reinit()
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brandon Philips <brandon@ifup.org>

commit 38000a94a902e94ca8b5498f7871c6316de8957a upstream.

sky2_phy_reinit is called by the ethtool helpers sky2_set_settings,
sky2_nway_reset and sky2_set_pauseparam when netif_running.

However, at the end of sky2_phy_init GM_GP_CTRL has GM_GPCR_RX_ENA and
GM_GPCR_TX_ENA cleared. So, doing these commands causes the device to
stop working:

$ ethtool -r eth0
$ ethtool -A eth0 autoneg off

Fix this issue by enabling Rx/Tx after running sky2_phy_init in
sky2_phy_reinit.

Signed-off-by: Brandon Philips <bphilips@suse.de>
Tested-by: Brandon Philips <bphilips@suse.de>
Cc: stable@kernel.org
Tested-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -716,11 +716,24 @@ static void sky2_phy_power_down(struct s
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 }
 
+/* Enable Rx/Tx */
+static void sky2_enable_rx_tx(struct sky2_port *sky2)
+{
+	struct sky2_hw *hw = sky2->hw;
+	unsigned port = sky2->port;
+	u16 reg;
+
+	reg = gma_read16(hw, port, GM_GP_CTRL);
+	reg |= GM_GPCR_RX_ENA | GM_GPCR_TX_ENA;
+	gma_write16(hw, port, GM_GP_CTRL, reg);
+}
+
 /* Force a renegotiation */
 static void sky2_phy_reinit(struct sky2_port *sky2)
 {
 	spin_lock_bh(&sky2->phy_lock);
 	sky2_phy_init(sky2->hw, sky2->port);
+	sky2_enable_rx_tx(sky2);
 	spin_unlock_bh(&sky2->phy_lock);
 }
 
@@ -1971,7 +1984,6 @@ static void sky2_link_up(struct sky2_por
 {
 	struct sky2_hw *hw = sky2->hw;
 	unsigned port = sky2->port;
-	u16 reg;
 	static const char *fc_name[] = {
 		[FC_NONE]	= "none",
 		[FC_TX]		= "tx",
@@ -1979,10 +1991,7 @@ static void sky2_link_up(struct sky2_por
 		[FC_BOTH]	= "both",
 	};
 
-	/* enable Rx/Tx */
-	reg = gma_read16(hw, port, GM_GP_CTRL);
-	reg |= GM_GPCR_RX_ENA | GM_GPCR_TX_ENA;
-	gma_write16(hw, port, GM_GP_CTRL, reg);
+	sky2_enable_rx_tx(sky2);
 
 	gm_phy_write(hw, port, PHY_MARV_INT_MASK, PHY_M_DEF_MSK);
 


