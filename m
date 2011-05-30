Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1E3Dt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:26 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:45295 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1E3DtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:25 -0400
X-AuditID: 1209190c-b7c65ae00000117c-4c-4de313cc1064
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 02/10] x86-64: Give vvars their own page
Date: Sun, 29 May 2011 23:48:39 -0400
Message-Id: <dfa611c9ca15b143d59969fabf997f78e2d2addd.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsUixG6nrntG+LGvwfFbrBZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJWx4u5x1oK9BhXXznYwNzB+U+9i5OSQEDCRWL9mKQuE
	LSZx4d56ti5GLg4hgX2MEouuHGaHcDYwSqzdM5EJwnnGJLFyxV2wFjYBFYmOpQ+AEhwcIgL6
	Elc/M4LUMAs8Z5Z48HAXK0iNsIC1xJ6u6WD1LAKqEufePWEDsXkFgiRmXfnPBLFaQeLKlXlg
	NZwCBhIn79wDs4WAZs679ZYNl/gERoEFjAyrGGVTcqt0cxMzc4pTk3WLkxPz8lKLdA31cjNL
	9FJTSjcxgmKEU5JnB+Obg0qHGAU4GJV4eI2LHvkKsSaWFVfmHmKU5GBSEuV9JPjYV4gvKT+l
	MiOxOCO+qDQntfgQowQHs5IIr/ovoHLelMTKqtSifJiUNAeLkjjvDEl1XyGB9MSS1OzU1ILU
	IpisDgeHwNnbb7kFWmb/DZdiycvPS1WS4A0DpgohwaLU9NSKtMycEoRyJg5OkGU8QMv0QQ7h
	LS5IzC3OTIfIn2I05pi7cetBRo7GtTsOMgqBjZMS57UBGScAUppRmgc3DZYGXzGKAz0rzHtF
	CKiKB5hC4ea9AlrFBLSq991DkFUliQgpqQbGruSwC2kpyqHVCx/GrGbj8V1UrLx4xy8Bj0jR
	AEbbT7c/C/NzSioc1nRnEZDKmaKxJ3Kb7OVpzhv0v3HslXqygE24RzrqgqPQqbNvXjkf9PNk
	PjHx++WqmLZlX/KfszbETeS8lpD+xuMlX7mtUPEH7g8rFpW/39xp/PVrkObW2Kw/QfdelbxT
	YinOSDTUYi4qTgQAep9jz14DAAA=
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
 5 files changed, 34 insertions(+), 23 deletions(-)

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
-- 
1.7.5.1

