Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1C3LY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:24:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1C3LY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:24:28 -0400
From: Michal Simek <monstr@monstr.eu>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH v2] microblaze: Fix level/edge irq sensibility
Date: Wed, 30 Mar 2011 13:24:24 +0200
Message-Id: <1301484264-6220-1-git-send-email-monstr@monstr.eu>
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
  2:          2  Xilinx INTC-level     eth0
  3:          2  Xilinx INTC-level     eth0
  4:        238  Xilinx INTC-edge      timer
  6:        108  Xilinx INTC-level     serial

Signed-off-by: Michal Simek <monstr@monstr.eu>

---

v2: Fix exchanged edge and level
---
 arch/microblaze/kernel/intc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 5ba7e16..c88f066 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -158,11 +158,11 @@ void __init init_IRQ(void)
 	for (i = 0; i < nr_irq; ++i) {
 		if (intr_type & (0x00000001 << i)) {
 			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_edge_irq, intc_dev.name);
+				handle_edge_irq, "edge");
 			irq_clear_status_flags(i, IRQ_LEVEL);
 		} else {
 			irq_set_chip_and_handler_name(i, &intc_dev,
-				handle_level_irq, intc_dev.name);
+				handle_level_irq, "level");
 			irq_set_status_flags(i, IRQ_LEVEL);
 		}
 	}
-- 
1.5.5.6

