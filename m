Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2EKLyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:54:40 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:43072
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab2EKLxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:53:54 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup event source
Date: Fri, 11 May 2012 19:53:54 +0800
Message-ID: <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APIs for setting wakeup source and lossless Ethernet in low power modes.
These APIs can be used by wake-on-packet feature.

Signed-off-by: Dave Liu <daveliu@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/sysdev/fsl_pmc.c |   71 ++++++++++++++++++++++++++++++++++++++++-
 arch/powerpc/sysdev/fsl_soc.h |    9 +++++
 2 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 1dc6e9e..c1170f7 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -34,6 +34,7 @@ struct pmc_regs {
 	__be32 powmgtcsr;
 #define POWMGTCSR_SLP		0x00020000
 #define POWMGTCSR_DPSLP		0x00100000
+#define POWMGTCSR_LOSSLESS	0x00400000
 	__be32 res3[2];
 	__be32 pmcdr;
 };
@@ -43,6 +44,74 @@ static unsigned int pmc_flag;
 
 #define PMC_SLEEP	0x1
 #define PMC_DEEP_SLEEP	0x2
+#define PMC_LOSSLESS	0x4
+
+/**
+ * mpc85xx_pmc_set_wake - enable devices as wakeup event source
+ * @pdev: platform device affected
+ * @enable: True to enable event generation; false to disable
+ *
+ * This enables the device as a wakeup event source, or disables it.
+ *
+ * RETURN VALUE:
+ * 0 is returned on success
+ * -EINVAL is returned if device is not supposed to wake up the system
+ * Error code depending on the platform is returned if both the platform and
+ * the native mechanism fail to enable the generation of wake-up events
+ */
+int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool enable)
+{
+	int ret = 0;
+	struct device_node *clk_np;
+	u32 *prop;
+	u32 pmcdr_mask;
+
+	if (!pmc_regs) {
+		pr_err("%s: PMC is unavailable\n", __func__);
+		return -ENODEV;
+	}
+
+	if (enable && !device_may_wakeup(&pdev->dev))
+		return -EINVAL;
+
+	clk_np = of_parse_phandle(pdev->dev.of_node, "fsl,pmc-handle", 0);
+	if (!clk_np)
+		return -EINVAL;
+
+	prop = (u32 *)of_get_property(clk_np, "fsl,pmcdr-mask", NULL);
+	if (!prop) {
+		ret = -EINVAL;
+		goto out;
+	}
+	pmcdr_mask = be32_to_cpup(prop);
+
+	if (enable)
+		/* clear to enable clock in low power mode */
+		clrbits32(&pmc_regs->pmcdr, pmcdr_mask);
+	else
+		setbits32(&pmc_regs->pmcdr, pmcdr_mask);
+
+out:
+	of_node_put(clk_np);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_wake);
+
+/**
+ * mpc85xx_pmc_set_lossless_ethernet - enable lossless ethernet
+ * in (deep) sleep mode
+ * @enable: True to enable event generation; false to disable
+ */
+void mpc85xx_pmc_set_lossless_ethernet(int enable)
+{
+	if (pmc_flag & PMC_LOSSLESS) {
+		if (enable)
+			setbits32(&pmc_regs->powmgtcsr,	POWMGTCSR_LOSSLESS);
+		else
+			clrbits32(&pmc_regs->powmgtcsr, POWMGTCSR_LOSSLESS);
+	}
+}
+EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_lossless_ethernet);
 
 static int pmc_suspend_enter(suspend_state_t state)
 {
@@ -117,7 +186,7 @@ static int pmc_probe(struct platform_device *pdev)
 		pmc_flag |= PMC_DEEP_SLEEP;
 
 	if (of_device_is_compatible(np, "fsl,p1022-pmc"))
-		pmc_flag |= PMC_DEEP_SLEEP;
+		pmc_flag |= PMC_DEEP_SLEEP | PMC_LOSSLESS;
 
 	suspend_set_ops(&pmc_suspend_ops);
 
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 949377d..8976534 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -3,6 +3,7 @@
 #ifdef __KERNEL__
 
 #include <asm/mmu.h>
+#include <linux/platform_device.h>
 
 struct spi_device;
 
@@ -21,6 +22,14 @@ struct device_node;
 
 extern void fsl_rstcr_restart(char *cmd);
 
+#ifdef CONFIG_FSL_PMC
+extern int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool enable);
+extern void mpc85xx_pmc_set_lossless_ethernet(int enable);
+#else
+#define mpc85xx_pmc_set_wake(pdev, enable)		do { } while (0)
+#define mpc85xx_pmc_set_lossless_ethernet(enable)	do { } while (0)
+#endif
+
 #if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 
 /* The different ports that the DIU can be connected to */
-- 
1.6.4.1


