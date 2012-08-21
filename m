Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2HUUhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:37:45 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52115 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2HUUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113787"
From: Attilio Rao <attilio.rao@citrix.com>
To: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 4/5] X86/XEN: Move content of xen_pagetable_setup_done() into xen_pagetable_init() and retire now unused x86_init.paging.pagetable_setup_done
Date: Tue, 21 Aug 2012 21:22:40 +0100
Message-ID: <1345580561-8506-5-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this stage x86_init.paging.pagetable_setup_done is only used in the
XEN case. Move its content in the x86_init.paging.pagetable_init setup
function and remove the now unused x86_init.paging.pagetable_setup_done
remaining infrastructure.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    2 --
 arch/x86/include/asm/x86_init.h      |    2 --
 arch/x86/kernel/setup.c              |    1 -
 arch/x86/kernel/x86_init.c           |    2 --
 arch/x86/mm/init_32.c                |    4 ----
 arch/x86/xen/mmu.c                   |   13 ++++---------
 6 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index c93cb8e..db8fec6 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -304,10 +304,8 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_init(void);
-extern void native_pagetable_setup_done(pgd_t *base);
 #else
 #define native_pagetable_init        paging_init
-#define native_pagetable_setup_done  x86_init_pgd_done_noop
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 24084b2..995ea5c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -82,11 +82,9 @@ struct x86_init_mapping {
 /**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_init:		platform specific paging initialization call
- * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
-	void (*pagetable_setup_done)(pgd_t *base);
 };
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 315fd24..4f16547 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -962,7 +962,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	x86_init.paging.pagetable_init();
-	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 5f2478f..7a3d075 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,6 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_done_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
@@ -69,7 +68,6 @@ struct x86_init_ops x86_init __initdata = {
 
 	.paging = {
 		.pagetable_init		= native_pagetable_init,
-		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
 
 	.timers = {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index e35b4b1..4f04db1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -478,10 +478,6 @@ void __init native_pagetable_init(void)
 	paging_init();
 }
 
-void __init native_pagetable_setup_done(pgd_t *base)
-{
-}
-
 /*
  * Build a proper pagetable for the kernel mappings.  Up until this
  * point, we've been running on some set of pagetables constructed by
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4f47b87..4290d83 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,9 +1174,13 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
+static void xen_post_allocator_init(void);
+
 static void __init xen_pagetable_init(void)
 {
 	paging_init();
+	xen_setup_shared_info();
+	xen_post_allocator_init();
 }
 
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
@@ -1193,14 +1197,6 @@ static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 	}
 }
 
-static void xen_post_allocator_init(void);
-
-static void __init xen_pagetable_setup_done(pgd_t *base)
-{
-	xen_setup_shared_info();
-	xen_post_allocator_init();
-}
-
 static void xen_write_cr2(unsigned long cr2)
 {
 	this_cpu_read(xen_vcpu)->arch.cr2 = cr2;
@@ -2070,7 +2066,6 @@ void __init xen_init_mmu_ops(void)
 {
 	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_init = xen_pagetable_init;
-	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-- 
1.7.2.5

