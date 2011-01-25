Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1AYNve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:51:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46257 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1AYNvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JgbWZZAkweoAEPeLauDYcJ58/oA8YZ47ZYL37OEXVpRcqj37t4paRMjrCMv6w7emN/
         y+MNTI0kiaD37n0vbnLWONTI7d2wTATnzSJ/ogSIVBGOpsqTqu1RnI0W0kvnKGjcvgC8
         ztJUDT+SydCLnY8avuphyU2wLTktu1ivWHneU=
Date: Tue, 25 Jan 2011 15:51:22 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next 1/2][RFC] x86: Saveoops: Switch to real-mode and call
	BIOS
Message-ID: <20110125135122.GB10051@laptop>
References: <20110125134748.GA10051@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110125134748.GA10051@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We get called here upon panic()s to save the kernel log buffer.

First, switch from 64-bit long mode to 16-bit real mode. Afterwards, save the
log buffer to disk using extended INT 0x13 BIOS services. The user has given
us an absolute LBA disk address to save the log buffer to.

By x86 design, this code is mandated to run on a single identity-mapped page.

- How to initialize the disk hardware to its POST state (thus making the
  BIOS code work reliably) while keeping system RAM unmodified?

- Is it guaranteed that '0x80' will always be the boot disk drive number?
  If not, we need to be passed the boot drive number from the bootloader.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 arch/x86/kernel/saveoops-rmode.S |  483 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 483 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/saveoops-rmode.S b/arch/x86/kernel/saveoops-rmode.S
new file mode 100644
index 0000000..6e07112
--- /dev/null
+++ b/arch/x86/kernel/saveoops-rmode.S
@@ -0,0 +1,483 @@
+/* PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE */
+
+/*
+ * Saveoops LongMode -> RealMode switch
+ *
+ * Don't come here with any unfinished business at hand, there's no return.
+ * After writing the log buffer to disk, we just halt.
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/processor-flags.h>
+#include <asm/msr-index.h>
+#include <asm/pgtable_types.h>
+#include <asm/segment.h>
+#include <asm/saveoops.h>
+
+/*
+ * Notes:
+ * - Avoid using relocatable symbols: we run from a different place than
+ *   where we're originally linked to. Use absolute addresses
+ * - Run this from an identity page since we disable paging
+ * - Dynamic values are used for all x86 table bases to let this code run
+ *   from *any* memory region below 1-Mbyte
+ */
+	.code64
+ENTRY(saveoops_start)
+	/*
+	 * Switch to 32bit-compatibility mode using a L=0 code segment
+	 */
+
+	cli
+
+	/* Permanently store passed parameters */
+	movq	%rdi, %rbp
+	movl	%esi, (ringbuf_addr - saveoops_start)(%ebp)
+	movl	%edx, (rstack_base - saveoops_start)(%ebp)
+	movq	%rcx, (disk_sector - saveoops_start)(%ebp)
+	movl	%r8d, (ringbuf_len - saveoops_start)(%ebp)
+
+	/* Dynamically set the 32bit-compat. GDTR base */
+	leaq	(lmode32_gdt - saveoops_start)(%ebp), %rax
+	movq	%rax, (lmode32_gdt + 2 - saveoops_start)(%ebp)
+
+	/* Dynamically set the 32bit farpointer base */
+	leal	(compat32 - saveoops_start)(%ebp), %eax
+	movl	%eax, (lmode32_farpointer - saveoops_start)(%ebp)
+
+	lgdt	(lmode32_gdt - saveoops_start)(%ebp)
+	ljmpl	*(lmode32_farpointer - saveoops_start)(%ebp)	# addr32
+
+	.code32
+compat32:
+	/*
+	 * 32bit-compatibility Long Mode, using a L=0 %cs
+	 */
+
+	movw	$__KERNEL_DS, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %ss
+
+	/* 'Deactivate' long mode: disable paging */
+	movl	%cr0, %eax
+	andl    $~X86_CR0_PG, %eax
+	movl    %eax, %cr0
+
+	/*
+	 * Prepare identity maps for the first 2Mbytes. PAE is already
+	 * enabled from the original pmode -> lmode transition.
+	 *
+	 * Reuse head.S page tables instead of creating new ones. Such
+	 * early tables are in fact already reused by the newer direct
+	 * mapping tables, but since paging is now disabled (and we're
+	 * not returning back), hopefully nothing will blow up.
+	 */
+
+	/*
+	 * Pick a table for the PAE Page Directory (PD)
+	 */
+
+	.equ	level2_pae_ident_pgt, (level2_ident_pgt - __START_KERNEL_map)
+	.equ	level2_entry_count, 512
+	.equ	level2_entry_len, 8
+
+	xorl	%eax, %eax
+	movl	$level2_pae_ident_pgt, %edi
+	movl    $((level2_entry_count * level2_entry_len) / 4), %ecx
+	rep	stosl
+
+	movl	$(0 + __PAGE_KERNEL_IDENT_LARGE_EXEC), level2_pae_ident_pgt
+
+	/*
+	 * Pick a table for for the PAE Page Directory Pointer (PDP)
+	 */
+
+	.equ	level3_pae_ident_pgt, (level2_spare_pgt - __START_KERNEL_map)
+	.equ	level3_entry_count, 4
+	.equ	level3_entry_len, 8
+
+	xorl	%eax, %eax
+	movl	$level3_pae_ident_pgt, %edi
+	movl    $((level3_entry_count * level3_entry_len) / 4), %ecx
+	rep	stosl
+
+	movl	$(level2_pae_ident_pgt + _PAGE_PRESENT), level3_pae_ident_pgt
+
+	movl	$level3_pae_ident_pgt, %eax
+	movl    %eax, %cr3
+
+	/* 'Disable' long mode: clear the EFER.LME bit */
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btcl	$_EFER_LME, %eax
+	wrmsr
+
+	/* Finally, move to 32-bit pmode: re-enabling paging */
+	movl	%cr0, %eax
+	orl     $X86_CR0_PG, %eax
+	movl    %eax, %cr0
+	jmp	pmode32			# flush prefetch
+
+pmode32:
+	/*
+	 * 32-bit protected mode, using a 2MB identity page.
+	 */
+
+	/* Paging was only enabled for the lmode->pmode step */
+	movl	%cr0, %eax
+	andl    $~X86_CR0_PG, %eax
+	movl    %eax, %cr0		# paging no more
+
+	xorl	%eax, %eax
+	movl	%eax, %cr3		# flush the TLB
+
+	/* Dynamically set the GDTR base value */
+	leal	(pmode16_gdt - saveoops_start)(%ebp), %eax
+	movl	%eax, (pmode16_gdt + 2 - saveoops_start)(%ebp)	# base[00:32]
+
+	/* Dynamically set %cs and %ds bases */
+	leal	(pmode16 - saveoops_start)(%ebp), %eax
+	movw	%ax, (pmode16_cs + 2 - saveoops_start)(%ebp)	# base[00:15]
+	movw	%ax, (pmode16_ds + 2 - saveoops_start)(%ebp)	# base[00:15]
+	shrl	$16, %eax
+	movb	%al, (pmode16_cs + 4 - saveoops_start)(%ebp)	# base[16:23]
+	movb	%al, (pmode16_ds + 4 - saveoops_start)(%ebp)	# base[16:23]
+
+	/* Load the 16-bit code and data segments */
+	lgdt	(pmode16_gdt - saveoops_start)(%ebp)
+
+	/* Switch to 16-bit pmode: use the setup 16-bit %cs */
+	ljmp	$0x08, $0x0
+
+	/*
+	 * - “Segment base addresses should be 16-byte aligned” --Intel
+	 * - We also use this as the rmode code base; the 16-byte align
+	 *   will make address caclulations much easier.
+	 */
+	.align 16
+	.globl pmode16
+	.code16
+pmode16:
+	/*
+	 * We're now in the 16-bit protected mode. Since PE is still = 1,
+	 * we can change a segment cache by loading a GDT selector value.
+	 */
+
+	movw	$0x10, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %fs
+	movw	%ax, %gs
+	movw	%ax, %ss
+
+	/*
+	 * NOTE! Due to the new %cs and %ds bases, dereference addresses
+	 * using the from ‘label - pmode16’ from now on.
+	 */
+
+	/* Dynamically build an rmode segment and offset */
+	leal	(pmode16 - saveoops_start)(%ebp), %eax		# absolute value
+	shrl	$4, %eax
+	movw	%ax, rmode_farpointer - pmode16 + 2		# 8086 %cs
+	movw	$(rmode - pmode16), rmode_farpointer - pmode16	# offset
+
+	/* Restore real-mode BIOS interrupt entries */
+	lidt   (rmode_idtr - pmode16)
+
+	/* Switch to canonical real-mode: clear PE */
+	movl	%cr0, %eax
+	andl	$~X86_CR0_PE, %eax
+	movl	%eax, %cr0
+
+	/* Flush prefetch; use the 8086 code segment */
+	ljmp	*(rmode_farpointer - pmode16)
+
+#ifdef	SAVEOOPS_DEBUG
+	/*
+	 * Valid for any real-mode context where a stack exists
+	 */
+#define __print(msg)		;\
+	pushfl			;\
+	pushal			;\
+	pushw	$(1f - pmode16) ;\
+	call	print_string	;\
+	.ascii	"Saveoops: "	;\
+	.ascii	msg		;\
+	.asciz	"      \n\r"	;\
+1:	popal			;\
+	popfl
+#else
+#define __print(msg)		;
+#endif
+
+	.align 16
+rmode:
+	/*
+	 * REAL Mode, at last!
+	 *
+	 * For further details on the BIOS interrupts used, check any
+	 * version of the “Enhanced Disk Drive Specification”.
+	 */
+
+	movw	%cs, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %fs
+	movw	%ax, %gs
+
+	/* Setup passed stack area */
+	movl	(rstack_base - pmode16), %eax
+	shrl	$4, %eax			# 16byte-aligned
+	movw	%ax, %ss
+	movw	$RMODE_STACK_LEN, %sp
+
+	__print	("Entered real mode")
+
+	/*
+	 * XXXX: We always use the boot disk drive number '0x80'. Can
+	 * this map to a wrong device?
+	 *
+	 * NOTE! Do not trust the BIOS: assume it clobbered all the
+	 * registers (relevant and not) while servicing interrupts.
+	 */
+
+	/*
+	 * Check Extensions Present (0x41) - Does the BIOS provide
+	 * EDD int 0x13 extensions?
+	 *
+	 * input  %bx     - 0x55aa
+	 * input  %dl     - drive number
+	 * output success - carry = 0 && bx = 0xaa55 && cx bit0 = 1
+	 * output failure - carry = 1 || any false condition above
+	 */
+	movb	$0x41, %ah
+	movw	$0x55aa, %bx
+	movb	$0x80, %dl
+	xorw	%cx, %cx
+	pushw	%ds
+	int	$0x13
+	popw	%ds
+	__print	("Queried BIOS for EDD services")
+	jc	no_edd1
+	cmpw	$0xaa55, %bx
+	jne	no_edd2
+	shrw	$1, %cx
+	jnc	no_edd3
+
+	/* Store 16byte-aligned ring buffer address in disk packet */
+	movl	(ringbuf_addr - pmode16), %eax
+	shrl	$4, %eax
+	movw	%ax, (buffer_seg - pmode16)
+	xorw	%ax, %ax
+	movw	%ax, (buffer_offset - pmode16)
+
+	/* Store ringbuf number of 512-byte blocks in disk packet */
+	movl	(ringbuf_len - pmode16), %eax
+	movb	%al, (sectors_cnt - pmode16)
+
+	__print	("Prepared the Disk Address Packet")
+
+	/*
+	 * Reset Hard Disks (0x00)
+	 *
+	 * input  %dl	  - drive number
+	 * output success - carry = 0 && %ah (err code) = 0
+	 * output failure - carry = 1 || %ah = error code
+	 *
+	 * The kernel has just paniced and left the disk controller
+	 * in an unknown state. Reset controllers before write.
+	 */
+	xorw	%ax, %ax
+	movb	$0x80, %dl
+	pushw	%ds
+	int	$0x13
+	popw	%ds
+	__print	("Disk controller reset")
+	jc	init_err1
+	cmpb	$0x0, %ah
+	jne	init_err2
+
+	/*
+	 * Extended Write (0x43) - Transfer data from RAM to disk
+	 *
+	 * input  %al     - 0 (write with verify off)
+	 * input  %dl     - drive number
+	 * input  %ds:si  - pointer to the Disk Address Packet
+	 * output success - carry = 0 && %ah (err code) = 0
+	 * output failure - carry = 1 || %ah = error code
+	 */
+	movb	$0x43, %ah
+	xorb	%al, %al
+	movb	$0x80, %dl
+	movw	$(disk_address_packet - pmode16), %si
+	pushw	%ds
+	int	$0x13
+	popw	%ds
+	__print	("Extended write finished")
+	jc	write_err1
+	cmpb	$0x0, %ah
+	jne	write_err2
+	jmp	success
+
+init_err1:
+	__print ("INT 0x13/0x0 init error 1")
+	jmp	print_errcode
+init_err2:
+	__print ("INT 0x13/0x0 init error 2")
+	jmp	print_errcode
+write_err1:
+	__print	("INT 0x13/0x43 write error 1")
+	jmp	print_errcode
+write_err2:
+	__print	("INT 0x13/0x43 write error 2")
+	jmp	print_errcode
+no_edd1:
+	__print	("Bios does not support EDD service (err=1)")
+	jmp	print_errcode
+no_edd2:
+	__print	("Bios does not support EDD service (err=2)")
+	jmp	print_errcode
+no_edd3:
+	__print	("Bios does not support EDD service (err=3)")
+	jmp	print_errcode
+success:
+	__print	("Sucess!!!")
+	jmp	print_errcode
+
+halt:	hlt
+	jmp	halt
+
+#ifdef	SAVEOOPS_DEBUG
+	/*
+	 * Print Null-terminated string pointed by top of the stack
+	 */
+	.type	print_string, @function
+print_string:
+	popw	%si
+1:	xorb	%bh, %bh
+	movb	$0x0e, %ah
+	lodsb
+	cmpb	$0, %al
+	je	2f
+	int	$0x10
+	jmp	1b
+2:	ret
+
+	/*
+	 * print %dx value in hexadecimal ascii
+	 */
+	.type	print_hex, @function
+print_hex:
+	xorb   %bh, %bh
+	movw   $4, %cx			# 2-bytes = 4 hex digits
+print_digit:
+	rolw   $4, %dx			# highest-order 4 bits in front
+	movw   $0x0e0f, %ax		# bios function 0x0e
+	andb   %dl, %al
+	cmpb   $0x0a, %al		# transform to ASCII
+	jl     digit
+	addb   $0x07, %al
+digit:
+	addb   $0x30, %al
+	int    $0x10
+	loop   print_digit
+	ret
+
+	/*
+	 * Print INT13 err code, number of sectors written
+	 */
+print_errcode:
+	movb	%ah, %dl
+	call	print_hex
+	movw	(sectors_cnt - pmode16), %dx
+	call	print_hex
+	jmp	halt
+#else
+print_errcode:
+	jmp	halt
+#endif
+
+
+/*
+ * Virtual data section; ‘(dyn.)’ = A dynamically-set value
+ */
+
+	.align 16
+lmode32_gdt:
+	.word	lmode32_gdt_end - lmode32_gdt - 1
+	.quad	0x0000000000000000	# base (dyn.)
+	.word	0, 0, 0			# padding
+lmode32_cs:
+	.word	0xffff			# limit
+	.word	0x0000			# base
+	.word	0x9a00			# P=1, C=0, type=0xA (r/x)
+	.word   0x00cf			# L=0 (compat.), D=1 (32-bit), G=1
+lmode32_ds:
+	.word	0xffff			# limit
+	.word	0x0000			# base
+	.word	0x9200			# P=1, type=0x2 (r/w)
+	.word	0x00cf			# G=1, D=1 (32-bit)
+lmode32_gdt_end:
+
+lmode32_farpointer:
+	.long	0x00000000		# offset (dyn.)
+	.word	lmode32_cs -lmode32_gdt # %cs selector
+
+	.align 16
+pmode16_gdt:
+	.word	pmode16_gdt_end - pmode16_gdt - 1
+	.long	0x00000000		# base (dyn.)
+	.word	0x0000			# padding
+pmode16_cs:
+	.word	0xffff			# limit
+	.word	0x0000			# base (dyn.)
+	.word	0x9a00			# P=1, DPL=00, type=0xA (execute/read)
+	.word	0x0000			# G=0 (byte), D=0 (16-bit)
+pmode16_ds:
+	.word	0xffff			# limit
+	.word	0x0000			# base (dyn.)
+	.word	0x9200			# P=1, DPL=00, type=0x2 (read/write)
+	.word	0x0000			# G=0 (byte), D=0 (16-bit)
+pmode16_gdt_end:
+
+rmode_farpointer:
+	.word	0x0000			# offset (dyn.)
+	.word	0x0000			# %cs (dyn.)
+
+rmode_idtr:
+	.equ	RIDT_BASE, 0x0		# PC architecture defined
+	.equ	RIDT_ENTRY_SIZE, 0x4	# 8086 defined
+	.equ	RIDT_ENTRIES, 0x100	# 8086, 286, 386+ defined
+	.word	RIDT_ENTRIES * RIDT_ENTRY_SIZE - 1
+	.long	RIDT_BASE
+
+	/* Values passed by long-mode C code */
+ringbuf_addr:
+	.long	0x00000000		# 16-byte aligned, < 1-MB (dyn.)
+ringbuf_len:
+	.long	0x00000000		# 512-byte aligned (dyn.)
+rstack_base:
+	.long	0x00000000		# 16-byte aligned, < 1-MB (dyn.)
+
+	.align 16
+disk_address_packet:			# for extended INT 0x13 services (dyn.)
+packet_size:
+	.byte	0x10			# in bytes
+reserved0:
+	.byte	0x00			# must be zero
+sectors_cnt:
+	.byte	0x00			# number of blocks to transfer [1 - 127]
+reserved1:
+	.byte	0x00			# must be zero
+buffer_offset:
+	.word	0x0000			# read/write buffer offset
+buffer_seg:
+	.word	0x0000			# read/write buffer segment
+disk_sector:
+	.quad	0x0000000000000000	# logical sector number (LBA)
+
+ENTRY(saveoops_end)
+
+/* PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE */

--
Darwish
http://darwish.07.googlepages.com
