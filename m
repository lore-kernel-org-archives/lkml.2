Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1CUXg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:36:27 -0400
Received: from kroah.org ([198.145.64.141]:49656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1CUXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:17 2011
Message-Id: <20110321230717.324514585@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [79/87] ixgbe: limit VF access to network traffic
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 96cc637235892a102fb829218adac048bd730ab7 upstream.

This change fixes VM pool allocation issues based on MAC address filtering,
as well as limits the scope of VF access to promiscuous mode.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Greg Rose <gregory.v.rose@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_common.c |    3 +++
 drivers/net/ixgbe/ixgbe_sriov.c  |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -1292,6 +1292,9 @@ s32 ixgbe_init_rx_addrs_generic(struct i
 		hw_dbg(hw, " New MAC Addr =%pM\n", hw->mac.addr);
 
 		hw->mac.ops.set_rar(hw, 0, hw->mac.addr, 0, IXGBE_RAH_AV);
+
+		/*  clear VMDq pool/queue selection for RAR 0 */
+		hw->mac.ops.clear_vmdq(hw, 0, IXGBE_CLEAR_VMDQ_ALL);
 	}
 	hw->addr_ctrl.overflow_promisc = 0;
 
--- a/drivers/net/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ixgbe/ixgbe_sriov.c
@@ -110,12 +110,10 @@ static int ixgbe_set_vf_vlan(struct ixgb
 	return adapter->hw.mac.ops.set_vfta(&adapter->hw, vid, vf, (bool)add);
 }
 
-
 static void ixgbe_set_vmolr(struct ixgbe_hw *hw, u32 vf, bool aupe)
 {
 	u32 vmolr = IXGBE_READ_REG(hw, IXGBE_VMOLR(vf));
 	vmolr |= (IXGBE_VMOLR_ROMPE |
-		  IXGBE_VMOLR_ROPE |
 		  IXGBE_VMOLR_BAM);
 	if (aupe)
 		vmolr |= IXGBE_VMOLR_AUPE;


