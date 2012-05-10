Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383Ab2EJRuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:50:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208Ab2EJRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:33 -0400
Message-Id: <20120510173133.257848025@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Greear <greearb@candelatech.com>,
        Jiri Pirko <jpirko@redhat.com>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ward <david.ward@ll.mit.edu>
Subject: [ 03/52] e1000: fix vlan processing regression
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jpirko@redhat.com>

commit 52f5509fe8ccb607ff9b84ad618f244262336475 upstream.

This patch fixes a regression introduced by commit "e1000: do vlan
cleanup (799d531)".

Apparently some e1000 chips (not mine) are sensitive about the order of
setting vlan filter and vlan stripping/inserting functionality. So this
patch changes the order so it's the same as before vlan cleanup.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: David Ward <david.ward@ll.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000/e1000_main.c |   35 ++++++++++++++++----------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -164,6 +164,8 @@ static int e1000_82547_fifo_workaround(s
 static bool e1000_vlan_used(struct e1000_adapter *adapter);
 static void e1000_vlan_mode(struct net_device *netdev,
 			    netdev_features_t features);
+static void e1000_vlan_filter_on_off(struct e1000_adapter *adapter,
+				     bool filter_on);
 static int e1000_vlan_rx_add_vid(struct net_device *netdev, u16 vid);
 static int e1000_vlan_rx_kill_vid(struct net_device *netdev, u16 vid);
 static void e1000_restore_vlan(struct e1000_adapter *adapter);
@@ -1213,7 +1215,7 @@ static int __devinit e1000_probe(struct
 	if (err)
 		goto err_register;
 
-	e1000_vlan_mode(netdev, netdev->features);
+	e1000_vlan_filter_on_off(adapter, false);
 
 	/* print bus type/speed/width info */
 	e_info(probe, "(PCI%s:%dMHz:%d-bit) %pM\n",
@@ -4549,6 +4551,22 @@ static bool e1000_vlan_used(struct e1000
 	return false;
 }
 
+static void __e1000_vlan_mode(struct e1000_adapter *adapter,
+			      netdev_features_t features)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 ctrl;
+
+	ctrl = er32(CTRL);
+	if (features & NETIF_F_HW_VLAN_RX) {
+		/* enable VLAN tag insert/strip */
+		ctrl |= E1000_CTRL_VME;
+	} else {
+		/* disable VLAN tag insert/strip */
+		ctrl &= ~E1000_CTRL_VME;
+	}
+	ew32(CTRL, ctrl);
+}
 static void e1000_vlan_filter_on_off(struct e1000_adapter *adapter,
 				     bool filter_on)
 {
@@ -4558,6 +4576,7 @@ static void e1000_vlan_filter_on_off(str
 	if (!test_bit(__E1000_DOWN, &adapter->flags))
 		e1000_irq_disable(adapter);
 
+	__e1000_vlan_mode(adapter, adapter->netdev->features);
 	if (filter_on) {
 		/* enable VLAN receive filtering */
 		rctl = er32(RCTL);
@@ -4578,24 +4597,14 @@ static void e1000_vlan_filter_on_off(str
 }
 
 static void e1000_vlan_mode(struct net_device *netdev,
-	netdev_features_t features)
+			    netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	struct e1000_hw *hw = &adapter->hw;
-	u32 ctrl;
 
 	if (!test_bit(__E1000_DOWN, &adapter->flags))
 		e1000_irq_disable(adapter);
 
-	ctrl = er32(CTRL);
-	if (features & NETIF_F_HW_VLAN_RX) {
-		/* enable VLAN tag insert/strip */
-		ctrl |= E1000_CTRL_VME;
-	} else {
-		/* disable VLAN tag insert/strip */
-		ctrl &= ~E1000_CTRL_VME;
-	}
-	ew32(CTRL, ctrl);
+	__e1000_vlan_mode(adapter, features);
 
 	if (!test_bit(__E1000_DOWN, &adapter->flags))
 		e1000_irq_enable(adapter);


