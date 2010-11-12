Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0KLOvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:51:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab0KLOvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:51:07 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] x86: only call smp_processor_id in non-preempt cases
Date: Fri, 12 Nov 2010 09:50:53 -0500
Message-Id: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some paths that walk the die_chain with preemption on.
Make sure we are in an NMI call before we start doing anything.

Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 5c4f952..ef4755d 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -49,7 +49,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int cpu = smp_processor_id();
+	int cpu;
 
 	switch (cmd) {
 	case DIE_NMI:
@@ -60,6 +60,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	}
 
 	regs = args->regs;
+	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
-- 
1.7.2.3

