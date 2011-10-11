Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1JKRHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab1JKRHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:07:50 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:14 2011
Message-Id: <20111011165714.147435550@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:48 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Subject: [38/38] e1000e: workaround for packet drop on 82579 at 100Mbps
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 0ed013e28fe853244f4972cf18d8e2bd62eeb8fc upstream.

The MAC can drop short packets when the PHY detects noise on the line at
100Mbps due to a timing issue.  Workaround the issue by increasing the PLL
counter so the PHY properly recognizes the synchronization pattern from the
MAC.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/ich8lan.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -137,8 +137,9 @@
 #define HV_PM_CTRL		PHY_REG(770, 17)
 
 /* PHY Low Power Idle Control */
-#define I82579_LPI_CTRL			PHY_REG(772, 20)
-#define I82579_LPI_CTRL_ENABLE_MASK	0x6000
+#define I82579_LPI_CTRL				PHY_REG(772, 20)
+#define I82579_LPI_CTRL_ENABLE_MASK		0x6000
+#define I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT	0x80
 
 /* EMI Registers */
 #define I82579_EMI_ADDR         0x10
@@ -1611,6 +1612,7 @@ static s32 e1000_k1_workaround_lv(struct
 	s32 ret_val = 0;
 	u16 status_reg = 0;
 	u32 mac_reg;
+	u16 phy_reg;
 
 	if (hw->mac.type != e1000_pch2lan)
 		goto out;
@@ -1625,12 +1627,19 @@ static s32 e1000_k1_workaround_lv(struct
 		mac_reg = er32(FEXTNVM4);
 		mac_reg &= ~E1000_FEXTNVM4_BEACON_DURATION_MASK;
 
-		if (status_reg & HV_M_STATUS_SPEED_1000)
+		ret_val = e1e_rphy(hw, I82579_LPI_CTRL, &phy_reg);
+		if (ret_val)
+			goto out;
+
+		if (status_reg & HV_M_STATUS_SPEED_1000) {
 			mac_reg |= E1000_FEXTNVM4_BEACON_DURATION_8USEC;
-		else
+			phy_reg &= ~I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT;
+		} else {
 			mac_reg |= E1000_FEXTNVM4_BEACON_DURATION_16USEC;
-
+			phy_reg |= I82579_LPI_CTRL_FORCE_PLL_LOCK_COUNT;
+		}
 		ew32(FEXTNVM4, mac_reg);
+		ret_val = e1e_wphy(hw, I82579_LPI_CTRL, phy_reg);
 	}
 
 out:


