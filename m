Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1IUJc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:32:58 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1IUJcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:32:55 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Mike Miller <mike.miller@hp.com>,
        Chirag Kantharia <chirag.kantharia@hp.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ralf Baechle <ralf@linux-mips.org>, iss_storagedev@hp.com
Subject: [PATCH 26/57] block: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:27 +0800
Message-Id: <1316597339-29861-27-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c    |    4 ++--
 drivers/block/cpqarray.c |    2 +-
 drivers/block/hd.c       |    7 +------
 drivers/block/mg_disk.c  |    2 +-
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6da7ede..3f3b7a2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4868,7 +4868,7 @@ static int cciss_request_irq(ctlr_info_t *h,
 {
 	if (h->msix_vector || h->msi_vector) {
 		if (!request_irq(h->intr[h->intr_mode], msixhandler,
-				IRQF_DISABLED, h->devname, h))
+				0, h->devname, h))
 			return 0;
 		dev_err(&h->pdev->dev, "Unable to get msi irq %d"
 			" for %s\n", h->intr[h->intr_mode],
@@ -4877,7 +4877,7 @@ static int cciss_request_irq(ctlr_info_t *h,
 	}
 
 	if (!request_irq(h->intr[h->intr_mode], intxhandler,
-			IRQF_DISABLED, h->devname, h))
+			0, h->devname, h))
 		return 0;
 	dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
 		h->intr[h->intr_mode], h->devname);
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index b2fceb5..33afbd7 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -406,7 +406,7 @@ static int __devinit cpqarray_register_ctlr( int i, struct pci_dev *pdev)
 	}
 	hba[i]->access.set_intr_mask(hba[i], 0);
 	if (request_irq(hba[i]->intr, do_ida_intr,
-		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
+		IRQF_SHARED, hba[i]->devname, hba[i]))
 	{
 		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
 				hba[i]->intr, hba[i]->devname);
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index b52c9ca..c30d1f9 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -696,11 +696,6 @@ static const struct block_device_operations hd_fops = {
 };
 
 /*
- * This is the hard disk IRQ description. The IRQF_DISABLED in sa_flags
- * means we run the IRQ-handler with interrupts disabled:  this is bad for
- * interrupt latency, but anything else has led to problems on some
- * machines.
- *
  * We enable interrupts in some of the routines after making sure it's
  * safe.
  */
@@ -762,7 +757,7 @@ static int __init hd_init(void)
 			p->cyl, p->head, p->sect);
 	}
 
-	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
+	if (request_irq(HD_IRQ, hd_interrupt, 0, "hd", NULL)) {
 		printk("hd: unable to get IRQ%d for the hard disk driver\n",
 			HD_IRQ);
 		goto out1;
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 76fa3de..3c80cba 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -930,7 +930,7 @@ static int mg_probe(struct platform_device *plat_dev)
 			goto probe_err_3b;
 		}
 		err = request_irq(host->irq, mg_irq,
-				IRQF_DISABLED | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_RISING,
 				MG_DEV_NAME, host);
 		if (err) {
 			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n",
-- 
1.7.4.1

