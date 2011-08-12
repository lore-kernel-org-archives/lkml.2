Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1HNQNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:13:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1HNQJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.525835308@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [73/90] sparc: Use popc when possible for ffs/__ffs/ffz.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 56d205cc5c0a3032a605121d4253e111193bf923 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/bitops_64.h |    7 +--
 arch/sparc/kernel/entry.h          |    7 +++
 arch/sparc/kernel/setup_64.c       |   34 +++++++++-----
 arch/sparc/kernel/sparc_ksyms_64.c |    4 +
 arch/sparc/kernel/vmlinux.lds.S    |    5 ++
 arch/sparc/lib/Makefile            |    2 
 arch/sparc/lib/ffs.S               |   84 +++++++++++++++++++++++++++++++++++++
 7 files changed, 127 insertions(+), 16 deletions(-)
 create mode 100644 arch/sparc/lib/ffs.S

--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -26,16 +26,17 @@ extern void change_bit(unsigned long nr,
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
-#include <asm-generic/bitops/ffz.h>
-#include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__
 
+extern int ffs(int x);
+extern unsigned long __ffs(unsigned long);
+
+#include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/ffs.h>
 
 /*
  * hweightN: returns the hamming weight (i.e. the number
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -49,6 +49,13 @@ struct popc_3insn_patch_entry {
 extern struct popc_3insn_patch_entry __popc_3insn_patch,
 	__popc_3insn_patch_end;
 
+struct popc_6insn_patch_entry {
+	unsigned int	addr;
+	unsigned int	insns[6];
+};
+extern struct popc_6insn_patch_entry __popc_6insn_patch,
+	__popc_6insn_patch_end;
+
 extern void __init per_cpu_patch(void);
 extern void __init sun4v_patch(void);
 extern void __init boot_cpu_id_too_large(int cpu);
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -275,25 +275,35 @@ void __init sun4v_patch(void)
 static void __init popc_patch(void)
 {
 	struct popc_3insn_patch_entry *p3;
+	struct popc_6insn_patch_entry *p6;
 
 	p3 = &__popc_3insn_patch;
 	while (p3 < &__popc_3insn_patch_end) {
-		unsigned long addr = p3->addr;
+		unsigned long i, addr = p3->addr;
 
-		*(unsigned int *) (addr +  0) = p3->insns[0];
-		wmb();
-		__asm__ __volatile__("flush	%0" : : "r" (addr +  0));
-
-		*(unsigned int *) (addr +  4) = p3->insns[1];
-		wmb();
-		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
-
-		*(unsigned int *) (addr +  8) = p3->insns[2];
-		wmb();
-		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
+		for (i = 0; i < 3; i++) {
+			*(unsigned int *) (addr +  (i * 4)) = p3->insns[i];
+			wmb();
+			__asm__ __volatile__("flush	%0"
+					     : : "r" (addr +  (i * 4)));
+		}
 
 		p3++;
 	}
+
+	p6 = &__popc_6insn_patch;
+	while (p6 < &__popc_6insn_patch_end) {
+		unsigned long i, addr = p6->addr;
+
+		for (i = 0; i < 6; i++) {
+			*(unsigned int *) (addr +  (i * 4)) = p6->insns[i];
+			wmb();
+			__asm__ __volatile__("flush	%0"
+					     : : "r" (addr +  (i * 4)));
+		}
+
+		p6++;
+	}
 }
 
 #ifdef CONFIG_SMP
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -45,5 +45,9 @@ EXPORT_SYMBOL(__arch_hweight16);
 EXPORT_SYMBOL(__arch_hweight32);
 EXPORT_SYMBOL(__arch_hweight64);
 
+/* from ffs_ffz.S */
+EXPORT_SYMBOL(ffs);
+EXPORT_SYMBOL(__ffs);
+
 /* Exporting a symbol from /init/main.c */
 EXPORT_SYMBOL(saved_command_line);
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -112,6 +112,11 @@ SECTIONS
 		*(.popc_3insn_patch)
 		__popc_3insn_patch_end = .;
 	}
+	.popc_6insn_patch : {
+		__popc_6insn_patch = .;
+		*(.popc_6insn_patch)
+		__popc_6insn_patch_end = .;
+	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
 	. = ALIGN(PAGE_SIZE);
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -37,7 +37,7 @@ lib-$(CONFIG_SPARC64) += GENmemcpy.o GEN
 lib-$(CONFIG_SPARC64) += GENpatch.o GENpage.o GENbzero.o
 
 lib-$(CONFIG_SPARC64) += copy_in_user.o user_fixup.o memmove.o
-lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o hweight.o
+lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o hweight.o ffs.o
 
 obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o
--- /dev/null
+++ b/arch/sparc/lib/ffs.S
@@ -0,0 +1,84 @@
+#include <linux/linkage.h>
+
+	.register	%g2,#scratch
+
+	.text
+	.align	32
+
+ENTRY(ffs)
+	brnz,pt	%o0, 1f
+	 mov	1, %o1
+	retl
+	 clr	%o0
+	nop
+	nop
+ENTRY(__ffs)
+	sllx	%o0, 32, %g1		/* 1  */
+	srlx	%o0, 32, %g2
+
+	clr	%o1			/* 2  */
+	movrz	%g1, %g2, %o0
+
+	movrz	%g1, 32, %o1		/* 3  */
+1:	clr	%o2
+
+	sllx	%o0, (64 - 16), %g1	/* 4  */
+	srlx	%o0, 16, %g2
+
+	movrz	%g1, %g2, %o0		/* 5  */
+	clr	%o3
+
+	movrz	%g1, 16, %o2		/* 6  */
+	clr	%o4
+
+	and	%o0, 0xff, %g1		/* 7  */
+	srlx	%o0, 8, %g2
+
+	movrz	%g1, %g2, %o0		/* 8  */
+	clr	%o5
+
+	movrz	%g1, 8, %o3		/* 9  */
+	add	%o2, %o1, %o2
+
+	and	%o0, 0xf, %g1		/* 10 */
+	srlx	%o0, 4, %g2
+
+	movrz	%g1, %g2, %o0		/* 11 */
+	add	%o2, %o3, %o2
+
+	movrz	%g1, 4, %o4		/* 12 */
+
+	and	%o0, 0x3, %g1		/* 13 */
+	srlx	%o0, 2, %g2
+
+	movrz	%g1, %g2, %o0		/* 14 */
+	add	%o2, %o4, %o2
+
+	movrz	%g1, 2, %o5		/* 15 */
+
+	and	%o0, 0x1, %g1		/* 16 */
+
+	add	%o2, %o5, %o2		/* 17 */
+	xor	%g1, 0x1, %g1
+
+	retl				/* 18 */
+	 add	%o2, %g1, %o0
+ENDPROC(ffs)
+ENDPROC(__ffs)
+
+	.section	.popc_6insn_patch, "ax"
+	.word		ffs
+	brz,pn	%o0, 98f
+	 neg	%o0, %g1
+	xnor	%o0, %g1, %o1
+	popc	%o1, %o0
+98:	retl
+	 nop
+	.word		__ffs
+	neg	%o0, %g1
+	xnor	%o0, %g1, %o1
+	popc	%o1, %o0
+	retl
+	 sub	%o0, 1, %o0
+	nop
+	.previous


