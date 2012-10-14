Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2JNRTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 13:19:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43897 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2JNRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 13:19:46 -0400
From: Dmitry Fleytman <dmitry@daynix.com>
To: linux-kernel@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>,
        Dmitry Fleytman <dmitry@daynix.com>
Subject: [PATCH] RX initialization sequence fixed - enable RX after corresponding ring initialization only
Date: Sun, 14 Oct 2012 19:19:11 +0200
Message-Id: <1350235151-11146-2-git-send-email-dmitry@daynix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Chris Webb	<chris.webb@elastichosts.com>
Reported-by: Richard Davies <richard.davies@elastichosts.com>

Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
 drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 9089d00..ebcce7a 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1091,10 +1091,6 @@ static int e1000_setup_desc_rings(struct e1000_adapter *adapter)
 	ew32(RDLEN, rxdr->size);
 	ew32(RDH, 0);
 	ew32(RDT, 0);
-	rctl = E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SZ_2048 |
-		E1000_RCTL_LBM_NO | E1000_RCTL_RDMTS_HALF |
-		(hw->mc_filter_type << E1000_RCTL_MO_SHIFT);
-	ew32(RCTL, rctl);
 
 	for (i = 0; i < rxdr->count; i++) {
 		struct e1000_rx_desc *rx_desc = E1000_RX_DESC(*rxdr, i);
@@ -1115,6 +1111,11 @@ static int e1000_setup_desc_rings(struct e1000_adapter *adapter)
 		memset(skb->data, 0x00, skb->len);
 	}
 
+	rctl = E1000_RCTL_EN | E1000_RCTL_BAM | E1000_RCTL_SZ_2048 |
+		E1000_RCTL_LBM_NO | E1000_RCTL_RDMTS_HALF |
+		(hw->mc_filter_type << E1000_RCTL_MO_SHIFT);
+	ew32(RCTL, rctl);
+
 	return 0;
 
 err_nomem:
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 222bfaf..01a4ad9 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -118,6 +118,7 @@ static int e1000_open(struct net_device *netdev);
 static int e1000_close(struct net_device *netdev);
 static void e1000_configure_tx(struct e1000_adapter *adapter);
 static void e1000_configure_rx(struct e1000_adapter *adapter);
+static void e1000_enable_rx(struct e1000_adapter *adapter);
 static void e1000_setup_rctl(struct e1000_adapter *adapter);
 static void e1000_clean_all_tx_rings(struct e1000_adapter *adapter);
 static void e1000_clean_all_rx_rings(struct e1000_adapter *adapter);
@@ -404,6 +405,7 @@ static void e1000_configure(struct e1000_adapter *adapter)
 		adapter->alloc_rx_buf(adapter, ring,
 		                      E1000_DESC_UNUSED(ring));
 	}
+	e1000_enable_rx(adapter);
 }
 
 int e1000_up(struct e1000_adapter *adapter)
@@ -1928,8 +1930,19 @@ static void e1000_configure_rx(struct e1000_adapter *adapter)
 			rxcsum &= ~E1000_RXCSUM_TUOFL;
 		ew32(RXCSUM, rxcsum);
 	}
+}
+
+/**
+ * e1000_enable_rx - Enable receive in HW
+ * @adapter: board private structure
+ *
+ * Inform HW that SW is ready for incoming packets indications
+ **/
 
-	/* Enable Receives */
+static void e1000_enable_rx(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 rctl = er32(RCTL);
 	ew32(RCTL, rctl | E1000_RCTL_EN);
 }
 
@@ -2196,6 +2209,7 @@ static void e1000_leave_82542_rst(struct e1000_adapter *adapter)
 		struct e1000_rx_ring *ring = &adapter->rx_ring[0];
 		e1000_configure_rx(adapter);
 		adapter->alloc_rx_buf(adapter, ring, E1000_DESC_UNUSED(ring));
+		e1000_enable_rx(adapter);
 	}
 }
 
@@ -5010,7 +5024,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 			rctl |= E1000_RCTL_MPE;
 
 		/* enable receives in the hardware */
-		ew32(RCTL, rctl | E1000_RCTL_EN);
+		e1000_enable_rx(adapter);
 
 		if (hw->mac_type >= e1000_82540) {
 			ctrl = er32(CTRL);
-- 
1.7.9.5

