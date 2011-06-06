Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1FFIc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:32:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:34294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab1FFIcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:32:54 -0400
Date: Mon, 6 Jun 2011 08:32:08 GMT
From: tip-bot for Andy Lutomirski <luto@MIT.EDU>
Message-ID: <tip-9fd67b4ed0714ab718f1f9bd14c344af336a6df7@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        luto@MIT.EDU, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, luto@MIT.EDU,
        Louis.Rilling@kerlabs.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
In-Reply-To: <b1460f81dc4463d66ea3f2b5ce240f58d48effec.1307292171.git.luto@mit.edu>
References: <b1460f81dc4463d66ea3f2b5ce240f58d48effec.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Give vvars their own page
Git-Commit-ID: 9fd67b4ed0714ab718f1f9bd14c344af336a6df7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:32:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fd67b4ed0714ab718f1f9bd14c344af336a6df7
Gitweb:     http://git.kernel.org/tip/9fd67b4ed0714ab718f1f9bd14c344af336a6df7
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Sun, 5 Jun 2011 13:50:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jun 2011 21:30:32 +0200

x86-64: Give vvars their own page

Move vvars out of the vsyscall page into their own page and mark
it NX.

Without this patch, an attacker who can force a daemon to call
some fixed address could wait until the time contains, say,
0xCD80, and then execute the current time.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/b1460f81dc4463d66ea3f2b5ce240f58d48effec.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/fixmap.h        |    1 +
 arch/x86/include/asm/pgtable_types.h |    2 ++
 arch/x86/include/asm/vvar.h          |   22 ++++++++++------------
 arch/x86/kernel/vmlinux.lds.S        |   28 +++++++++++++++++-----------
 arch/x86/kernel/vsyscall_64.c        |    5 +++++
 5 files changed, 35 insertions(+), 23 deletions(-)

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
index 89aed99..98b378d 100644
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
@@ -192,19 +186,31 @@ SECTIONS
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
+	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+
+	      /* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 		\
+		. = offset;		\
+		*(.vvar_ ## name)
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
+	} :data
+
+       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+
 #endif /* CONFIG_X86_64 */
 
 	/* Init code and data - will be freed after init */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e68218..3cf1cef 100644
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
