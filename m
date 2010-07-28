Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0G1Xsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:48:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33096 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab0G1XsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=crwfNd0fiyxzWs2YBwH3n+tcrbG02l3BIdWUczX3vTZeVpsDqU2aSzzQ59G9hliJ/r
         6VvWVZrsaYO8Mh4KPOhXERoR1DvO0D9dpmrll8NWcJ7PMADm+WfxYa3e01Z7O4hVXgzQ
         Qtd8RV48/Gk8EI+ku6PWO41bzx2pYF7xLScfU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-arch@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Anders Kaseorg <andersk@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/4] boot linker stripts: accomodate function and data sections
Date: Thu, 29 Jul 2010 01:47:56 +0200
Message-Id: <1280360876-2571-5-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com>
References: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc -ffunction-sections -fdata-sections places each function foo
into separate section .text.foo, and every data object bar into
separate section .data.bar, .rodata.bar or .bss.bar.

Boot linker scripts were not ready for this.

This fix adds *(.text.*), *(.data.*) etc patterns
directly after corresponding *(.text), *(.data) etc patterns
in all boot linker scripts.

This may be unnecessary, but I want to be
function and data section-clean in all linker scripts,
including boot ones.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/alpha/boot/bootloader.lds               |    6 +++---
 arch/arm/boot/bootp/bootp.lds                |    1 +
 arch/cris/boot/compressed/decompress_v10.lds |    3 +++
 arch/cris/boot/compressed/decompress_v32.lds |    3 +++
 arch/cris/boot/rescue/rescue_v10.lds         |    2 ++
 arch/cris/boot/rescue/rescue_v32.lds         |    3 +++
 arch/h8300/boot/compressed/vmlinux.lds       |    2 ++
 arch/h8300/boot/compressed/vmlinux.scr       |    1 +
 arch/ia64/hp/sim/boot/bootloader.lds         |    6 +++---
 arch/m32r/boot/compressed/vmlinux.lds.S      |    6 +++---
 arch/m32r/boot/compressed/vmlinux.scr        |    1 +
 arch/mn10300/boot/compressed/vmlinux.lds     |    1 +
 arch/powerpc/boot/zImage.coff.lds.S          |    2 ++
 arch/powerpc/boot/zImage.lds.S               |    2 ++
 arch/powerpc/boot/zImage.ps3.lds.S           |    2 ++
 arch/sh/boot/compressed/vmlinux.scr          |    1 +
 arch/x86/boot/setup.ld                       |    3 ++-
 arch/xtensa/boot/boot-elf/boot.lds.S         |    5 ++++-
 arch/xtensa/boot/boot-redboot/boot.ld        |    5 ++++-
 19 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/boot/bootloader.lds b/arch/alpha/boot/bootloader.lds
index 31c081c..ff5374d 100644
--- a/arch/alpha/boot/bootloader.lds
+++ b/arch/alpha/boot/bootloader.lds
@@ -4,17 +4,17 @@ printk = srm_printk;
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
 
diff --git a/arch/arm/boot/bootp/bootp.lds b/arch/arm/boot/bootp/bootp.lds
index fc54394..14be7ff 100644
--- a/arch/arm/boot/bootp/bootp.lds
+++ b/arch/arm/boot/bootp/bootp.lds
@@ -16,6 +16,7 @@ SECTIONS
    _stext = .;
    *(.start)
    *(.text)
+   *(.text.*)
    initrd_size = initrd_end - initrd_start;
    _etext = .;
   }
diff --git a/arch/cris/boot/compressed/decompress_v10.lds b/arch/cris/boot/compressed/decompress_v10.lds
index e80f459..d6022d9 100644
--- a/arch/cris/boot/compressed/decompress_v10.lds
+++ b/arch/cris/boot/compressed/decompress_v10.lds
@@ -13,6 +13,7 @@ SECTIONS
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.rodata)
 		*(.rodata.*)
 		_etext = . ;
@@ -20,11 +21,13 @@ SECTIONS
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
diff --git a/arch/cris/boot/compressed/decompress_v32.lds b/arch/cris/boot/compressed/decompress_v32.lds
index 3c837fe..b5cfeb4 100644
--- a/arch/cris/boot/compressed/decompress_v32.lds
+++ b/arch/cris/boot/compressed/decompress_v32.lds
@@ -13,6 +13,7 @@ SECTIONS
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.rodata)
 		*(.rodata.*)
 		_etext = . ;
@@ -20,11 +21,13 @@ SECTIONS
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
diff --git a/arch/cris/boot/rescue/rescue_v10.lds b/arch/cris/boot/rescue/rescue_v10.lds
index 0b52a94..42b03a3 100644
--- a/arch/cris/boot/rescue/rescue_v10.lds
+++ b/arch/cris/boot/rescue/rescue_v10.lds
@@ -10,11 +10,13 @@ SECTIONS
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
diff --git a/arch/cris/boot/rescue/rescue_v32.lds b/arch/cris/boot/rescue/rescue_v32.lds
index 8ac646b..440ea40 100644
--- a/arch/cris/boot/rescue/rescue_v32.lds
+++ b/arch/cris/boot/rescue/rescue_v32.lds
@@ -17,6 +17,7 @@ SECTIONS
 	{
 		_stext = . ;
 		*(.text)
+		*(.text.*)
 		*(.init.text)
 		*(.rodata)
 		*(.rodata.*)
@@ -25,12 +26,14 @@ SECTIONS
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
 
diff --git a/arch/h8300/boot/compressed/vmlinux.lds b/arch/h8300/boot/compressed/vmlinux.lds
index a0a3a0e..6896c9a 100644
--- a/arch/h8300/boot/compressed/vmlinux.lds
+++ b/arch/h8300/boot/compressed/vmlinux.lds
@@ -6,12 +6,14 @@ SECTIONS
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
 
diff --git a/arch/h8300/boot/compressed/vmlinux.scr b/arch/h8300/boot/compressed/vmlinux.scr
index a0f6962..f4cfb3f 100644
--- a/arch/h8300/boot/compressed/vmlinux.scr
+++ b/arch/h8300/boot/compressed/vmlinux.scr
@@ -4,6 +4,7 @@ SECTIONS
 	_input_len = .;
 	LONG(_input_data_end - _input_data) _input_data = .;
 	*(.data)
+	*(.data.*)
 	_input_data_end = .;
 	}
 }
diff --git a/arch/ia64/hp/sim/boot/bootloader.lds b/arch/ia64/hp/sim/boot/bootloader.lds
index 3977f25..56bf12c 100644
--- a/arch/ia64/hp/sim/boot/bootloader.lds
+++ b/arch/ia64/hp/sim/boot/bootloader.lds
@@ -7,13 +7,13 @@ SECTIONS
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
@@ -24,7 +24,7 @@ SECTIONS
 
   __bss_start = .;
   .sbss      : { *(.sbss) *(.scommon) }
-  .bss       : { *(.bss) *(COMMON) }
+  .bss       : { *(.bss) *(.bss.*) *(COMMON) }
   . = ALIGN(64 / 8);
   __bss_stop = .;
   _end = . ;
diff --git a/arch/m32r/boot/compressed/vmlinux.lds.S b/arch/m32r/boot/compressed/vmlinux.lds.S
index dd11963..d51580e 100644
--- a/arch/m32r/boot/compressed/vmlinux.lds.S
+++ b/arch/m32r/boot/compressed/vmlinux.lds.S
@@ -6,12 +6,12 @@ SECTIONS
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
@@ -19,7 +19,7 @@ SECTIONS
 
   . = ALIGN(32 / 8);
   __bss_start = .;
-  .bss : { *(.bss) *(.sbss) }
+  .bss : { *(.bss) *(.bss.*) *(.sbss) }
   . = ALIGN(32 / 8);
   _ebss = .;
   . = ALIGN(4096);
diff --git a/arch/m32r/boot/compressed/vmlinux.scr b/arch/m32r/boot/compressed/vmlinux.scr
index 924c799..253eff1 100644
--- a/arch/m32r/boot/compressed/vmlinux.scr
+++ b/arch/m32r/boot/compressed/vmlinux.scr
@@ -3,6 +3,7 @@ SECTIONS
   .data : {
 	zimage_data = .;
 	*(.data)
+	*(.data.*)
 	zimage_data_end = .;
 	}
   zimage_len = zimage_data_end - zimage_data;
diff --git a/arch/mn10300/boot/compressed/vmlinux.lds b/arch/mn10300/boot/compressed/vmlinux.lds
index a084903..3e3e043 100644
--- a/arch/mn10300/boot/compressed/vmlinux.lds
+++ b/arch/mn10300/boot/compressed/vmlinux.lds
@@ -4,6 +4,7 @@ SECTIONS
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
+	*(.data.*)
 	input_data_end = .;
 	}
 }
diff --git a/arch/powerpc/boot/zImage.coff.lds.S b/arch/powerpc/boot/zImage.coff.lds.S
index 856dc78..504183a 100644
--- a/arch/powerpc/boot/zImage.coff.lds.S
+++ b/arch/powerpc/boot/zImage.coff.lds.S
@@ -7,6 +7,7 @@ SECTIONS
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -41,6 +42,7 @@ SECTIONS
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   _end = . ;
 
diff --git a/arch/powerpc/boot/zImage.lds.S b/arch/powerpc/boot/zImage.lds.S
index 0962d62..2815506 100644
--- a/arch/powerpc/boot/zImage.lds.S
+++ b/arch/powerpc/boot/zImage.lds.S
@@ -7,6 +7,7 @@ SECTIONS
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -45,6 +46,7 @@ SECTIONS
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
diff --git a/arch/powerpc/boot/zImage.ps3.lds.S b/arch/powerpc/boot/zImage.ps3.lds.S
index aaa469c..a29ce62 100644
--- a/arch/powerpc/boot/zImage.ps3.lds.S
+++ b/arch/powerpc/boot/zImage.ps3.lds.S
@@ -21,6 +21,7 @@ SECTIONS
   .text      :
   {
     *(.text)
+    *(.text.*)
     *(.fixup)
   }
   _etext = .;
@@ -44,6 +45,7 @@ SECTIONS
   {
    *(.sbss)
    *(.bss)
+   *(.bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
diff --git a/arch/sh/boot/compressed/vmlinux.scr b/arch/sh/boot/compressed/vmlinux.scr
index 862d748..e7d733f 100644
--- a/arch/sh/boot/compressed/vmlinux.scr
+++ b/arch/sh/boot/compressed/vmlinux.scr
@@ -4,6 +4,7 @@ SECTIONS
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
+	*(.data.*)
 	output_len = . - 4;
 	input_data_end = .;
 	}
diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index 03c0683..a4af992 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -20,7 +20,7 @@ SECTIONS
 	.initdata	: { *(.initdata) }
 	__end_init = .;
 
-	.text		: { *(.text) }
+	.text		: { *(.text) *(.text.*) }
 	.text32		: { *(.text32) }
 
 	. = ALIGN(16);
@@ -46,6 +46,7 @@ SECTIONS
 	{
 		__bss_start = .;
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	. = ALIGN(16);
diff --git a/arch/xtensa/boot/boot-elf/boot.lds.S b/arch/xtensa/boot/boot-elf/boot.lds.S
index 4e53b74..368d766 100644
--- a/arch/xtensa/boot/boot-elf/boot.lds.S
+++ b/arch/xtensa/boot/boot-elf/boot.lds.S
@@ -10,19 +10,21 @@ SECTIONS
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
@@ -58,6 +60,7 @@ SECTIONS
 		*(.scommon)
 		*(.dynbss)
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	_end = .;
diff --git a/arch/xtensa/boot/boot-redboot/boot.ld b/arch/xtensa/boot/boot-redboot/boot.ld
index 774db20..8747b68 100644
--- a/arch/xtensa/boot/boot-redboot/boot.ld
+++ b/arch/xtensa/boot/boot-redboot/boot.ld
@@ -8,19 +8,21 @@ SECTIONS
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
@@ -56,6 +58,7 @@ SECTIONS
 		*(.scommon)
 		*(.dynbss)
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 	_end = .;
-- 
1.6.2.4

