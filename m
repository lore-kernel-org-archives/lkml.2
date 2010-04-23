Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0DWVa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:30:27 -0400
Received: from tex.lwn.net ([70.33.254.29]:50590 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0DWV2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:42 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 11/13] viafb: Add a simple VX855 DMA engine driver
Date: Fri, 23 Apr 2010 15:28:11 -0600
Message-Id: <1272058093-20914-12-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code provides a minimal amount of access to the DMA engine as
needed by the camera driver.  VX855 only; it's guaranteed not to work
on other chipsets, so it won't try.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |  232 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via-core.h |   29 +++++
 2 files changed, 261 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index d368f4f..957af6b 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -13,6 +13,7 @@
 #include "global.h"
 
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/platform_device.h>
 
 /*
@@ -92,7 +93,238 @@ void viafb_irq_disable(u32 mask)
 }
 EXPORT_SYMBOL_GPL(viafb_irq_disable);
 
+/* ---------------------------------------------------------------------- */
+/*
+ * Access to the DMA engine.  This currently provides what the camera
+ * driver needs (i.e. outgoing only) but is easily expandable if need
+ * be.
+ */
+
+/*
+ * There are four DMA channels in the vx855.  For now, we only
+ * use one of them, though.  Most of the time, the DMA channel
+ * will be idle, so we keep the IRQ handler unregistered except
+ * when some subsystem has indicated an interest.
+ */
+static int viafb_dma_users;
+static DECLARE_COMPLETION(viafb_dma_completion);
+/*
+ * This mutex protects viafb_dma_users and our global interrupt
+ * registration state; it also serializes access to the DMA
+ * engine.
+ */
+static DEFINE_MUTEX(viafb_dma_lock);
+
+/*
+ * The VX855 DMA descriptor (used for s/g transfers) looks
+ * like this.
+ */
+struct viafb_vx855_dma_descr {
+	u32	addr_low;	/* Low part of phys addr */
+	u32	addr_high;	/* High 12 bits of addr */
+	u32	fb_offset;	/* Offset into FB memory */
+	u32	seg_size;	/* Size, 16-byte units */
+	u32	tile_mode;	/* "tile mode" setting */
+	u32	next_desc_low;	/* Next descriptor addr */
+	u32	next_desc_high;
+	u32	pad;		/* Fill out to 64 bytes */
+};
+
+/*
+ * Flags added to the "next descriptor low" pointers
+ */
+#define VIAFB_DMA_MAGIC		0x01  /* ??? Just has to be there */
+#define VIAFB_DMA_FINAL_SEGMENT 0x02  /* Final segment */
+
+/*
+ * The completion IRQ handler.
+ */
+static irqreturn_t viafb_dma_irq(int irq, void *data)
+{
+	int csr;
+	irqreturn_t ret = IRQ_NONE;
+
+	spin_lock(&global_dev.reg_lock);
+	csr = viafb_mmio_read(VDMA_CSR0);
+	if (csr & VDMA_C_DONE) {
+		viafb_mmio_write(VDMA_CSR0, VDMA_C_DONE);
+		complete(&viafb_dma_completion);
+		ret = IRQ_HANDLED;
+	}
+	spin_unlock(&global_dev.reg_lock);
+	return ret;
+}
+
+/*
+ * Indicate a need for DMA functionality.
+ */
+int viafb_request_dma(void)
+{
+	int ret = 0;
+
+	/*
+	 * Only VX855 is supported currently.
+	 */
+	if (global_dev.chip_type != UNICHROME_VX855)
+		return -ENODEV;
+	/*
+	 * Note the new user and set up our interrupt handler
+	 * if need be.
+	 */
+	mutex_lock(&viafb_dma_lock);
+	viafb_dma_users++;
+	if (viafb_dma_users == 1) {
+		ret = request_irq(global_dev.pdev->irq, viafb_dma_irq,
+				IRQF_SHARED, "via-dma", &viafb_dma_users);
+		if (ret)
+			viafb_dma_users--;
+		else
+			viafb_irq_enable(VDE_I_DMA0TDEN);
+	}
+	mutex_unlock(&viafb_dma_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(viafb_request_dma);
+
+void viafb_release_dma(void)
+{
+	mutex_lock(&viafb_dma_lock);
+	viafb_dma_users--;
+	if (viafb_dma_users == 0) {
+		viafb_irq_disable(VDE_I_DMA0TDEN);
+		free_irq(global_dev.pdev->irq, &viafb_dma_users);
+	}
+	mutex_unlock(&viafb_dma_lock);
+}
+EXPORT_SYMBOL_GPL(viafb_release_dma);
+
+
+#if 0
+/*
+ * Copy a single buffer from FB memory, synchronously.  This code works
+ * but is not currently used.
+ */
+void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int len)
+{
+	unsigned long flags;
+	int csr;
+
+	mutex_lock(&viafb_dma_lock);
+	init_completion(&viafb_dma_completion);
+	/*
+	 * Program the controller.
+	 */
+	spin_lock_irqsave(&global_dev.reg_lock, flags);
+	viafb_mmio_write(VDMA_CSR0, VDMA_C_ENABLE|VDMA_C_DONE);
+	/* Enable ints; must happen after CSR0 write! */
+	viafb_mmio_write(VDMA_MR0, VDMA_MR_TDIE);
+	viafb_mmio_write(VDMA_MARL0, (int) (paddr & 0xfffffff0));
+	viafb_mmio_write(VDMA_MARH0, (int) ((paddr >> 28) & 0xfff));
+	/* Data sheet suggests DAR0 should be <<4, but it lies */
+	viafb_mmio_write(VDMA_DAR0, offset);
+	viafb_mmio_write(VDMA_DQWCR0, len >> 4);
+	viafb_mmio_write(VDMA_TMR0, 0);
+	viafb_mmio_write(VDMA_DPRL0, 0);
+	viafb_mmio_write(VDMA_DPRH0, 0);
+	viafb_mmio_write(VDMA_PMR0, 0);
+	csr = viafb_mmio_read(VDMA_CSR0);
+	viafb_mmio_write(VDMA_CSR0, VDMA_C_ENABLE|VDMA_C_START);
+	spin_unlock_irqrestore(&global_dev.reg_lock, flags);
+	/*
+	 * Now we just wait until the interrupt handler says
+	 * we're done.
+	 */
+	wait_for_completion_interruptible(&viafb_dma_completion);
+	viafb_mmio_write(VDMA_MR0, 0); /* Reset int enable */
+	mutex_unlock(&viafb_dma_lock);
+}
+EXPORT_SYMBOL_GPL(viafb_dma_copy_out);
+#endif
+
+/*
+ * Do a scatter/gather DMA copy from FB memory.  You must have done
+ * a successful call to viafb_request_dma() first.
+ */
+int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg)
+{
+	struct viafb_vx855_dma_descr *descr;
+	void *descrpages;
+	dma_addr_t descr_handle;
+	unsigned long flags;
+	int i;
+	struct scatterlist *sgentry;
+	dma_addr_t nextdesc;
 
+	/*
+	 * Get a place to put the descriptors.
+	 */
+	descrpages = dma_alloc_coherent(&global_dev.pdev->dev,
+			nsg*sizeof(struct viafb_vx855_dma_descr),
+			&descr_handle, GFP_KERNEL);
+	if (descrpages == NULL) {
+		dev_err(&global_dev.pdev->dev, "Unable to get descr page.\n");
+		return -ENOMEM;
+	}
+	mutex_lock(&viafb_dma_lock);
+	/*
+	 * Fill them in.
+	 */
+	descr = descrpages;
+	nextdesc = descr_handle + sizeof(struct viafb_vx855_dma_descr);
+	for_each_sg(sg, sgentry, nsg, i) {
+		dma_addr_t paddr = sg_dma_address(sgentry);
+		descr->addr_low = paddr & 0xfffffff0;
+		descr->addr_high = ((u64) paddr >> 32) & 0x0fff;
+		descr->fb_offset = offset;
+		descr->seg_size = sg_dma_len(sgentry) >> 4;
+		descr->tile_mode = 0;
+		descr->next_desc_low = (nextdesc&0xfffffff0) | VIAFB_DMA_MAGIC;
+		descr->next_desc_high = ((u64) nextdesc >> 32) & 0x0fff;
+		descr->pad = 0xffffffff;  /* VIA driver does this */
+		offset += sg_dma_len(sgentry);
+		nextdesc += sizeof(struct viafb_vx855_dma_descr);
+		descr++;
+	}
+	descr[-1].next_desc_low = VIAFB_DMA_FINAL_SEGMENT|VIAFB_DMA_MAGIC;
+	/*
+	 * Program the engine.
+	 */
+	spin_lock_irqsave(&global_dev.reg_lock, flags);
+	init_completion(&viafb_dma_completion);
+	viafb_mmio_write(VDMA_DQWCR0, 0);
+	viafb_mmio_write(VDMA_CSR0, VDMA_C_ENABLE|VDMA_C_DONE);
+	viafb_mmio_write(VDMA_MR0, VDMA_MR_TDIE | VDMA_MR_CHAIN);
+	viafb_mmio_write(VDMA_DPRL0, descr_handle | VIAFB_DMA_MAGIC);
+	viafb_mmio_write(VDMA_DPRH0,
+			(((u64)descr_handle >> 32) & 0x0fff) | 0xf0000);
+	(void) viafb_mmio_read(VDMA_CSR0);
+	viafb_mmio_write(VDMA_CSR0, VDMA_C_ENABLE|VDMA_C_START);
+	spin_unlock_irqrestore(&global_dev.reg_lock, flags);
+	/*
+	 * Now we just wait until the interrupt handler says
+	 * we're done.  Except that, actually, we need to wait a little
+	 * longer: the interrupts seem to jump the gun a little and we
+	 * get corrupted frames sometimes.
+	 */
+	wait_for_completion_timeout(&viafb_dma_completion, 1);
+	msleep(1);
+	if ((viafb_mmio_read(VDMA_CSR0)&VDMA_C_DONE) == 0)
+		printk(KERN_ERR "VIA DMA timeout!\n");
+	/*
+	 * Clean up and we're done.
+	 */
+	viafb_mmio_write(VDMA_CSR0, VDMA_C_DONE);
+	viafb_mmio_write(VDMA_MR0, 0); /* Reset int enable */
+	mutex_unlock(&viafb_dma_lock);
+	dma_free_coherent(&global_dev.pdev->dev,
+			nsg*sizeof(struct viafb_vx855_dma_descr), descrpages,
+			descr_handle);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(viafb_dma_copy_out_sg);
+
+
+/* ---------------------------------------------------------------------- */
 /*
  * Figure out how big our framebuffer memory is.  Kind of ugly,
  * but evidently we can't trust the information found in the
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index ba64b36..3d03141 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -131,4 +131,33 @@ void viafb_irq_disable(u32 mask);
 #define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
 #define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
 
+/*
+ * DMA management.
+ */
+int viafb_request_dma(void);
+void viafb_release_dma(void);
+/* void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int len); */
+int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
+
+/*
+ * DMA Controller registers.
+ */
+#define VDMA_MR0	0xe00		/* Mod reg 0 */
+#define   VDMA_MR_CHAIN   0x01		/* Chaining mode */
+#define   VDMA_MR_TDIE    0x02		/* Transfer done int enable */
+#define VDMA_CSR0	0xe04		/* Control/status */
+#define	  VDMA_C_ENABLE	  0x01		  /* DMA Enable */
+#define	  VDMA_C_START	  0x02		  /* Start a transfer */
+#define	  VDMA_C_ABORT	  0x04		  /* Abort a transfer */
+#define	  VDMA_C_DONE	  0x08		  /* Transfer is done */
+#define VDMA_MARL0	0xe20		/* Mem addr low */
+#define VDMA_MARH0	0xe24		/* Mem addr high */
+#define VDMA_DAR0	0xe28		/* Device address */
+#define VDMA_DQWCR0	0xe2c		/* Count (16-byte) */
+#define VDMA_TMR0	0xe30		/* Tile mode reg */
+#define VDMA_DPRL0	0xe34		/* Not sure */
+#define	  VDMA_DPR_IN	  0x08		/* Inbound transfer to FB */
+#define VDMA_DPRH0	0xe38
+#define VDMA_PMR0	(0xe00 + 0x134) /* Pitch mode */
+
 #endif /* __VIA_CORE_H__ */
-- 
1.7.0.1

