Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602Ab2J2Vyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:54:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:48496 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761528Ab2J2VlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>,
        David McKay <david.mckay@st.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 08/54] ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count
Date: Mon, 29 Oct 2012 14:40:09 -0700
Message-Id: <20121029213803.683365444@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Reported-by: Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>
Cc: David McKay <david.mckay@st.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/smp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -249,18 +249,24 @@ static void percpu_timer_setup(void);
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
 


