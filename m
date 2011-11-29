Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1K2MW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:22:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52445 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1K2MWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:51 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 5/6] ARM: Remove current_mm per-cpu variable
Date: Tue, 29 Nov 2011 12:22:31 +0000
Message-Id: <1322569352-23584-6-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 29 Nov 2011 12:22:40.0191 (UTC) FILETIME=[964B4CF0:01CCAE91]
X-MC-Unique: 111112912224803601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pATCNChX007578

The current_mm variable was used to store the new mm between the
switch_mm() and switch_to() calls where an IPI to reset the context
could have set the wrong mm. Since the interrupts are disabled during
context switch, there is no need for this variable, current->active_mm
already points to the current mm when interrupts are re-enabled.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/mmu_context.h |    7 -------
 arch/arm/mm/context.c              |   12 +-----------
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 3e4b219..56710d8 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -42,9 +42,6 @@ void __check_kvm_seq(struct mm_struct *mm);
 #define ASID_FIRST_VERSION	(1 << ASID_BITS)
 
 extern unsigned int cpu_last_asid;
-#ifdef CONFIG_SMP
-DECLARE_PER_CPU(struct mm_struct *, current_mm);
-#endif
 
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 void __new_context(struct mm_struct *mm);
@@ -154,10 +151,6 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		__flush_icache_all();
 #endif
 	if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)) || prev != next) {
-#ifdef CONFIG_SMP
-		struct mm_struct **crt_mm = &per_cpu(current_mm, cpu);
-		*crt_mm = next;
-#endif
 		check_and_switch_context(next, tsk);
 		if (cache_is_vivt())
 			cpumask_clear_cpu(cpu, mm_cpumask(prev));
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index d80aef0..cbca8a4 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -18,9 +18,6 @@
 
 static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 unsigned int cpu_last_asid = ASID_FIRST_VERSION;
-#ifdef CONFIG_SMP
-DEFINE_PER_CPU(struct mm_struct *, current_mm);
-#endif
 
 void cpu_set_reserved_ttbr0(void)
 {
@@ -90,14 +87,7 @@ static void reset_context(void *info)
 {
 	unsigned int asid;
 	unsigned int cpu = smp_processor_id();
-	struct mm_struct *mm = per_cpu(current_mm, cpu);
-
-	/*
-	 * Check if a current_mm was set on this CPU as it might still
-	 * be in the early booting stages and using the reserved ASID.
-	 */
-	if (!mm)
-		return;
+	struct mm_struct *mm = current->active_mm;
 
 	smp_rmb();
 	asid = cpu_last_asid + cpu;

