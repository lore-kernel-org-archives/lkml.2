Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2HUB2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:28:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42065 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2HUB1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:27:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,799,1336348800"; 
   d="scan'208";a="14095095"
From: Attilio Rao <attilio.rao@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH 2/5] XEN: Remove the base argument from x86_init.paging.pagetable_setup_start PVOPS
Date: Tue, 21 Aug 2012 02:14:03 +0100
Message-ID: <1345511646-12427-3-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_init.paging.pagetable_setup_start for native will however use
swapper_pg_dir in the single place where it is used and for native the
argument is simply unused. Aditionally, the comments already point to
swapper_pg_dir as the sole base touched.
Finally, this will help with further merging of
x86_init.paging.pagetable_setup_start with
x86_init.paging.pagetable_setup_done PVOPS.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    6 +++---
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/setup.c              |    2 +-
 arch/x86/kernel/x86_init.c           |    3 +--
 arch/x86/mm/init_32.c                |    5 ++++-
 arch/x86/xen/mmu.c                   |    2 +-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index f9e07b0..9b1c1f7 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -303,11 +303,11 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
-extern void native_pagetable_setup_start(pgd_t *base);
+extern void native_pagetable_setup_start(void);
 extern void native_pagetable_setup_done(void);
 #else
-#define native_pagetable_setup_start x86_init_pgd_start_noop
-#define native_pagetable_setup_done  x86_init_pgd_stop_noop
+#define native_pagetable_setup_start x86_init_pgd_noop
+#define native_pagetable_setup_done  x86_init_pgd_noop
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 439a4c3..efd0075 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -85,7 +85,7 @@ struct x86_init_mapping {
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
-	void (*pagetable_setup_start)(pgd_t *base);
+	void (*pagetable_setup_start)(void);
 	void (*pagetable_setup_done)(void);
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ed9094d..d3d8f00 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -961,7 +961,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	x86_init.paging.pagetable_setup_start(swapper_pg_dir);
+	x86_init.paging.pagetable_setup_start();
 	paging_init();
 	x86_init.paging.pagetable_setup_done();
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index b27b30d..849be14 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,8 +26,7 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_start_noop(pgd_t *unused) { }
-void __init x86_init_pgd_stop_noop(void) { }
+void __init x86_init_pgd_noop(void) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 1019156..7999cef 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -445,14 +445,17 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
 }
 #endif /* CONFIG_HIGHMEM */
 
-void __init native_pagetable_setup_start(pgd_t *base)
+void __init native_pagetable_setup_start(void)
 {
 	unsigned long pfn, va;
+	pgd_t *base;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
+	base = swapper_pg_dir;
+
 	/*
 	 * Remove any mappings which extend past the end of physical
 	 * memory from the boot time page table:
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d847548..04a0a8f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,7 +1174,7 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
-static void __init xen_pagetable_setup_start(pgd_t *base)
+static void __init xen_pagetable_setup_start(void)
 {
 }
 
-- 
1.7.2.5

