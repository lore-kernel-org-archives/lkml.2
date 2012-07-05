Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2GEVGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:06:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:10490 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GEVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:06:12 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV454=
X-RZG-CLASS-ID: mo00
Date: Thu, 5 Jul 2012 23:06:07 +0200
From: Olaf Hering <olaf@aepfle.de>
To: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: incorrect layout of globals from head_64.S during kexec boot
Message-ID: <20120705210607.GA26908@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During kexec in a Xen PVonHVM guest the new kernel crashes most of the
time in secondary_startup_64 because the content of phys_base is
corrupted. Its not zero as expected but has some random other values.
While debugging that crash I came up with the change below to inspect
the memory around phys_base. 

It turned out that the globales are not in the expected memory location.
An expected value such as phys_base_plus1 is shifted, but by a different
amount during repeated kexec attempts. Up to now I havent figured out
where this happens.

My question is: were to put additional debug to trace the copying of the
data section to its final destination? Is this a task of kexec -l or
does that happen during decompressing? I suspect the latter. This is the
console output before the crash (the crash happens in 'movq %rax, %cr3'):

...
[   44.072548] Starting new kernel
I'm in purgatory
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
...


example xenctx output:
rip: 0000000001000146
flags: 00010086 rf s nz p
rsp: 0000000002119c80
rax: 888888888a495999   rcx: 00000000000003d5   rdx: 0000000001000000
rbx: 0000000001cac000   rsi: 0000000000003000   rdi: 0000000001c13000
rbp: 0000000000000000    r8: 0000000001c13000    r9: 1111111111112222
r10: 0000000000001111   r11: 9999999999990000   r12: 8888888888889999
r13: 7777777777778888   r14: 0000000000007777   r15: 0000000000000000
 cs: 0010        ss: 0000        ds: 0000        es: 0000
 fs: 0000 @ 0000000000000000
 gs: 0000 @ 0000000000000000/0000000000000000

cr0: 80000011
cr2: ffffffffff600400
cr3: 0211a000
cr4: 000000a0

dr0: 00000000
dr1: 00000000
dr2: 00000000
dr3: 00000000
dr6: ffff0ff0
dr7: 00000400
Code (instr addr 01000146)
a0 00 00 00 0f 22 e0 48 c7 c0 00 c0 c0 01 48 03 05 02 3f c1 00 <0f> 22 d8 48 c7 c0 52 01 00 81 ff



diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..999807c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -69,6 +69,22 @@ startup_64:
 	/* Compute the delta between the address I am compiled to run at and the
 	 * address I am actually running at.
 	 */
+#if 1
+	movq	$phys_base - __START_KERNEL_map, %rdx
+	movq	phys_base_minus5(%rip),%rbp
+	movq	phys_base_minus4(%rip),%r8
+	movq	phys_base_minus3(%rip),%r9
+	movq	phys_base_minus2(%rip),%r10
+	movq	phys_base_minus1(%rip),%r11
+	movq	phys_base(%rip),%r12
+	movq	phys_base_plus1(%rip),%r13
+	movq	phys_base_plus2(%rip),%r14
+	movq	phys_base_plus3(%rip),%r15
+#if 0
+	ud2a
+	hlt
+#endif
+#endif
 	leaq	_text(%rip), %rbp
 	subq	$_text - __START_KERNEL_map, %rbp
 
@@ -166,6 +182,10 @@ ENTRY(secondary_startup_64)
 	/* Setup early boot stage 4 level pagetables. */
 	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
 	addq	phys_base(%rip), %rax
+#if 0
+	ud2a
+	hlt
+#endif
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
@@ -439,10 +459,28 @@ early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
 early_gdt_descr_base:
 	.quad	INIT_PER_CPU_VAR(gdt_page)
-
-ENTRY(phys_base)
+	.align 32
+phys_base_minus5:
+	.quad	0x5555555555555555
+phys_base_minus4:
+	.quad	0x4444444444444444
+phys_base_minus3:
+	.quad	0x3333333333333333
+phys_base_minus2:
+	.quad	0x2222222222222222
+phys_base_minus1:
+	.quad	0x1111111111111111
+
+	.globl phys_base
+phys_base:
 	/* This must match the first entry in level2_kernel_pgt */
 	.quad   0x0000000000000000
+phys_base_plus1:
+	.quad	0x9999999999999999
+phys_base_plus2:
+	.quad	0x8888888888888888
+phys_base_plus3:
+	.quad	0x7777777777777777
 
 #include "../../x86/xen/xen-head.S"
 	

