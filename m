Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1JVKEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:04:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1JVKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:04:10 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 12/49] MIPS: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:24 +0800
Message-Id: <1319277421-9203-13-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/alchemy/common/dbdma.c                |    2 +-
 arch/mips/alchemy/common/time.c                 |    2 +-
 arch/mips/alchemy/devboards/db1200/platform.c   |    4 ++--
 arch/mips/cavium-octeon/smp.c                   |    2 +-
 arch/mips/dec/setup.c                           |    1 -
 arch/mips/include/asm/mach-generic/floppy.h     |    2 +-
 arch/mips/include/asm/mach-jazz/floppy.h        |    2 +-
 arch/mips/jazz/irq.c                            |    2 +-
 arch/mips/kernel/cevt-bcm1480.c                 |    2 +-
 arch/mips/kernel/cevt-ds1287.c                  |    2 +-
 arch/mips/kernel/cevt-gt641xx.c                 |    2 +-
 arch/mips/kernel/cevt-r4k.c                     |    2 +-
 arch/mips/kernel/cevt-sb1250.c                  |    2 +-
 arch/mips/kernel/cevt-txx9.c                    |    2 +-
 arch/mips/kernel/i8253.c                        |    2 +-
 arch/mips/kernel/rtlx.c                         |    1 -
 arch/mips/kernel/smtc.c                         |    2 +-
 arch/mips/lantiq/irq.c                          |    1 -
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    2 +-
 arch/mips/mti-malta/malta-int.c                 |    4 ++--
 arch/mips/pci/ops-pmcmsp.c                      |    2 +-
 arch/mips/pci/ops-tx3927.c                      |    2 +-
 arch/mips/pci/pci-tx4927.c                      |    2 +-
 arch/mips/pci/pci-tx4938.c                      |    2 +-
 arch/mips/pci/pci-tx4939.c                      |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c     |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_smp.c          |    4 ++--
 arch/mips/pnx8550/common/int.c                  |    4 ++--
 arch/mips/pnx8550/common/time.c                 |    4 ++--
 arch/mips/sgi-ip22/ip22-int.c                   |   10 +++++-----
 arch/mips/sgi-ip27/ip27-irq.c                   |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c                 |    2 +-
 arch/mips/sgi-ip32/ip32-irq.c                   |    2 --
 arch/mips/sni/irq.c                             |    2 +-
 arch/mips/sni/time.c                            |    2 +-
 arch/mips/txx9/generic/pci.c                    |    2 +-
 36 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/arch/mips/alchemy/common/dbdma.c b/arch/mips/alchemy/common/dbdma.c
index 0e63ee4..d185b89 100644
--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@ -1019,7 +1019,7 @@ static int __init dbdma_setup(unsigned int irq, dbdev_tab_t *idtable)
 	dbdma_gptr->ddma_inten = 0xffff;
 	au_sync();
 
-	ret = request_irq(irq, dbdma_interrupt, IRQF_DISABLED, "dbdma",
+	ret = request_irq(irq, dbdma_interrupt, 0, "dbdma",
 			  (void *)dbdma_gptr);
 	if (ret)
 		printk(KERN_ERR "Cannot grab DBDMA interrupt!\n");
diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index d5da6ad..146a5fa 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -92,7 +92,7 @@ static struct clock_event_device au1x_rtcmatch2_clockdev = {
 
 static struct irqaction au1x_rtcmatch2_irqaction = {
 	.handler	= au1x_rtcmatch2_irq,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.name		= "timer",
 	.dev_id		= &au1x_rtcmatch2_clockdev,
 };
diff --git a/arch/mips/alchemy/devboards/db1200/platform.c b/arch/mips/alchemy/devboards/db1200/platform.c
index c61867c..78459c1 100644
--- a/arch/mips/alchemy/devboards/db1200/platform.c
+++ b/arch/mips/alchemy/devboards/db1200/platform.c
@@ -276,12 +276,12 @@ static int db1200_mmc_cd_setup(void *mmc_host, int en)
 
 	if (en) {
 		ret = request_irq(DB1200_SD0_INSERT_INT, db1200_mmc_cd,
-				  IRQF_DISABLED, "sd_insert", mmc_host);
+				  0, "sd_insert", mmc_host);
 		if (ret)
 			goto out;
 
 		ret = request_irq(DB1200_SD0_EJECT_INT, db1200_mmc_cd,
-				  IRQF_DISABLED, "sd_eject", mmc_host);
+				  0, "sd_eject", mmc_host);
 		if (ret) {
 			free_irq(DB1200_SD0_INSERT_INT, mmc_host);
 			goto out;
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 8b60642..b6a0807 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -207,7 +207,7 @@ void octeon_prepare_cpus(unsigned int max_cpus)
 	 * the other bits alone.
 	 */
 	cvmx_write_csr(CVMX_CIU_MBOX_CLRX(cvmx_get_core_num()), 0xffff);
-	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt, IRQF_DISABLED,
+	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt, 0,
 			"SMP-IPI", mailbox_interrupt)) {
 		panic("Cannot request_irq(OCTEON_IRQ_MBOX0)\n");
 	}
diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index f7b7ba6..b874acc 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -110,7 +110,6 @@ static struct irqaction fpuirq = {
 };
 
 static struct irqaction busirq = {
-	.flags = IRQF_DISABLED,
 	.name = "bus error",
 	.flags = IRQF_NO_THREAD,
 };
diff --git a/arch/mips/include/asm/mach-generic/floppy.h b/arch/mips/include/asm/mach-generic/floppy.h
index 001a8ce..a38f4d4 100644
--- a/arch/mips/include/asm/mach-generic/floppy.h
+++ b/arch/mips/include/asm/mach-generic/floppy.h
@@ -98,7 +98,7 @@ static inline void fd_disable_irq(void)
 static inline int fd_request_irq(void)
 {
 	return request_irq(FLOPPY_IRQ, floppy_interrupt,
-	                   IRQF_DISABLED, "floppy", NULL);
+	                   0, "floppy", NULL);
 }
 
 static inline void fd_free_irq(void)
diff --git a/arch/mips/include/asm/mach-jazz/floppy.h b/arch/mips/include/asm/mach-jazz/floppy.h
index 56e9ca6..88b5acb 100644
--- a/arch/mips/include/asm/mach-jazz/floppy.h
+++ b/arch/mips/include/asm/mach-jazz/floppy.h
@@ -90,7 +90,7 @@ static inline void fd_disable_irq(void)
 static inline int fd_request_irq(void)
 {
 	return request_irq(FLOPPY_IRQ, floppy_interrupt,
-	                   IRQF_DISABLED, "floppy", NULL);
+	                   0, "floppy", NULL);
 }
 
 static inline void fd_free_irq(void)
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
index ca9bd20..0f4a147 100644
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -133,7 +133,7 @@ static irqreturn_t r4030_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction r4030_timer_irqaction = {
 	.handler	= r4030_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.name		= "R4030 timer",
 };
 
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index 36c3898..69bbfae 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -145,7 +145,7 @@ void __cpuinit sb1480_clockevent_init(void)
 	bcm1480_unmask_irq(cpu, irq);
 
 	action->handler	= sibyte_counter_handler;
-	action->flags	= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER;
+	action->flags	= IRQF_PERCPU | IRQF_TIMER;
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/cevt-ds1287.c b/arch/mips/kernel/cevt-ds1287.c
index 939157e..ed648cb 100644
--- a/arch/mips/kernel/cevt-ds1287.c
+++ b/arch/mips/kernel/cevt-ds1287.c
@@ -108,7 +108,7 @@ static irqreturn_t ds1287_interrupt(int irq, void *dev_id)
 
 static struct irqaction ds1287_irqaction = {
 	.handler	= ds1287_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "ds1287",
 };
 
diff --git a/arch/mips/kernel/cevt-gt641xx.c b/arch/mips/kernel/cevt-gt641xx.c
index 339f363..831b475 100644
--- a/arch/mips/kernel/cevt-gt641xx.c
+++ b/arch/mips/kernel/cevt-gt641xx.c
@@ -114,7 +114,7 @@ static irqreturn_t gt641xx_timer0_interrupt(int irq, void *dev_id)
 
 static struct irqaction gt641xx_timer0_irqaction = {
 	.handler	= gt641xx_timer0_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "gt641xx_timer0",
 };
 
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 98c5a97..4a3a1af 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -84,7 +84,7 @@ out:
 
 struct irqaction c0_compare_irqaction = {
 	.handler = c0_compare_interrupt,
-	.flags = IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags = IRQF_PERCPU | IRQF_TIMER,
 	.name = "timer",
 };
 
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index 590c54f..e73439f 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -144,7 +144,7 @@ void __cpuinit sb1250_clockevent_init(void)
 	sb1250_unmask_irq(cpu, irq);
 
 	action->handler	= sibyte_counter_handler;
-	action->flags	= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER;
+	action->flags	= IRQF_PERCPU | IRQF_TIMER;
 	action->name	= name;
 	action->dev_id	= cd;
 
diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
index f0ab92a..e5c30b1 100644
--- a/arch/mips/kernel/cevt-txx9.c
+++ b/arch/mips/kernel/cevt-txx9.c
@@ -146,7 +146,7 @@ static irqreturn_t txx9tmr_interrupt(int irq, void *dev_id)
 
 static struct irqaction txx9tmr_irq = {
 	.handler	= txx9tmr_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "txx9tmr",
 	.dev_id		= &txx9_clock_event_device,
 };
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 7047bff..c5bc344 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -19,7 +19,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "timer"
 };
 
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 933166f..a9d801d 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -473,7 +473,6 @@ static const struct file_operations rtlx_fops = {
 
 static struct irqaction rtlx_irq = {
 	.handler	= rtlx_interrupt,
-	.flags		= IRQF_DISABLED,
 	.name		= "RTLX",
 };
 
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index f0895e7..17c9412 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -1130,7 +1130,7 @@ static void ipi_irq_dispatch(void)
 
 static struct irqaction irq_ipi = {
 	.handler	= ipi_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "SMTC_IPI"
 };
 
diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index f9737bb..3c56179 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -240,7 +240,6 @@ out:
 
 static struct irqaction cascade = {
 	.handler = no_action,
-	.flags = IRQF_DISABLED,
 	.name = "cascade",
 };
 
diff --git a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
index 0cb1b97..5d1f48f 100644
--- a/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
+++ b/arch/mips/loongson/common/cs5536/cs5536_mfgpt.c
@@ -111,7 +111,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq5 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "timer"
 };
 
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index d53ff91..a588b5c 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -322,13 +322,13 @@ static irqreturn_t ipi_call_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq_resched = {
 	.handler	= ipi_resched_interrupt,
-	.flags		= IRQF_DISABLED|IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_resched"
 };
 
 static struct irqaction irq_call = {
 	.handler	= ipi_call_interrupt,
-	.flags		= IRQF_DISABLED|IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_call"
 };
 #endif /* CONFIG_MIPS_MT_SMP */
diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index 8fbfbf2..389bf66 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -405,7 +405,7 @@ int msp_pcibios_config_access(unsigned char access_type,
 	if (pciirqflag == 0) {
 		ret = request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
 				bpci_interrupt,
-				IRQF_SHARED | IRQF_DISABLED,
+				IRQF_SHARED,
 				"PMC MSP PCI Host",
 				preg);
 		if (ret != 0)
diff --git a/arch/mips/pci/ops-tx3927.c b/arch/mips/pci/ops-tx3927.c
index 6a3bdb5..02d64f7 100644
--- a/arch/mips/pci/ops-tx3927.c
+++ b/arch/mips/pci/ops-tx3927.c
@@ -225,7 +225,7 @@ void __init tx3927_setup_pcierr_irq(void)
 {
 	if (request_irq(TXX9_IRQ_BASE + TX3927_IR_PCI,
 			tx3927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX3927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
diff --git a/arch/mips/pci/pci-tx4927.c b/arch/mips/pci/pci-tx4927.c
index a580740..a032ae0 100644
--- a/arch/mips/pci/pci-tx4927.c
+++ b/arch/mips/pci/pci-tx4927.c
@@ -85,7 +85,7 @@ void __init tx4927_setup_pcierr_irq(void)
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4927_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
diff --git a/arch/mips/pci/pci-tx4938.c b/arch/mips/pci/pci-tx4938.c
index 20e45f3..141bba5 100644
--- a/arch/mips/pci/pci-tx4938.c
+++ b/arch/mips/pci/pci-tx4938.c
@@ -136,7 +136,7 @@ void __init tx4938_setup_pcierr_irq(void)
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4938_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
diff --git a/arch/mips/pci/pci-tx4939.c b/arch/mips/pci/pci-tx4939.c
index 9ef8406..c10fbf2 100644
--- a/arch/mips/pci/pci-tx4939.c
+++ b/arch/mips/pci/pci-tx4939.c
@@ -101,7 +101,7 @@ void __init tx4939_setup_pcierr_irq(void)
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4939_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4939_PCIC_REG))
 		pr_warning("Failed to request irq for PCIERR\n");
 }
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
index c841f08..bb57ed9 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -149,7 +149,7 @@ static int msp_hwbutton_register(struct hwbutton_interrupt *hirq)
 		CIC_EXT_SET_ACTIVE_HI(cic_ext, hirq->eirq);
 	*CIC_EXT_CFG_REG = cic_ext;
 
-	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
+	return request_irq(hirq->irq, hwbutton_handler, 0,
 			   hirq->name, hirq);
 }
 
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_smp.c b/arch/mips/pmc-sierra/msp71xx/msp_smp.c
index bec1790..1017058 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_smp.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_smp.c
@@ -51,13 +51,13 @@ static irqreturn_t ipi_call_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq_resched = {
 	.handler	= ipi_resched_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_resched"
 };
 
 static struct irqaction irq_call = {
 	.handler	= ipi_call_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_call"
 };
 
diff --git a/arch/mips/pnx8550/common/int.c b/arch/mips/pnx8550/common/int.c
index 1ebe22b..ec684b8 100644
--- a/arch/mips/pnx8550/common/int.c
+++ b/arch/mips/pnx8550/common/int.c
@@ -167,13 +167,13 @@ static struct irq_chip level_irq_type = {
 
 static struct irqaction gic_action = {
 	.handler =	no_action,
-	.flags =	IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags =	IRQF_NO_THREAD,
 	.name =		"GIC",
 };
 
 static struct irqaction timer_action = {
 	.handler =	no_action,
-	.flags =	IRQF_DISABLED | IRQF_TIMER,
+	.flags =	IRQF_TIMER,
 	.name =		"Timer",
 };
 
diff --git a/arch/mips/pnx8550/common/time.c b/arch/mips/pnx8550/common/time.c
index 8836c62..831d6b3 100644
--- a/arch/mips/pnx8550/common/time.c
+++ b/arch/mips/pnx8550/common/time.c
@@ -59,7 +59,7 @@ static irqreturn_t pnx8xxx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction pnx8xxx_timer_irq = {
 	.handler	= pnx8xxx_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "pnx8xxx_timer",
 };
 
@@ -72,7 +72,7 @@ static irqreturn_t monotonic_interrupt(int irq, void *dev_id)
 
 static struct irqaction monotonic_irqaction = {
 	.handler = monotonic_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "Monotonic timer",
 };
 
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f72c336..3f2b763 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -155,32 +155,32 @@ static void __irq_entry indy_buserror_irq(void)
 
 static struct irqaction local0_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags		= IRQF_NO_THREAD,
 	.name		= "local0 cascade",
 };
 
 static struct irqaction local1_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags		= IRQF_NO_THREAD,
 	.name		= "local1 cascade",
 };
 
 static struct irqaction buserr = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags		= IRQF_NO_THREAD,
 	.name		= "Bus Error",
 };
 
 static struct irqaction map0_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags		= IRQF_NO_THREAD,
 	.name		= "mapable0 cascade",
 };
 
 #ifdef USE_LIO3_IRQ
 static struct irqaction map1_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED | IRQF_NO_THREAD,
+	.flags		= IRQF_NO_THREAD,
 	.name		= "mapable1 cascade",
 };
 #define SGI_INTERRUPTS	SGINT_END
diff --git a/arch/mips/sgi-ip27/ip27-irq.c b/arch/mips/sgi-ip27/ip27-irq.c
index f90dce3..888eac1 100644
--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -116,7 +116,7 @@ static int ms1bit(unsigned long x)
 }
 
 /*
- * This code is unnecessarily complex, because we do IRQF_DISABLED
+ * This code is unnecessarily complex, because we do
  * intr enabling. Basically, once we grab the set of intrs we need
  * to service, we must mask _all_ these interrupts; firstly, to make
  * sure the same intr does not intr again, causing recursion that
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index ef74f32..13cfeab 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -91,7 +91,7 @@ static irqreturn_t hub_rt_counter_handler(int irq, void *dev_id)
 
 struct irqaction hub_rt_irqaction = {
 	.handler	= hub_rt_counter_handler,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "hub-rt",
 };
 
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index c65ea76..a092860 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -113,13 +113,11 @@ extern irqreturn_t crime_cpuerr_intr(int irq, void *dev_id);
 
 static struct irqaction memerr_irq = {
 	.handler = crime_memerr_intr,
-	.flags = IRQF_DISABLED,
 	.name = "CRIME memory error",
 };
 
 static struct irqaction cpuerr_irq = {
 	.handler = crime_cpuerr_intr,
-	.flags = IRQF_DISABLED,
 	.name = "CRIME CPU error",
 };
 
diff --git a/arch/mips/sni/irq.c b/arch/mips/sni/irq.c
index e8e72bb..5a4ec75 100644
--- a/arch/mips/sni/irq.c
+++ b/arch/mips/sni/irq.c
@@ -42,7 +42,7 @@ static irqreturn_t sni_isa_irq_handler(int dummy, void *p)
 struct irqaction sni_isa_irq = {
 	.handler = sni_isa_irq_handler,
 	.name = "ISA",
-	.flags = IRQF_SHARED | IRQF_DISABLED
+	.flags = IRQF_SHARED
 };
 
 /*
diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index ec0be14..494c9e7 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -68,7 +68,7 @@ static irqreturn_t a20r_interrupt(int irq, void *dev_id)
 
 static struct irqaction a20r_irqaction = {
 	.handler	= a20r_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU | IRQF_TIMER,
+	.flags		= IRQF_PERCPU | IRQF_TIMER,
 	.name		= "a20r-timer",
 };
 
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 85a87de..682efb0 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -262,7 +262,7 @@ txx9_i8259_irq_setup(int irq)
 	int err;
 
 	init_i8259_irqs();
-	err = request_irq(irq, &i8259_interrupt, IRQF_DISABLED|IRQF_SHARED,
+	err = request_irq(irq, &i8259_interrupt, IRQF_SHARED,
 			  "cascade(i8259)", (void *)(long)irq);
 	if (!err)
 		printk(KERN_INFO "PCI-ISA bridge PIC (irq %d)\n", irq);
-- 
1.7.1

