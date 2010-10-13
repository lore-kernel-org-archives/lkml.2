Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0JMKKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:10:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:37621 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0JMKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:10:13 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux@arm.linux.org.uk, khilman@deeprootsystems.com,
        akpm@linux-foundation.org, charu@ti.com, tero.kristo@nokia.com,
        ext-eugeny.kuznetsov@nokia.com
Subject: [PATCHv2 1/1] omap: Ptr "isr_reg" tracked as NULL was dereferenced
Date: Wed, 13 Oct 2010 14:04:50 +0400
Message-Id: <7bb69801f49283c3bde78aa008c15308ac8a5fbf.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-OriginalArrivalTime: 13 Oct 2010 10:08:39.0051 (UTC) FILETIME=[9B35B5B0:01CB6ABE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Value of "isr_reg" pointer is depend on configuration and GPIO method.
Potentially it may have NULL value and it is dereferenced later
in code. If pointer is NULL there is some kernel issue.
Warning and exit from function are added in this case.
Also compilation check is added for correct architecture
configuration.

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
---
 arch/arm/plat-omap/gpio.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index c05c653..d04913c 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1318,6 +1318,23 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	if (bank->method == METHOD_GPIO_44XX)
 		isr_reg = bank->base + OMAP4_GPIO_IRQSTATUS0;
 #endif
+
+#if !defined(CONFIG_ARCH_OMAP1) &&		\
+		!defined(CONFIG_ARCH_OMAP15XX) &&	\
+		!defined(CONFIG_ARCH_OMAP16XX) &&	\
+		!defined(CONFIG_ARCH_OMAP730) &&	\
+		!defined(CONFIG_ARCH_OMAP850) &&	\
+		!defined(CONFIG_ARCH_OMAP2) &&	\
+		!defined(CONFIG_ARCH_OMAP3) &&	\
+		!defined(CONFIG_ARCH_OMAP4)
+	
+#error "Incorrect arch configuration"
+	
+#endif
+	
+	if (WARN_ON(!isr_reg))
+		goto exit;
+
 	while(1) {
 		u32 isr_saved, level_mask = 0;
 		u32 enabled;
@@ -1377,6 +1394,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	configured, we must unmask the bank interrupt only after
 	handler(s) are executed in order to avoid spurious bank
 	interrupt */
+exit:
 	if (!unmasked)
 		desc->chip->unmask(irq);
 
-- 
1.6.3.3

