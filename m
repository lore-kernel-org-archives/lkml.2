Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1E0RjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:39:15 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54167 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1E0RjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:39:03 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-5d-4ddfe178c3d4
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/5] x86-64: Give vvars their own page
Date: Fri, 27 May 2011 13:38:39 -0400
Message-Id: <80895427afdff1cb56c7f02d567f92ce2e1fa9d8.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42IR4hRV1q14eN/X4PUcCYu+K0fZLS7vmsNm
	seVSM6vF5k1TmS1+bHjM6sDqcavtD7PHzll32T02repk83h37hy7x+dNcgGsUVw2Kak5mWWp
	Rfp2CVwZ87/YFPSuYqx4cfwWewPjjbmMXYycHBICJhIrz75khrDFJC7cW8/WxcjFISSwj1Gi
	79YHZghnA6PEtr8n2SGcZ0wSE3rOg7WwCahIdCx9wARiiwjESTTM/s0KYjMLOEjcfnwEbIWw
	gJnE2n3vwGpYBFQl5qzYAmbzCgRJXO8+yAqxWkHiypV5LCA2p4CBxPW/O9hBbCEBfYnvF9ex
	4RKfwCiwgJFhFaNsSm6Vbm5iZk5xarJucXJiXl5qka6RXm5miV5qSukmRnB4SvLuYHx3UOkQ
	owAHoxIPr8XB+75CrIllxZW5hxglOZiURHn9HgCF+JLyUyozEosz4otKc1KLDzFKcDArifCa
	7AfK8aYkVlalFuXDpKQ5WJTEeWdKqvsKCaQnlqRmp6YWpBbBZHU4OATO3n7LLdAy+2+4FEte
	fl6qkgTvbJAlgkWp6akVaZk5JQjlTBycIMt4gJZNA6nhLS5IzC3OTIfIn2I05pi7cetBRo7G
	tTsOMgqBjZMS5y0CKRUAKc0ozYObBktBrxjFgZ4V5u0HqeIBpi+4ea+AVjEBrdL5fRdkVUki
	QkqqgVH6of3m3GK9eTxiXzUtvvVPz1HyuLJAdHuqyYal87hD1IXSZ9zdx5jjvfnTtNOH8w6b
	dCq4eOv7bGC4/LGDS/io1eZTa3/l9O0XutfyLL/RQGPSwqfRWb02Tzfulvtv82RixKz87U9l
	PFfu3qSx2fNb6oa4RK/t7NHBD0VlN4T/mPJCdY1w3SwlluKMREMt5qLiRABlMCUUHAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move vvars out of the vsyscall page into their own page and mark it
NX.

Without this patch, an attacker who can force a daemon to call some
fixed address could wait until the time contains, say, 0xCD80, and
then execute the current time.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/fixmap.h        |    1 +
 arch/x86/include/asm/pgtable_types.h |    2 ++
 arch/x86/include/asm/vvar.h          |   22 ++++++++++------------
 arch/x86/kernel/vmlinux.lds.S        |   27 ++++++++++++++++-----------
 arch/x86/kernel/vsyscall_64.c        |    5 +++++
 tools/power/x86/turbostat/turbostat  |  Bin 0 -> 29200 bytes
 6 files changed, 34 insertions(+), 23 deletions(-)
 create mode 100755 tools/power/x86/turbostat/turbostat

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4729b2b..460c74e 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -78,6 +78,7 @@ enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+	VVAR_PAGE,
 	VSYSCALL_HPET,
 #endif
 	FIX_DBGP_BASE,
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index d56187c..6a29aed6 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -108,6 +108,7 @@
 #define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -130,6 +131,7 @@
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
 
 #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index a4eaca4..de656ac 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -10,15 +10,14 @@
  * In normal kernel code, they are used like any other variable.
  * In user code, they are accessed through the VVAR macro.
  *
- * Each of these variables lives in the vsyscall page, and each
- * one needs a unique offset within the little piece of the page
- * reserved for vvars.  Specify that offset in DECLARE_VVAR.
- * (There are 896 bytes available.  If you mess up, the linker will
- * catch it.)
+ * These variables live in a page of kernel data that has an extra RO
+ * mapping for userspace.  Each variable needs a unique offset within
+ * that page; specify that offset with the DECLARE_VVAR macro.  (If
+ * you mess up, the linker will catch it.)
  */
 
-/* Offset of vars within vsyscall page */
-#define VSYSCALL_VARS_OFFSET (3072 + 128)
+/* Base address of vvars.  This is not ABI. */
+#define VVAR_ADDRESS (-10*1024*1024 - 4096)
 
 #if defined(__VVAR_KERNEL_LDS)
 
@@ -26,17 +25,17 @@
  * right place.
  */
 #define DECLARE_VVAR(offset, type, name) \
-	EMIT_VVAR(name, VSYSCALL_VARS_OFFSET + offset)
+	EMIT_VVAR(name, offset)
 
 #else
 
 #define DECLARE_VVAR(offset, type, name)				\
 	static type const * const vvaraddr_ ## name =			\
-		(void *)(VSYSCALL_START + VSYSCALL_VARS_OFFSET + (offset));
+		(void *)(VVAR_ADDRESS + (offset));
 
 #define DEFINE_VVAR(type, name)						\
-	type __vvar_ ## name						\
-	__attribute__((section(".vsyscall_var_" #name), aligned(16)))
+	type name							\
+	__attribute__((section(".vvar_" #name), aligned(16)))
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
@@ -49,4 +48,3 @@ DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-#undef VSYSCALL_VARS_OFFSET
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1432bd4..3c1ec1c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -161,12 +161,6 @@ SECTIONS
 
 #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-#define EMIT_VVAR(x, offset) .vsyscall_var_ ## x	\
-	ADDR(.vsyscall_0) + offset		 	\
-	: AT(VLOAD(.vsyscall_var_ ## x)) {     		\
-		*(.vsyscall_var_ ## x)			\
-	}						\
-	x = VVIRT(.vsyscall_var_ ## x);
 
 	. = ALIGN(4096);
 	__vsyscall_0 = .;
@@ -192,17 +186,28 @@ SECTIONS
 		*(.vsyscall_3)
 	}
 
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-
-	. = __vsyscall_0 + PAGE_SIZE;
+	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
 #undef VLOAD_OFFSET
 #undef VLOAD
 #undef VVIRT_OFFSET
 #undef VVIRT
+
+	__vvar_page = .;
+
+#define EMIT_VVAR(name, offset) .vvar_ ## name		\
+	(__vvar_page + offset) :			\
+	 AT(ADDR(.vvar_ ## name) - LOAD_OFFSET) {	\
+		*(.vvar_ ## x)				\
+	} :data
+
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+
+       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+
 #undef EMIT_VVAR
 
 #endif /* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 5f6ad03..ee22180 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -284,9 +284,14 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_0;
 	unsigned long physaddr_page0 = __pa_symbol(&__vsyscall_0);
+	extern char __vvar_page;
+	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
 	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
+	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
+		     (unsigned long)VVAR_ADDRESS);
 }
 
 static int __init vsyscall_init(void)
diff --git a/tools/power/x86/turbostat/turbostat b/tools/power/x86/turbostat/turbostat
new file mode 100755
index 0000000000000000000000000000000000000000..97aabd2a0c77eed562f15bc5285911a4db3fa763
GIT binary patch
literal 29200
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
PR9hPfMD=Q;NB{o@pOHv+

literal 0
HcmV?d00001

-- 
1.7.5.1

