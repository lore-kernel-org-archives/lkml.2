Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab1JRQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:09:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1JRQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:54 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [RESEND][PATCH 08/26] staging: et131x: move et1310_rx.h contents into et131x.c
Date: Tue, 18 Oct 2011 17:07:41 +0100
Message-Id: <1318954079-16666-9-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move et1310_rx.h contents into et131x.c and delete et1310_rx.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_rx.h |  243 ------------------------------------
 drivers/staging/et131x/et131x.c    |  181 ++++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 244 deletions(-)
 delete mode 100644 drivers/staging/et131x/et1310_rx.h

diff --git a/drivers/staging/et131x/et1310_rx.h b/drivers/staging/et131x/et1310_rx.h
deleted file mode 100644
index b3b1bc9..0000000
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 402ab7f..484a626 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -82,7 +82,6 @@
 #include <linux/phy.h>
 
 #include "et1310_tx.h"
-#include "et1310_rx.h"
 #include "et131x.h"
 
 MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
@@ -186,6 +185,186 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define PARM_TX_NUM_BUFS_DEF    4
 #define PARM_DMA_CACHE_DEF      0
 
+/* RX defines */
+#define USE_FBR0 true
+
+#ifdef USE_FBR0
+/* #define FBR0_BUFFER_SIZE 256 */
+#endif
+
+/* #define FBR1_BUFFER_SIZE 2048 */
+
+#define FBR_CHUNKS 32
+
+#define MAX_DESC_PER_RING_RX         1024
+
+/* number of RFDs - default and min */
+#ifdef USE_FBR0
+#define RFD_LOW_WATER_MARK	40
+#define NIC_MIN_NUM_RFD		64
+#define NIC_DEFAULT_NUM_RFD	1024
+#else
+#define RFD_LOW_WATER_MARK	20
+#define NIC_MIN_NUM_RFD		64
+#define NIC_DEFAULT_NUM_RFD	256
+#endif
+
+#define NUM_PACKETS_HANDLED	256
+
+#define ALCATEL_BAD_STATUS	0xe47f0000
+#define ALCATEL_MULTICAST_PKT	0x01000000
+#define ALCATEL_BROADCAST_PKT	0x02000000
+
+/* typedefs for Free Buffer Descriptors */
+struct fbr_desc {
+	u32 addr_lo;
+	u32 addr_hi;
+	u32 word2;		/* Bits 10-31 reserved, 0-9 descriptor */
+};
+
+/* Packet Status Ring Descriptors
+ *
+ * Word 0:
+ *
+ * top 16 bits are from the Alcatel Status Word as enumerated in
+ * PE-MCXMAC Data Sheet IPD DS54 0210-1 (also IPD-DS80 0205-2)
+ *
+ * 0: hp			hash pass
+ * 1: ipa			IP checksum assist
+ * 2: ipp			IP checksum pass
+ * 3: tcpa			TCP checksum assist
+ * 4: tcpp			TCP checksum pass
+ * 5: wol			WOL Event
+ * 6: rxmac_error		RXMAC Error Indicator
+ * 7: drop			Drop packet
+ * 8: ft			Frame Truncated
+ * 9: jp			Jumbo Packet
+ * 10: vp			VLAN Packet
+ * 11-15: unused
+ * 16: asw_prev_pkt_dropped	e.g. IFG too small on previous
+ * 17: asw_RX_DV_event		short receive event detected
+ * 18: asw_false_carrier_event	bad carrier since last good packet
+ * 19: asw_code_err		one or more nibbles signalled as errors
+ * 20: asw_CRC_err		CRC error
+ * 21: asw_len_chk_err		frame length field incorrect
+ * 22: asw_too_long		frame length > 1518 bytes
+ * 23: asw_OK			valid CRC + no code error
+ * 24: asw_multicast		has a multicast address
+ * 25: asw_broadcast		has a broadcast address
+ * 26: asw_dribble_nibble	spurious bits after EOP
+ * 27: asw_control_frame	is a control frame
+ * 28: asw_pause_frame		is a pause frame
+ * 29: asw_unsupported_op	unsupported OP code
+ * 30: asw_VLAN_tag		VLAN tag detected
+ * 31: asw_long_evt		Rx long event
+ *
+ * Word 1:
+ * 0-15: length			length in bytes
+ * 16-25: bi			Buffer Index
+ * 26-27: ri			Ring Index
+ * 28-31: reserved
+ */
+
+struct pkt_stat_desc {
+	u32 word0;
+	u32 word1;
+};
+
+/* Typedefs for the RX DMA status word */
+
+/*
+ * rx status word 0 holds part of the status bits of the Rx DMA engine
+ * that get copied out to memory by the ET-1310.  Word 0 is a 32 bit word
+ * which contains the Free Buffer ring 0 and 1 available offset.
+ *
+ * bit 0-9 FBR1 offset
+ * bit 10 Wrap flag for FBR1
+ * bit 16-25 FBR0 offset
+ * bit 26 Wrap flag for FBR0
+ */
+
+/*
+ * RXSTAT_WORD1_t structure holds part of the status bits of the Rx DMA engine
+ * that get copied out to memory by the ET-1310.  Word 3 is a 32 bit word
+ * which contains the Packet Status Ring available offset.
+ *
+ * bit 0-15 reserved
+ * bit 16-27 PSRoffset
+ * bit 28 PSRwrap
+ * bit 29-31 unused
+ */
+
+/*
+ * struct rx_status_block is a structure representing the status of the Rx
+ * DMA engine it sits in free memory, and is pointed to by 0x101c / 0x1020
+ */
+struct rx_status_block {
+	u32 word0;
+	u32 word1;
+};
+
+/*
+ * Structure for look-up table holding free buffer ring pointers
+ */
+struct fbr_lookup {
+	void *virt[MAX_DESC_PER_RING_RX];
+	void *buffer1[MAX_DESC_PER_RING_RX];
+	void *buffer2[MAX_DESC_PER_RING_RX];
+	u32 bus_high[MAX_DESC_PER_RING_RX];
+	u32 bus_low[MAX_DESC_PER_RING_RX];
+};
+
+/*
+ * struct rx_ring is the sructure representing the adaptor's local
+ * reference(s) to the rings
+ */
+struct rx_ring {
+#ifdef USE_FBR0
+	void *fbr0_ring_virtaddr;
+	dma_addr_t fbr0_ring_physaddr;
+	void *fbr0_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	dma_addr_t fbr0_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	uint64_t fbr0_real_physaddr;
+	uint64_t fbr0_offset;
+	u32 local_fbr0_full;
+	u32 fbr0_num_entries;
+	u32 fbr0_buffsize;
+#endif
+	void *fbr1_ring_virtaddr;
+	dma_addr_t fbr1_ring_physaddr;
+	void *fbr1_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	dma_addr_t fbr1_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	uint64_t fbr1_real_physaddr;
+	uint64_t fbr1_offset;
+	struct fbr_lookup *fbr[2];	/* One per ring */
+	u32 local_fbr1_full;
+	u32 fbr1_num_entries;
+	u32 fbr1_buffsize;
+
+	void *ps_ring_virtaddr;
+	dma_addr_t ps_ring_physaddr;
+	u32 local_psr_full;
+	u32 psr_num_entries;
+
+	struct rx_status_block *rx_status_block;
+	dma_addr_t rx_status_bus;
+
+	struct list_head recv_buff_pool;
+
+	/* RECV */
+	struct list_head recv_list;
+	u32 num_ready_recv;
+
+	u32 num_rfd;
+
+	bool unfinished_receives;
+
+	struct list_head recv_packet_pool;
+
+	/* lookaside lists */
+	struct kmem_cache *recv_lookaside;
+};
+
 /* ADAPTER defines */
 /*
  * Do not change these values: if changed, then change also in respective
-- 
1.7.6.4

