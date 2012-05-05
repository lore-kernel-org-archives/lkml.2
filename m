Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2EEBON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:14:13 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46814 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2EEBOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:14:11 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: SMP: prevent use of the console when using idmap_pgd
Date: Fri,  4 May 2012 18:14:02 -0700
Message-Id: <1336180444-26563-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4e8ee7de227e3ab9a72040b448ad728c5428a042 (ARM: SMP: use
idmap_pgd for mapping MMU enable during secondary booting)
switched secondary boot to use idmap_pgd, which is initialized
during early_initcall, instead of a page table initialized during
__cpu_up.  This causes idmap_pgd to contain the static mappings
but be missing all dynamic mappings.

If a console is registered that creates a dynamic mapping, the
printk in secondary_start_kernel will trigger a data abort on
the missing mapping before the exception handlers have been
initialized, leading to a hang.  Initial boot is not affected
because no consoles have been registered, and resume is usually
not affected because the offending console is suspended.
Onlining a cpu with hotplug triggers the problem.

A workaround is to the printk in secondary_start_kernel until
after the page tables have been switched back to init_mm.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/kernel/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index addbbe8..aa98928 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -251,8 +251,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu = smp_processor_id();
 
-	printk("CPU%u: Booted secondary processor\n", cpu);
-
 	/*
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
@@ -264,6 +262,8 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	enter_lazy_tlb(mm, current);
 	local_flush_tlb_all();
 
+	printk("CPU%u: Booted secondary processor\n", cpu);
+
 	cpu_init();
 	preempt_disable();
 	trace_hardirqs_off();
-- 
1.7.7.3

