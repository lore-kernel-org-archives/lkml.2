Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1C3LTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:19:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1C3LTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:19:44 -0400
From: Michal Simek <monstr@monstr.eu>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Fix level/edge irq sensibility
Date: Wed, 30 Mar 2011 13:19:39 +0200
Message-Id: <1301483979-3175-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches:
"microblaze: Convert to new irq function names"
sha (4adc192ec7d977c74c750320f289af9d61c1caca)
and
"microblaze: Use generic show_interrupts()"
sha(9d61c18b25726306c9231428c17db42e3ff29ba7)

should also setup edge/level in irq_set_chip_and_handler_name
name parameter.

Error log:
~ # cat /proc/interrupts
           CPU0
  2:          2  Xilinx INTC-Xilinx INTC  eth0
  3:          2  Xilinx INTC-Xilinx INTC  eth0
  4:        241  Xilinx INTC-Xilinx INTC  timer
  6:        108  Xilinx INTC-Xilinx INTC  serial

Fixed:
~ # cat /proc/interrupts
           CPU0
  2:          2  Xilinx INTC-edge      eth0
  3:          2  Xilinx INTC-edge      eth0
  4:        241  Xilinx INTC-level     timer
  6:        108  Xilinx INTC-edge      serial

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/intc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 5ba7e16..71efa51 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -158,11 +158,11 @@ void __init init_IRQ(void)
 	for (i = 0; i < nr_irq; ++i) {
 		if (intr_type & (0x00000001 << i)) {
 			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_edge_irq, intc_dev.name);
+				handle_edge_irq, "level");
 			irq_clear_status_flags(i, IRQ_LEVEL);
 		} else {
 			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_level_irq, intc_dev.name);
+				handle_level_irq, "edge");
 			irq_set_status_flags(i, IRQ_LEVEL);
 		}
 	}
-- 
1.5.5.6

