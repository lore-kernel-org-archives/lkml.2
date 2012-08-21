Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2HUUiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:38:46 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48117 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab2HUUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:15 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113784"
From: Attilio Rao <attilio.rao@citrix.com>
To: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 1/5] X86/XEN: Remove the base argument from x86_init.paging.pagetable_setup_start
Date: Tue, 21 Aug 2012 21:22:37 +0100
Message-ID: <1345580561-8506-2-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
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
x86_init.paging.pagetable_setup_done.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    6 +++---
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/setup.c              |    2 +-
 arch/x86/kernel/x86_init.c           |    3 ++-
 arch/x86/mm/init_32.c                |    4 ++--
 arch/x86/xen/mmu.c                   |    2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..e02b875 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -303,11 +303,11 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
-extern void native_pagetable_setup_start(pgd_t *base);
+extern void native_pagetable_setup_start(void);
 extern void native_pagetable_setup_done(pgd_t *base);
 #else
-#define native_pagetable_setup_start x86_init_pgd_noop
-#define native_pagetable_setup_done  x86_init_pgd_noop
+#define native_pagetable_setup_start x86_init_pgd_start_noop
+#define native_pagetable_setup_done  x86_init_pgd_done_noop
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..782ba0c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -85,7 +85,7 @@ struct x86_init_mapping {
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
-	void (*pagetable_setup_start)(pgd_t *base);
+	void (*pagetable_setup_start)(void);
 	void (*pagetable_setup_done)(pgd_t *base);
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..90cbbe0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -961,7 +961,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	x86_init.paging.pagetable_setup_start(swapper_pg_dir);
+	x86_init.paging.pagetable_setup_start();
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9f3167e..3b88493 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,8 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_noop(pgd_t *unused) { }
+void __init x86_init_pgd_start_noop(void) { }
+void __init x86_init_pgd_done_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..c4aa1b2 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -445,10 +445,10 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
 }
 #endif /* CONFIG_HIGHMEM */
 
-void __init native_pagetable_setup_start(pgd_t *base)
+void __init native_pagetable_setup_start(void)
 {
 	unsigned long pfn, va;
-	pgd_t *pgd;
+	pgd_t *pgd, *base = swapper_pg_dir;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..d89ea5c 100644
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

