Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab2KZRMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab2KZRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David McKay <david.mckay@st.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 201/270] ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count
Date: Mon, 26 Nov 2012 14:58:11 -0200
Message-Id: <1353949160-26803-202-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 5f40b909728ad784eb43aa309d3c4e9bdf050781 upstream.

When booting a secondary CPU, the primary CPU hands two sets of page
tables via the secondary_data struct:

	(1) swapper_pg_dir: a normal, cacheable, shared (if SMP) mapping
	    of the kernel image (i.e. the tables used by init_mm).

	(2) idmap_pgd: an uncached mapping of the .idmap.text ELF
	    section.

The idmap is generally used when enabling and disabling the MMU, which
includes early CPU boot. In this case, the secondary CPU switches to
swapper as soon as it enters C code:

	struct mm_struct *mm = &init_mm;
	unsigned int cpu = smp_processor_id();

	/*
	 * All kernel threads share the same mm context; grab a
	 * reference and switch to it.
	 */
	atomic_inc(&mm->mm_count);
	current->active_mm = mm;
	cpumask_set_cpu(cpu, mm_cpumask(mm));
	cpu_switch_mm(mm->pgd, mm);

This causes a problem on ARMv7, where the identity mapping is treated as
strongly-ordered leading to architecturally UNPREDICTABLE behaviour of
exclusive accesses, such as those used by atomic_inc.

This patch re-orders the secondary_start_kernel function so that we
switch to swapper before performing any exclusive accesses.

Cc: David McKay <david.mckay@st.com>
Reported-by: Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/kernel/smp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ea73045..dbde2b9 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -222,18 +222,24 @@ static void percpu_timer_setup(void);
 asmlinkage void __cpuinit secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu;
+
+	/*
+	 * The identity mapping is uncached (strongly ordered), so
+	 * switch away from it before attempting any exclusive accesses.
+	 */
+	cpu_switch_mm(mm->pgd, mm);
+	enter_lazy_tlb(mm, current);
+	local_flush_tlb_all();
 
 	/*
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
 	 */
+	cpu = smp_processor_id();
 	atomic_inc(&mm->mm_count);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
-	cpu_switch_mm(mm->pgd, mm);
-	enter_lazy_tlb(mm, current);
-	local_flush_tlb_all();
 
 	printk("CPU%u: Booted secondary processor\n", cpu);
 
-- 
1.7.9.5

