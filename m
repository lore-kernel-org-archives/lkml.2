Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2ILNrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:47:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2ILNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:47:10 -0400
Date: Wed, 12 Sep 2012 06:46:38 -0700
From: tip-bot for Attilio Rao <attilio.rao@citrix.com>
Message-ID: <tip-73090f8993a40a2f67fed1ab866a928c68cd3765@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
In-Reply-To: <1345580561-8506-2-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-2-git-send-email-attilio.rao@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Remove base argument from x86_init.paging.
 pagetable_setup_start
Git-Commit-ID: 73090f8993a40a2f67fed1ab866a928c68cd3765
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 12 Sep 2012 06:46:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73090f8993a40a2f67fed1ab866a928c68cd3765
Gitweb:     http://git.kernel.org/tip/73090f8993a40a2f67fed1ab866a928c68cd3765
Author:     Attilio Rao <attilio.rao@citrix.com>
AuthorDate: Tue, 21 Aug 2012 21:22:37 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Sep 2012 15:33:06 +0200

x86: Remove base argument from x86_init.paging.pagetable_setup_start

We either use swapper_pg_dir or the argument is unused. Preparatory
patch to simplify platform pagetable setup further.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Ackedb-by: <konrad.wilk@oracle.com>
Cc: <Ian.Campbell@citrix.com>
Cc: <Stefano.Stabellini@eu.citrix.com>
Cc: <xen-devel@lists.xensource.com>
Link: http://lkml.kernel.org/r/1345580561-8506-2-git-send-email-attilio.rao@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
index 5141d80..32e66c8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,7 +1174,7 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
-static void __init xen_pagetable_setup_start(pgd_t *base)
+static void __init xen_pagetable_setup_start(void)
 {
 }
 
