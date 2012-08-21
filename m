Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2HUUhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:37:48 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48117 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab2HUUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113786"
From: Attilio Rao <attilio.rao@citrix.com>
To: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 3/5] X86/XEN: Allow setup function x86_init.paging.pagetable_init to setup kernel pagetables
Date: Tue, 21 Aug 2012 21:22:39 +0100
Message-ID: <1345580561-8506-4-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, x86_init.paging.pagetable_init relies on callers to setup the
kernel pagetable.  In order to unify the functionality of
x86_init.paging.pagetable_setup_start and x86_init.paging.pagetable_setup_done
allow the new setup function to perform the operation itself.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    2 +-
 arch/x86/kernel/setup.c              |    1 -
 arch/x86/kernel/x86_init.c           |    1 -
 arch/x86/mm/init_32.c                |    1 +
 arch/x86/xen/mmu.c                   |    1 +
 5 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 0c01e07..c93cb8e 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -306,7 +306,7 @@ extern void native_pagetable_reserve(u64 start, u64 end);
 extern void native_pagetable_init(void);
 extern void native_pagetable_setup_done(pgd_t *base);
 #else
-#define native_pagetable_init        x86_init_pgd_init_noop
+#define native_pagetable_init        paging_init
 #define native_pagetable_setup_done  x86_init_pgd_done_noop
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 61b7d98..315fd24 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -962,7 +962,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	x86_init.paging.pagetable_init();
-	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
 	if (boot_cpu_data.cpuid_level >= 0) {
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 0e1e950..5f2478f 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,6 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_init_noop(void) { }
 void __init x86_init_pgd_done_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0e38e0e..e35b4b1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -475,6 +475,7 @@ void __init native_pagetable_init(void)
 		pte_clear(NULL, va, pte);
 	}
 	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
+	paging_init();
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ff1af97..4f47b87 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1176,6 +1176,7 @@ static void xen_exit_mmap(struct mm_struct *mm)
 
 static void __init xen_pagetable_init(void)
 {
+	paging_init();
 }
 
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
-- 
1.7.2.5

