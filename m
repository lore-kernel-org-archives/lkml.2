Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2KQAuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:50:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2KQAuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:50:10 -0500
Date: Fri, 16 Nov 2012 16:49:36 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-fb50b020c5331c8c4bee0eb875865f5f8be6c03a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, daniel@numascale-asia.com
In-Reply-To: <20121116215244.8521.31505.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215244.8521.31505.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Move some contents of page_64_types.h into pgtable_64.h and page_64.h
Git-Commit-ID: fb50b020c5331c8c4bee0eb875865f5f8be6c03a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:50:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb50b020c5331c8c4bee0eb875865f5f8be6c03a
Gitweb:     http://git.kernel.org/tip/fb50b020c5331c8c4bee0eb875865f5f8be6c03a
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:53:09 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 16:40:34 -0800

x86: Move some contents of page_64_types.h into pgtable_64.h and page_64.h

This patch is meant to clean-up the fact that we have several functions in
page_64_types.h which really don't belong there.  I found this issue when I
had tried to replace __phys_addr with an inline function.  It resulted in the
realmode bits generating compile warnings about types.  In order to resolve
that I am relocating the address translation to page_64.h since this is in
keeping with where these functions are located in 32 bit.

In addtion I have relocated several functions defined in init_64.c to
pgtable_64.h as this seems to be where most of the functions related to
memory initialization were already located.

[ hpa: added missing #include <asm/pgtable.h> to apic_numachip.c,
  as reported by Yinghai Lu. ]

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215244.8521.31505.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/page_64.h       | 19 +++++++++++++++++++
 arch/x86/include/asm/page_64_types.h | 22 ----------------------
 arch/x86/include/asm/pgtable_64.h    |  5 +++++
 arch/x86/kernel/apic/apic_numachip.c |  1 +
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 072694e..4150999 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -3,4 +3,23 @@
 
 #include <asm/page_64_types.h>
 
+#ifndef __ASSEMBLY__
+
+/* duplicated to the one in bootmem.h */
+extern unsigned long max_pfn;
+extern unsigned long phys_base;
+
+extern unsigned long __phys_addr(unsigned long);
+
+#define __phys_reloc_hide(x)	(x)
+
+#ifdef CONFIG_FLATMEM
+#define pfn_valid(pfn)          ((pfn) < max_pfn)
+#endif
+
+void clear_page(void *page);
+void copy_page(void *to, void *from);
+
+#endif	/* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_PAGE_64_H */
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 320f7bb..8b491e6 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -50,26 +50,4 @@
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
 #define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
-#ifndef __ASSEMBLY__
-void clear_page(void *page);
-void copy_page(void *to, void *from);
-
-/* duplicated to the one in bootmem.h */
-extern unsigned long max_pfn;
-extern unsigned long phys_base;
-
-extern unsigned long __phys_addr(unsigned long);
-#define __phys_reloc_hide(x)	(x)
-
-#define vmemmap ((struct page *)VMEMMAP_START)
-
-extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
-extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
-
-#endif	/* !__ASSEMBLY__ */
-
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)          ((pfn) < max_pfn)
-#endif
-
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 47356f9..b5d30ad 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -183,6 +183,11 @@ extern void cleanup_highmap(void);
 
 #define __HAVE_ARCH_PTE_SAME
 
+#define vmemmap ((struct page *)VMEMMAP_START)
+
+extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
+extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_64_H */
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index a65829a..ae9196f 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -27,6 +27,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/apic_flat_64.h>
+#include <asm/pgtable.h>
 
 static int numachip_system __read_mostly;
 
