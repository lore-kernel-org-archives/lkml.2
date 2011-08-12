Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1HNQOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:14:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab1HNQJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.163506664@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [69/90] sparc: Use popc if possible for hweight routines.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit ef7c4d4675d2a9206f913f26ca1a5cd41bff9d41 ]

Just like powerpc, we code patch at boot time.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/bitops_64.h |   42 ++----------------------------
 arch/sparc/kernel/entry.h          |    7 +++++
 arch/sparc/kernel/setup_64.c       |   27 +++++++++++++++++++
 arch/sparc/kernel/sparc_ksyms_64.c |    7 +++++
 arch/sparc/kernel/vmlinux.lds.S    |    6 +++-
 arch/sparc/lib/Makefile            |    2 -
 arch/sparc/lib/hweight.S           |   51 +++++++++++++++++++++++++++++++++++++
 7 files changed, 102 insertions(+), 40 deletions(-)
 create mode 100644 arch/sparc/lib/hweight.S

--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -42,45 +42,11 @@ extern void change_bit(unsigned long nr,
  * of bits set) of a N-bit word
  */
 
-#ifdef ULTRA_HAS_POPULATION_COUNT
+extern unsigned long __arch_hweight64(__u64 w);
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
 
-static inline unsigned int __arch_hweight64(unsigned long w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w));
-	return res;
-}
-
-static inline unsigned int __arch_hweight32(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xffffffff));
-	return res;
-}
-
-static inline unsigned int __arch_hweight16(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xffff));
-	return res;
-}
-
-static inline unsigned int __arch_hweight8(unsigned int w)
-{
-	unsigned int res;
-
-	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xff));
-	return res;
-}
-
-#else
-
-#include <asm-generic/bitops/arch_hweight.h>
-
-#endif
 #include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -42,6 +42,13 @@ extern void fpsave(unsigned long *fpregs
 extern void fpload(unsigned long *fpregs, unsigned long *fsr);
 
 #else /* CONFIG_SPARC32 */
+struct popc_3insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insns[3];
+};
+extern struct popc_3insn_patch_entry __popc_3insn_patch,
+	__popc_3insn_patch_end;
+
 extern void __init per_cpu_patch(void);
 extern void __init sun4v_patch(void);
 extern void __init boot_cpu_id_too_large(int cpu);
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -272,6 +272,30 @@ void __init sun4v_patch(void)
 	sun4v_hvapi_init();
 }
 
+static void __init popc_patch(void)
+{
+	struct popc_3insn_patch_entry *p3;
+
+	p3 = &__popc_3insn_patch;
+	while (p3 < &__popc_3insn_patch_end) {
+		unsigned long addr = p3->addr;
+
+		*(unsigned int *) (addr +  0) = p3->insns[0];
+		wmb();
+		__asm__ __volatile__("flush	%0" : : "r" (addr +  0));
+
+		*(unsigned int *) (addr +  4) = p3->insns[1];
+		wmb();
+		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
+
+		*(unsigned int *) (addr +  8) = p3->insns[2];
+		wmb();
+		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
+
+		p3++;
+	}
+}
+
 #ifdef CONFIG_SMP
 void __init boot_cpu_id_too_large(int cpu)
 {
@@ -424,6 +448,9 @@ static void __init init_sparc64_elf_hwca
 	sparc64_elf_hwcap = cap | mdesc_caps;
 
 	report_hwcaps(sparc64_elf_hwcap);
+
+	if (sparc64_elf_hwcap & AV_SPARC_POPC)
+		popc_patch();
 }
 
 void __init setup_arch(char **cmdline_p)
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
 #include <asm/cpudata.h>
@@ -38,5 +39,11 @@ EXPORT_SYMBOL(sun4v_niagara_setperf);
 EXPORT_SYMBOL(sun4v_niagara2_getperf);
 EXPORT_SYMBOL(sun4v_niagara2_setperf);
 
+/* from hweight.S */
+EXPORT_SYMBOL(__arch_hweight8);
+EXPORT_SYMBOL(__arch_hweight16);
+EXPORT_SYMBOL(__arch_hweight32);
+EXPORT_SYMBOL(__arch_hweight64);
+
 /* Exporting a symbol from /init/main.c */
 EXPORT_SYMBOL(saved_command_line);
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -107,7 +107,11 @@ SECTIONS
 		*(.sun4v_2insn_patch)
 		__sun4v_2insn_patch_end = .;
 	}
-
+	.popc_3insn_patch : {
+		__popc_3insn_patch = .;
+		*(.popc_3insn_patch)
+		__popc_3insn_patch_end = .;
+	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
 	. = ALIGN(PAGE_SIZE);
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -37,7 +37,7 @@ lib-$(CONFIG_SPARC64) += GENmemcpy.o GEN
 lib-$(CONFIG_SPARC64) += GENpatch.o GENpage.o GENbzero.o
 
 lib-$(CONFIG_SPARC64) += copy_in_user.o user_fixup.o memmove.o
-lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o
+lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o hweight.o
 
 obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o
--- /dev/null
+++ b/arch/sparc/lib/hweight.S
@@ -0,0 +1,51 @@
+#include <linux/linkage.h>
+
+	.text
+	.align	32
+ENTRY(__arch_hweight8)
+	ba,pt	%xcc, __sw_hweight8
+	 nop
+	nop
+ENDPROC(__arch_hweight8)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight8
+	sllx		%o0, 64-8, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight16)
+	ba,pt	%xcc, __sw_hweight16
+	 nop
+	nop
+ENDPROC(__arch_hweight16)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight16
+	sllx		%o0, 64-16, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight32)
+	ba,pt	%xcc, __sw_hweight32
+	 nop
+	nop
+ENDPROC(__arch_hweight32)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight32
+	sllx		%o0, 64-32, %g1
+	retl
+	 popc		%g1, %o0
+	.previous
+
+ENTRY(__arch_hweight64)
+	ba,pt	%xcc, __sw_hweight64
+	 nop
+	nop
+ENDPROC(__arch_hweight64)
+	.section	.popc_3insn_patch, "ax"
+	.word		__arch_hweight64
+	retl
+	 popc		%o0, %o0
+	nop
+	.previous


