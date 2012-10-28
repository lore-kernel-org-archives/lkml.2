Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2J1XjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:39:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799Ab2J1X1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:49 -0400
Message-Id: <20121028231557.021233710@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>, David McKay <david.mckay@st.com>,
        Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 065/105] ARM: 7559/1: smp: switch away from the idmap before updating
 init_mm.mm_count
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/smp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8e20754d..fbc8b26 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -294,18 +294,24 @@ static void percpu_timer_setup(void);
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
 


