Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2HUB1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:27:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42065 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2HUB13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:27:29 -0400
X-IronPort-AV: E=Sophos;i="4.77,799,1336348800"; 
   d="scan'208";a="14095094"
From: Attilio Rao <attilio.rao@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH 1/5] XEN: Remove the base argument from x86_init.paging.pagetable_setup_done PVOPS
Date: Tue, 21 Aug 2012 02:14:02 +0100
Message-ID: <1345511646-12427-2-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_init.paging.pagetable_setup_done PVOPS does not really need to know about
the base argument, thus just remove it.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    6 +++---
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/setup.c              |    2 +-
 arch/x86/kernel/x86_init.c           |    3 ++-
 arch/x86/mm/init_32.c                |    2 +-
 arch/x86/xen/mmu.c                   |    2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..f9e07b0 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -304,10 +304,10 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
-extern void native_pagetable_setup_done(pgd_t *base);
+extern void native_pagetable_setup_done(void);
 #else
-#define native_pagetable_setup_start x86_init_pgd_noop
-#define native_pagetable_setup_done  x86_init_pgd_noop
+#define native_pagetable_setup_start x86_init_pgd_start_noop
+#define native_pagetable_setup_done  x86_init_pgd_stop_noop
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..439a4c3 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -86,7 +86,7 @@ struct x86_init_mapping {
  */
 struct x86_init_paging {
 	void (*pagetable_setup_start)(pgd_t *base);
-	void (*pagetable_setup_done)(pgd_t *base);
+	void (*pagetable_setup_done)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..ed9094d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -963,7 +963,7 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.paging.pagetable_setup_start(swapper_pg_dir);
 	paging_init();
-	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
+	x86_init.paging.pagetable_setup_done();
 
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9f3167e..b27b30d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,8 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_noop(pgd_t *unused) { }
+void __init x86_init_pgd_start_noop(pgd_t *unused) { }
+void __init x86_init_pgd_stop_noop(void) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..1019156 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -477,7 +477,7 @@ void __init native_pagetable_setup_start(pgd_t *base)
 	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
 }
 
-void __init native_pagetable_setup_done(pgd_t *base)
+void __init native_pagetable_setup_done(void)
 {
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..d847548 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1194,7 +1194,7 @@ static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 
 static void xen_post_allocator_init(void);
 
-static void __init xen_pagetable_setup_done(pgd_t *base)
+static void __init xen_pagetable_setup_done(void)
 {
 	xen_setup_shared_info();
 	xen_post_allocator_init();
-- 
1.7.2.5

