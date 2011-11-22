Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1KVTYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:24:07 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:51430 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1KVTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:23:59 -0500
From: David Decotigny <david.decotigny@google.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <david.decotigny@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH net-next v2 3/4] net-e1000e: reworked carrier detection logic
Date: Tue, 22 Nov 2011 11:23:37 -0800
Message-Id: <162f094e526f3b2a21e66b5863608de6970bba68.1321989502.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321989502.git.david.decotigny@google.com>
References: <cover.1321989502.git.david.decotigny@google.com>
In-Reply-To: <cover.1321989502.git.david.decotigny@google.com>
References: <cover.1321989502.git.david.decotigny@google.com>
Organization: Google, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Żenczykowski <zenczykowski@gmail.com>

This change removes an un-needed final pause in case of timeout and
reworks the "link is up" detection logic.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c |   64 +++++++++++++++++++------------
 1 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 8666476..f487a7f 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -1775,39 +1775,53 @@ static s32 e1000_wait_autoneg(struct e1000_hw *hw)
  *  Polls the PHY status register for link, 'iterations' number of times.
  **/
 s32 e1000e_phy_has_link_generic(struct e1000_hw *hw, u32 iterations,
-			       u32 usec_interval, bool *success)
+				u32 usec_interval, bool *success)
 {
-	s32 ret_val = 0;
-	u16 i, phy_status;
+	u32 i;
+	u16 phy_reg;
+	int good_reads_phy_status = 0;
+
+	}
+
+	/*
+	 * Remember that e1e_rphy may fail because of another entity
+	 * (like the firmware) holding the lock, we need to handle
+	 * this gracefully - by waiting and trying again.
+	 *
+	 * Some PHYs require the PHY_STATUS register to be read twice
+	 * due to the link bit being sticky.  No harm doing it across
+	 * the board.
+	 */
+	for (i = 0; i < iterations; /* i incremented manually */) {
+		if (0 == e1e_rphy(hw, PHY_STATUS, &phy_reg)) {
+			if (++good_reads_phy_status < 2)
+				continue; /* Re-read once, to make sure */
 
-	for (i = 0; i < iterations; i++) {
-		/*
-		 * Some PHYs require the PHY_STATUS register to be read
-		 * twice due to the link bit being sticky.  No harm doing
-		 * it across the board.
-		 */
-		ret_val = e1e_rphy(hw, PHY_STATUS, &phy_status);
-		if (ret_val)
 			/*
-			 * If the first read fails, another entity may have
-			 * ownership of the resources, wait and try again to
-			 * see if they have relinquished the resources yet.
+			 * Great, we got at least 2 successfull reads
 			 */
-			udelay(usec_interval);
-		ret_val = e1e_rphy(hw, PHY_STATUS, &phy_status);
-		if (ret_val)
-			break;
-		if (phy_status & MII_SR_LINK_STATUS)
-			break;
-		if (usec_interval >= 1000)
-			mdelay(usec_interval/1000);
+
+			if (phy_reg & MII_SR_LINK_STATUS) {
+				/* success: link up */
+				*success = true;
+				return 0;
+			}
+		}
+
+		/* Pause now and re-iterate */
+		if (++i >= iterations)
+			break; /* Pause not needed after last iteration */
+		else if (usec_interval >= 1000)
+			mdelay(usec_interval / 1000);
 		else
 			udelay(usec_interval);
 	}
 
-	*success = (i < iterations);
-
-	return ret_val;
+	/* no success in for(;;) loop */
+	*success = false;
+	if (good_reads_phy_status < 2)
+		return -E1000_ERR_PHY;
+	return 0;
 }
 
 /**
-- 
1.7.3.1

