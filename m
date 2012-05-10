Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab2EJRoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:44:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760532Ab2EJRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:45 -0400
Message-Id: <20120510173134.514349257@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Colin Cross <ccross@android.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 18/52] ARM: 7414/1: SMP: prevent use of the console when using idmap_pgd
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit fde165b2a29673aabf18ceff14dea1f1cfb0daad upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -255,8 +255,6 @@ asmlinkage void __cpuinit secondary_star
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu = smp_processor_id();
 
-	printk("CPU%u: Booted secondary processor\n", cpu);
-
 	/*
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
@@ -268,6 +266,8 @@ asmlinkage void __cpuinit secondary_star
 	enter_lazy_tlb(mm, current);
 	local_flush_tlb_all();
 
+	printk("CPU%u: Booted secondary processor\n", cpu);
+
 	cpu_init();
 	preempt_disable();
 	trace_hardirqs_off();


