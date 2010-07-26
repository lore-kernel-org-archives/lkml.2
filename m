Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0GZB3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:29:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0GZB3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=M+hev7ArjfhQ5dBzf7tvyN+oDTQ0lwI8ZyKX8JuqpcSygS+lWDkTjzGyYzLMYdl7tF
         7b7dRsXdmUvmI4CaTF0Q9eKLkuAMoAn5WXMpiBM8HXpSTE6fg5H/x2xld+47tgbrrBI7
         /+0SMkKv1jYsQ1lDtiEMFOnuSHK1zdKb3sYls=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Date: Mon, 26 Jul 2010 03:29:09 +0200
User-Agent: KMail/1.8.2
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
References: <201007181703.17022.vda.linux@googlemail.com> <20100723202448.GB27054@merkur.ravnborg.org>
In-Reply-To: <20100723202448.GB27054@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lTOTMwjX+GKUVQ1"
Message-Id: <201007260329.09913.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lTOTMwjX+GKUVQ1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 23 July 2010 22:24, Sam Ravnborg wrote:
> > * fix for kernel linker stripts: linux-2.6.35-rc4-fs.fix-kernel-linker-scripts.patch
> >   It makes _all_ linker scripts -ffunction/data-sections safe via:
> >   -       *(.data)
> >   +       *(.data .data.*)
> >   
> 
> This patch touches both the regular kernel linker scripts and the
> boot linker scripts.
> I would strongly prefer a split so you touched the boot linker
> scripts in a separate patch.

No problem.

> In addition the patch handles more sections than
> documented: rodata, bss, text.

Yes, that was assumed.

> The patch introduce the following syntax for input sections:
> 
>     *(.bss .bss.*)
>
> Where the kernel linker script would have one input
> section per line.
> Can we stick to the "layout" used in the kernel linker scripts?

Sure.


> The patch in addition in several places changes linker
> scripts that already uses the two-lines layout to a single line approach.
> These "fixes" should be omitted.

Reverted.

> Why do we need *(.bss .bss.*)?
> Does -fdata-sections introduce special .bss sectiosn too?

Yes, it does.

Please take a look at attached updated patches.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda


--Boundary-00=_lTOTMwjX+GKUVQ1
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.35-rc4-fs-boot-linker-scripts.v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fs-boot-linker-scripts.v2.patch"

--- linux-2.6.35-rc4/arch/alpha/boot/bootloader.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/alpha/boot/bootloader.lds
@@ -4,17 +4,17 @@
 SECTIONS
 {
   . = 0x20000000;
-  .text : { *(.text) }
+  .text : { *(.text) *(.text.*) }
   _etext = .;
   PROVIDE (etext = .);
   .rodata : { *(.rodata) *(.rodata.*) }
-  .data : { *(.data) CONSTRUCTORS }
+  .data : { *(.data) *(.data.*) CONSTRUCTORS }
   .got : { *(.got) }
   .sdata : { *(.sdata) }
   _edata = .;
   PROVIDE (edata = .);
   .sbss : { *(.sbss) *(.scommon) }
-  .bss : { *(.bss) *(COMMON) }
+  .bss : { *(.bss) *(.bss.*) *(COMMON) }
   _end = . ;
   PROVIDE (end = .);
 
--- linux-2.6.35-rc4/arch/arm/boot/bootp/bootp.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/arm/boot/bootp/bootp.lds
@@ -16,6 +16,7 @@
    _stext = .;
    *(.start)
    *(.text)
+   *(.text.*)
    initrd_size = initrd_end - initrd_start;
    _etext = .;
   }
--- linux-2.6.35-rc4/arch/cris/boot/compressed/decompress_v10.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/cris/boot/compressed/decompress_v10.lds
@@ -13,6 +13,7 @@
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.rodata)
 		*(.rodata.*)
 		_etext = . ;
@@ -20,11 +21,13 @@
 	.data :
 	{
 		*(.data)
+		*(.data.*)
 		_edata = . ;
 	} > dram
 	.bss :
 	{
 		*(.bss)
+		*(.bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > dram
 }
--- linux-2.6.35-rc4/arch/cris/boot/compressed/decompress_v32.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/cris/boot/compressed/decompress_v32.lds
@@ -13,6 +13,7 @@
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.rodata)
 		*(.rodata.*)
 		_etext = . ;
@@ -20,11 +21,13 @@
 	.data :
 	{
 		*(.data)
+		*(.data.*)
 		_edata = . ;
 	} > dram
 	.bss :
 	{
 		*(.bss)
+		*(.bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > dram
 }
--- linux-2.6.35-rc4/arch/cris/boot/rescue/rescue_v10.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/cris/boot/rescue/rescue_v10.lds
@@ -10,11 +10,13 @@
 	{
 		stext = . ;
 		*(.text)
+		*(.text.*)
 		etext = . ;
 	} > flash
 	.data :
 	{
 		*(.data)
+		*(.data.*)
 		edata = . ;
 	} > flash
 }
--- linux-2.6.35-rc4/arch/cris/boot/rescue/rescue_v32.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/cris/boot/rescue/rescue_v32.lds
@@ -17,6 +17,7 @@
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.init.text)
 		*(.rodata)
 		*(.rodata.*)
@@ -25,12 +26,14 @@
 	.data :
 	{
 		*(.data)
+		*(.data.*)
 		_edata = . ;
 	} > bootblk
 	.bss :
 	{
 		_bss = . ;
 		*(.bss)
+		*(.bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > intmem
 
--- linux-2.6.35-rc4/arch/h8300/boot/compressed/vmlinux.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/h8300/boot/compressed/vmlinux.lds
@@ -6,12 +6,14 @@
 	__text = .;
 	       *(.text..startup)
 	       *(.text)
+	       *(.text.*)
         __etext = . ;
         }
 
 	.rodata :
 	{
 		*(.rodata)
+		*(.rodata.*)
 	}
         .data :
 
--- linux-2.6.35-rc4/arch/h8300/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/h8300/boot/compressed/vmlinux.scr
@@ -4,6 +4,7 @@
 	_input_len = .;
 	LONG(_input_data_end - _input_data) _input_data = .;
 	*(.data)
+	*(.data.*)
 	_input_data_end = .;
 	}
 }
--- linux-2.6.35-rc4/arch/ia64/hp/sim/boot/bootloader.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/ia64/hp/sim/boot/bootloader.lds
@@ -7,13 +7,13 @@
   . = 0x100000;
 
   _text = .;
-  .text : { *(__ivt_section) *(.text) }
+  .text : { *(__ivt_section) *(.text) *(.text.*) }
   _etext = .;
 
   /* Global data */
   _data = .;
   .rodata : { *(.rodata) *(.rodata.*) }
-  .data    : { *(.data) *(.gnu.linkonce.d*) CONSTRUCTORS }
+  .data    : { *(.data) *(.data.*) *(.gnu.linkonce.d*) CONSTRUCTORS }
   __gp = ALIGN (8) + 0x200000;
   .got           : { *(.got.plt) *(.got) }
   /* We want the small data sections together, so single-instruction offsets
@@ -24,7 +24,7 @@
 
   __bss_start = .;
   .sbss      : { *(.sbss) *(.scommon) }
-  .bss       : { *(.bss) *(COMMON) }
+  .bss       : { *(.bss) *(.bss.*) *(COMMON) }
   . = ALIGN(64 / 8);
   __bss_stop = .;
   _end = . ;
--- linux-2.6.35-rc4/arch/m32r/boot/compressed/vmlinux.lds.S
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/m32r/boot/compressed/vmlinux.lds.S
@@ -6,12 +6,12 @@
   . = CONFIG_MEMORY_START + 0x00400000;
 
   _text = .;
-  .text : { *(.text) } = 0
+  .text : { *(.text) *(.text.*) } = 0
   .rodata : { *(.rodata) *(.rodata.*) }
   _etext = .;
 
   . = ALIGN(32 / 8);
-  .data : { *(.data) }
+  .data : { *(.data) *(.data.*) }
   . = ALIGN(32 / 8);
   _got = .;
   .got  : { *(.got) _egot = .; *(.got.*) }
@@ -19,7 +19,7 @@
 
   . = ALIGN(32 / 8);
   __bss_start = .;
-  .bss : { *(.bss) *(.sbss) }
+  .bss : { *(.bss) *(.bss.*) *(.sbss) }
   . = ALIGN(32 / 8);
   _ebss = .;
   . = ALIGN(4096);
--- linux-2.6.35-rc4/arch/m32r/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/m32r/boot/compressed/vmlinux.scr
@@ -3,6 +3,7 @@
   .data : {
 	zimage_data = .;
 	*(.data)
+	*(.data.*)
 	zimage_data_end = .;
 	}
   zimage_len = zimage_data_end - zimage_data;
--- linux-2.6.35-rc4/arch/mn10300/boot/compressed/vmlinux.lds
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/mn10300/boot/compressed/vmlinux.lds
@@ -4,6 +4,7 @@
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
+	*(.data.*)
 	input_data_end = .;
 	}
 }
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.coff.lds.S
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/powerpc/boot/zImage.coff.lds.S
@@ -7,6 +7,7 @@
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -41,6 +42,7 @@
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   _end = . ;
 
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.lds.S
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/powerpc/boot/zImage.lds.S
@@ -7,6 +7,7 @@
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -45,6 +46,7 @@
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.ps3.lds.S
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/powerpc/boot/zImage.ps3.lds.S
@@ -21,6 +21,7 @@
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -44,6 +45,7 @@
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
--- linux-2.6.35-rc4/arch/sh/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/sh/boot/compressed/vmlinux.scr
@@ -4,6 +4,7 @@
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
+	*(.data.*)
 	output_len = . - 4;
 	input_data_end = .;
 	}
--- linux-2.6.35-rc4/arch/x86/boot/setup.ld
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/x86/boot/setup.ld
@@ -20,7 +20,7 @@
 	.initdata	: { *(.initdata) }
 	__end_init = .;
 
-	.text		: { *(.text) }
+	.text		: { *(.text) *(.text.*) }
 	.text32		: { *(.text32) }
 
 	. = ALIGN(16);
@@ -46,6 +46,7 @@
 	{
 		__bss_start = .;
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	. = ALIGN(16);
--- linux-2.6.35-rc4/arch/xtensa/boot/boot-elf/boot.lds.S
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/xtensa/boot/boot-elf/boot.lds.S
@@ -10,19 +10,21 @@
 	{
 		__reloc_start = . ;
 		_text_start = . ;
-		*(.literal .text.literal .text)
+		*(.literal .text.literal .text .text.*)
 		_text_end = . ;
 	}
 
 	.rodata ALIGN(0x04):
 	{
 		*(.rodata)
+		*(.rodata.*)
 		*(.rodata1)
 	}
 
 	.data ALIGN(0x04):
 	{
 		*(.data)
+		*(.data.*)
 		*(.data1)
 		*(.sdata)
 		*(.sdata2)
@@ -58,6 +60,7 @@
 		*(.scommon)
 		*(.dynbss)
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	_end = .;
--- linux-2.6.35-rc4/arch/xtensa/boot/boot-redboot/boot.ld
+++ linux-2.6.35-rc4-fs-boot-linker-scripts/arch/xtensa/boot/boot-redboot/boot.ld
@@ -8,19 +8,21 @@
 	{
 		__reloc_start = . ;
 		_text_start = . ;
-		*(.literal .text.literal .text)
+		*(.literal .text.literal .text .text.*)
 		_text_end = . ;
 	}
 
 	.rodata ALIGN(0x04):
 	{
 		*(.rodata)
+		*(.rodata.*)
 		*(.rodata1)
 	}
 
 	.data ALIGN(0x04):
 	{
 		*(.data)
+		*(.data.*)
 		*(.data1)
 		*(.sdata)
 		*(.sdata2)
@@ -56,6 +58,7 @@
 		*(.scommon)
 		*(.dynbss)
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	_end = .;

--Boundary-00=_lTOTMwjX+GKUVQ1
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.35-rc4-fs-kernel-linker-scripts.v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fs-kernel-linker-scripts.v2.patch"

--- linux-2.6.35-rc4/arch/frv/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/frv/kernel/vmlinux.lds.S
@@ -114,7 +114,6 @@
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss..stack	: { *(.bss) }
 
   __bss_stop = .;
   _end = . ;
--- linux-2.6.35-rc4/arch/ia64/scripts/check-segrel.lds
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/ia64/scripts/check-segrel.lds
@@ -1,9 +1,9 @@
 SECTIONS {
 	. = SIZEOF_HEADERS;
-	.rodata : { *(.rodata) } :ro
+	.rodata : { *(.rodata) *(.rodata.*) } :ro
 	.note : { *(.note*) }
 	. = 0xa0000;
-	.data : { *(.data) } :dat
+	.data : { *(.data) *(.data.*) } :dat
 	/DISCARD/ : { *(*) }
 }
 PHDRS {
--- linux-2.6.35-rc4/arch/m68knommu/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/m68knommu/kernel/vmlinux.lds.S
@@ -169,6 +169,7 @@
 		. = ALIGN(4);
 		_sbss = . ;
 		*(.bss)
+		*(.bss.*)
 		*(COMMON)
 		. = ALIGN(4) ;
 		_ebss = . ;
--- linux-2.6.35-rc4/arch/mips/lasat/image/romscript.normal
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/mips/lasat/image/romscript.normal
@@ -12,6 +12,7 @@
   .data ALIGN(0x10) :
   {
     *(.data)
+    *(.data.*)
   }
   _image_start = ADDR(.data);
   _image_size = SIZEOF(.data);
--- linux-2.6.35-rc4/arch/parisc/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/parisc/kernel/vmlinux.lds.S
@@ -112,6 +112,7 @@
 	}
 	.bss : {
 		*(.bss)
+		*(.bss.*)
 		*(COMMON)
 	}
 	__bss_stop = .;
--- linux-2.6.35-rc4/arch/sh/kernel/vsyscall/vsyscall.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/sh/kernel/vsyscall/vsyscall.lds.S
@@ -35,7 +35,7 @@
 	 */
 	. = 0x400;
 
-	.text		: { *(.text) } 			:text	=0x90909090
+	.text		: { *(.text) *(.text.*) }	:text	=0x90909090
 	.note		: { *(.note.*) }		:text	:note
 	.eh_frame_hdr	: { *(.eh_frame_hdr ) }		:text	:eh_frame_hdr
 	.eh_frame	: {
--- linux-2.6.35-rc4/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -42,6 +42,7 @@
 	.bss :	{
 		__bss_start = .;
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 
--- linux-2.6.35-rc4/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/arch/x86/kernel/vmlinux.lds.S
@@ -307,6 +307,7 @@
 		__bss_start = .;
 		*(.bss..page_aligned)
 		*(.bss)
+		*(.bss.*)
 		. = ALIGN(4);
 		__bss_stop = .;
 	}
--- linux-2.6.35-rc4/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.35-rc4-fs-kernel-linker-scripts/include/asm-generic/vmlinux.lds.h
@@ -140,9 +140,22 @@
 #define TRACE_SYSCALLS()
 #endif
 
+/* .data.foo are generated by gcc itself with -fdata-sections,
+ * whereas double-dot sections (like .data..percpu) are generated
+ * by kernel's magic macros.
+ *
+ * arch/.../vmlinux.lds.S decides where to place various double-dot sections
+ * as needed by its arch, here DATA_DATA needs to be careful and collect
+ * only .data and .data.foo sections, skipping .data..foo
+ *
+ * Same goes for .text, .bss and .rodata. In case of .rodata, various
+ * .rodata.foo sections are generated by gcc even without -fdata-sections
+ */
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
+	*(.data.[A-Za-z0-9_$^]*)					\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
@@ -202,7 +215,8 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata)						\
+		*(.rodata.[A-Za-z0-9_$^]*)				\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
@@ -369,6 +383,7 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot)						\
 		*(.text)						\
+		*(.text.[A-Za-z0-9_$^]*)				\
 		*(.ref.text)						\
 	DEV_KEEP(init.text)						\
 	DEV_KEEP(exit.text)						\
@@ -502,6 +517,7 @@
 		*(.bss..page_aligned)					\
 		*(.dynbss)						\
 		*(.bss)							\
+		*(.bss.[A-Za-z0-9_$^]*)					\
 		*(COMMON)						\
 	}
 

--Boundary-00=_lTOTMwjX+GKUVQ1--
