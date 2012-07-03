Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2GCKfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:35:09 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:55130
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab2GCKfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:35:07 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2012 06:35:07 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Date: Tue, 3 Jul 2012 18:21:18 +0800
Message-ID: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do hardware timebase sync. Firstly, stop all timebases, and transfer
the timebase value of the boot core to the other core. Finally,
start all timebases.

Only apply to dual-core chips, such as MPC8572, P2020, etc.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
v7:
 * removed CONFIG_85xx_TB_SYNC
 * incorporated Timur's comments

 arch/powerpc/include/asm/fsl_guts.h |    2 +
 arch/powerpc/platforms/85xx/smp.c   |   82 +++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/fsl_guts.h b/arch/powerpc/include/asm/fsl_guts.h
index aa4c488..dd5ba2c 100644
--- a/arch/powerpc/include/asm/fsl_guts.h
+++ b/arch/powerpc/include/asm/fsl_guts.h
@@ -48,6 +48,8 @@ struct ccsr_guts {
         __be32  dmuxcr;		/* 0x.0068 - DMA Mux Control Register */
         u8	res06c[0x70 - 0x6c];
 	__be32	devdisr;	/* 0x.0070 - Device Disable Control */
+#define CCSR_GUTS_DEVDISR_TB1	0x00001000
+#define CCSR_GUTS_DEVDISR_TB0	0x00004000
 	__be32	devdisr2;	/* 0x.0074 - Device Disable Control 2 */
 	u8	res078[0x7c - 0x78];
 	__be32  pmjcr;		/* 0x.007c - 4 Power Management Jog Control Register */
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index ff42490..2e65fe8 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -24,6 +24,7 @@
 #include <asm/mpic.h>
 #include <asm/cacheflush.h>
 #include <asm/dbell.h>
+#include <asm/fsl_guts.h>
 
 #include <sysdev/fsl_soc.h>
 #include <sysdev/mpic.h>
@@ -42,6 +43,64 @@ extern void __early_start(void);
 #define NUM_BOOT_ENTRY		8
 #define SIZE_BOOT_ENTRY		(NUM_BOOT_ENTRY * sizeof(u32))
 
+static struct ccsr_guts __iomem *guts;
+static u64 timebase;
+static int tb_req;
+static int tb_valid;
+
+static void mpc85xx_timebase_freeze(int freeze)
+{
+	uint32_t mask;
+
+	mask = CCSR_GUTS_DEVDISR_TB0 | CCSR_GUTS_DEVDISR_TB1;
+	if (freeze)
+		setbits32(&guts->devdisr, mask);
+	else
+		clrbits32(&guts->devdisr, mask);
+
+	in_be32(&guts->devdisr);
+}
+
+static void mpc85xx_give_timebase(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	while (!tb_req)
+		barrier();
+	tb_req = 0;
+
+	mpc85xx_timebase_freeze(1);
+	timebase = get_tb();
+	mb();
+	tb_valid = 1;
+
+	while (tb_valid)
+		barrier();
+
+	mpc85xx_timebase_freeze(0);
+
+	local_irq_restore(flags);
+}
+
+static void mpc85xx_take_timebase(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	tb_req = 1;
+	while (!tb_valid)
+		barrier();
+
+	set_tb(timebase >> 32, timebase & 0xffffffff);
+	isync();
+	tb_valid = 0;
+
+	local_irq_restore(flags);
+}
+
 static int __init
 smp_85xx_kick_cpu(int nr)
 {
@@ -228,6 +287,16 @@ smp_85xx_setup_cpu(int cpu_nr)
 		doorbell_setup_this_cpu();
 }
 
+static const struct of_device_id mpc85xx_smp_guts_ids[] = {
+	{ .compatible = "fsl,mpc8572-guts", },
+	{ .compatible = "fsl,p1020-guts", },
+	{ .compatible = "fsl,p1021-guts", },
+	{ .compatible = "fsl,p1022-guts", },
+	{ .compatible = "fsl,p1023-guts", },
+	{ .compatible = "fsl,p2020-guts", },
+	{},
+};
+
 void __init mpc85xx_smp_init(void)
 {
 	struct device_node *np;
@@ -249,6 +318,19 @@ void __init mpc85xx_smp_init(void)
 		smp_85xx_ops.cause_ipi = doorbell_cause_ipi;
 	}
 
+	np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
+	if (np) {
+		guts = of_iomap(np, 0);
+		of_node_put(np);
+		if (!guts) {
+			pr_err("%s: Could not map guts node address\n",
+								__func__);
+			return;
+		}
+		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
+		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
+	}
+
 	smp_ops = &smp_85xx_ops;
 
 #ifdef CONFIG_KEXEC
-- 
1.6.4.1


