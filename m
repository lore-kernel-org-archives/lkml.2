Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1ANB5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:57:04 -0500
Received: from [69.28.251.93] ([69.28.251.93]:45030 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab1ANB41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:56:27 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND 5/6] MIPS: Install handlers for BMIPS software IRQs
Date: Thu, 13 Jan 2011 17:52:16 -0800
Message-Id: <f882756bdbcde53bef3261341cd3b997@localhost>
In-Reply-To: <491015d51e5d3d36c517da09e038ecaf@localhost>
References: <491015d51e5d3d36c517da09e038ecaf@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BMIPS4350/4380/5000 CMT/SMT all use SW INT0/INT1 for inter-thread
signaling.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/irq_cpu.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index 0262abe..70d4736 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -107,14 +107,12 @@ void __init mips_cpu_irq_init(void)
 	clear_c0_status(ST0_IM);
 	clear_c0_cause(CAUSEF_IP);
 
-	/*
-	 * Only MT is using the software interrupts currently, so we just
-	 * leave them uninitialized for other processors.
-	 */
-	if (cpu_has_mipsmt)
-		for (i = irq_base; i < irq_base + 2; i++)
-			set_irq_chip_and_handler(i, &mips_mt_cpu_irq_controller,
-						 handle_percpu_irq);
+	/* Software interrupts are used for MT/CMT IPI */
+	for (i = irq_base; i < irq_base + 2; i++)
+		set_irq_chip_and_handler(i, cpu_has_mipsmt ?
+					 &mips_mt_cpu_irq_controller :
+					 &mips_cpu_irq_controller,
+					 handle_percpu_irq);
 
 	for (i = irq_base + 2; i < irq_base + 8; i++)
 		set_irq_chip_and_handler(i, &mips_cpu_irq_controller,
-- 
1.7.0.4

