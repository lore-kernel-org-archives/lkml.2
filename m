Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0HaCgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:36:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54763 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab0HaCgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C634TXnnjOE4psrJ3XY6oiTl4kSAuNhPK9jOPzlHjvpZ5G+U1olAoFkrnu4spww8kl
         9DaU4PnZDnkGz9fmt0jPOpS6e+0N8cgAWSfJ4mI4qO5Wjk3UCzK2X8Mw333tFykjd62q
         mUiW0fgm0Pl65tXiv9BymVFyFPBwuYlyj/6BI=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 4/5] ARM: pxa168: added special case handler for keypad interrupts
Date: Thu, 26 Aug 2010 05:18:58 -0400
Message-Id: <1282814339-10934-5-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/irq-pxa168.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/irq-pxa168.c b/arch/arm/mach-mmp/irq-pxa168.c
index 52ff2f0..bfb0984 100644
--- a/arch/arm/mach-mmp/irq-pxa168.c
+++ b/arch/arm/mach-mmp/irq-pxa168.c
@@ -17,6 +17,8 @@
 #include <linux/io.h>
 
 #include <mach/regs-icu.h>
+#include <mach/regs-apmu.h>
+#include <mach/cputype.h>
 
 #include "common.h"
 
@@ -42,6 +44,19 @@ static struct irq_chip icu_irq_chip = {
 	.unmask	= icu_unmask_irq,
 };
 
+void handle_pxa168_keypad_irq(unsigned int irq, struct irq_desc *desc)
+{
+	uint32_t val;
+	uint32_t mask = APMU_PXA168_KP_WAKE_CLR;
+
+	/* clear keypad wake event */
+	val = __raw_readl(APMU_WAKE_CLR);
+	__raw_writel(val |  mask, APMU_WAKE_CLR);
+
+	/* handle irq */
+	handle_level_irq(irq, desc);
+}
+
 void __init icu_init_irq(void)
 {
 	int irq;
@@ -49,7 +64,13 @@ void __init icu_init_irq(void)
 	for (irq = 0; irq < 64; irq++) {
 		icu_mask_irq(irq);
 		set_irq_chip(irq, &icu_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+
+		/* special handler for keypad */
+		if (cpu_is_pxa168() && irq == IRQ_PXA168_KEYPAD)
+			set_irq_handler(irq, handle_pxa168_keypad_irq);
+		else
+			set_irq_handler(irq, handle_level_irq);
+
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
-- 
1.7.0.4

