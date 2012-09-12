Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab2ILNs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2ILNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:48:49 -0400
Date: Wed, 12 Sep 2012 06:48:29 -0700
From: tip-bot for Attilio Rao <attilio.rao@citrix.com>
Message-ID: <tip-843b8ed2ec598aae5e3516b21957ede62a070e36@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
In-Reply-To: <1345580561-8506-4-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-4-git-send-email-attilio.rao@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Move paging_init() call to x86_init.paging
 .pagetable_init()
Git-Commit-ID: 843b8ed2ec598aae5e3516b21957ede62a070e36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 12 Sep 2012 06:48:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  843b8ed2ec598aae5e3516b21957ede62a070e36
Gitweb:     http://git.kernel.org/tip/843b8ed2ec598aae5e3516b21957ede62a070e36
Author:     Attilio Rao <attilio.rao@citrix.com>
AuthorDate: Tue, 21 Aug 2012 21:22:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Sep 2012 15:33:06 +0200

x86: Move paging_init() call to x86_init.paging.pagetable_init()

Move the paging_init() call to the platform specific pagetable_init()
function, so we can get rid of the extra pagetable_setup_done()
function pointer.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Acked-by: <konrad.wilk@oracle.com>
Cc: <Ian.Campbell@citrix.com>
Cc: <Stefano.Stabellini@eu.citrix.com>
Cc: <xen-devel@lists.xensource.com>
Link: http://lkml.kernel.org/r/1345580561-8506-4-git-send-email-attilio.rao@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
index 624efbe..c2ff7ea 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1176,6 +1176,7 @@ static void xen_exit_mmap(struct mm_struct *mm)
 
 static void __init xen_pagetable_init(void)
 {
+	paging_init();
 }
 
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
