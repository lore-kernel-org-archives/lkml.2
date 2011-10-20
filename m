Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1JTGUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65381 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1JTGUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:50 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 9/24] Staging: comedi: fix warning issue in dt3000.c
Date: Thu, 20 Oct 2011 11:48:55 +0530
Message-Id: <1319091550-2558-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt.
Converted printks to pr_<level> and dev_printk.
Removed unneccessary printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   51 +++++++++++++++----------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 6170f7b..1d2c1a1 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -57,6 +57,9 @@ AO commands are not supported.
    you the docs without one, also.
 */
 
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DEBUG 1
 
 #include <linux/interrupt.h>
@@ -161,7 +164,7 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 	 },
 };
 
-#define n_dt3k_boards sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype)
+#define n_dt3k_boards (sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype))
 #define this_board ((const struct dt3k_boardtype *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
@@ -352,7 +355,7 @@ static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR)
 		return 0;
 
-	printk("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
+	pr_err("%s: timeout/error status=0x%04x\n", __func__, status);
 
 	return -ETIME;
 }
@@ -383,7 +386,7 @@ static void dt3k_writesingle(struct comedi_device *dev, unsigned int subsys,
 	dt3k_send_cmd(dev, CMD_WRITESINGLE);
 }
 
-static int debug_n_ints = 0;
+static int debug_n_ints;
 
 /* FIXME! Assumes shared interrupt is for this card. */
 /* What's this debug_n_ints stuff? Obviously needs some work... */
@@ -420,7 +423,6 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-#ifdef DEBUG
 static char *intr_flags[] = {
 	"AdFull", "AdSwError", "AdHwError", "DaEmpty",
 	"DaSwError", "DaHwError", "CtDone", "CmDone",
@@ -429,14 +431,12 @@ static char *intr_flags[] = {
 static void debug_intr_flags(unsigned int flags)
 {
 	int i;
-	printk("dt3k: intr_flags:");
+	pr_debug("intr_flags:\n");
 	for (i = 0; i < 8; i++) {
 		if (flags & (1 << i))
-			printk(" %s", intr_flags[i]);
+			pr_debug("%s\n", intr_flags[i]);
 	}
-	printk("\n");
 }
-#endif
 
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
@@ -452,7 +452,7 @@ static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 	if (count < 0)
 		count += AI_FIFO_DEPTH;
 
-	printk("reading %d samples\n", count);
+	pr_debug("reading %d samples\n", count);
 
 	rear = devpriv->ai_rear;
 
@@ -504,7 +504,9 @@ static int dt3k_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 
 	if (err)
 		return 2;
@@ -640,7 +642,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int ret;
 	unsigned int mode;
 
-	printk("dt3k_ai_cmd:\n");
+	dev_dbg(dev->hw_dev, "dt3k_ai_cmd:\n");
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
 		range = CR_RANGE(cmd->chanlist[i]);
@@ -651,15 +653,15 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	aref = CR_AREF(cmd->chanlist[0]);
 
 	writew(cmd->scan_end_arg, devpriv->io_addr + DPR_Params(0));
-	printk("param[0]=0x%04x\n", cmd->scan_end_arg);
+	dev_dbg(dev->hw_dev, "param[0]=0x%04x\n", cmd->scan_end_arg);
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		divider = dt3k_ns_to_timer(50, &cmd->convert_arg,
 					   cmd->flags & TRIG_ROUND_MASK);
 		writew((divider >> 16), devpriv->io_addr + DPR_Params(1));
-		printk("param[1]=0x%04x\n", divider >> 16);
+		dev_dbg(dev->hw_dev, "param[1]=0x%04x\n", divider >> 16);
 		writew((divider & 0xffff), devpriv->io_addr + DPR_Params(2));
-		printk("param[2]=0x%04x\n", divider & 0xffff);
+		dev_dbg(dev->hw_dev, "param[2]=0x%04x\n", divider & 0xffff);
 	} else {
 		/* not supported */
 	}
@@ -668,21 +670,21 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		tscandiv = dt3k_ns_to_timer(100, &cmd->scan_begin_arg,
 					    cmd->flags & TRIG_ROUND_MASK);
 		writew((tscandiv >> 16), devpriv->io_addr + DPR_Params(3));
-		printk("param[3]=0x%04x\n", tscandiv >> 16);
+		dev_dbg(dev->hw_dev, "param[3]=0x%04x\n", tscandiv >> 16);
 		writew((tscandiv & 0xffff), devpriv->io_addr + DPR_Params(4));
-		printk("param[4]=0x%04x\n", tscandiv & 0xffff);
+		dev_dbg(dev->hw_dev, "param[4]=0x%04x\n", tscandiv & 0xffff);
 	} else {
 		/* not supported */
 	}
 
 	mode = DT3000_AD_RETRIG_INTERNAL | 0 | 0;
 	writew(mode, devpriv->io_addr + DPR_Params(5));
-	printk("param[5]=0x%04x\n", mode);
+	dev_dbg(dev->hw_dev, "param[5]=0x%04x\n", mode);
 	writew(aref == AREF_DIFF, devpriv->io_addr + DPR_Params(6));
-	printk("param[6]=0x%04x\n", aref == AREF_DIFF);
+	dev_dbg(dev->hw_dev, "param[6]=0x%04x\n", aref == AREF_DIFF);
 
 	writew(AI_FIFO_DEPTH / 2, devpriv->io_addr + DPR_Params(7));
-	printk("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
+	dev_dbg(dev->hw_dev, "param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
 
 	writew(SUBS_AI, devpriv->io_addr + DPR_SubSys);
 	ret = dt3k_send_cmd(dev, CMD_CONFIG);
@@ -848,7 +850,6 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int bus, slot;
 	int ret = 0;
 
-	printk("dt3000:");
 	bus = it->options[0];
 	slot = it->options[1];
 
@@ -860,7 +861,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
-		printk(" no DT board found\n");
+		pr_err("no DT board found\n");
 		return -ENODEV;
 	}
 
@@ -868,7 +869,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (request_irq(devpriv->pci_dev->irq, dt3k_interrupt, IRQF_SHARED,
 			"dt3000", dev)) {
-		printk(" unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
+		pr_err("unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -998,10 +999,8 @@ static int setup_pci(struct comedi_device *dev)
 	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
 	if (!devpriv->io_addr)
 		return -ENOMEM;
-#if DEBUG
-	printk("0x%08llx mapped to %p, ",
-	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
-#endif
+	pr_debug("0x%08llx mapped to %p,\n",
+		(unsigned long long)devpriv->phys_addr, devpriv->io_addr);
 
 	return 0;
 }
-- 
1.7.6.4

