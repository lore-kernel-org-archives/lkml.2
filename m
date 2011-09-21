Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1IUJbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:31:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56712 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1IUJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:31:48 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Paul Mundt <lethal@linux-sh.org>, Tejun Heo <tj@kernel.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH 17/57] SH: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:18 +0800
Message-Id: <1316597339-29861-18-git-send-email-yong.zhang0@gmail.com>
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
---
 arch/sh/boards/board-secureedge5410.c |    3 +--
 arch/sh/boards/mach-cayman/irq.c      |    2 --
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c |    2 +-
 arch/sh/drivers/dma/dma-g2.c          |    2 +-
 arch/sh/drivers/dma/dma-pvr2.c        |    1 -
 arch/sh/drivers/dma/dma-sh.c          |    4 ++--
 arch/sh/drivers/dma/dmabrg.c          |    6 +++---
 arch/sh/drivers/pci/pci-sh5.c         |    4 ++--
 arch/sh/drivers/pci/pci-sh7780.c      |    2 +-
 arch/sh/drivers/push-switch.c         |    2 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c    |    2 +-
 11 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/sh/boards/board-secureedge5410.c b/arch/sh/boards/board-secureedge5410.c
index f968f17..03820c3 100644
--- a/arch/sh/boards/board-secureedge5410.c
+++ b/arch/sh/boards/board-secureedge5410.c
@@ -41,8 +41,7 @@ static int __init eraseconfig_init(void)
 	printk("SnapGear: EraseConfig init\n");
 
 	/* Setup "EraseConfig" switch on external IRQ 0 */
-	if (request_irq(irq, eraseconfig_interrupt, IRQF_DISABLED,
-				"Erase Config", NULL))
+	if (request_irq(irq, eraseconfig_interrupt, 0, "Erase Config", NULL))
 		printk("SnapGear: failed to register IRQ%d for Reset witch\n",
 				irq);
 	else
diff --git a/arch/sh/boards/mach-cayman/irq.c b/arch/sh/boards/mach-cayman/irq.c
index 311bceb..724e8b7 100644
--- a/arch/sh/boards/mach-cayman/irq.c
+++ b/arch/sh/boards/mach-cayman/irq.c
@@ -46,13 +46,11 @@ static irqreturn_t cayman_interrupt_pci2(int irq, void *dev_id)
 static struct irqaction cayman_action_smsc = {
 	.name		= "Cayman SMSC Mux",
 	.handler	= cayman_interrupt_smsc,
-	.flags		= IRQF_DISABLED,
 };
 
 static struct irqaction cayman_action_pci2 = {
 	.name		= "Cayman PCI2 Mux",
 	.handler	= cayman_interrupt_pci2,
-	.flags		= IRQF_DISABLED,
 };
 
 static void enable_cayman_irq(struct irq_data *data)
diff --git a/arch/sh/boards/mach-hp6xx/hp6xx_apm.c b/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
index b49535c..865d8d6 100644
--- a/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
+++ b/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
@@ -86,7 +86,7 @@ static int __init hp6x0_apm_init(void)
 	int ret;
 
 	ret = request_irq(HP680_BTN_IRQ, hp6x0_apm_interrupt,
-			  IRQF_DISABLED, MODNAME, NULL);
+			  0, MODNAME, NULL);
 	if (unlikely(ret < 0)) {
 		printk(KERN_ERR MODNAME ": IRQ %d request failed\n",
 		       HP680_BTN_IRQ);
diff --git a/arch/sh/drivers/dma/dma-g2.c b/arch/sh/drivers/dma/dma-g2.c
index af7bb58..be9ca7c 100644
--- a/arch/sh/drivers/dma/dma-g2.c
+++ b/arch/sh/drivers/dma/dma-g2.c
@@ -170,7 +170,7 @@ static int __init g2_dma_init(void)
 {
 	int ret;
 
-	ret = request_irq(HW_EVENT_G2_DMA, g2_dma_interrupt, IRQF_DISABLED,
+	ret = request_irq(HW_EVENT_G2_DMA, g2_dma_interrupt, 0,
 			  "g2 DMA handler", &g2_dma_info);
 	if (unlikely(ret))
 		return -EINVAL;
diff --git a/arch/sh/drivers/dma/dma-pvr2.c b/arch/sh/drivers/dma/dma-pvr2.c
index 3cee58e..706a343 100644
--- a/arch/sh/drivers/dma/dma-pvr2.c
+++ b/arch/sh/drivers/dma/dma-pvr2.c
@@ -70,7 +70,6 @@ static int pvr2_xfer_dma(struct dma_channel *chan)
 static struct irqaction pvr2_dma_irq = {
 	.name		= "pvr2 DMA handler",
 	.handler	= pvr2_dma_interrupt,
-	.flags		= IRQF_DISABLED,
 };
 
 static struct dma_ops pvr2_dma_ops = {
diff --git a/arch/sh/drivers/dma/dma-sh.c b/arch/sh/drivers/dma/dma-sh.c
index 8272087..a60da6d 100644
--- a/arch/sh/drivers/dma/dma-sh.c
+++ b/arch/sh/drivers/dma/dma-sh.c
@@ -95,7 +95,7 @@ static int sh_dmac_request_dma(struct dma_channel *chan)
 #if defined(CONFIG_SH_DMA_IRQ_MULTI)
 				IRQF_SHARED,
 #else
-				IRQF_DISABLED,
+				0,
 #endif
 				chan->dev_id, chan);
 }
@@ -305,7 +305,7 @@ static int __init sh_dmac_init(void)
 #if defined(CONFIG_SH_DMA_IRQ_MULTI)
 				IRQF_SHARED,
 #else
-				IRQF_DISABLED,
+				0,
 #endif
 				dmae_name[n], (void *)dmae_name[n]);
 		if (unlikely(i < 0)) {
diff --git a/arch/sh/drivers/dma/dmabrg.c b/arch/sh/drivers/dma/dmabrg.c
index 6ab9c4a..3d66a32 100644
--- a/arch/sh/drivers/dma/dmabrg.c
+++ b/arch/sh/drivers/dma/dmabrg.c
@@ -174,17 +174,17 @@ static int __init dmabrg_init(void)
 	or = __raw_readl(DMAOR);
 	__raw_writel(or | DMAOR_BRG | DMAOR_DMEN, DMAOR);
 
-	ret = request_irq(DMABRGI0, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI0, dmabrg_irq, 0,
 			"DMABRG USB address error", NULL);
 	if (ret)
 		goto out0;
 
-	ret = request_irq(DMABRGI1, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI1, dmabrg_irq, 0,
 			"DMABRG Transfer End", NULL);
 	if (ret)
 		goto out1;
 
-	ret = request_irq(DMABRGI2, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI2, dmabrg_irq, 0,
 			"DMABRG Transfer Half", NULL);
 	if (ret == 0)
 		return ret;
diff --git a/arch/sh/drivers/pci/pci-sh5.c b/arch/sh/drivers/pci/pci-sh5.c
index 0bf296c..16c1e72 100644
--- a/arch/sh/drivers/pci/pci-sh5.c
+++ b/arch/sh/drivers/pci/pci-sh5.c
@@ -107,13 +107,13 @@ static int __init sh5pci_init(void)
 	u32 uval;
 
         if (request_irq(IRQ_ERR, pcish5_err_irq,
-                        IRQF_DISABLED, "PCI Error",NULL) < 0) {
+                        0, "PCI Error",NULL) < 0) {
                 printk(KERN_ERR "PCISH5: Cannot hook PCI_PERR interrupt\n");
                 return -EINVAL;
         }
 
         if (request_irq(IRQ_SERR, pcish5_serr_irq,
-                        IRQF_DISABLED, "PCI SERR interrupt", NULL) < 0) {
+                        0, "PCI SERR interrupt", NULL) < 0) {
                 printk(KERN_ERR "PCISH5: Cannot hook PCI_SERR interrupt\n");
                 return -EINVAL;
         }
diff --git a/arch/sh/drivers/pci/pci-sh7780.c b/arch/sh/drivers/pci/pci-sh7780.c
index edb7cca..fa7b978 100644
--- a/arch/sh/drivers/pci/pci-sh7780.c
+++ b/arch/sh/drivers/pci/pci-sh7780.c
@@ -172,7 +172,7 @@ static int __init sh7780_pci_setup_irqs(struct pci_channel *hose)
 		     PCI_STATUS_SIG_TARGET_ABORT | \
 		     PCI_STATUS_PARITY, hose->reg_base + PCI_STATUS);
 
-	ret = request_irq(hose->serr_irq, sh7780_pci_serr_irq, IRQF_DISABLED,
+	ret = request_irq(hose->serr_irq, sh7780_pci_serr_irq, 0,
 			  "PCI SERR interrupt", hose);
 	if (unlikely(ret)) {
 		printk(KERN_ERR "PCI: Failed hooking SERR IRQ\n");
diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index afc2455..637b79b 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -63,7 +63,7 @@ static int switch_drv_probe(struct platform_device *pdev)
 	BUG_ON(!psw_info);
 
 	ret = request_irq(irq, psw_info->irq_handler,
-			  IRQF_DISABLED | psw_info->irq_flags,
+			  psw_info->irq_flags,
 			  psw_info->name ? psw_info->name : DRV_NAME, pdev);
 	if (unlikely(ret < 0))
 		goto err;
diff --git a/arch/sh/kernel/cpu/sh4a/smp-shx3.c b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
index de865ca..03f2b55 100644
--- a/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -79,7 +79,7 @@ static void shx3_prepare_cpus(unsigned int max_cpus)
 
 	for (i = 0; i < SMP_MSG_NR; i++)
 		request_irq(104 + i, ipi_interrupt_handler,
-			    IRQF_DISABLED | IRQF_PERCPU, "IPI", (void *)(long)i);
+			    IRQF_PERCPU, "IPI", (void *)(long)i);
 
 	for (i = 0; i < max_cpus; i++)
 		set_cpu_present(i, true);
-- 
1.7.4.1

