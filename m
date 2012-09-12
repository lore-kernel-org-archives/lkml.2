Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2ILNtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:49:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2ILNtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:49:46 -0400
Date: Wed, 12 Sep 2012 06:49:24 -0700
From: tip-bot for Attilio Rao <attilio.rao@citrix.com>
Message-ID: <tip-c711288727a62f74d48032e56e51333dd104bf58@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
In-Reply-To: <1345580561-8506-5-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-5-git-send-email-attilio.rao@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: xen: Cleanup and remove x86_init.paging.
 pagetable_setup_done()
Git-Commit-ID: c711288727a62f74d48032e56e51333dd104bf58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 12 Sep 2012 06:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c711288727a62f74d48032e56e51333dd104bf58
Gitweb:     http://git.kernel.org/tip/c711288727a62f74d48032e56e51333dd104bf58
Author:     Attilio Rao <attilio.rao@citrix.com>
AuthorDate: Tue, 21 Aug 2012 21:22:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Sep 2012 15:33:06 +0200

x86: xen: Cleanup and remove x86_init.paging.pagetable_setup_done()

At this stage x86_init.paging.pagetable_setup_done is only used in the
XEN case. Move its content in the x86_init.paging.pagetable_init setup
function and remove the now unused x86_init.paging.pagetable_setup_done
remaining infrastructure.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Acked-by: <konrad.wilk@oracle.com>
Cc: <Ian.Campbell@citrix.com>
Cc: <Stefano.Stabellini@eu.citrix.com>
Cc: <xen-devel@lists.xensource.com>
Link: http://lkml.kernel.org/r/1345580561-8506-5-git-send-email-attilio.rao@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
index c2ff7ea..7a769b7 100644
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
