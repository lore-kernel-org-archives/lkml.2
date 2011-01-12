Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1ALR0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:26:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46761 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1ALR0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:26:04 -0500
Date: Wed, 12 Jan 2011 17:25:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to
	setup.c
Message-ID: <20110112172552.GF11039@n2100.arm.linux.org.uk>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6> <20110111104051.GA11039@n2100.arm.linux.org.uk> <20110111153630.GB2707@angua.secretlab.ca> <20110111154833.GF11039@n2100.arm.linux.org.uk> <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com> <20110112155215.GB11039@n2100.arm.linux.org.uk> <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com> <alpine.LFD.2.00.1101121145430.24532@xanadu.home> <AANLkTinPibTVUu2zoMbDYnSWXGvB6dVjCp54DoN9S1p3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPibTVUu2zoMbDYnSWXGvB6dVjCp54DoN9S1p3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:16:44AM -0700, Grant Likely wrote:
> On Wed, Jan 12, 2011 at 9:53 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Wed, 12 Jan 2011, Grant Likely wrote:
> >
> >> Actually it looks like the real problem is that the mmu has been
> >> turned on, but the virtual mappings for devices have not yet been
> >> established, and so the debug macros aren't using a valid address.
> >
> > A temporary virtual mapping should be there -- look for addruart in
> > head.S.
> 
> Hi Russell and Nicolas,
> 
> Oops, yes all the early debug stuff works fine.  Stupid human trick on
> my end, but I've sorted it out now.  Thanks for the help.  I'll have
> patches to post later today.

I just hacked this up, and on Versatile (real hardware) it produces
the below for an invalid r1 value - and of course works for a proper r1
value.

Uncompressing Linux... done, booting the kernel.

Error: unrecognized/unsupported machine ID (r1 = 0x00123456).

Available machine support:

ID (hex)        NAME
00000183        ARM-Versatile PB
0000025e        ARM-Versatile AB

Please check your kernel config and/or bootloader.

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index bbecaac..c84b57d 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -25,81 +25,6 @@
  * machine ID for example).
  */
 	__HEAD
-__error_a:
-#ifdef CONFIG_DEBUG_LL
-	mov	r4, r1				@ preserve machine ID
-	adr	r0, str_a1
-	bl	printascii
-	mov	r0, r4
-	bl	printhex8
-	adr	r0, str_a2
-	bl	printascii
-	adr	r3, __lookup_machine_type_data
-	ldmia	r3, {r4, r5, r6}		@ get machine desc list
-	sub	r4, r3, r4			@ get offset between virt&phys
-	add	r5, r5, r4			@ convert virt addresses to
-	add	r6, r6, r4			@ physical address space
-1:	ldr	r0, [r5, #MACHINFO_TYPE]	@ get machine type
-	bl	printhex8
-	mov	r0, #'\t'
-	bl	printch
-	ldr     r0, [r5, #MACHINFO_NAME]	@ get machine name
-	add	r0, r0, r4
-	bl	printascii
-	mov	r0, #'\n'
-	bl	printch
-	add	r5, r5, #SIZEOF_MACHINE_DESC	@ next machine_desc
-	cmp	r5, r6
-	blo	1b
-	adr	r0, str_a3
-	bl	printascii
-	b	__error
-ENDPROC(__error_a)
-
-str_a1:	.asciz	"\nError: unrecognized/unsupported machine ID (r1 = 0x"
-str_a2:	.asciz	").\n\nAvailable machine support:\n\nID (hex)\tNAME\n"
-str_a3:	.asciz	"\nPlease check your kernel config and/or bootloader.\n"
-	.align
-#endif
-
-/*
- * Lookup machine architecture in the linker-build list of architectures.
- * Note that we can't use the absolute addresses for the __arch_info
- * lists since we aren't running with the MMU on (and therefore, we are
- * not in the correct address space).  We have to calculate the offset.
- *
- *  r1 = machine architecture number
- * Returns:
- *  r3, r4, r6 corrupted
- *  r5 = mach_info pointer in physical address space
- */
-__lookup_machine_type:
-	adr	r3, __lookup_machine_type_data
-	ldmia	r3, {r4, r5, r6}
-	sub	r3, r3, r4			@ get offset between virt&phys
-	add	r5, r5, r3			@ convert virt addresses to
-	add	r6, r6, r3			@ physical address space
-1:	ldr	r3, [r5, #MACHINFO_TYPE]	@ get machine type
-	teq	r3, r1				@ matches loader number?
-	beq	2f				@ found
-	add	r5, r5, #SIZEOF_MACHINE_DESC	@ next machine_desc
-	cmp	r5, r6
-	blo	1b
-	mov	r5, #0				@ unknown machine
-2:	mov	pc, lr
-ENDPROC(__lookup_machine_type)
-
-/*
- * Look in arch/arm/kernel/arch.[ch] for information about the
- * __arch_info structures.
- */
-	.align	2
-	.type	__lookup_machine_type_data, %object
-__lookup_machine_type_data:
-	.long	.
-	.long	__arch_info_begin
-	.long	__arch_info_end
-	.size	__lookup_machine_type_data, . - __lookup_machine_type_data
 
 /* Determine validity of the r2 atags pointer.  The heuristic requires
  * that the pointer be aligned, in the first 16k of physical RAM and
@@ -107,8 +32,6 @@ __lookup_machine_type_data:
  * of this function may be more lenient with the physical address and
  * may also be able to move the ATAGS block if necessary.
  *
- * r8  = machinfo
- *
  * Returns:
  *  r2 either valid atags pointer, or zero
  *  r5, r6 corrupted
@@ -183,17 +106,6 @@ __mmap_switched_data:
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
 /*
- * This provides a C-API version of __lookup_machine_type
- */
-ENTRY(lookup_machine_type)
-	stmfd	sp!, {r4 - r6, lr}
-	mov	r1, r0
-	bl	__lookup_machine_type
-	mov	r0, r5
-	ldmfd	sp!, {r4 - r6, pc}
-ENDPROC(lookup_machine_type)
-
-/*
  * This provides a C-API version of __lookup_processor_type
  */
 ENTRY(lookup_processor_type)
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index 814ce1a..6b1e0ad 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -44,9 +44,6 @@ ENTRY(stext)
 	bl	__lookup_processor_type		@ r5=procinfo r9=cpuid
 	movs	r10, r5				@ invalid processor (r5=0)?
 	beq	__error_p				@ yes, error 'p'
-	bl	__lookup_machine_type		@ r5=machinfo
-	movs	r8, r5				@ invalid machine (r5=0)?
-	beq	__error_a			@ yes, error 'a'
 
 	adr	lr, BSYM(__after_proc_init)	@ return (PIC) address
  ARM(	add	pc, r10, #PROCINFO_INITFUNC	)
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 06aed19..084db6c 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -87,14 +87,10 @@ ENTRY(stext)
 	movs	r10, r5				@ invalid processor (r5=0)?
  THUMB( it	eq )		@ force fixup-able long branch encoding
 	beq	__error_p			@ yes, error 'p'
-	bl	__lookup_machine_type		@ r5=machinfo
-	movs	r8, r5				@ invalid machine (r5=0)?
- THUMB( it	eq )		@ force fixup-able long branch encoding
-	beq	__error_a			@ yes, error 'a'
 
 	/*
 	 * r1 = machine no, r2 = atags,
-	 * r8 = machinfo, r9 = cpuid, r10 = procinfo
+	 * r9 = cpuid, r10 = procinfo
 	 */
 	bl	__vet_atags
 #ifdef CONFIG_SMP_ON_UP
@@ -108,7 +104,7 @@ ENTRY(stext)
 	/*
 	 * The following calls CPU specific code in a position independent
 	 * manner.  See arch/arm/mm/proc-*.S for details.  r10 = base of
-	 * xxx_proc_info structure selected by __lookup_machine_type
+	 * xxx_proc_info structure selected by __lookup_processor_type
 	 * above.  On return, the CPU will be ready for the MMU to be
 	 * turned on, and r0 will hold the CPU control register value.
 	 */
@@ -127,7 +123,6 @@ ENDPROC(stext)
  * amount which are required to get the kernel running, which
  * generally means mapping in the kernel code.
  *
- * r8  = machinfo
  * r9  = cpuid
  * r10 = procinfo
  *
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 7c5499d..eb952a7 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -308,7 +308,44 @@ static void __init cacheid_init(void)
  * already provide the required functionality.
  */
 extern struct proc_info_list *lookup_processor_type(unsigned int);
-extern struct machine_desc *lookup_machine_type(unsigned int);
+
+static void __init early_print(const char *str, ...)
+{
+	extern void printascii(const char *);
+	char buf[256];
+	va_list ap;
+
+	va_start(ap, str);
+	vsnprintf(buf, sizeof(buf), str, ap);
+	va_end(ap);
+
+#ifdef CONFIG_DEBUG_LL
+	printascii(buf);
+#endif
+	printk("%s", buf);
+}
+
+static struct machine_desc * __init lookup_machine_type(unsigned int type)
+{
+	extern struct machine_desc __arch_info_begin[], __arch_info_end[];
+	struct machine_desc *p;
+
+	for (p = __arch_info_begin; p < __arch_info_end; p++)
+		if (type == p->nr)
+			return p;
+
+	early_print("\n"
+		"Error: unrecognized/unsupported machine ID (r1 = 0x%08x).\n\n"
+		"Available machine support:\n\nID (hex)\tNAME\n", type);
+
+	for (p = __arch_info_begin; p < __arch_info_end; p++)
+		early_print("%08x\t%s\n", p->nr, p->name);
+
+	early_print("\nPlease check your kernel config and/or bootloader.\n");
+
+	while (true)
+		/* can't use cpu_relax() here as it may require MMU setup */;
+}
 
 static void __init feat_v6_fixup(void)
 {

