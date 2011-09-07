Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1IGRXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:23:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:7320 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1IGRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:23:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1315415185!33818445!139
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: dt3155v4l: Remove printk noise
Date: Wed, 7 Sep 2011 10:20:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <mchehab@redhat.com>,
        <hverkuil@xs4all.nl>, <paul.gortmaker@windriver.com>,
        <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109071020.48549.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the printk's in this driver are just noise. Proper error codes
are being returned so just remove the noise and clean up the whitespace
in the code due to the removal.

The two messages left in the probe are useful. Convert them to dev_info
messages.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 4059ea6..421df43 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -104,18 +104,13 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
 	iowrite32((tmp<<17) | IIC_READ, addr + IIC_CSR2);
 	mmiowb();
 	udelay(45); /* wait at least 43 usec for NEW_CYCLE to clear */
-	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
-		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
-		return -EIO;
-	}
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
+		return -EIO; /* error: NEW_CYCLE not cleared */
 	tmp = ioread32(addr + IIC_CSR1);
 	if (tmp & DIRECT_ABORT) {
-		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
-		return -EIO;
+		return -EIO; /* error: DIRECT_ABORT set */
 	}
 	*data = tmp>>24;
 	return 0;
@@ -141,17 +136,12 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
 	iowrite32((tmp<<17) | IIC_WRITE | data, addr + IIC_CSR2);
 	mmiowb();
 	udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
-	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
-		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
-		return -EIO;
-	}
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
+		return -EIO; /* error: NEW_CYCLE not cleared */
 	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
-		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
-		return -EIO;
+		return -EIO; /* error: DIRECT_ABORT set */
 	}
 	return 0;
 }
@@ -187,17 +177,12 @@ static int wait_i2c_reg(void __iomem *addr)
 {
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
 		udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
-	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
-		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
-		return -EIO;
-	}
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
+		return -EIO; /* error: NEW_CYCLE not cleared */
 	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
-		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
-		return -EIO;
+		return -EIO; /* error: DIRECT_ABORT set */
 	}
 	return 0;
 }
@@ -345,17 +330,14 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 		ipd->field_count++;
 		return IRQ_HANDLED; /* start of field irq */
 	}
-	if ((tmp & FLD_START) && (tmp & FLD_END_ODD)) {
-		if (!ipd->stats.start_before_end++)
-			printk(KERN_ERR "dt3155: irq: START before END\n");
-	}
+	if ((tmp & FLD_START) && (tmp & FLD_END_ODD))
+		!ipd->stats.start_before_end++;
 	/*	check for corrupted fields     */
 /*	write_i2c_reg(ipd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);	*/
 /*	write_i2c_reg(ipd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);	*/
 	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
 	if (tmp) {
-		if (!ipd->stats.corrupted_fields++)
-			printk(KERN_ERR "dt3155: corrupted field %u\n", tmp);
+		ipd->stats.corrupted_fields++;
 		iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
 						FLD_DN_ODD | FLD_DN_EVEN |
 						CAP_CONT_EVEN | CAP_CONT_ODD,
@@ -405,13 +387,9 @@ dt3155_open(struct file *filp)
 	int ret = 0;
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	printk(KERN_INFO "dt3155: open(): minor: %i, users: %i\n",
-						pd->vdev->minor, pd->users);
-
 	if (!pd->users) {
 		pd->q = kzalloc(sizeof(*pd->q), GFP_KERNEL);
 		if (!pd->q) {
-			printk(KERN_ERR "dt3155: error: alloc queue\n");
 			ret = -ENOMEM;
 			goto err_alloc_queue;
 		}
@@ -431,10 +409,8 @@ dt3155_open(struct file *filp)
 		pd->irq_handler = dt3155_irq_handler_even;
 		ret = request_irq(pd->pdev->irq, pd->irq_handler,
 						IRQF_SHARED, DT3155_NAME, pd);
-		if (ret) {
-			printk(KERN_ERR "dt3155: error: request_irq\n");
+		if (ret)
 			goto err_request_irq;
-		}
 	}
 	pd->users++;
 	return 0; /* success */
@@ -450,9 +426,6 @@ dt3155_release(struct file *filp)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	printk(KERN_INFO "dt3155: release(): minor: %i, users: %i\n",
-					pd->vdev->minor, pd->users - 1);
-
 	pd->users--;
 	BUG_ON(pd->users < 0);
 	if (!pd->users) {
@@ -805,11 +778,8 @@ dt3155_init_board(struct pci_dev *pdev)
 	/* allocate memory, and initialize the DMA machine */
 	buf_cpu = dma_alloc_coherent(&pdev->dev, DT3155_BUF_SIZE, &buf_dma,
 								GFP_KERNEL);
-	if (!buf_cpu) {
-		printk(KERN_ERR "dt3155: dma_alloc_coherent "
-					"(in dt3155_init_board) failed\n");
+	if (!buf_cpu)
 		return -ENOMEM;
-	}
 	iowrite32(buf_dma, pd->regs + EVEN_DMA_START);
 	iowrite32(buf_dma, pd->regs + ODD_DMA_START);
 	iowrite32(0, pd->regs + EVEN_DMA_STRIDE);
@@ -830,10 +800,8 @@ dt3155_init_board(struct pci_dev *pdev)
 
 	/*  deallocate memory  */
 	dma_free_coherent(&pdev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
-	if (tmp & BUSY_EVEN) {
-		printk(KERN_ERR "dt3155: BUSY_EVEN not cleared\n");
+	if (tmp & BUSY_EVEN)
 		return -EIO;
-	}
 	return 0;
 }
 
@@ -917,27 +885,18 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int err;
 	struct dt3155_priv *pd;
 
-	printk(KERN_INFO "dt3155: probe()\n");
 	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (err) {
-		printk(KERN_ERR "dt3155: cannot set dma_mask\n");
+	if (err)
 		return -ENODEV;
-	}
 	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (err) {
-		printk(KERN_ERR "dt3155: cannot set dma_coherent_mask\n");
+	if (err)
 		return -ENODEV;
-	}
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		printk(KERN_ERR "dt3155: cannot allocate dt3155_priv\n");
+	if (!pd)
 		return -ENOMEM;
-	}
 	pd->vdev = video_device_alloc();
-	if (!pd->vdev) {
-		printk(KERN_ERR "dt3155: cannot allocate vdev structure\n");
+	if (!pd->vdev)
 		goto err_video_device_alloc;
-	}
 	*pd->vdev = dt3155_vdev;
 	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
 	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
@@ -950,34 +909,25 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
 	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "dt3155: pci_dev not enabled\n");
+	if (err)
 		goto err_enable_dev;
-	}
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_req_region;
 	pd->regs = pci_iomap(pdev, 0, pci_resource_len(pd->pdev, 0));
-	if (!pd->regs) {
+	if (!pd->regs)
 		err = -ENOMEM;
-		printk(KERN_ERR "dt3155: pci_iomap failed\n");
 		goto err_pci_iomap;
-	}
 	err = dt3155_init_board(pdev);
-	if (err) {
-		printk(KERN_ERR "dt3155: dt3155_init_board failed\n");
+	if (err)
 		goto err_init_board;
-	}
 	err = video_register_device(pd->vdev, VFL_TYPE_GRABBER, -1);
-	if (err) {
-		printk(KERN_ERR "dt3155: Cannot register video device\n");
-		goto err_init_board;
-	}
-	err = dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
-							DMA_MEMORY_MAP);
 	if (err)
-		printk(KERN_INFO "dt3155: preallocated 8 buffers\n");
-	printk(KERN_INFO "dt3155: /dev/video%i is ready\n", pd->vdev->minor);
+		goto err_init_board;
+	if (dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
+							DMA_MEMORY_MAP))
+		dev_info(&pdev->dev, "preallocated 8 buffers\n");
+	dev_info(&pdev->dev, "/dev/video%i is ready\n", pd->vdev->minor);
 	return 0;  /*   success   */
 
 err_init_board:
@@ -998,7 +948,6 @@ dt3155_remove(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 
-	printk(KERN_INFO "dt3155: remove()\n");
 	dt3155_free_coherent(&pdev->dev);
 	video_unregister_device(pd->vdev);
 	pci_iounmap(pdev, pd->regs);
@@ -1027,24 +976,13 @@ static struct pci_driver pci_driver = {
 static int __init
 dt3155_init_module(void)
 {
-	int err;
-
-	printk(KERN_INFO "dt3155: ==================\n");
-	printk(KERN_INFO "dt3155: init()\n");
-	err = pci_register_driver(&pci_driver);
-	if (err) {
-		printk(KERN_ERR "dt3155: cannot register pci_driver\n");
-		return err;
-	}
-	return 0; /* succes */
+	return pci_register_driver(&pci_driver);
 }
 
 static void __exit
 dt3155_exit_module(void)
 {
 	pci_unregister_driver(&pci_driver);
-	printk(KERN_INFO "dt3155: exit()\n");
-	printk(KERN_INFO "dt3155: ==================\n");
 }
 
 module_init(dt3155_init_module);
