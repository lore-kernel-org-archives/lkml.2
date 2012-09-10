Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2IJWYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:24:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2IJWYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:24:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6830"; a="232768808"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@linaro.org>
Subject: [PATCH] ARM: smp: Formalize an IPI for wakeup
Date: Mon, 10 Sep 2012 15:24:29 -0700
Message-Id: <1347315869-28285-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the offset from ipi_msg_type and assume that SGI0 is the
wakeup interrupt now that all WFI hotplug users call
gic_raise_softirq() with 0 instead of 1. This allows us to 
track how many wakeup interrupts are sent and also removes the
unknown IPI printk message for WFI hotplug based systems.

Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/hardirq.h |  2 +-
 arch/arm/kernel/smp.c          | 13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index 436e60b..2740c2a2 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	5
+#define NR_IPI	6
 
 typedef struct {
 	unsigned int __softirq_pending;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ebd8ad2..d98c37e 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -51,7 +51,8 @@
 struct secondary_data secondary_data;
 
 enum ipi_msg_type {
-	IPI_TIMER = 2,
+	IPI_WAKEUP,
+	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
 	IPI_CALL_FUNC_SINGLE,
@@ -347,7 +348,8 @@ void arch_send_call_function_single_ipi(int cpu)
 }
 
 static const char *ipi_types[NR_IPI] = {
-#define S(x,s)	[x - IPI_TIMER] = s
+#define S(x,s)	[x] = s
+	S(IPI_WAKEUP, "CPU wakeup interrupts"),
 	S(IPI_TIMER, "Timer broadcast interrupts"),
 	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
 	S(IPI_CALL_FUNC, "Function call interrupts"),
@@ -500,10 +502,13 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 	unsigned int cpu = smp_processor_id();
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	if (ipinr >= IPI_TIMER && ipinr < IPI_TIMER + NR_IPI)
-		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_TIMER]);
+	if (ipinr < NR_IPI)
+		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
 
 	switch (ipinr) {
+	case IPI_WAKEUP:
+		break;
+
 	case IPI_TIMER:
 		irq_enter();
 		ipi_timer();
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

