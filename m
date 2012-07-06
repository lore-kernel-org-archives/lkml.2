Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2GFOOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:14:25 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:52891 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GFOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:14:22 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk3M7oE7o=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 Jul 2012 16:14:19 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120706141419.GA21951@aepfle.de>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120706133105.GA20600@aepfle.de>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, Olaf Hering wrote:

> I will cleanup my debug changes and post the output.

What I see is that the content of the uncompressed vmlinux is
appearently already corrupted after decompress().  After I made small
changes to arch/x86/boot/compressed/misc.c and arch/x86/kernel/head_64.S
the offset in memory changed from 0x2c to 0x8.

This could mean that the unzip code is broken, but this is rather
unlikely. The odd thing is, if the first kernel is forced to return
false in xen_hvm_platform() to disable the PVonHVM features then kexec
works ok.

Could it be that some code tweaks the stack content used by decompress()
in some odd way? But that would most likely lead to a crash, not to
unexpected uncompressing results.

I will study the code some more.


This is the readelf output from vmlinux:

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
0 LOAD           0x200000 0xffffffff81000000 0x0000000001000000 0xa3b000 0xa3b000 R E 0x200000
1 LOAD           0xe00000 0xffffffff81c00000 0x0000000001c00000 0x05b0e8 0x05b0e8 RW  0x200000
2 LOAD           0x1000000 0x0000000000000000 0x0000000001c5c000 0x012c40 0x012c40 RW  0x200000
3 LOAD           0x106f000 0xffffffff81c6f000 0x0000000001c6f000 0x087000 0x702000 RWE 0x200000
4 NOTE           0x82d5bc 0xffffffff8162d5bc 0x000000000162d5bc 0x00017c 0x00017c     0x4

Dump of the Program Header sections:

#0
dd if=../O/x86_64-O-3.5/vmlinux bs=1 skip=$(( 0x200000 )) count=$(( 0xa3b000 )) | xxd -a -g 8 | head -n 12
0000000: 4c8b0d2940c1004c 8b152a40c1004c8b  L..)@..L..*@..L.
0000010: 1d2b40c1004c8b25 3440c1004c8b2d35  .+@..L.%4@..L.-5
0000020: 40c1004c8b353640 c1004c8b3d3740c1  @..L.56@..L.=7@.
0000030: 00488d2dc8ffffff 4881ed0000000148  .H.-....H......H
0000040: 89e825ffff1f0085 c00f855b01000048  ..%........[...H
0000050: 8d15aaffffff48b8 0000000080000000  ......H.........
0000060: 4839c20f83410100 0048012d90bfc000  H9...A...H.-....
0000070: 48012d09c8c00048 012d7acfc0004801  H.-....H.-z...H.
0000080: 2d7bcfc00048012d 64efc00048012d65  -{...H.-d...H.-e
0000090: efc00048012d36ff c000488d3d5fffff  ...H.-6...H.=_..
00000a0: ff4881e70000e0ff 4889f848c1e81e48  .H......H..H...H
00000b0: 25ff010000743148 8d956330c101488d  %....t1H..c0..H.

#1
dd if=../O/x86_64-O-3.5/vmlinux bs=1 skip=$(( 0xe00000 )) count=$(( 0x05b0e8 )) | xxd -a -g 8 | head -n 12
0000000: 8044c181ffffffff 60acc181ffffffff  .D......`.......
0000010: 0000000000000000 0000000001000010  ................
0000020: ffffffffffffffff c0d70481ffffffff  ................
0000030: 0000000000000000 0000000000000000  ................
*
0002000: 48c7c0600000000f 05c3cccccccccccc  H..`............
0002010: cccccccccccccccc cccccccccccccccc  ................
0002020: cccccccccccccccc cccccccccccccccc  ................
0002030: cccccccccccccccc cccccccccccccccc  ................
0002040: cccccccccccccccc cccccccccccccccc  ................
0002050: cccccccccccccccc cccccccccccccccc  ................
0002060: cccccccccccccccc cccccccccccccccc  ................

#2
 dd if=../O/x86_64-O-3.5/vmlinux bs=1 skip=$(( 0x1000000 )) count=$(( 0x012c40 )) | xxd -a -g 8 | head -n 12
0000000: 0000000000000000 0000000000000000  ................
*
0004000: 0000000000000000 ffff0000009bcf00  ................
0004010: ffff0000009baf00 ffff00000093cf00  ................
0004020: ffff000000fbcf00 ffff000000f3cf00  ................
0004030: ffff000000fbaf00 0000000000000000  ................
0004040: 0000000000000000 0000000000000000  ................
*
000be80: ffffffff00000000 0000000000000000  ................
000be90: 0000000000000000 0000000000000000  ................
*
000bf00: ffffffffffffffff ffffffffffffffff  ................

#3
dd if=../O/x86_64-O-3.5/vmlinux bs=1 skip=$(( 0x106f000 )) count=$(( 0x087000 )) | xxd -a -g 8 | head -n 12
0000000: 6a006a00e9170100 006a006a01e90e01  j.j......j.j....
0000010: 00006a006a02e905 0100006a006a03e9  ..j.j......j.j..
0000020: fc0000006a006a04 e9f30000006a006a  ....j.j......j.j
0000030: 05e9ea0000006a00 6a06e9e10000006a  ......j.j......j
0000040: 006a07e9d8000000 66906a08e9cf0000  .j......f.j.....
0000050: 006a006a09e9c600 000066906a0ae9bd  .j.j......f.j...
0000060: 00000066906a0be9 b400000066906a0c  ...f.j......f.j.
0000070: e9ab00000066906a 0de9a20000006690  .....f.j......f.
0000080: 6a0ee9990000006a 006a0fe990000000  j......j.j......
0000090: 6a006a10e9870000 0066906a11e97e00  j.j......f.j..~.
00000a0: 00006a006a12e975 0000006a006a13e9  ..j.j..u...j.j..
00000b0: 6c0000006a006a14 e9630000006a006a  l...j.j..c...j.j

#4
dd if=../O/x86_64-O-3.5/vmlinux bs=1 skip=$(( 0x82d5bc )) count=$(( 0x00017c )) 2>/dev/null | xxd -a -g 8 | head -n 12 
0000000: 0400000006000000 0600000058656e00  ............Xen.
0000010: 6c696e7578000000 0400000004000000  linux...........
0000020: 0700000058656e00 322e360004000000  ....Xen.2.6.....
0000030: 0800000005000000 58656e0078656e2d  ........Xen.xen-
0000040: 332e300004000000 0800000003000000  3.0.............
0000050: 58656e0000000080 ffffffff04000000  Xen.............
0000060: 0800000001000000 58656e0010f2c681  ........Xen.....
0000070: ffffffff04000000 0800000002000000  ................
0000080: 58656e0000100081 ffffffff04000000  Xen.............
0000090: 2a0000000a000000 58656e0021777269  *.......Xen.!wri
00000a0: 7461626c655f7061 67655f7461626c65  table_page_table
00000b0: 737c7061655f7067 6469725f61626f76  s|pae_pgdir_abov


Dump of the place where phys_base is stored in the .data section:
(5555555555555555 should have been at offset 0x14020, but in fact its
stored at 0x14028 in the output of the guest below)
*
0014000: 7f000000c681ffff ffff000000000000  ................
0014010: 0000000000000000 0000000000000000  ................
0014020: 5555555555555555 4444444444444444  UUUUUUUUDDDDDDDD
0014030: 3333333333333333 2222222222222222  33333333""""""""
0014040: 1111111111111111 9090909090909090  ................
0014050: 0000000000000000 9999999999999999  ................
0014060: 8888888888888888 7777777777777777  ........wwwwwwww
0014070: 0000000000000000 0000000000000000  ................
0014080: 7b599781ffffffff 82599781ffffffff  {Y.......Y......
0014090: 0000000000000000 0000000000000000  ................
*


Thats what I get in the guest:

...
[   29.590290] Starting new kernel
I'm in purgatory
early console in decompress_kernel

Decompressing Linux... Parsing ELF...
output 0000000001000000 phdrs 000000000210e040 ehdr.e_phoff 0000000000000040 ehdr.e_phnum 0000000000000005
i 0000000000000000 p 0000000001200000 4c8b0d2940c1004c8b152a40c1004c8b1d2b40c1004c8b253440c1004c8b2d3540c1004c8b353640c1004c8b3d3740c100488d2dc8ffffff4881ed0000000148
i 0000000000000001 p 0000000001e00000 00000000000000008044c181ffffffff60acc181ffffffff00000000000000000000000001000010ffffffffffffffffc0d70481ffffffff0000000000000000
i 0000000000000001 &p[j] 0000000001e14028 5555555555555555444444444444444433333333333333332222222222222222111111111111111190909090909090900000000000000000999999999999999988888888888888887777777777777777
i 0000000000000002 p 0000000002000000 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
i 0000000000000003 p 000000000206f000 00000000000000006a006a00e9170100006a006a01e90e0100006a006a02e9050100006a006a03e9fc0000006a006a04e9f30000006a006a05e9ea0000006a00
i 0000000000000004 p 000000000182d5bc 6631d2e9c9fdfdff04ec300006ec300006ec300058656e006c696e7578ec300004ec300004ec300007ec300058656e00322e360004ec30000830ec3005ec3000

i 0000000000000000 dest 0000000001000000 phdr->p_paddr 0000000001000000 phdr->p_offset 0000000000200000 phdr->p_filesz 0000000000a3b000
i 0000000000000000 dest 0000000001000000 output + phdr->p_offset 0000000001200000 phdr->p_filesz 0000000000a3b000
overlap 000000000083b000
i 0000000000000001 dest 0000000001c00000 phdr->p_paddr 0000000001c00000 phdr->p_offset 0000000000e00000 phdr->p_filesz 000000000005b0e8
i 0000000000000001 dest 0000000001c00000 output + phdr->p_offset 0000000001e00000 phdr->p_filesz 000000000005b0e8
i 0000000000000002 dest 0000000001c5c000 phdr->p_paddr 0000000001c5c000 phdr->p_offset 0000000001000000 phdr->p_filesz 0000000000012c40
i 0000000000000002 dest 0000000001c5c000 output + phdr->p_offset 0000000002000000 phdr->p_filesz 0000000000012c40
i 0000000000000003 dest 0000000001c6f000 phdr->p_paddr 0000000001c6f000 phdr->p_offset 000000000106f000 phdr->p_filesz 0000000000087000
i 0000000000000003 dest 0000000001c6f000 output + phdr->p_offset 000000000206f000 phdr->p_filesz 0000000000087000
done.
Booting the kernel.
<crash>


xenctx shows this:
rip: 0000000001000136
flags: 00010086 rf s nz p
rsp: 000000000211a040
rax: 9090909092515090   rcx: 00000000000003d5   rdx: 0000000001000000
rbx: 0000000001cac000   rsi: 0000000000003000   rdi: 0000000001c13000
rbp: 0000000000000000    r8: 0000000001c13000    r9: 4444444444444444
r10: 3333333333333333   r11: 2222222222222222   r12: 9090909090909090
r13: 0000000000000000   r14: 9999999999999999   r15: 8888888888888888
 cs: 0010        ss: 0000        ds: 0000        es: 0000
 fs: 0000 @ 0000000000000000
 gs: 0000 @ 0000000000000000/0000000000000000

cr0: 80000011
cr2: ffffffffff600400
cr3: 0211b000
cr4: 000000a0

dr0: 00000000
dr1: 00000000
dr2: 00000000
dr3: 00000000
dr6: ffff0ff0
dr7: 00000400
Code (instr addr 01000136)
a0 00 00 00 0f 22 e0 48 c7 c0 00 c0 c0 01 48 03 05 1a 3f c1 00 <0f> 22 d8 48 c7 c0 42 01 00 81 ff


The debug patch for 3.5-rc5:

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7116dcb..14e77cf 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -273,6 +273,36 @@ static void error(char *x)
 		asm("hlt");
 }
 
+static void putbyte(unsigned char val)
+{
+	static const char digits[] = "0123456789abcdef";
+	char str[(sizeof(unsigned char) * 2) + 1];
+	int i = sizeof(str), c = sizeof(unsigned char) * 2;
+	str[--i] = 0;
+	while(c--) {
+		str[--i] = digits[val & 0xf];
+		val >>=4;
+	}
+	putstr(str);
+}
+static void __putval(char *s, unsigned long val)
+{
+	static const char digits[] = "0123456789abcdef";
+	char str[(sizeof(unsigned long) * 2) + 3];
+	int i = sizeof(str), c = sizeof(unsigned long) * 2;
+	str[--i] = 0;
+	str[--i] = ' ';
+	while(c--) {
+		str[--i] = digits[val & 0xf];
+		val >>=4;
+	}
+	str[--i] = ' ';
+
+	putstr(s);
+	putstr(str);
+}
+#define putval(x) __putval(#x, (unsigned long)(x))
+
 static void parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
@@ -284,6 +314,9 @@ static void parse_elf(void *output)
 #endif
 	void *dest;
 	int i;
+	unsigned long j, c;
+	unsigned char *p;
+	signed long overlap;
 
 	memcpy(&ehdr, output, sizeof(ehdr));
 	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
@@ -303,6 +336,33 @@ static void parse_elf(void *output)
 
 	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
 
+	putstr("\n");
+	putval(output);
+	putval(phdrs);
+	putval(ehdr.e_phoff);
+	putval(ehdr.e_phnum);
+	putstr("\n");
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		phdr = &phdrs[i];
+		p = output + phdr->p_offset;
+		putval(i);
+		putval(p);
+		for (j = 0; j < 64; j++)
+			putbyte(p[j]);
+		putstr("\n");
+		if (i == 1)
+			for (j = 0; j < phdr->p_filesz; j++) {
+				if (p[j + 0] == 0x55 && p[j + 1] == 0x55 && p[j + 2] == 0x55 && p[j + 3] == 0x55 && p[j + 4] == 0x55 && p[j + 5] == 0x55 && p[j + 6] == 0x55 && p[j + 7] == 0x55) {
+					putval(i);
+					putval(&p[j]);
+					for (c = 0; c < 10 * sizeof(unsigned long); c++)
+						putbyte(p[j +c]);
+					putstr("\n");
+					break;
+				}
+			}
+	}
+	putstr("\n");
 	for (i = 0; i < ehdr.e_phnum; i++) {
 		phdr = &phdrs[i];
 
@@ -314,6 +374,22 @@ static void parse_elf(void *output)
 #else
 			dest = (void *)(phdr->p_paddr);
 #endif
+			putval(i);
+			putval(dest);
+			putval(phdr->p_paddr);
+			putval(phdr->p_offset);
+			putval(phdr->p_filesz);
+			putstr("\n");
+			putval(i);
+			putval(dest);
+			putval(output + phdr->p_offset);
+			putval(phdr->p_filesz);
+			putstr("\n");
+			overlap = ((long)dest + (long)phdr->p_filesz) - ((long)output + (long)phdr->p_offset);
+			if (overlap > 0) {
+				putval(overlap);
+				putstr("\n");
+			}
 			memcpy(dest,
 			       output + phdr->p_offset,
 			       phdr->p_filesz);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..42f1836 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -69,6 +69,15 @@ startup_64:
 	/* Compute the delta between the address I am compiled to run at and the
 	 * address I am actually running at.
 	 */
+#if 1
+	movq	phys_base_minus3(%rip),%r9
+	movq	phys_base_minus2(%rip),%r10
+	movq	phys_base_minus1(%rip),%r11
+	movq	phys_base(%rip),%r12
+	movq	phys_base_plus1(%rip),%r13
+	movq	phys_base_plus2(%rip),%r14
+	movq	phys_base_plus3(%rip),%r15
+#endif
 	leaq	_text(%rip), %rbp
 	subq	$_text - __START_KERNEL_map, %rbp
 
@@ -166,6 +175,9 @@ ENTRY(secondary_startup_64)
 	/* Setup early boot stage 4 level pagetables. */
 	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
 	addq	phys_base(%rip), %rax
+#if 0
+	ud2a
+#endif
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
@@ -439,10 +451,27 @@ early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
 early_gdt_descr_base:
 	.quad	INIT_PER_CPU_VAR(gdt_page)
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
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
 	.quad   0x0000000000000000
+phys_base_plus1:
+	.quad	0x9999999999999999
+phys_base_plus2:
+	.quad	0x8888888888888888
+phys_base_plus3:
+	.quad	0x7777777777777777
 
 #include "../../x86/xen/xen-head.S"
 	
