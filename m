Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2G3MCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:02:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45168 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2G3MB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:01:59 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 09/11] ARM: VIC: Add a couple of low-level FIQ management helpers
Date: Mon, 30 Jul 2012 04:58:18 -0700
Message-Id: <1343649500-18491-9-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120730115719.GA5742@lizard>
References: <20120730115719.GA5742@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a couple of calls to manage VIC FIQ routing. We'll use them for
KGDB FIQ support on ARM Versatile machines.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/common/vic.c               |   28 ++++++++++++++++++++++++++++
 arch/arm/include/asm/hardware/vic.h |    2 ++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
index e0d5388..df2fc82 100644
--- a/arch/arm/common/vic.c
+++ b/arch/arm/common/vic.c
@@ -66,6 +66,34 @@ static struct vic_device vic_devices[CONFIG_ARM_VIC_NR];
 
 static int vic_id;
 
+static void __iomem *vic_base(struct irq_data *d)
+{
+	return (void __iomem *)irq_data_get_irq_chip_data(d);
+}
+
+void vic_fiq_select(unsigned int irq, bool on)
+{
+	void __iomem *base = vic_base(&irq_to_desc(irq)->irq_data);
+	void __iomem *sel = base + VIC_INT_SELECT;
+	u32 msk = 1 << irq;
+	u32 val;
+
+	pr_debug("rerouting VIC vector %d to %s\n", irq, on ? "FIQ" : "IRQ");
+
+	val = readl(sel);
+	val &= ~msk;
+	if (on)
+		val |= msk;
+	writel(val, sel);
+}
+
+bool vic_is_fiq_rised(unsigned int irq)
+{
+	void __iomem *base = vic_base(&irq_to_desc(irq)->irq_data);
+
+	return readl(base + VIC_FIQ_STATUS) & (1 << irq);
+}
+
 /**
  * vic_init2 - common initialisation code
  * @base: Base of the VIC.
diff --git a/arch/arm/include/asm/hardware/vic.h b/arch/arm/include/asm/hardware/vic.h
index e14af1a..2728975 100644
--- a/arch/arm/include/asm/hardware/vic.h
+++ b/arch/arm/include/asm/hardware/vic.h
@@ -52,6 +52,8 @@ void __vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources,
 void vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources, u32 resume_sources);
 int vic_of_init(struct device_node *node, struct device_node *parent);
 void vic_handle_irq(struct pt_regs *regs);
+void vic_fiq_select(unsigned int irq, bool on);
+bool vic_is_fiq_rised(unsigned int irq);
 
 #endif /* __ASSEMBLY__ */
 #endif
-- 
1.7.10.4

