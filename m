Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2I1ILs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:11:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46006 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab2I1IL1 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 28 Sep 2012 04:11:27 -0400
Message-Id: <506577E3020000780009E65B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 28 Sep 2012 09:11:47 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, "xen-devel" <xen-devel@lists.xen.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/11] x86/xen: Add i386 kexec/kdump implementation
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartD5E4EDD3.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartD5E4EDD3.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Add i386 kexec/kdump implementation.

So this as well as the subsequent patch introduces quite a bit of
duplicate code. The old 2.6.18 kernel had an initial pair of cleanup
patches (attached in their forward ported form for 3.6-rc6) that
would allow reducing the amount of duplication, particularly by
eliminating the need to clone relocate_kernel_??.S altogether.

Additionally, in the PAE case (which is the only relevant one for
a 32-bit Xen kernel) I'm missing the address restriction
enforcement for the PGD, without which the __ma() conversion
result may not fit into the field it gets stored into.

Finally, as noticed in an earlier patch already, you appear to
re-introduce stuff long dropped from the kernel - the forward
ported kernels get away with just setting PA_CONTROL_PAGE,
PA_PGD, and PA_SWAP_PAGE in the page list. Since the number
and purpose of the pages is established entirely by the guest
kernel, all you need to obey is that the hypervisor expects
alternating PA_/VA_ pairs (where the VA_ ones can be left
unpopulated). Perhaps taking a look at a recent SLES kernel
would help...

Jan


--=__PartD5E4EDD3.3__=
Content-Type: text/plain; name="kexec-move-segment-code-x86_64.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="kexec-move-segment-code-x86_64.patch"

Subject: kexec: Move asm segment handling code to the assembly file =
(x86_64)=0AFrom: http://xenbits.xensource.com/xen-unstable.hg (tip =
13816)=0APatch-mainline: n/a=0A=0AThis patch moves the idt, gdt, and =
segment handling code from machine_kexec.c=0Ato relocate_kernel.S.  The =
main reason behind this move is to avoid code =0Aduplication in the Xen =
hypervisor. With this patch all code required to kexec=0Ais put on the =
control page.=0A=0AOn top of that this patch also counts as a cleanup - I =
think it is much=0Anicer to write assembly directly in assembly files than =
wrap inline assembly=0Ain C functions for no apparent reason.=0A=0ASigned-o=
ff-by: Magnus Damm <magnus@valinux.co.jp>=0AAcked-by: jbeulich@novell.com=
=0A=0A Applies to 2.6.19-rc1.=0A jb: fixed up register usage for 2.6.30 =
(bnc#545206)=0A=0A--- head-2011-08-09.orig/arch/x86/kernel/machine_kexec_64=
.c	2011-08-09 10:21:04.000000000 +0200=0A+++ head-2011-08-09/arch/x86/=
kernel/machine_kexec_64.c	2010-04-15 09:38:56.000000000 +0200=0A@@ =
-203,47 +203,6 @@ static int init_pgtable(struct kimage *i=0A 	return =
init_transition_pgtable(image, level4p);=0A }=0A =0A-static void set_idt(vo=
id *newidt, u16 limit)=0A-{=0A-	struct desc_ptr curidt;=0A-=0A-	/* x86-64 =
supports unaliged loads & stores */=0A-	curidt.size    =3D limit;=0A-	=
curidt.address =3D (unsigned long)newidt;=0A-=0A-	__asm__ __volatile_=
_ (=0A-		"lidtq %0\n"=0A-		: : "m" (curidt)=0A-		=
);=0A-};=0A-=0A-=0A-static void set_gdt(void *newgdt, u16 limit)=0A-{=0A-	=
struct desc_ptr curgdt;=0A-=0A-	/* x86-64 supports unaligned loads & =
stores */=0A-	curgdt.size    =3D limit;=0A-	curgdt.address =3D =
(unsigned long)newgdt;=0A-=0A-	__asm__ __volatile__ (=0A-		=
"lgdtq %0\n"=0A-		: : "m" (curgdt)=0A-		);=0A-};=0A=
-=0A-static void load_segments(void)=0A-{=0A-	__asm__ __volatile__ (=0A-	=
	"\tmovl %0,%%ds\n"=0A-		"\tmovl %0,%%es\n"=0A-		=
"\tmovl %0,%%ss\n"=0A-		"\tmovl %0,%%fs\n"=0A-		"\tmovl =
%0,%%gs\n"=0A-		: : "a" (__KERNEL_DS) : "memory"=0A-		=
);=0A-}=0A-=0A int machine_kexec_prepare(struct kimage *image)=0A {=0A 	=
unsigned long start_pgtable;=0A@@ -311,24 +270,6 @@ void machine_kexec(stru=
ct kimage *image)=0A 		page_list[PA_SWAP_PAGE] =3D (page_to_pfn(im=
age->swap_page)=0A 						<< =
PAGE_SHIFT);=0A =0A-	/*=0A-	 * The segment registers are funny things, =
they have both a=0A-	 * visible and an invisible part.  Whenever the =
visible part is=0A-	 * set to a specific selector, the invisible part =
is loaded=0A-	 * with from a table in memory.  At no other time is =
the=0A-	 * descriptor table in memory accessed.=0A-	 *=0A-	 * I take =
advantage of this here by force loading the=0A-	 * segments, before I zap =
the gdt with an invalid value.=0A-	 */=0A-	load_segments();=0A-	=
/*=0A-	 * The gdt & idt are now invalid.=0A-	 * If you want to load =
them you must set up your own idt & gdt.=0A-	 */=0A-	set_gdt(phys_to_vir=
t(0), 0);=0A-	set_idt(phys_to_virt(0), 0);=0A-=0A 	/* now call it =
*/=0A 	image->start =3D relocate_kernel((unsigned long)image->head,=0A 	=
			       (unsigned long)page_list,=0A--- head-2011-08=
-09.orig/arch/x86/kernel/relocate_kernel_64.S	2011-08-09 10:19:07.0000000=
00 +0200=0A+++ head-2011-08-09/arch/x86/kernel/relocate_kernel_64.S	=
2011-08-09 10:21:24.000000000 +0200=0A@@ -91,13 +91,30 @@ relocate_kernel:=
=0A 	/* Switch to the identity mapped page tables */=0A 	movq	=
%r9, %cr3=0A =0A+	/* setup idt */=0A+	lidtq	idt_80 - relocate_k=
ernel(%r8)=0A+=0A+	/* setup gdt */=0A+	leaq	gdt - relocate_kern=
el(%r8), %rax=0A+	movq	%rax, (gdt_80 - relocate_kernel) + =
2(%r8)=0A+	lgdtq	gdt_80 - relocate_kernel(%r8)=0A+=0A+	/* setup =
data segment registers */=0A+	xorl	%eax, %eax=0A+	movl	%eax, =
%ds=0A+	movl	%eax, %es=0A+	movl	%eax, %fs=0A+	movl	%eax, =
%gs=0A+	movl	%eax, %ss=0A+=0A 	/* setup a new stack at the end of =
the physical control page */=0A 	lea	PAGE_SIZE(%r8), %rsp=0A =
=0A-	/* jump to identity mapped page */=0A+	/* load new code segment =
and jump to identity mapped page */=0A 	addq	$(identity_mapped - =
relocate_kernel), %r8=0A+	pushq	$(gdt_cs - gdt)=0A 	pushq	=
%r8=0A-	ret=0A+	lretq=0A =0A identity_mapped:=0A 	/* set return =
address to 0 if not preserving context */=0A@@ -264,5 +281,20 @@ swap_pages=
:=0A 3:=0A 	ret=0A =0A+	.align  16=0A+gdt:=0A+	.quad	0x000000000=
0000000	/* NULL descriptor */=0A+gdt_cs:=0A+	.quad   0x00af9a000000ffff=
=0A+gdt_end:=0A+=0A+gdt_80:=0A+	.word	gdt_end - gdt - 1	/* limit =
*/=0A+	.quad	0			/* base - filled in by code above =
*/=0A+=0A+idt_80:=0A+	.word	0			/* limit */=0A+	=
.quad	0			/* base */=0A+=0A 	.globl kexec_contro=
l_code_size=0A .set kexec_control_code_size, . - relocate_kernel=0A
--=__PartD5E4EDD3.3__=
Content-Type: text/plain; name="kexec-move-segment-code-i386.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="kexec-move-segment-code-i386.patch"

Subject: kexec: Move asm segment handling code to the assembly file =
(i386)=0AFrom: http://xenbits.xensource.com/xen-unstable.hg (tip 13816)=0AP=
atch-mainline: n/a=0A=0AThis patch moves the idt, gdt, and segment =
handling code from machine_kexec.c=0Ato relocate_kernel.S. The main reason =
behind this move is to avoid code =0Aduplication in the Xen hypervisor. =
With this patch all code required to kexec=0Ais put on the control =
page.=0A=0AOn top of that this patch also counts as a cleanup - I think it =
is much=0Anicer to write assembly directly in assembly files than wrap =
inline assembly=0Ain C functions for no apparent reason.=0A=0ASigned-off-by=
: Magnus Damm <magnus@valinux.co.jp>=0AAcked-by: jbeulich@novell.com=0A=0A =
Applies to 2.6.19-rc1.=0A jb: fixed up register usage (paralleling what's =
needed for 2.6.30 on x86-64)=0A=0A--- head.orig/arch/x86/kernel/machine_kex=
ec_32.c	2012-04-10 14:24:22.000000000 +0200=0A+++ head/arch/x86/kernel/mach=
ine_kexec_32.c	2012-04-10 14:50:08.000000000 +0200=0A@@ -26,48 +26,6 =
@@=0A #include <asm/cacheflush.h>=0A #include <asm/debugreg.h>=0A =
=0A-static void set_idt(void *newidt, __u16 limit)=0A-{=0A-	struct =
desc_ptr curidt;=0A-=0A-	/* ia32 supports unaliged loads & stores =
*/=0A-	curidt.size    =3D limit;=0A-	curidt.address =3D (unsigned =
long)newidt;=0A-=0A-	load_idt(&curidt);=0A-}=0A-=0A-=0A-static void =
set_gdt(void *newgdt, __u16 limit)=0A-{=0A-	struct desc_ptr curgdt;=0A-=
=0A-	/* ia32 supports unaligned loads & stores */=0A-	curgdt.size=
    =3D limit;=0A-	curgdt.address =3D (unsigned long)newgdt;=0A-=0A-	=
load_gdt(&curgdt);=0A-}=0A-=0A-static void load_segments(void)=0A-{=0A-#def=
ine __STR(X) #X=0A-#define STR(X) __STR(X)=0A-=0A-	__asm__ __volatile_=
_ (=0A-		"\tljmp $"STR(__KERNEL_CS)",$1f\n"=0A-		"\t1:\n"=0A=
-		"\tmovl $"STR(__KERNEL_DS)",%%eax\n"=0A-		=
"\tmovl %%eax,%%ds\n"=0A-		"\tmovl %%eax,%%es\n"=0A-		=
"\tmovl %%eax,%%fs\n"=0A-		"\tmovl %%eax,%%gs\n"=0A-		=
"\tmovl %%eax,%%ss\n"=0A-		: : : "eax", "memory");=0A-#undef =
STR=0A-#undef __STR=0A-}=0A-=0A static void machine_kexec_free_page_tables(=
struct kimage *image)=0A {=0A 	free_page((unsigned long)image->arch.pgd);=
=0A@@ -227,24 +185,6 @@ void machine_kexec(struct kimage *image)=0A 		=
page_list[PA_SWAP_PAGE] =3D (page_to_pfn(image->swap_page)=0A 			=
			<< PAGE_SHIFT);=0A =0A-	/*=0A-	 * The segment =
registers are funny things, they have both a=0A-	 * visible and an =
invisible part.  Whenever the visible part is=0A-	 * set to a =
specific selector, the invisible part is loaded=0A-	 * with from a =
table in memory.  At no other time is the=0A-	 * descriptor table in =
memory accessed.=0A-	 *=0A-	 * I take advantage of this here by force =
loading the=0A-	 * segments, before I zap the gdt with an invalid =
value.=0A-	 */=0A-	load_segments();=0A-	/*=0A-	 * The gdt & idt =
are now invalid.=0A-	 * If you want to load them you must set up your =
own idt & gdt.=0A-	 */=0A-	set_gdt(phys_to_virt(0), 0);=0A-	=
set_idt(phys_to_virt(0), 0);=0A-=0A 	/* now call it */=0A 	image->star=
t =3D relocate_kernel_ptr((unsigned long)image->head,=0A 			=
		   (unsigned long)page_list,=0A--- head.orig/arch/x86/kerne=
l/relocate_kernel_32.S	2011-10-24 09:10:05.000000000 +0200=0A+++ =
head/arch/x86/kernel/relocate_kernel_32.S	2011-08-09 10:21:17.0000000=
00 +0200=0A@@ -87,14 +87,32 @@ relocate_kernel:=0A 	movl	PTR(PA_PGD)=
(%ebp), %eax=0A 	movl	%eax, %cr3=0A =0A+	/* setup idt =
*/=0A+	lidtl	idt_48 - relocate_kernel(%edi)=0A+=0A+	/* setup gdt =
*/=0A+	leal	gdt - relocate_kernel(%edi), %eax=0A+	movl	%eax, =
(gdt_48 - relocate_kernel) + 2(%edi)=0A+	lgdtl	gdt_48 - relocate_k=
ernel(%edi)=0A+=0A+	/* setup data segment registers */=0A+	mov	=
$(gdt_ds - gdt), %eax=0A+	mov	%eax, %ds=0A+	mov	%eax, =
%es=0A+	mov	%eax, %fs=0A+	mov	%eax, %gs=0A+	mov	%eax, =
%ss=0A+=0A 	/* setup a new stack at the end of the physical control =
page */=0A 	lea	PAGE_SIZE(%edi), %esp=0A =0A-	/* jump to =
identity mapped page */=0A+	/* load new code segment and jump to =
identity mapped page */=0A+	pushl	$0=0A+	pushl	$(gdt_cs - gdt)=0A =
	movl    %edi, %eax=0A 	addl    $(identity_mapped - relocate_kernel=
), %eax=0A 	pushl   %eax=0A-	ret=0A+	iretl=0A =0A identity_mappe=
d:=0A 	/* set return address to 0 if not preserving context */=0A@@ =
-273,5 +291,22 @@ swap_pages:=0A 	popl	%ebp=0A 	ret=0A =
=0A+	.align	16=0A+gdt:=0A+	.quad	0x0000000000000000	/* NULL =
descriptor */=0A+gdt_cs:=0A+	.quad	0x00cf9a000000ffff	/* kernel =
4GB code at 0x00000000 */=0A+gdt_ds:=0A+	.quad	0x00cf92000000ffff	=
/* kernel 4GB data at 0x00000000 */=0A+gdt_end:=0A+=0A+gdt_48:=0A+	=
.word	gdt_end - gdt - 1	/* limit */=0A+	.long	0			=
/* base - filled in by code above */=0A+=0A+idt_48:=0A+	.word	0		=
	/* limit */=0A+	.long	0			/* base */=0A+=0A 	=
.globl kexec_control_code_size=0A .set kexec_control_code_size, . - =
relocate_kernel=0A
--=__PartD5E4EDD3.3__=--
