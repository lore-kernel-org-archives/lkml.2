Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1IAXzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:55:10 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37171 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab1IAXzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:55:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1314921297!30292012!12
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155v4l: Convert printk's to pr_<level>
Date: Thu, 1 Sep 2011 16:53:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <mchehab@redhat.com>,
        <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109011653.56089.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all the printk(KERN_<level>) messages in the driver to pr_<level>()
and use pr_fmt to provide the module name.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>

---

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 4059ea6..d314f71 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -18,6 +18,8 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/stringify.h>
@@ -106,13 +108,13 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
 	udelay(45); /* wait at least 43 usec for NEW_CYCLE to clear */
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
 		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		pr_err("NEW_CYCLE not cleared\n");
 		return -EIO;
 	}
 	tmp = ioread32(addr + IIC_CSR1);
 	if (tmp & DIRECT_ABORT) {
 		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		pr_err("DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
 		return -EIO;
@@ -143,12 +145,12 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
 	udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
 		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		pr_err("NEW_CYCLE not cleared\n");
 		return -EIO;
 	}
 	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
 		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		pr_err("DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
 		return -EIO;
@@ -189,12 +191,12 @@ static int wait_i2c_reg(void __iomem *addr)
 		udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
 		/* error: NEW_CYCLE not cleared */
-		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		pr_err("NEW_CYCLE not cleared\n");
 		return -EIO;
 	}
 	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
 		/* error: DIRECT_ABORT set */
-		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		pr_err("DIRECT_ABORT set\n");
 		/* reset DIRECT_ABORT bit */
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
 		return -EIO;
@@ -347,7 +349,7 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 	}
 	if ((tmp & FLD_START) && (tmp & FLD_END_ODD)) {
 		if (!ipd->stats.start_before_end++)
-			printk(KERN_ERR "dt3155: irq: START before END\n");
+			pr_err("irq: START before END\n");
 	}
 	/*	check for corrupted fields     */
 /*	write_i2c_reg(ipd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);	*/
@@ -355,7 +357,7 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
 	if (tmp) {
 		if (!ipd->stats.corrupted_fields++)
-			printk(KERN_ERR "dt3155: corrupted field %u\n", tmp);
+			pr_err("corrupted field %u\n", tmp);
 		iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
 						FLD_DN_ODD | FLD_DN_EVEN |
 						CAP_CONT_EVEN | CAP_CONT_ODD,
@@ -405,13 +407,12 @@ dt3155_open(struct file *filp)
 	int ret = 0;
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	printk(KERN_INFO "dt3155: open(): minor: %i, users: %i\n",
-						pd->vdev->minor, pd->users);
+	pr_info("open(): minor: %i, users: %i\n", pd->vdev->minor, pd->users);
 
 	if (!pd->users) {
 		pd->q = kzalloc(sizeof(*pd->q), GFP_KERNEL);
 		if (!pd->q) {
-			printk(KERN_ERR "dt3155: error: alloc queue\n");
+			pr_err("error: alloc queue\n");
 			ret = -ENOMEM;
 			goto err_alloc_queue;
 		}
@@ -432,7 +433,7 @@ dt3155_open(struct file *filp)
 		ret = request_irq(pd->pdev->irq, pd->irq_handler,
 						IRQF_SHARED, DT3155_NAME, pd);
 		if (ret) {
-			printk(KERN_ERR "dt3155: error: request_irq\n");
+			pr_err("error: request_irq\n");
 			goto err_request_irq;
 		}
 	}
@@ -450,7 +451,7 @@ dt3155_release(struct file *filp)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	printk(KERN_INFO "dt3155: release(): minor: %i, users: %i\n",
+	pr_info("release(): minor: %i, users: %i\n",
 					pd->vdev->minor, pd->users - 1);
 
 	pd->users--;
@@ -806,8 +807,7 @@ dt3155_init_board(struct pci_dev *pdev)
 	buf_cpu = dma_alloc_coherent(&pdev->dev, DT3155_BUF_SIZE, &buf_dma,
 								GFP_KERNEL);
 	if (!buf_cpu) {
-		printk(KERN_ERR "dt3155: dma_alloc_coherent "
-					"(in dt3155_init_board) failed\n");
+		pr_err("dma_alloc_coherent (in dt3155_init_board) failed\n");
 		return -ENOMEM;
 	}
 	iowrite32(buf_dma, pd->regs + EVEN_DMA_START);
@@ -831,7 +831,7 @@ dt3155_init_board(struct pci_dev *pdev)
 	/*  deallocate memory  */
 	dma_free_coherent(&pdev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
 	if (tmp & BUSY_EVEN) {
-		printk(KERN_ERR "dt3155: BUSY_EVEN not cleared\n");
+		pr_err("BUSY_EVEN not cleared\n");
 		return -EIO;
 	}
 	return 0;
@@ -917,25 +917,25 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int err;
 	struct dt3155_priv *pd;
 
-	printk(KERN_INFO "dt3155: probe()\n");
+	pr_info("probe()\n");
 	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
-		printk(KERN_ERR "dt3155: cannot set dma_mask\n");
+		pr_err("cannot set dma_mask\n");
 		return -ENODEV;
 	}
 	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
-		printk(KERN_ERR "dt3155: cannot set dma_coherent_mask\n");
+		pr_err("cannot set dma_coherent_mask\n");
 		return -ENODEV;
 	}
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd) {
-		printk(KERN_ERR "dt3155: cannot allocate dt3155_priv\n");
+		pr_err("cannot allocate dt3155_priv\n");
 		return -ENOMEM;
 	}
 	pd->vdev = video_device_alloc();
 	if (!pd->vdev) {
-		printk(KERN_ERR "dt3155: cannot allocate vdev structure\n");
+		pr_err("cannot allocate vdev structure\n");
 		goto err_video_device_alloc;
 	}
 	*pd->vdev = dt3155_vdev;
@@ -951,7 +951,7 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->config = config_init;
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "dt3155: pci_dev not enabled\n");
+		pr_err("pci_dev not enabled\n");
 		goto err_enable_dev;
 	}
 	err = pci_request_region(pdev, 0, pci_name(pdev));
@@ -960,24 +960,24 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->regs = pci_iomap(pdev, 0, pci_resource_len(pd->pdev, 0));
 	if (!pd->regs) {
 		err = -ENOMEM;
-		printk(KERN_ERR "dt3155: pci_iomap failed\n");
+		pr_err("pci_iomap failed\n");
 		goto err_pci_iomap;
 	}
 	err = dt3155_init_board(pdev);
 	if (err) {
-		printk(KERN_ERR "dt3155: dt3155_init_board failed\n");
+		pr_err("dt3155_init_board failed\n");
 		goto err_init_board;
 	}
 	err = video_register_device(pd->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
-		printk(KERN_ERR "dt3155: Cannot register video device\n");
+		pr_err("Cannot register video device\n");
 		goto err_init_board;
 	}
 	err = dt3155_alloc_coherent(&pdev->dev, DT3155_CHUNK_SIZE,
 							DMA_MEMORY_MAP);
 	if (err)
-		printk(KERN_INFO "dt3155: preallocated 8 buffers\n");
-	printk(KERN_INFO "dt3155: /dev/video%i is ready\n", pd->vdev->minor);
+		pr_info("preallocated 8 buffers\n");
+	pr_info("/dev/video%i is ready\n", pd->vdev->minor);
 	return 0;  /*   success   */
 
 err_init_board:
@@ -998,7 +998,7 @@ dt3155_remove(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 
-	printk(KERN_INFO "dt3155: remove()\n");
+	pr_info("remove()\n");
 	dt3155_free_coherent(&pdev->dev);
 	video_unregister_device(pd->vdev);
 	pci_iounmap(pdev, pd->regs);
@@ -1029,11 +1029,11 @@ dt3155_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO "dt3155: ==================\n");
-	printk(KERN_INFO "dt3155: init()\n");
+	pr_info("==================\n");
+	pr_info("init()\n");
 	err = pci_register_driver(&pci_driver);
 	if (err) {
-		printk(KERN_ERR "dt3155: cannot register pci_driver\n");
+		pr_err("cannot register pci_driver\n");
 		return err;
 	}
 	return 0; /* succes */
@@ -1043,8 +1043,8 @@ static void __exit
 dt3155_exit_module(void)
 {
 	pci_unregister_driver(&pci_driver);
-	printk(KERN_INFO "dt3155: exit()\n");
-	printk(KERN_INFO "dt3155: ==================\n");
+	pr_info("exit()\n");
+	pr_info("==================\n");
 }
 
 module_init(dt3155_init_module);
