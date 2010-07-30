Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab0G3TWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:22:11 -0400
Received: from kroah.org ([198.145.64.141]:46212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0G3RRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171500.920428077@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brandon Philips <bphilips@suse.de>
Subject: [014/165] igb: change how we handle alternate mac addresses
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 22896639af98ebc721a94ed71fc3acf2fb4a24dc upstream.

This patch allows us to treat the alternate mac address as though it is the
physical address on the adapter.  This is accomplished by letting the
alt_mac_address function to only fail on an NVM error.  If no errors occur
and the alternate mac address is not present then RAR0 is read as the
default mac address.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/e1000_82575.c |   13 +++++++++++--
 drivers/net/igb/e1000_hw.h    |    2 ++
 drivers/net/igb/e1000_mac.c   |   17 +++++++++--------
 3 files changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1168,9 +1168,18 @@ static s32 igb_read_mac_addr_82575(struc
 {
 	s32 ret_val = 0;
 
-	if (igb_check_alt_mac_addr(hw))
-		ret_val = igb_read_mac_addr(hw);
+	/*
+	 * If there's an alternate MAC address place it in RAR0
+	 * so that it will override the Si installed default perm
+	 * address.
+	 */
+	ret_val = igb_check_alt_mac_addr(hw);
+	if (ret_val)
+		goto out;
 
+	ret_val = igb_read_mac_addr(hw);
+
+out:
 	return ret_val;
 }
 
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -53,6 +53,8 @@ struct e1000_hw;
 
 #define E1000_FUNC_1     1
 
+#define E1000_ALT_MAC_ADDRESS_OFFSET_LAN1   3
+
 enum e1000_mac_type {
 	e1000_undefined = 0,
 	e1000_82575,
--- a/drivers/net/igb/e1000_mac.c
+++ b/drivers/net/igb/e1000_mac.c
@@ -185,13 +185,12 @@ s32 igb_check_alt_mac_addr(struct e1000_
 	}
 
 	if (nvm_alt_mac_addr_offset == 0xFFFF) {
-		ret_val = -(E1000_NOT_IMPLEMENTED);
+		/* There is no Alternate MAC Address */
 		goto out;
 	}
 
 	if (hw->bus.func == E1000_FUNC_1)
-		nvm_alt_mac_addr_offset += ETH_ALEN/sizeof(u16);
-
+		nvm_alt_mac_addr_offset += E1000_ALT_MAC_ADDRESS_OFFSET_LAN1;
 	for (i = 0; i < ETH_ALEN; i += 2) {
 		offset = nvm_alt_mac_addr_offset + (i >> 1);
 		ret_val = hw->nvm.ops.read(hw, offset, 1, &nvm_data);
@@ -206,14 +205,16 @@ s32 igb_check_alt_mac_addr(struct e1000_
 
 	/* if multicast bit is set, the alternate address will not be used */
 	if (alt_mac_addr[0] & 0x01) {
-		ret_val = -(E1000_NOT_IMPLEMENTED);
+		hw_dbg("Ignoring Alternate Mac Address with MC bit set\n");
 		goto out;
 	}
 
-	for (i = 0; i < ETH_ALEN; i++)
-		hw->mac.addr[i] = hw->mac.perm_addr[i] = alt_mac_addr[i];
-
-	hw->mac.ops.rar_set(hw, hw->mac.perm_addr, 0);
+	/*
+	 * We have a valid alternate MAC address, and we want to treat it the
+	 * same as the normal permanent MAC address stored by the HW into the
+	 * RAR. Do this by mapping this address into RAR0.
+	 */
+	hw->mac.ops.rar_set(hw, alt_mac_addr, 0);
 
 out:
 	return ret_val;


