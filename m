Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab2C3Wo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:44:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935127Ab2C3VHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:13 -0400
Message-Id: <20120330195733.509502855@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 079/108] e1000e: Avoid wrong check on TX hang
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

commit 09357b00255c233705b1cf6d76a8d147340545b8 upstream.

Based on the original patch submitted my Michael Wang
<wangyun@linux.vnet.ibm.com>.
Descriptors may not be write-back while checking TX hang with flag
FLAG2_DMA_BURST on.
So when we detect hang, we just flush the descriptor and detect
again for once.

-v2 change 1 to true and 0 to false and remove extra ()

CC: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Flavio Leitner <fbl@redhat.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/e1000e/e1000.h  |    1 +
 drivers/net/e1000e/netdev.c |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -311,6 +311,7 @@ struct e1000_adapter {
 	u32 txd_cmd;
 
 	bool detect_tx_hung;
+	bool tx_hang_recheck;
 	u8 tx_timeout_factor;
 
 	u32 tx_int_delay;
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -930,6 +930,7 @@ static void e1000_print_hw_hang(struct w
 	struct e1000_adapter *adapter = container_of(work,
 	                                             struct e1000_adapter,
 	                                             print_hang_task);
+	struct net_device *netdev = adapter->netdev;
 	struct e1000_ring *tx_ring = adapter->tx_ring;
 	unsigned int i = tx_ring->next_to_clean;
 	unsigned int eop = tx_ring->buffer_info[i].next_to_watch;
@@ -941,6 +942,21 @@ static void e1000_print_hw_hang(struct w
 	if (test_bit(__E1000_DOWN, &adapter->state))
 		return;
 
+	if (!adapter->tx_hang_recheck &&
+	    (adapter->flags2 & FLAG2_DMA_BURST)) {
+		/* May be block on write-back, flush and detect again
+		 * flush pending descriptor writebacks to memory
+		 */
+		ew32(TIDV, adapter->tx_int_delay | E1000_TIDV_FPD);
+		/* execute the writes immediately */
+		e1e_flush();
+		adapter->tx_hang_recheck = true;
+		return;
+	}
+	/* Real hang detected */
+	adapter->tx_hang_recheck = false;
+	netif_stop_queue(netdev);
+
 	e1e_rphy(hw, PHY_STATUS, &phy_status);
 	e1e_rphy(hw, PHY_1000T_STATUS, &phy_1000t_status);
 	e1e_rphy(hw, PHY_EXT_STATUS, &phy_ext_status);
@@ -1054,10 +1070,10 @@ static bool e1000_clean_tx_irq(struct e1
 		if (tx_ring->buffer_info[i].time_stamp &&
 		    time_after(jiffies, tx_ring->buffer_info[i].time_stamp
 			       + (adapter->tx_timeout_factor * HZ)) &&
-		    !(er32(STATUS) & E1000_STATUS_TXOFF)) {
+		    !(er32(STATUS) & E1000_STATUS_TXOFF))
 			schedule_work(&adapter->print_hang_task);
-			netif_stop_queue(netdev);
-		}
+		else
+			adapter->tx_hang_recheck = false;
 	}
 	adapter->total_tx_bytes += total_tx_bytes;
 	adapter->total_tx_packets += total_tx_packets;
@@ -3678,6 +3694,7 @@ static int e1000_open(struct net_device
 
 	e1000_irq_enable(adapter);
 
+	adapter->tx_hang_recheck = false;
 	netif_start_queue(netdev);
 
 	adapter->idle_check = true;


