Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2HVIqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:46:14 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:44982 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab2HVIoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:44:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Etienne Carriere <etienne.carriere@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/7] ux500: GIC: MASK_ON_SUSPEND
Date: Wed, 22 Aug 2012 10:43:48 +0200
Message-ID: <1345625028-5608-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Etienne Carriere <etienne.carriere@stericsson.com>

ux500 machines performs pins (GPIO) reconfiguration when entering
in the suspended mode. This reconfiguration aims at reaching an ultra
low power HW configuration.

Due to this HW reconfiguration, some HW devices can change of HW state
and have their output signals at level that could generate IRQs.

If the non-wakeup IRQs are disabled but not yet masked (delayed interrupt
disable feature from the generic irq layer), effective interrupts reach
the system only because the system attempt to enter the suspended mode.

To prevent such IRQs to trig, all irq chips embedded in ux500 platform
should enable their IRQCHIP_MASK_ON_SUSPEND flag.

Signed-off-by: Etienne Carriere <etienne.carriere@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index e2360e7..84d7f7e 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -51,6 +51,8 @@ void __init ux500_init_irq(void)
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
 
+	gic_arch_extn.flags = IRQCHIP_MASK_ON_SUSPEND;
+
 	if (cpu_is_u8500_family()) {
 		dist_base = __io_address(U8500_GIC_DIST_BASE);
 		cpu_base = __io_address(U8500_GIC_CPU_BASE);
-- 
1.7.11.3

