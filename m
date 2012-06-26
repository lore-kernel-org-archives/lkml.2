Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab2FZKZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:25:19 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14163
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab2FZKZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:25:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <galak@kernel.crashing.org>,
        <leoli@freescale.com>
Subject: [PATCH v6 4/5] fsl_pmc: Add API to enable device as wakeup event source
Date: Tue, 26 Jun 2012 18:25:58 +0800
Message-ID: <1340706359-9455-4-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
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
Changes for v6:
 * changed the parameter of mpc85xx_pmc_set_wake()
 * set an initial value to PMCDR register

 arch/powerpc/sysdev/fsl_pmc.c |   77 ++++++++++++++++++++++++++++++++++++++++-
 arch/powerpc/sysdev/fsl_soc.h |   12 ++++++
 2 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 45718c5..b6c8c8f 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -38,6 +38,7 @@ struct pmc_regs {
 	__be32 powmgtcsr;
 #define POWMGTCSR_SLP		0x00020000
 #define POWMGTCSR_DPSLP		0x00100000
+#define POWMGTCSR_LOSSLESS	0x00400000
 	__be32 res3[2];
 	/* 0xe008c: Power management clock disable register */
 	__be32 pmcdr;
@@ -48,6 +49,77 @@ static unsigned int pmc_flag;
 
 #define PMC_SLEEP	0x1
 #define PMC_DEEP_SLEEP	0x2
+#define PMC_LOSSLESS	0x4
+
+#define PMCDR_MASK_INIT		0x00e008e0
+
+/**
+ * mpc85xx_pmc_set_wake - enable devices as wakeup event source
+ * @dev: a device affected
+ * @enable: True to enable event generation; false to disable
+ *
+ * This enables the device as a wakeup event source, or disables it.
+ *
+ * RETURN VALUE:
+ * 0 is returned on success.
+ * -EINVAL is returned if device is not supposed to wake up the system.
+ * -ENODEV is returned if PMC is unavailable.
+ * Error code depending on the platform is returned if both the platform and
+ * the native mechanism fail to enable the generation of wake-up events
+ */
+int mpc85xx_pmc_set_wake(struct device *dev, bool enable)
+{
+	int ret = 0;
+	struct device_node *clk_np;
+	const u32 *prop;
+	u32 pmcdr_mask;
+
+	if (!pmc_regs) {
+		pr_err("%s: PMC is unavailable\n", __func__);
+		return -ENODEV;
+	}
+
+	if (enable && !device_may_wakeup(dev))
+		return -EINVAL;
+
+	clk_np = of_parse_phandle(dev->of_node, "fsl,pmc-handle", 0);
+	if (!clk_np)
+		return -EINVAL;
+
+	prop = of_get_property(clk_np, "fsl,pmcdr-mask", NULL);
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
@@ -123,7 +195,10 @@ static int pmc_probe(struct platform_device *pdev)
 		pmc_flag |= PMC_DEEP_SLEEP;
 
 	if (of_device_is_compatible(np, "fsl,p1022-pmc"))
-		pmc_flag |= PMC_DEEP_SLEEP;
+		pmc_flag |= PMC_DEEP_SLEEP | PMC_LOSSLESS;
+
+	/* Init the Power Management Clock Disable Register. */
+	setbits32(&pmc_regs->pmcdr, PMCDR_MASK_INIT);
 
 	suspend_set_ops(&pmc_suspend_ops);
 
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 11d9f94..b1510ef 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -3,6 +3,7 @@
 #ifdef __KERNEL__
 
 #include <asm/mmu.h>
+#include <linux/platform_device.h>
 
 struct spi_device;
 
@@ -21,6 +22,17 @@ struct device_node;
 
 extern void fsl_rstcr_restart(char *cmd);
 
+#ifdef CONFIG_FSL_PMC
+extern int mpc85xx_pmc_set_wake(struct device *dev, bool enable);
+extern void mpc85xx_pmc_set_lossless_ethernet(int enable);
+#else
+static inline int mpc85xx_pmc_set_wake(struct device *dev, bool enable)
+{
+	return -ENODEV;
+}
+#define mpc85xx_pmc_set_lossless_ethernet(enable)	do { } while (0)
+#endif
+
 #if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 
 /* The different ports that the DIU can be connected to */
-- 
1.6.4.1


