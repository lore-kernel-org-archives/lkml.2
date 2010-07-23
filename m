Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0GWUfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:35:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39506 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0GWUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:35:45 -0400
Date: Fri, 23 Jul 2010 22:35:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Message-ID: <20100723203543.GB27288@merkur.ravnborg.org>
References: <201007181703.17022.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007181703.17022.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Then, in order to also garbage-collect the sections, I added
> 
> LDFLAGS_vmlinux += --gc-sections
> 
> in top-level Makefile.
> 
> This requires the additional patch (linux-2.6.35-rc4-fsgs.patch)
> which adds KEEP(section) directives to kernel linker stripts.
> Otherwise, linker will discard some crucial sections.
> 

Changelog does not address why you need:

     -Map $@.ldmap

and what effect they have.

And it is obvious that some archs should consolidate a little more from
asm-generic/vmlinux.lds.h.
But that said this patch looks much better than the initial versions posted.

How do you determine which sections needs the KEEP()?
Worth documenting for future when we add new sections.

	Sam


--- linux-2.6.35-rc4.fs/Makefile
+++ linux-2.6.35-rc4-fsgs.obj/Makefile
@@ -610,6 +610,8 @@
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
+LDFLAGS_vmlinux += --gc-sections
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
@@ -705,7 +707,7 @@
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
 quiet_cmd_vmlinux__ ?= LD      $@
-      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
+      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ -Map $@.ldmap \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
       --start-group $(vmlinux-main) --end-group                  \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
--- linux-2.6.35-rc4.fs/arch/arm/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/arm/kernel/vmlinux.lds.S
@@ -157,7 +157,7 @@
 		. = ALIGN(32);
 		__start___ex_table = .;
 #ifdef CONFIG_MMU
-		*(__ex_table)
+		KEEP(*(__ex_table))
 #endif
 		__stop___ex_table = .;
 
--- linux-2.6.35-rc4.fs/arch/blackfin/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/blackfin/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@
 
 		. = ALIGN(16);
 		___start___ex_table = .;
-		*(__ex_table)
+		KEEP(*(__ex_table))
 		___stop___ex_table = .;
 
 		__etext = .;
--- linux-2.6.35-rc4.fs/arch/cris/boot/rescue/rescue_v32.lds
+++ linux-2.6.35-rc4-fsgs.obj/arch/cris/boot/rescue/rescue_v32.lds
@@ -36,7 +36,7 @@
 	/* Get rid of stuff from EXPORT_SYMBOL(foo). */
 	/DISCARD/ :
 	{
-	        *(__ksymtab_strings)
-	        *(__ksymtab)
+		KEEP(*(__ksymtab_strings))
+		*(__ksymtab)
 	}
 }
--- linux-2.6.35-rc4.fs/arch/cris/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/cris/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@
 	.init.setup : { INIT_SETUP(16) }
 #ifdef CONFIG_ETRAX_ARCH_V32
 	__start___param = .;
-	__param : { *(__param) }
+	__param : { KEEP(*(__param)) }
 	__stop___param = .;
 #endif
 	.initcall.init : {
@@ -88,7 +88,7 @@
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
 		__initramfs_start = .;
-		*(.init.ramfs)
+		KEEP(*(.init.ramfs))
 		__initramfs_end = .;
 	}
 #endif
--- linux-2.6.35-rc4.fs/arch/h8300/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/h8300/kernel/vmlinux.lds.S
@@ -112,7 +112,7 @@
 	. = ALIGN(0x4) ;
 	INIT_SETUP(0x4)
 	___setup_start = .;
-		*(.init.setup)
+		KEEP(*(.init.setup))
 	. = ALIGN(0x4) ;
 	___setup_end = .;
 	INIT_CALLS
--- linux-2.6.35-rc4.fs/arch/m68knommu/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/m68knommu/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
-		*(__ex_table)
+		KEEP(*(__ex_table))
 		__stop___ex_table = .;
 
 		*(.rodata .rodata.*)
@@ -129,16 +129,16 @@
 
 		/* Kernel symbol table: GPL-future symbols */
 		__start___kcrctab_gpl_future = .;
-		*(__kcrctab_gpl_future)
+		KEEP(*(__kcrctab_gpl_future))
 		__stop___kcrctab_gpl_future = .;
 
 		/* Kernel symbol table: strings */
-		*(__ksymtab_strings)
+		KEEP(*(__ksymtab_strings))
 
 		/* Built-in module parameters */
 		. = ALIGN(4) ;
 		__start___param = .;
-		*(__param)
+		KEEP(*(__param))
 		__stop___param = .;
 
 		. = ALIGN(4) ;
--- linux-2.6.35-rc4.fs/arch/microblaze/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/microblaze/kernel/vmlinux.lds.S
@@ -122,7 +122,7 @@
 
 	.init.ramfs ALIGN(4096) : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 		__initramfs_start = .;
-		*(.init.ramfs)
+		KEEP(*(.init.ramfs))
 		__initramfs_end = .;
 		. = ALIGN(4);
 		LONG(0);
--- linux-2.6.35-rc4.fs/arch/mn10300/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/mn10300/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@
   . = ALIGN(PAGE_SIZE);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
-	*(.smp_locks)
+	KEEP(*(.smp_locks))
 	__smp_locks_end = .;
   }
 
@@ -62,9 +62,9 @@
   INIT_DATA_SECTION(16)
   . = ALIGN(4);
   __alt_instructions = .;
-  .altinstructions : { *(.altinstructions) }
+  .altinstructions : { KEEP(*(.altinstructions)) }
   __alt_instructions_end = .;
- .altinstr_replacement : { *(.altinstr_replacement) }
+ .altinstr_replacement : { KEEP(*(.altinstr_replacement)) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
 	.exit.text : { EXIT_TEXT; }
--- linux-2.6.35-rc4.fs/arch/um/include/asm/common.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/um/include/asm/common.lds.S
@@ -76,10 +76,10 @@
   . = ALIGN(4);
   .altinstructions : {
 	__alt_instructions = .;
-	*(.altinstructions)
+	KEEP(*(.altinstructions))
 	__alt_instructions_end = .;
   }
-  .altinstr_replacement : { *(.altinstr_replacement) }
+  .altinstr_replacement : { KEEP(*(.altinstr_replacement)) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
--- linux-2.6.35-rc4.fs/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/x86/kernel/vmlinux.lds.S
@@ -162,46 +162,46 @@
 
 	. = VSYSCALL_ADDR;
 	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
-		*(.vsyscall_0)
+		KEEP(*(.vsyscall_0))
 	} :user
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
-		*(.vsyscall_fn)
+		KEEP(*(.vsyscall_fn))
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
-		*(.vsyscall_gtod_data)
+		KEEP(*(.vsyscall_gtod_data))
 	}
 
 	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
-		*(.vsyscall_clock)
+		KEEP(*(.vsyscall_clock))
 	}
 	vsyscall_clock = VVIRT(.vsyscall_clock);
 
 
 	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
-		*(.vsyscall_1)
+		KEEP(*(.vsyscall_1))
 	}
 	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
-		*(.vsyscall_2)
+		KEEP(*(.vsyscall_2))
 	}
 
 	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
-		*(.vgetcpu_mode)
+		KEEP(*(.vgetcpu_mode))
 	}
 	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.jiffies : AT(VLOAD(.jiffies)) {
-		*(.jiffies)
+		KEEP(*(.jiffies))
 	}
 	jiffies = VVIRT(.jiffies);
 
 	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
+		KEEP(*(.vsyscall_3))
 	}
 
 	. = __vsyscall_0 + PAGE_SIZE;
@@ -252,12 +252,12 @@
 	. = ALIGN(8);
 	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 		__alt_instructions = .;
-		*(.altinstructions)
+		KEEP(*(.altinstructions))
 		__alt_instructions_end = .;
 	}
 
 	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-		*(.altinstr_replacement)
+		KEEP(*(.altinstr_replacement))
 	}
 
 	/*
@@ -290,7 +290,7 @@
 	. = ALIGN(PAGE_SIZE);
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		__smp_locks = .;
-		*(.smp_locks)
+		KEEP(*(.smp_locks))
 		. = ALIGN(PAGE_SIZE);
 		__smp_locks_end = .;
 	}
--- linux-2.6.35-rc4.fs/arch/x86/vdso/vdso-layout.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/x86/vdso/vdso-layout.lds.S
@@ -34,8 +34,8 @@
 	      *(.gnu.linkonce.b.*)
 	}
 
-	.altinstructions	: { *(.altinstructions) }
-	.altinstr_replacement	: { *(.altinstr_replacement) }
+	.altinstructions	: { KEEP(*(.altinstructions)) }
+	.altinstr_replacement	: { KEEP(*(.altinstr_replacement)) }
 
 	/*
 	 * Align the actual code well away from the non-instruction data.
--- linux-2.6.35-rc4.fs/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.35-rc4-fsgs.obj/include/asm-generic/vmlinux.lds.h
@@ -229,25 +229,25 @@
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
-		*(.pci_fixup_early)					\
+		KEEP(*(.pci_fixup_early))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
-		*(.pci_fixup_header)					\
+		KEEP(*(.pci_fixup_header))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
-		*(.pci_fixup_final)					\
+		KEEP(*(.pci_fixup_final))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
-		*(.pci_fixup_enable)					\
+		KEEP(*(.pci_fixup_enable))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
-		*(.pci_fixup_resume)					\
+		KEEP(*(.pci_fixup_resume))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
-		*(.pci_fixup_resume_early)				\
+		KEEP(*(.pci_fixup_resume_early))			\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
 		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
-		*(.pci_fixup_suspend)					\
+		KEEP(*(.pci_fixup_suspend))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
 	}								\
 									\
@@ -270,76 +270,76 @@
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		KEEP(*(__ksymtab))					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		KEEP(*(__ksymtab_gpl))					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		KEEP(*(__ksymtab_unused))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		KEEP(*(__ksymtab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		KEEP(*(__ksymtab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		KEEP(*(__kcrctab))					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		KEEP(*(__kcrctab_gpl))					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		KEEP(*(__kcrctab_unused))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		KEEP(*(__kcrctab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		KEEP(*(__kcrctab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
+		KEEP(*(__ksymtab_strings))				\
 	}								\
 									\
 	/* __*init sections */						\
@@ -356,7 +356,7 @@
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___param) = .;			\
-		*(__param)						\
+		KEEP(*(__param))					\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
@@ -371,7 +371,7 @@
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-		*(.security_initcall.init) 				\
+		KEEP(*(.security_initcall.init))			\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
@@ -424,7 +424,7 @@
 #endif
 
 /* Section used for early init (in .S files) */
-#define HEAD_TEXT  *(.head.text)
+#define HEAD_TEXT  KEEP(*(.head.text))
 
 #define HEAD_TEXT_SECTION							\
 	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
@@ -438,7 +438,7 @@
 	. = ALIGN(align);						\
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ex_table) = .;			\
-		*(__ex_table)						\
+		KEEP(*(__ex_table))					\
 		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
 	}
 
@@ -591,29 +591,29 @@
 #define INIT_SETUP(initsetup_align)					\
 		. = ALIGN(initsetup_align);				\
 		VMLINUX_SYMBOL(__setup_start) = .;			\
-		*(.init.setup)						\
+		KEEP(*(.init.setup))					\
 		VMLINUX_SYMBOL(__setup_end) = .;
 
 #define INITCALLS							\
-	*(.initcallearly.init)						\
+	KEEP(*(.initcallearly.init))					\
 	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
-  	*(.initcall0.init)						\
-  	*(.initcall0s.init)						\
-  	*(.initcall1.init)						\
-  	*(.initcall1s.init)						\
-  	*(.initcall2.init)						\
-  	*(.initcall2s.init)						\
-  	*(.initcall3.init)						\
-  	*(.initcall3s.init)						\
-  	*(.initcall4.init)						\
-  	*(.initcall4s.init)						\
-  	*(.initcall5.init)						\
-  	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
-  	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
-  	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+	KEEP(*(.initcall0.init))					\
+	KEEP(*(.initcall0s.init))					\
+	KEEP(*(.initcall1.init))					\
+	KEEP(*(.initcall1s.init))					\
+	KEEP(*(.initcall2.init))					\
+	KEEP(*(.initcall2s.init))					\
+	KEEP(*(.initcall3.init))					\
+	KEEP(*(.initcall3s.init))					\
+	KEEP(*(.initcall4.init))					\
+	KEEP(*(.initcall4s.init))					\
+	KEEP(*(.initcall5.init))					\
+	KEEP(*(.initcall5s.init))					\
+	KEEP(*(.initcallrootfs.init))					\
+	KEEP(*(.initcall6.init))					\
+	KEEP(*(.initcall6s.init))					\
+	KEEP(*(.initcall7.init))					\
+	KEEP(*(.initcall7s.init))
 
 #define INIT_CALLS							\
 		VMLINUX_SYMBOL(__initcall_start) = .;			\
@@ -622,19 +622,19 @@
 
 #define CON_INITCALL							\
 		VMLINUX_SYMBOL(__con_initcall_start) = .;		\
-		*(.con_initcall.init)					\
+		KEEP(*(.con_initcall.init))				\
 		VMLINUX_SYMBOL(__con_initcall_end) = .;
 
 #define SECURITY_INITCALL						\
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-		*(.security_initcall.init)				\
+		KEEP(*(.security_initcall.init))			\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
-	*(.init.ramfs)							\
+	KEEP(*(.init.ramfs))						\
 	VMLINUX_SYMBOL(__initramfs_end) = .;
 #else
 #define INIT_RAM_FS
