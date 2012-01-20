Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2ATCR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:17:58 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39053 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2ATCRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:17:55 -0500
X-SpamScore: 0
X-BigFish: VS0(zz13e6Kc8kzz1202hzz8275bh84d07hz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <qiang.liu@freescale.com>
To: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH V2] fsl-sata: I/O load balancing
Date: Fri, 20 Jan 2012 10:19:18 +0800
Message-ID: <1327025958-10605-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

Reduce interrupt signals through reset Interrupt Coalescing Control Reg.
Provide dynamic method to adjust interrupt signals and timer ticks by sysfs.
It is a tradeoff for different applications.

Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---

change for V2
	support dynamic config interrupt coalescing register by /sysfs
	test random small file with iometer
Description:
  1. fsl-sata interrupt will be raised 130 thousand times when write 8G file
    (dd if=/dev/zero of=/dev/sda2 bs=128K count=65536);
  2. most of interrupts raised because of only 1-4 commands completed;
  3. only 30 thousand times will be raised after set max interrupt threshold,
    more interrupts are coalesced as the description of ICC;

Test methods and results:
  1. test sequential large file performance,
  [root@p2020ds root]# echo 31 524287 > \
  	/sys/devices/soc.0/ffe18000.sata/intr_coalescing
  [root@p2020ds root]# dd if=/dev/zero of=/dev/sda2 bs=128K count=65536 &
  [root@p2020ds root]# top

  CPU %  |  dd   |  flush-8:0 | softirq
  ---------------------------------------
  before | 20-22 |    17-19   |    7
  ---------------------------------------
  after  | 18-21 |    15-16   |    5
  ---------------------------------------
  2. test random small file with iometer,
 iometer paramters:
   4 I/Os burst length, 1MB transfer request size, 100% write, 2MB file size
   as default configuration of interrupt coalescing register, 1 interrupts and
 no timeout config, total write performance is 119MB per second,
   after config with the maximum value, write performance is 110MB per second.

  After compare the test results, a configuable interrupt coalescing should be
  better when cope with flexible context.

 drivers/ata/sata_fsl.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 3547000..41ca495 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -6,7 +6,7 @@
  * Author: Ashish Kalra <ashish.kalra@freescale.com>
  * Li Yang <leoli@freescale.com>
  *
- * Copyright (c) 2006-2007, 2011 Freescale Semiconductor, Inc.
+ * Copyright (c) 2006-2007, 2011-2012 Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -26,6 +26,15 @@
 #include <asm/io.h>
 #include <linux/of_platform.h>

+static unsigned int intr_coalescing_count;
+module_param(intr_coalescing_count, int, S_IRUGO);
+MODULE_PARM_DESC(intr_coalescing_count,
+				 "INT coalescing count threshold (1..31)");
+
+static unsigned int intr_coalescing_ticks;
+module_param(intr_coalescing_ticks, int, S_IRUGO);
+MODULE_PARM_DESC(intr_coalescing_ticks,
+				 "INT coalescing timer threshold in AHB ticks");
 /* Controller information */
 enum {
 	SATA_FSL_QUEUE_DEPTH	= 16,
@@ -83,6 +92,16 @@ enum {
 };

 /*
+ * Interrupt Coalescing Control Register bitdefs  */
+enum {
+	ICC_MIN_INT_COUNT_THRESHOLD	= 1,
+	ICC_MAX_INT_COUNT_THRESHOLD	= ((1 << 5) - 1),
+	ICC_MIN_INT_TICKS_THRESHOLD	= 0,
+	ICC_MAX_INT_TICKS_THRESHOLD	= ((1 << 19) - 1),
+	ICC_SAFE_INT_TICKS		= 1,
+};
+
+/*
 * Host Controller command register set - per port
 */
 enum {
@@ -263,9 +282,66 @@ struct sata_fsl_host_priv {
 	int irq;
 	int data_snoop;
 	u32 quirks;
+	struct device_attribute intr_coalescing;
 #define SATA_FSL_QUIRK_P3P5_ERRATA	(1 << 0)
 };

+static void fsl_sata_set_irq_coalescing(struct ata_host *host,
+		unsigned int count, unsigned int ticks)
+{
+	struct sata_fsl_host_priv *host_priv = host->private_data;
+	void __iomem *hcr_base = host_priv->hcr_base;
+
+	if (count > ICC_MAX_INT_COUNT_THRESHOLD)
+		count = ICC_MAX_INT_COUNT_THRESHOLD;
+	else if (count < ICC_MIN_INT_COUNT_THRESHOLD)
+		count = ICC_MIN_INT_COUNT_THRESHOLD;
+
+	if (ticks > ICC_MAX_INT_TICKS_THRESHOLD)
+		ticks = ICC_MAX_INT_TICKS_THRESHOLD;
+	else if ((ICC_MIN_INT_TICKS_THRESHOLD == ticks) &&
+			(count > ICC_MIN_INT_COUNT_THRESHOLD))
+		ticks = ICC_SAFE_INT_TICKS;
+
+	spin_lock(&host->lock);
+	iowrite32((count << 24 | ticks), hcr_base + ICC);
+
+	intr_coalescing_count = count;
+	intr_coalescing_ticks = ticks;
+	spin_unlock(&host->lock);
+
+	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
+			intr_coalescing_count, intr_coalescing_ticks);
+	DPRINTK("ICC register status: (hcr base: 0x%x) = 0x%x\n",
+			hcr_base, ioread32(hcr_base + ICC));
+}
+
+static ssize_t fsl_sata_intr_coalescing_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d	%d\n",
+			intr_coalescing_count, intr_coalescing_ticks);
+}
+
+static ssize_t fsl_sata_intr_coalescing_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned int coalescing_count,	coalescing_ticks;
+
+	if (sscanf(buf, "%d%d",
+				&coalescing_count,
+				&coalescing_ticks) != 2) {
+		printk(KERN_ERR "fsl-sata: wrong parameter format.\n");
+		return -EINVAL;
+	}
+
+	fsl_sata_set_irq_coalescing(dev_get_drvdata(dev),
+			coalescing_count, coalescing_ticks);
+
+	return strlen(buf);
+}
+
 static void sata_fsl_dev_config(struct ata_device *dev)
 {
 		dev->max_sectors = 16;
@@ -352,11 +428,11 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 			(unsigned long long)sg_addr, sg_len);

 		/* warn if each s/g element is not dword aligned */
-		if (sg_addr & 0x03)
+		if (unlikely(sg_addr & 0x03))
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g addr unaligned : 0x%llx\n",
 					(unsigned long long)sg_addr);
-		if (sg_len & 0x03)
+		if (unlikely(sg_len & 0x03))
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g len unaligned : 0x%x\n", sg_len);

@@ -1305,6 +1381,13 @@ static int sata_fsl_init_controller(struct ata_host *host)
 	iowrite32(0x00000FFFF, hcr_base + DE);

 	/*
+	 * reset the number of command complete bits which will cause the
+	 * interrupt to be signaled
+	 */
+	fsl_sata_set_irq_coalescing(host, intr_coalescing_count,
+			intr_coalescing_ticks);
+
+	/*
 	 * host controller will be brought on-line, during xx_port_start()
 	 * callback, that should also initiate the OOB, COMINIT sequence
 	 */
@@ -1368,7 +1451,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	void __iomem *csr_base = NULL;
 	struct sata_fsl_host_priv *host_priv = NULL;
 	int irq;
-	struct ata_host *host;
+	struct ata_host *host = NULL;
 	u32 temp;

 	struct ata_port_info pi = sata_fsl_port_info[0];
@@ -1430,6 +1513,10 @@ static int sata_fsl_probe(struct platform_device *ofdev)

 	/* allocate host structure */
 	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_FSL_MAX_PORTS);
+	if (!host) {
+		retval = -ENOMEM;
+		goto error_exit_with_cleanup;
+	}

 	/* host->iomap is not used currently */
 	host->private_data = host_priv;
@@ -1447,10 +1534,24 @@ static int sata_fsl_probe(struct platform_device *ofdev)

 	dev_set_drvdata(&ofdev->dev, host);

+	host_priv->intr_coalescing.show = fsl_sata_intr_coalescing_show;
+	host_priv->intr_coalescing.store = fsl_sata_intr_coalescing_store;
+	sysfs_attr_init(&host_priv->intr_coalescing.attr);
+	host_priv->intr_coalescing.attr.name = "intr_coalescing";
+	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
+	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
+	if (retval)
+		goto error_exit_with_cleanup;
+
 	return 0;

 error_exit_with_cleanup:

+	if (host) {
+		dev_set_drvdata(&ofdev->dev, NULL);
+		ata_host_detach(host);
+	}
+
 	if (hcr_base)
 		iounmap(hcr_base);
 	if (host_priv)
@@ -1464,6 +1565,8 @@ static int sata_fsl_remove(struct platform_device *ofdev)
 	struct ata_host *host = dev_get_drvdata(&ofdev->dev);
 	struct sata_fsl_host_priv *host_priv = host->private_data;

+	device_remove_file(&ofdev->dev, &host_priv->intr_coalescing);
+
 	ata_host_detach(host);

 	dev_set_drvdata(&ofdev->dev, NULL);
--
1.7.5.1


