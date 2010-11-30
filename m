Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0K3W17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:27:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0K3W15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:27:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/9] x86: only call smp_processor_id in non-preempt cases
Date: Tue, 30 Nov 2010 17:27:27 -0500
Message-Id: <1291156050-4482-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some paths that walk the die_chain with preemption on.
Make sure we are in an NMI call before we start doing anything.

This was triggered by do_general_protection calling notify_die with
DIE_GPF.

Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 82bff25..ddb29bf 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -59,7 +59,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int cpu = smp_processor_id();
+	int cpu;
 
 	switch (cmd) {
 	case DIE_NMI:
@@ -70,6 +70,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	}
 
 	regs = args->regs;
+	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
-- 
1.7.3.2

