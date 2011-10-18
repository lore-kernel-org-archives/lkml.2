Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab1JRQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:09:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56765 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab1JRQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:56 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [RESEND][PATCH 09/26] staging: et131x: move et1310_tx.h contents into et131x.c
Date: Tue, 18 Oct 2011 17:07:42 +0100
Message-Id: <1318954079-16666-10-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move et1310_tx.h contents into et131x.c and delete et1310_tx.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_tx.h |  150 ------------------------------------
 drivers/staging/et131x/et131x.c    |   87 ++++++++++++++++++++-
 2 files changed, 86 insertions(+), 151 deletions(-)
 delete mode 100644 drivers/staging/et131x/et1310_tx.h

diff --git a/drivers/staging/et131x/et1310_tx.h b/drivers/staging/et131x/et1310_tx.h
deleted file mode 100644
index 82d06e9..0000000
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 484a626..9596102 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -81,7 +81,6 @@
 #include <linux/random.h>
 #include <linux/phy.h>
 
-#include "et1310_tx.h"
 #include "et131x.h"
 
 MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
@@ -365,6 +364,92 @@ struct rx_ring {
 	struct kmem_cache *recv_lookaside;
 };
 
+/* TX defines */
+/*
+ * word 2 of the control bits in the Tx Descriptor ring for the ET-1310
+ *
+ * 0-15: length of packet
+ * 16-27: VLAN tag
+ * 28: VLAN CFI
+ * 29-31: VLAN priority
+ *
+ * word 3 of the control bits in the Tx Descriptor ring for the ET-1310
+ *
+ * 0: last packet in the sequence
+ * 1: first packet in the sequence
+ * 2: interrupt the processor when this pkt sent
+ * 3: Control word - no packet data
+ * 4: Issue half-duplex backpressure : XON/XOFF
+ * 5: send pause frame
+ * 6: Tx frame has error
+ * 7: append CRC
+ * 8: MAC override
+ * 9: pad packet
+ * 10: Packet is a Huge packet
+ * 11: append VLAN tag
+ * 12: IP checksum assist
+ * 13: TCP checksum assist
+ * 14: UDP checksum assist
+ */
+
+/* struct tx_desc represents each descriptor on the ring */
+struct tx_desc {
+	u32 addr_hi;
+	u32 addr_lo;
+	u32 len_vlan;	/* control words how to xmit the */
+	u32 flags;	/* data (detailed above) */
+};
+
+/*
+ * The status of the Tx DMA engine it sits in free memory, and is pointed to
+ * by 0x101c / 0x1020. This is a DMA10 type
+ */
+
+/* TCB (Transmit Control Block: Host Side) */
+struct tcb {
+	struct tcb *next;	/* Next entry in ring */
+	u32 flags;		/* Our flags for the packet */
+	u32 count;		/* Used to spot stuck/lost packets */
+	u32 stale;		/* Used to spot stuck/lost packets */
+	struct sk_buff *skb;	/* Network skb we are tied to */
+	u32 index;		/* Ring indexes */
+	u32 index_start;
+};
+
+/* Structure representing our local reference(s) to the ring */
+struct tx_ring {
+	/* TCB (Transmit Control Block) memory and lists */
+	struct tcb *tcb_ring;
+
+	/* List of TCBs that are ready to be used */
+	struct tcb *tcb_qhead;
+	struct tcb *tcb_qtail;
+
+	/* list of TCBs that are currently being sent.  NOTE that access to all
+	 * three of these (including used) are controlled via the
+	 * TCBSendQLock.  This lock should be secured prior to incementing /
+	 * decrementing used, or any queue manipulation on send_head /
+	 * tail
+	 */
+	struct tcb *send_head;
+	struct tcb *send_tail;
+	int used;
+
+	/* The actual descriptor ring */
+	struct tx_desc *tx_desc_ring;
+	dma_addr_t tx_desc_ring_pa;
+
+	/* send_idx indicates where we last wrote to in the descriptor ring. */
+	u32 send_idx;
+
+	/* The location of the write-back status block */
+	u32 *tx_status;
+	dma_addr_t tx_status_pa;
+
+	/* Packets since the last IRQ: used for interrupt coalescing */
+	int since_irq;
+};
+
 /* ADAPTER defines */
 /*
  * Do not change these values: if changed, then change also in respective
-- 
1.7.6.4

