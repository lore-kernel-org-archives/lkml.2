Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2J1IIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:08:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50623 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755283Ab2J1IIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:08:25 -0400
From: Joe Perches <joe@perches.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] dma: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:44 -0700
Message-Id: <cf922e807ca2ec44837ffc7a320851e9c5272d03.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/at_hdmac_regs.h |    8 +++---
 drivers/dma/iop-adma.c      |   45 +++++++++++++++----------------
 drivers/dma/mv_xor.c        |   62 ++++++++++++++++++------------------------
 3 files changed, 53 insertions(+), 62 deletions(-)

diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 116e4ad..0eb3c13 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -369,10 +369,10 @@ static void vdbg_dump_regs(struct at_dma_chan *atchan) {}
 
 static void atc_dump_lli(struct at_dma_chan *atchan, struct at_lli *lli)
 {
-	dev_printk(KERN_CRIT, chan2dev(&atchan->chan_common),
-			"  desc: s0x%x d0x%x ctrl0x%x:0x%x l0x%x\n",
-			lli->saddr, lli->daddr,
-			lli->ctrla, lli->ctrlb, lli->dscr);
+	dev_crit(chan2dev(&atchan->chan_common),
+		 "  desc: s0x%x d0x%x ctrl0x%x:0x%x l0x%x\n",
+		 lli->saddr, lli->daddr,
+		 lli->ctrla, lli->ctrlb, lli->dscr);
 }
 
 
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 79e3eba..e11d930 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -936,7 +936,7 @@ static irqreturn_t iop_adma_err_handler(int irq, void *data)
 	struct iop_adma_chan *chan = data;
 	unsigned long status = iop_chan_get_status(chan);
 
-	dev_printk(KERN_ERR, chan->device->common.dev,
+	dev_err(chan->device->common.dev,
 		"error ( %s%s%s%s%s%s%s)\n",
 		iop_is_err_int_parity(status, chan) ? "int_parity " : "",
 		iop_is_err_mcu_abort(status, chan) ? "mcu_abort " : "",
@@ -1017,7 +1017,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 
 	if (iop_adma_status(dma_chan, cookie, NULL) !=
 			DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test copy timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1027,7 +1027,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	dma_sync_single_for_cpu(&iop_chan->device->pdev->dev, dest_dma,
 		IOP_ADMA_TEST_SIZE, DMA_FROM_DEVICE);
 	if (memcmp(src, dest, IOP_ADMA_TEST_SIZE)) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test copy failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1117,7 +1117,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 
 	if (iop_adma_status(dma_chan, cookie, NULL) !=
 		DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test xor timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1129,7 +1129,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i] != cmp_word) {
-			dev_printk(KERN_ERR, dma_chan->device->dev,
+			dev_err(dma_chan->device->dev,
 				"Self-test xor failed compare, disabling\n");
 			err = -ENODEV;
 			goto free_resources;
@@ -1163,14 +1163,14 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	msleep(8);
 
 	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test zero sum timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
 
 	if (zero_sum_result != 0) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test zero sum failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1187,7 +1187,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	msleep(8);
 
 	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test memset timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1196,7 +1196,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	for (i = 0; i < PAGE_SIZE/sizeof(u32); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i]) {
-			dev_printk(KERN_ERR, dma_chan->device->dev,
+			dev_err(dma_chan->device->dev,
 				"Self-test memset failed compare, disabling\n");
 			err = -ENODEV;
 			goto free_resources;
@@ -1219,14 +1219,14 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	msleep(8);
 
 	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test non-zero sum timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
 
 	if (zero_sum_result != 1) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
+		dev_err(dma_chan->device->dev,
 			"Self-test non-zero sum failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
@@ -1579,15 +1579,14 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 			goto err_free_iop_chan;
 	}
 
-	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
-	  "( %s%s%s%s%s%s%s)\n",
-	  dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
-	  dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
-	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
-	  dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask) ? "xor_val " : "",
-	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
-	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
-	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
+	dev_info(&pdev->dev, "Intel(R) IOP: ( %s%s%s%s%s%s%s)\n",
+		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
+		 dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
+		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
+		 dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask) ? "xor_val " : "",
+		 dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
+		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
+		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
 	dma_async_device_register(dma_dev);
 	goto out;
@@ -1651,8 +1650,8 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
 		/* run the descriptor */
 		iop_chan_enable(iop_chan);
 	} else
-		dev_printk(KERN_ERR, iop_chan->device->common.dev,
-			 "failed to allocate null descriptor\n");
+		dev_err(iop_chan->device->common.dev,
+			"failed to allocate null descriptor\n");
 	spin_unlock_bh(&iop_chan->lock);
 }
 
@@ -1704,7 +1703,7 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 		/* run the descriptor */
 		iop_chan_enable(iop_chan);
 	} else
-		dev_printk(KERN_ERR, iop_chan->device->common.dev,
+		dev_err(iop_chan->device->common.dev,
 			"failed to allocate null descriptor\n");
 	spin_unlock_bh(&iop_chan->lock);
 }
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index e362e2b..f9d09ae 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -206,9 +206,9 @@ static void mv_set_mode(struct mv_xor_chan *chan,
 		op_mode = XOR_OPERATION_MODE_MEMSET;
 		break;
 	default:
-		dev_printk(KERN_ERR, chan->device->common.dev,
-			   "error: unsupported operation %d.\n",
-			   type);
+		dev_err(chan->device->common.dev,
+			"error: unsupported operation %d\n",
+			type);
 		BUG();
 		return;
 	}
@@ -828,28 +828,22 @@ static void mv_dump_xor_regs(struct mv_xor_chan *chan)
 	u32 val;
 
 	val = __raw_readl(XOR_CONFIG(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "config       0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "config       0x%08x\n", val);
 
 	val = __raw_readl(XOR_ACTIVATION(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "activation   0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "activation   0x%08x\n", val);
 
 	val = __raw_readl(XOR_INTR_CAUSE(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "intr cause   0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "intr cause   0x%08x\n", val);
 
 	val = __raw_readl(XOR_INTR_MASK(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "intr mask    0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "intr mask    0x%08x\n", val);
 
 	val = __raw_readl(XOR_ERROR_CAUSE(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "error cause  0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "error cause  0x%08x\n", val);
 
 	val = __raw_readl(XOR_ERROR_ADDR(chan));
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "error addr   0x%08x.\n", val);
+	dev_err(chan->device->common.dev, "error addr   0x%08x\n", val);
 }
 
 static void mv_xor_err_interrupt_handler(struct mv_xor_chan *chan,
@@ -861,9 +855,9 @@ static void mv_xor_err_interrupt_handler(struct mv_xor_chan *chan,
 	     return;
 	}
 
-	dev_printk(KERN_ERR, chan->device->common.dev,
-		   "error on chan %d. intr cause 0x%08x.\n",
-		   chan->idx, intr_cause);
+	dev_err(chan->device->common.dev,
+		"error on chan %d. intr cause 0x%08x\n",
+		chan->idx, intr_cause);
 
 	mv_dump_xor_regs(chan);
 	BUG();
@@ -950,8 +944,8 @@ static int __devinit mv_xor_memcpy_self_test(struct mv_xor_device *device)
 
 	if (mv_xor_status(dma_chan, cookie, NULL) !=
 	    DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
-			   "Self-test copy timed out, disabling\n");
+		dev_err(dma_chan->device->dev,
+			"Self-test copy timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
@@ -960,8 +954,8 @@ static int __devinit mv_xor_memcpy_self_test(struct mv_xor_device *device)
 	dma_sync_single_for_cpu(&mv_chan->device->pdev->dev, dest_dma,
 				MV_XOR_TEST_SIZE, DMA_FROM_DEVICE);
 	if (memcmp(src, dest, MV_XOR_TEST_SIZE)) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
-			   "Self-test copy failed compare, disabling\n");
+		dev_err(dma_chan->device->dev,
+			"Self-test copy failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
@@ -1048,8 +1042,8 @@ mv_xor_xor_self_test(struct mv_xor_device *device)
 
 	if (mv_xor_status(dma_chan, cookie, NULL) !=
 	    DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
-			   "Self-test xor timed out, disabling\n");
+		dev_err(dma_chan->device->dev,
+			"Self-test xor timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
@@ -1060,10 +1054,9 @@ mv_xor_xor_self_test(struct mv_xor_device *device)
 	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i] != cmp_word) {
-			dev_printk(KERN_ERR, dma_chan->device->dev,
-				   "Self-test xor failed compare, disabling."
-				   " index %d, data %x, expected %x\n", i,
-				   ptr[i], cmp_word);
+			dev_err(dma_chan->device->dev,
+				"Self-test xor failed compare, disabling. index %d, data %x, expected %x\n",
+				i, ptr[i], cmp_word);
 			err = -ENODEV;
 			goto free_resources;
 		}
@@ -1212,12 +1205,11 @@ static int __devinit mv_xor_probe(struct platform_device *pdev)
 			goto err_free_dma;
 	}
 
-	dev_printk(KERN_INFO, &pdev->dev, "Marvell XOR: "
-	  "( %s%s%s%s)\n",
-	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
-	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
-	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
-	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
+	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s%s)\n",
+		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
+		 dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
+		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
+		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
 	dma_async_device_register(dma_dev);
 	goto out;
@@ -1275,7 +1267,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 	struct mv_xor_shared_private *msp;
 	struct resource *res;
 
-	dev_printk(KERN_NOTICE, &pdev->dev, "Marvell shared XOR driver\n");
+	dev_notice(&pdev->dev, "Marvell shared XOR driver\n");
 
 	msp = devm_kzalloc(&pdev->dev, sizeof(*msp), GFP_KERNEL);
 	if (!msp)
-- 
1.7.8.112.g3fd21

