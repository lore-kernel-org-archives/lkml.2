Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162263Ab2GLWym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:54:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162176Ab2GLWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 143/187] e1000e: test for valid check_reset_block function pointer
Date: Thu, 12 Jul 2012 15:34:59 -0700
Message-Id: <20120712191535.671333252@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 470a54207ccf7045a59df727573bd9d148988582 upstream.

commit 44abd5c12767a8c567dc4e45fd9aec3b13ca85e0 introduced NULL pointer
dereferences when attempting to access the check_reset_block function
pointer on 8257x and 80003es2lan non-copper devices.

This fix should be applied back through 3.4.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/ethtool.c |    6 ++++--
 drivers/net/ethernet/intel/e1000e/mac.c     |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c  |    4 ++--
 drivers/net/ethernet/intel/e1000e/phy.c     |    8 +++++---
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -258,7 +258,8 @@ static int e1000_set_settings(struct net
 	 * When SoL/IDER sessions are active, autoneg/speed/duplex
 	 * cannot be changed
 	 */
-	if (hw->phy.ops.check_reset_block(hw)) {
+	if (hw->phy.ops.check_reset_block &&
+	    hw->phy.ops.check_reset_block(hw)) {
 		e_err("Cannot change link characteristics when SoL/IDER is "
 		      "active.\n");
 		return -EINVAL;
@@ -1604,7 +1605,8 @@ static int e1000_loopback_test(struct e1
 	 * PHY loopback cannot be performed if SoL/IDER
 	 * sessions are active
 	 */
-	if (hw->phy.ops.check_reset_block(hw)) {
+	if (hw->phy.ops.check_reset_block &&
+	    hw->phy.ops.check_reset_block(hw)) {
 		e_err("Cannot do PHY loopback test when SoL/IDER is active.\n");
 		*data = 0;
 		goto out;
--- a/drivers/net/ethernet/intel/e1000e/mac.c
+++ b/drivers/net/ethernet/intel/e1000e/mac.c
@@ -709,7 +709,7 @@ s32 e1000e_setup_link_generic(struct e10
 	 * In the case of the phy reset being blocked, we already have a link.
 	 * We do not need to set it up again.
 	 */
-	if (hw->phy.ops.check_reset_block(hw))
+	if (hw->phy.ops.check_reset_block && hw->phy.ops.check_reset_block(hw))
 		return 0;
 
 	/*
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6209,7 +6209,7 @@ static int __devinit e1000_probe(struct
 		adapter->hw.phy.ms_type = e1000_ms_hw_default;
 	}
 
-	if (hw->phy.ops.check_reset_block(hw))
+	if (hw->phy.ops.check_reset_block && hw->phy.ops.check_reset_block(hw))
 		e_info("PHY reset is blocked due to SOL/IDER session.\n");
 
 	/* Set initial default active device features */
@@ -6376,7 +6376,7 @@ err_register:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
-	if (!hw->phy.ops.check_reset_block(hw))
+	if (hw->phy.ops.check_reset_block && !hw->phy.ops.check_reset_block(hw))
 		e1000_phy_hw_reset(&adapter->hw);
 err_hw_init:
 	kfree(adapter->tx_ring);
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2121,9 +2121,11 @@ s32 e1000e_phy_hw_reset_generic(struct e
 	s32 ret_val;
 	u32 ctrl;
 
-	ret_val = phy->ops.check_reset_block(hw);
-	if (ret_val)
-		return 0;
+	if (phy->ops.check_reset_block) {
+		ret_val = phy->ops.check_reset_block(hw);
+		if (ret_val)
+			return 0;
+	}
 
 	ret_val = phy->ops.acquire(hw);
 	if (ret_val)


