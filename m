Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab1JRQO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:14:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232Ab1JRQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:48 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [RESEND][PATCH 06/26] staging: et131x: move et131x_adapter.h contents into et131x.c
Date: Tue, 18 Oct 2011 17:07:39 +0100
Message-Id: <1318954079-16666-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move et131x_adapter.h contents into et131x.c and delete et131x_adapter.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c         |  152 +++++++++++++++++++++-
 drivers/staging/et131x/et131x_adapter.h |  217 -------------------------------
 2 files changed, 151 insertions(+), 218 deletions(-)
 delete mode 100644 drivers/staging/et131x/et131x_adapter.h

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 271ae31..e88c277 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -83,7 +83,6 @@
 #include <linux/random.h>
 #include <linux/phy.h>
 
-#include "et131x_adapter.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et131x.h"
@@ -125,6 +124,157 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define INT_MASK_ENABLE             0xfffebf17
 #define INT_MASK_ENABLE_NO_FLOW     0xfffebfd7
 
+/* ADAPTER defines */
+/*
+ * Do not change these values: if changed, then change also in respective
+ * TXdma and Rxdma engines
+ */
+#define NUM_DESC_PER_RING_TX         512    /* TX Do not change these values */
+#define NUM_TCB                      64
+
+/*
+ * These values are all superseded by registry entries to facilitate tuning.
+ * Once the desired performance has been achieved, the optimal registry values
+ * should be re-populated to these #defines:
+ */
+#define NUM_TRAFFIC_CLASSES          1
+
+#define TX_ERROR_PERIOD             1000
+
+#define LO_MARK_PERCENT_FOR_PSR     15
+#define LO_MARK_PERCENT_FOR_RX      15
+
+/* RFD (Receive Frame Descriptor) */
+struct rfd {
+	struct list_head list_node;
+	struct sk_buff *skb;
+	u32 len;	/* total size of receive frame */
+	u16 bufferindex;
+	u8 ringindex;
+};
+
+/* Flow Control */
+#define FLOW_BOTH	0
+#define FLOW_TXONLY	1
+#define FLOW_RXONLY	2
+#define FLOW_NONE	3
+
+/* Struct to define some device statistics */
+struct ce_stats {
+	/* MIB II variables
+	 *
+	 * NOTE: atomic_t types are only guaranteed to store 24-bits; if we
+	 * MUST have 32, then we'll need another way to perform atomic
+	 * operations
+	 */
+	u32		unicast_pkts_rcvd;
+	atomic_t	unicast_pkts_xmtd;
+	u32		multicast_pkts_rcvd;
+	atomic_t	multicast_pkts_xmtd;
+	u32		broadcast_pkts_rcvd;
+	atomic_t	broadcast_pkts_xmtd;
+	u32		rcvd_pkts_dropped;
+
+	/* Tx Statistics. */
+	u32		tx_underflows;
+
+	u32		tx_collisions;
+	u32		tx_excessive_collisions;
+	u32		tx_first_collisions;
+	u32		tx_late_collisions;
+	u32		tx_max_pkt_errs;
+	u32		tx_deferred;
+
+	/* Rx Statistics. */
+	u32		rx_overflows;
+
+	u32		rx_length_errs;
+	u32		rx_align_errs;
+	u32		rx_crc_errs;
+	u32		rx_code_violations;
+	u32		rx_other_errs;
+
+	u32		synchronous_iterations;
+	u32		interrupt_status;
+};
+
+/* The private adapter structure */
+struct et131x_adapter {
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+	struct mii_bus *mii_bus;
+	struct phy_device *phydev;
+	struct work_struct task;
+
+	/* Flags that indicate current state of the adapter */
+	u32 flags;
+
+	/* local link state, to determine if a state change has occurred */
+	int link;
+
+	/* Configuration  */
+	u8 rom_addr[ETH_ALEN];
+	u8 addr[ETH_ALEN];
+	bool has_eeprom;
+	u8 eeprom_data[2];
+
+	/* Spinlocks */
+	spinlock_t lock;
+
+	spinlock_t tcb_send_qlock;
+	spinlock_t tcb_ready_qlock;
+	spinlock_t send_hw_lock;
+
+	spinlock_t rcv_lock;
+	spinlock_t rcv_pend_lock;
+	spinlock_t fbr_lock;
+
+	spinlock_t phy_lock;
+
+	/* Packet Filter and look ahead size */
+	u32 packet_filter;
+
+	/* multicast list */
+	u32 multicast_addr_count;
+	u8 multicast_list[NIC_MAX_MCAST_LIST][ETH_ALEN];
+
+	/* Pointer to the device's PCI register space */
+	struct address_map __iomem *regs;
+
+	/* Registry parameters */
+	u8 wanted_flow;		/* Flow we want for 802.3x flow control */
+	u32 registry_jumbo_packet;	/* Max supported ethernet packet size */
+
+	/* Derived from the registry: */
+	u8 flowcontrol;		/* flow control validated by the far-end */
+
+	/* Minimize init-time */
+	struct timer_list error_timer;
+
+	/* variable putting the phy into coma mode when boot up with no cable
+	 * plugged in after 5 seconds
+	 */
+	u8 boot_coma;
+
+	/* Next two used to save power information at power down. This
+	 * information will be used during power up to set up parts of Power
+	 * Management in JAGCore
+	 */
+	u16 pdown_speed;
+	u8 pdown_duplex;
+
+	/* Tx Memory Variables */
+	struct tx_ring tx_ring;
+
+	/* Rx Memory Variables */
+	struct rx_ring rx_ring;
+
+	/* Stats */
+	struct ce_stats stats;
+
+	struct net_device_stats net_stats;
+};
+
 void et131x_error_timer_handler(unsigned long data);
 void et131x_enable_interrupts(struct et131x_adapter *adapter);
 void et131x_disable_interrupts(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
deleted file mode 100644
index 74efdb0..0000000
-- 
1.7.6.4

