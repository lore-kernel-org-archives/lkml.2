Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2JPAnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:43:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57787 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2JPAnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:43:39 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/4] ARM: VIC: Add a couple of low-level FIQ management helpers
Date: Mon, 15 Oct 2012 17:39:55 -0700
Message-Id: <1350347996-25412-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121016003756.GA23146@lizard>
References: <20121016003756.GA23146@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a couple of calls to manage VIC FIQ routing. We'll use them for
KGDB FIQ support on ARM Versatile machines.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/common/vic.c               | 28 ++++++++++++++++++++++++++++
 arch/arm/include/asm/hardware/vic.h |  2 ++
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
1.7.12.3

