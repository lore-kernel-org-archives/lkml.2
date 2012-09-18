Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2IRNih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:38:37 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47218 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab2IRNi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:38:27 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 2/2] rapidio/tsi721: add inbound memory mapping callbacks
Date: Tue, 18 Sep 2012 09:37:21 -0400
Message-Id: <1347975441-6723-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1347975441-6723-1-git-send-email-alexandre.bounine@idt.com>
References: <1347975441-6723-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Tsi721 routines to support RapidIO subsystem's inbound memory mapping
interface (RapidIO to system's local memory). 

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rapidio/devices/tsi721.c |   88 +++++++++++++++++++++++++++++++++++++-
 drivers/rapidio/devices/tsi721.h |   15 +++++-
 2 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 1974359..961dc7a 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -862,6 +862,90 @@ static void tsi721_init_pc2sr_mapping(struct tsi721_device *priv)
 }
 
 /**
+ * tsi721_rio_map_inb_mem -- Mapping inbound memory region.
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the inbound mapping
+ * from rstart to lstart.
+ */
+static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
+		u64 rstart, u32 size, u32 flags)
+{
+	struct tsi721_device *priv = mport->priv;
+	int i;
+	u32 regval;
+
+	if (!is_power_of_2(size) || size < 0x1000 ||
+	    ((u64)lstart & (size - 1)) || (rstart & (size - 1)))
+		return -EINVAL;
+
+	/* Search for free inbound translation window */
+	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
+		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
+		if (!(regval & TSI721_IBWIN_LB_WEN))
+			break;
+	}
+
+	if (i >= TSI721_IBWIN_NUM) {
+		dev_err(&priv->pdev->dev,
+			"Unable to find free inbound window\n");
+		return -EBUSY;
+	}
+
+	iowrite32(TSI721_IBWIN_SIZE(size) << 8,
+			priv->regs + TSI721_IBWIN_SZ(i));
+
+	iowrite32(((u64)lstart >> 32), priv->regs + TSI721_IBWIN_TUA(i));
+	iowrite32(((u64)lstart & TSI721_IBWIN_TLA_ADD),
+		  priv->regs + TSI721_IBWIN_TLA(i));
+
+	iowrite32(rstart >> 32, priv->regs + TSI721_IBWIN_UB(i));
+	iowrite32((rstart & TSI721_IBWIN_LB_BA) | TSI721_IBWIN_LB_WEN,
+		priv->regs + TSI721_IBWIN_LB(i));
+	dev_dbg(&priv->pdev->dev,
+		"Configured IBWIN%d mapping (RIO_0x%llx -> PCIe_0x%llx)\n",
+		i, rstart, (unsigned long long)lstart);
+
+	return 0;
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @mport: RapidIO master port
+ * @lstart: Local memory space start address.
+ */
+static void tsi721_rio_unmap_inb_mem(struct rio_mport *mport,
+				dma_addr_t lstart)
+{
+	struct tsi721_device *priv = mport->priv;
+	int i;
+	u64 addr;
+	u32 regval;
+
+	/* Search for matching active inbound translation window */
+	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
+		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
+		if (regval & TSI721_IBWIN_LB_WEN) {
+			regval = ioread32(priv->regs + TSI721_IBWIN_TUA(i));
+			addr = (u64)regval << 32;
+			regval = ioread32(priv->regs + TSI721_IBWIN_TLA(i));
+			addr |= regval & TSI721_IBWIN_TLA_ADD;
+
+			if (addr == (u64)lstart) {
+				iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
+				break;
+			}
+		}
+	}
+}
+
+/**
  * tsi721_init_sr2pc_mapping - initializes inbound (SRIO->PCIe)
  * translation regions.
  * @priv: pointer to tsi721 private data
@@ -874,7 +958,7 @@ static void tsi721_init_sr2pc_mapping(struct tsi721_device *priv)
 
 	/* Disable all SR2PC inbound windows */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++)
-		iowrite32(0, priv->regs + TSI721_IBWINLB(i));
+		iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
 }
 
 /**
@@ -2144,6 +2228,8 @@ static int __devinit tsi721_setup_mport(struct tsi721_device *priv)
 	ops->add_outb_message = tsi721_add_outb_message;
 	ops->add_inb_buffer = tsi721_add_inb_buffer;
 	ops->get_inb_message = tsi721_get_inb_message;
+	ops->map_inb = tsi721_rio_map_inb_mem;
+	ops->unmap_inb = tsi721_rio_unmap_inb_mem;
 
 	mport = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!mport) {
diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
index 59de9d7..7d5b13b 100644
--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -156,9 +156,18 @@
 
 #define TSI721_IBWIN_NUM	8
 
-#define TSI721_IBWINLB(x)	(0x29000 + (x) * 0x20)
-#define TSI721_IBWINLB_BA	0xfffff000
-#define TSI721_IBWINLB_WEN	0x00000001
+#define TSI721_IBWIN_LB(x)	(0x29000 + (x) * 0x20)
+#define TSI721_IBWIN_LB_BA	0xfffff000
+#define TSI721_IBWIN_LB_WEN	0x00000001
+
+#define TSI721_IBWIN_UB(x)	(0x29004 + (x) * 0x20)
+#define TSI721_IBWIN_SZ(x)	(0x29008 + (x) * 0x20)
+#define TSI721_IBWIN_SZ_SIZE	0x00001f00
+#define TSI721_IBWIN_SIZE(size)	(__fls(size) - 12)
+
+#define TSI721_IBWIN_TLA(x)	(0x2900c + (x) * 0x20)
+#define TSI721_IBWIN_TLA_ADD	0xfffff000
+#define TSI721_IBWIN_TUA(x)	(0x29010 + (x) * 0x20)
 
 #define TSI721_SR2PC_GEN_INTE	0x29800
 #define TSI721_SR2PC_PWE	0x29804
-- 
1.7.8.4

