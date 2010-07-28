Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0G1UkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:40:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:62706 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab0G1UkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:40:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] x86,kgdb: Fix hw breakpoint regression
Date: Wed, 28 Jul 2010 15:39:50 -0500
Message-Id: <1280349590-27754-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 28 Jul 2010 20:39:55.0939 (UTC) FILETIME=[09C96730:01CB2E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW breakpoints events stopped working correctly with kgdb
as a result of commit: 018cbffe6819f6f8db20a0a3acd9bab9bfd667e4
(Merge commit 'v2.6.33' into perf/core).

The regression occurred because the behavior changed for setting
NOTIFY_STOP as the return value to the die notifier if the breakpoint
was known to the HW breakpoint API.  Because kgdb is using the HW
breakpoint API to register HW breakpoints slots, it must also now
implement the overflow_handler call back else kgdb does not get to see
the events from the die notifier.

The kgdb_ll_trap function will be changed to be general purpose code
which can allow an easy way to implement the hw_breakpoint API
overflow call back.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Dongdong Deng <dongdong.deng@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kgdb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 4f4af75..4030ce5 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -572,10 +572,10 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 	return NOTIFY_STOP;
 }
 
-#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 int kgdb_ll_trap(int cmd, const char *str,
 		 struct pt_regs *regs, long err, int trap, int sig)
 {
+	unsigned long flags;
 	struct die_args args = {
 		.regs	= regs,
 		.str	= str,
@@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
 	if (!kgdb_io_module_registered)
 		return NOTIFY_DONE;
 
+	local_irq_save(flags);
 	return __kgdb_notify(&args, cmd);
+	local_irq_restore(flags);
 }
-#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
 static int
 kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
@@ -625,6 +626,12 @@ int kgdb_arch_init(void)
 	return register_die_notifier(&kgdb_notifier);
 }
 
+static void kgdb_hw_overflow_handler(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs)
+{
+	kgdb_ll_trap(DIE_DEBUG, "debug", regs, 0, 0, SIGTRAP);
+}
+
 void kgdb_arch_late(void)
 {
 	int i, cpu;
@@ -655,6 +662,7 @@ void kgdb_arch_late(void)
 		for_each_online_cpu(cpu) {
 			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
 			pevent[0]->hw.sample_period = 1;
+			pevent[0]->overflow_handler = kgdb_hw_overflow_handler;
 			if (pevent[0]->destroy != NULL) {
 				pevent[0]->destroy = NULL;
 				release_bp_slot(*pevent);
-- 
1.6.4.rc1

