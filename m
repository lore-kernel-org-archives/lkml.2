Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2DEQEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:04:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56549 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2DEQEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:04:49 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3 7/9] mtd: nand: omap2: use gpmc provided irqs
Date: Thu, 5 Apr 2012 21:17:01 +0530
Message-ID: <9787e29348c451d3454104320ac2fa58f852fe82.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPMC driver provides it's clientsd with interrupts that can be used
through struct resource. Make use of it for irq mode functionality.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/mtd/nand/omap2.c |   67 +++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index be4b321..440536b 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -121,7 +121,8 @@ struct omap_nand_info {
 	unsigned long			mem_size;
 	struct completion		comp;
 	int				dma_ch;
-	int				gpmc_irq;
+	int				gpmc_irq_fifo;
+	int				gpmc_irq_count;
 	enum {
 		OMAP_NAND_IO_READ = 0,	/* read */
 		OMAP_NAND_IO_WRITE,	/* write */
@@ -472,13 +473,11 @@ static irqreturn_t omap_nand_irq(int this_irq, void *dev)
 {
 	struct omap_nand_info *info = (struct omap_nand_info *) dev;
 	u32 bytes;
-	u32 irq_stat;
 
-	irq_stat = gpmc_read_status(GPMC_GET_IRQ_STATUS);
 	bytes = gpmc_read_status(GPMC_PREFETCH_FIFO_CNT);
 	bytes = bytes  & 0xFFFC; /* io in multiple of 4 bytes */
 	if (info->iomode == OMAP_NAND_IO_WRITE) { /* checks for write io */
-		if (irq_stat & 0x2)
+		if (this_irq == info->gpmc_irq_count)
 			goto done;
 
 		if (info->buf_len && (info->buf_len < bytes))
@@ -495,20 +494,17 @@ static irqreturn_t omap_nand_irq(int this_irq, void *dev)
 						(u32 *)info->buf, bytes >> 2);
 		info->buf = info->buf + bytes;
 
-		if (irq_stat & 0x2)
+		if (this_irq == info->gpmc_irq_count)
 			goto done;
 	}
-	gpmc_cs_configure(info->gpmc_cs, GPMC_SET_IRQ_STATUS, irq_stat);
 
 	return IRQ_HANDLED;
 
 done:
 	complete(&info->comp);
-	/* disable irq */
-	gpmc_cs_configure(info->gpmc_cs, GPMC_ENABLE_IRQ, 0);
 
-	/* clear status */
-	gpmc_cs_configure(info->gpmc_cs, GPMC_SET_IRQ_STATUS, irq_stat);
+	disable_irq_nosync(info->gpmc_irq_fifo);
+	disable_irq_nosync(info->gpmc_irq_count);
 
 	return IRQ_HANDLED;
 }
@@ -542,9 +538,9 @@ static void omap_read_buf_irq_pref(struct mtd_info *mtd, u_char *buf, int len)
 		goto out_copy;
 
 	info->buf_len = len;
-	/* enable irq */
-	gpmc_cs_configure(info->gpmc_cs, GPMC_ENABLE_IRQ,
-		(GPMC_IRQ_FIFOEVENTENABLE | GPMC_IRQ_COUNT_EVENT));
+
+	enable_irq(info->gpmc_irq_count);
+	enable_irq(info->gpmc_irq_fifo);
 
 	/* waiting for read to complete */
 	wait_for_completion(&info->comp);
@@ -591,12 +587,13 @@ static void omap_write_buf_irq_pref(struct mtd_info *mtd,
 		goto out_copy;
 
 	info->buf_len = len;
-	/* enable irq */
-	gpmc_cs_configure(info->gpmc_cs, GPMC_ENABLE_IRQ,
-			(GPMC_IRQ_FIFOEVENTENABLE | GPMC_IRQ_COUNT_EVENT));
+
+	enable_irq(info->gpmc_irq_count);
+	enable_irq(info->gpmc_irq_fifo);
 
 	/* waiting for write to complete */
 	wait_for_completion(&info->comp);
+
 	/* wait for data to flushed-out before reset the prefetch */
 	tim = 0;
 	limit = (loops_per_jiffy *  msecs_to_jiffies(OMAP_NAND_TIMEOUT_MS));
@@ -982,6 +979,14 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 		goto out_release_mem_region;
 	}
 
+	info->gpmc_irq_fifo = platform_get_irq(pdev, 0);
+	if (info->gpmc_irq_fifo == -ENXIO)
+		dev_warn(&pdev->dev, "error getting FIFO IRQ\n");
+
+	info->gpmc_irq_count = platform_get_irq(pdev, 1);
+	if (info->gpmc_irq_fifo == -ENXIO)
+		dev_warn(&pdev->dev, "error getting TERMINALCOUNT IRQ\n");
+
 	info->nand.controller = &info->controller;
 
 	info->nand.IO_ADDR_W = info->nand.IO_ADDR_R;
@@ -1037,17 +1042,24 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 		break;
 
 	case NAND_OMAP_PREFETCH_IRQ:
-		err = request_irq(pdata->gpmc_irq,
-				omap_nand_irq, IRQF_SHARED, "gpmc-nand", info);
+		err = request_irq(info->gpmc_irq_fifo,	omap_nand_irq,
+					IRQF_SHARED, "gpmc-nand-fifo", info);
 		if (err) {
 			dev_err(&pdev->dev, "requesting irq(%d) error:%d",
-							pdata->gpmc_irq, err);
+						info->gpmc_irq_fifo, err);
 			goto out_release_mem_region;
-		} else {
-			info->gpmc_irq	     = pdata->gpmc_irq;
-			info->nand.read_buf  = omap_read_buf_irq_pref;
-			info->nand.write_buf = omap_write_buf_irq_pref;
 		}
+		err = request_irq(info->gpmc_irq_count,	omap_nand_irq,
+					IRQF_SHARED, "gpmc-nand-count", info);
+		if (err) {
+			dev_err(&pdev->dev, "requesting irq(%d) error:%d",
+						info->gpmc_irq_count, err);
+			goto out_free_irq_gpmc_fifo;
+		}
+
+		info->nand.read_buf  = omap_read_buf_irq_pref;
+		info->nand.write_buf = omap_write_buf_irq_pref;
+
 		break;
 
 	default:
@@ -1117,6 +1129,8 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 
 	return 0;
 
+out_free_irq_gpmc_fifo:
+	free_irq(info->gpmc_irq_fifo, info);
 out_release_mem_region:
 	release_mem_region(info->phys_base, info->mem_size);
 out_free_info:
@@ -1135,8 +1149,11 @@ static int omap_nand_remove(struct platform_device *pdev)
 	if (info->dma_ch != -1)
 		omap_free_dma(info->dma_ch);
 
-	if (info->gpmc_irq)
-		free_irq(info->gpmc_irq, info);
+	if (info->gpmc_irq_fifo > 0)
+		free_irq(info->gpmc_irq_fifo, info);
+
+	if (info->gpmc_irq_count > 0)
+		free_irq(info->gpmc_irq_count, info);
 
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
-- 
1.7.9.3

