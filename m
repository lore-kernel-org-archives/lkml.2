Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2HUUib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:38:31 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35462 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab2HUUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113785"
From: Attilio Rao <attilio.rao@citrix.com>
To: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 2/5] X86/XEN: Rename pagetable_setup_start() setup functions into pagetable_init()
Date: Tue, 21 Aug 2012 21:22:38 +0100
Message-ID: <1345580561-8506-3-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for unifying the pagetable_setup_start() and
pagetable_setup_done() setup functions, rename appropriately all the
infrastructure related to pagetable_setup_start().

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    4 ++--
 arch/x86/include/asm/x86_init.h      |    4 ++--
 arch/x86/kernel/setup.c              |    2 +-
 arch/x86/kernel/x86_init.c           |    4 ++--
 arch/x86/mm/init_32.c                |    4 ++--
 arch/x86/xen/mmu.c                   |    4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index e02b875..0c01e07 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -303,10 +303,10 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
-extern void native_pagetable_setup_start(void);
+extern void native_pagetable_init(void);
 extern void native_pagetable_setup_done(pgd_t *base);
 #else
-#define native_pagetable_setup_start x86_init_pgd_start_noop
+#define native_pagetable_init        x86_init_pgd_init_noop
 #define native_pagetable_setup_done  x86_init_pgd_done_noop
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 782ba0c..24084b2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -81,11 +81,11 @@ struct x86_init_mapping {
 
 /**
  * struct x86_init_paging - platform specific paging functions
- * @pagetable_setup_start:	platform specific pre paging_init() call
+ * @pagetable_init:		platform specific paging initialization call
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
-	void (*pagetable_setup_start)(void);
+	void (*pagetable_init)(void);
 	void (*pagetable_setup_done)(pgd_t *base);
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90cbbe0..61b7d98 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -961,7 +961,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	x86_init.paging.pagetable_setup_start();
+	x86_init.paging.pagetable_init();
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 3b88493..0e1e950 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,7 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_start_noop(void) { }
+void __init x86_init_pgd_init_noop(void) { }
 void __init x86_init_pgd_done_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
@@ -69,7 +69,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.paging = {
-		.pagetable_setup_start	= native_pagetable_setup_start,
+		.pagetable_init		= native_pagetable_init,
 		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c4aa1b2..0e38e0e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -445,7 +445,7 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
 }
 #endif /* CONFIG_HIGHMEM */
 
-void __init native_pagetable_setup_start(void)
+void __init native_pagetable_init(void)
 {
 	unsigned long pfn, va;
 	pgd_t *pgd, *base = swapper_pg_dir;
@@ -493,7 +493,7 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * If we're booting paravirtualized under a hypervisor, then there are
  * more options: we may already be running PAE, and the pagetable may
  * or may not be based in swapper_pg_dir.  In any case,
- * paravirt_pagetable_setup_start() will set up swapper_pg_dir
+ * paravirt_pagetable_init() will set up swapper_pg_dir
  * appropriately for the rest of the initialization to work.
  *
  * In general, pagetable_init() assumes that the pagetable may already
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d89ea5c..ff1af97 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,7 +1174,7 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
-static void __init xen_pagetable_setup_start(void)
+static void __init xen_pagetable_init(void)
 {
 }
 
@@ -2068,7 +2068,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 void __init xen_init_mmu_ops(void)
 {
 	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
-	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
+	x86_init.paging.pagetable_init = xen_pagetable_init;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
 
-- 
1.7.2.5

