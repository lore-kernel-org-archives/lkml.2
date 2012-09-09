Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2IIT0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 15:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2IIT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 15:26:18 -0400
From: raghu.prabhu13@gmail.com
To: jeremy@goop.org, mingo@redhat.com, x86@kernel.org
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...,commit_signer:2/11=18%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        liu chuansheng <chuansheng.liu@intel.com> (commit_signer:2/11=18%),
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp> (commit_signer:2/11=18%),
        Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/11=9%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] IRQ: Add a check for uninitialized irqs.
Date: Mon, 10 Sep 2012 00:55:27 +0530
Message-Id: <9250ef1afde6ddd2bab613bd847ad54adc014bac.1347218449.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Errors like "do_IRQ: 0.84 No Irq handler for vector (irq -1)" have been reported
earlier filling up the console/logs. So this adds a condition to check for
uninitialized irqs so that it exits early and doesn't proceed further. Also, irq
is made a signed integer, since if it is not mapped to a vector, it will be
assigned -1 which will be UINT_MAX otherwise.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 arch/x86/kernel/irq.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..ddba63a 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -184,21 +184,24 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
+	int irq;
 
 	irq_enter();
 	exit_idle();
 
-	irq = __this_cpu_read(vector_irq[vector]);
+	if (unlikely((irq = __this_cpu_read(vector_irq[vector])) == -1)) {
+		pr_emerg_ratelimited("IRQ handler not setup for vector %u", vector);
+		goto err_exit;
+	}
 
 	if (!handle_irq(irq, regs)) {
 		ack_APIC_irq();
 
-		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
-				__func__, smp_processor_id(), vector, irq);
+		pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %u)\n",
+			__func__, smp_processor_id(), vector, irq);
 	}
 
+err_exit:
 	irq_exit();
 
 	set_irq_regs(old_regs);
-- 
1.7.12

