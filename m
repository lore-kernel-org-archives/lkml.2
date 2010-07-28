Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0G1Xs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:48:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43782 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0G1XsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QkKdPvct3ZBiBSDtvff6LXMWn9Y3RvrptYi69zKl2k9o6Qts8S9LwLN6ZlqIkKZooh
         04RUT9SvRV98vKBn73yHZ2pApRMwIjcdXba0F0jYJxk48WBHrEHzKD8G4hn9OU1NrbPY
         NXtY6R6TbwJyAi+r4WTIEC20XNtVsGVggsG0g=
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
Subject: [PATCH 3/4] kernel linker stripts: accomodate function and data sections
Date: Thu, 29 Jul 2010 01:47:55 +0200
Message-Id: <1280360876-2571-4-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com>
References: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc -ffunction-sections -fdata-sections places each function foo
into separate section .text.foo, and every data object bar into
separate section .data.bar, .rodata.bar or .bss.bar.

Kernel linker scripts were not ready for this and linker heuristics
for orphaned sections were not good enough to result in bootable
kernel.

This fix adds *(.text.*), *(.data.*) etc patterns
directly after corresponding *(.text), *(.data) etc patterns
in all kernel linker scripts. Boot scripts will be handled
in the next fix.

include/asm-generic/vmlinux.lds.h is a little bit more complicated.
It needs to avoid collecting special kernel sections
by using more restrictive patterns like *(.text.[A-Za-z0-9_$^]*)
instead of simplistic *(.text.*): special kernel sections like
.text..page_aligned contain double dots and won't be accidentally
matched by them.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/frv/kernel/vmlinux.lds.S              |    1 -
 arch/ia64/scripts/check-segrel.lds         |    4 ++--
 arch/m68knommu/kernel/vmlinux.lds.S        |    1 +
 arch/mips/lasat/image/romscript.normal     |    1 +
 arch/parisc/kernel/vmlinux.lds.S           |    1 +
 arch/sh/kernel/vsyscall/vsyscall.lds.S     |    2 +-
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    1 +
 arch/x86/kernel/vmlinux.lds.S              |    1 +
 include/asm-generic/vmlinux.lds.h          |   18 +++++++++++++++++-
 9 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 8b973f3..9949f1a 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -114,7 +114,6 @@ SECTIONS
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss..stack	: { *(.bss) }
 
   __bss_stop = .;
   _end = . ;
diff --git a/arch/ia64/scripts/check-segrel.lds b/arch/ia64/scripts/check-segrel.lds
index 85a0d54..1e23df4 100644
--- a/arch/ia64/scripts/check-segrel.lds
+++ b/arch/ia64/scripts/check-segrel.lds
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
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index a91b271..c095a5b 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -169,6 +169,7 @@ SECTIONS {
 		. = ALIGN(4);
 		_sbss = . ;
 		*(.bss)
+		*(.bss.*)
 		*(COMMON)
 		. = ALIGN(4) ;
 		_ebss = . ;
diff --git a/arch/mips/lasat/image/romscript.normal b/arch/mips/lasat/image/romscript.normal
index 0864c96..408e5ad 100644
--- a/arch/mips/lasat/image/romscript.normal
+++ b/arch/mips/lasat/image/romscript.normal
@@ -12,6 +12,7 @@ SECTIONS
   .data ALIGN(0x10) :
   {
     *(.data)
+    *(.data.*)
   }
   _image_start = ADDR(.data);
   _image_size = SIZEOF(.data);
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index d64a6bb..56d472c 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -112,6 +112,7 @@ SECTIONS
 	}
 	.bss : {
 		*(.bss)
+		*(.bss.*)
 		*(COMMON)
 	}
 	__bss_stop = .;
diff --git a/arch/sh/kernel/vsyscall/vsyscall.lds.S b/arch/sh/kernel/vsyscall/vsyscall.lds.S
index 6d59ee7..19ee0cb 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.lds.S
+++ b/arch/sh/kernel/vsyscall/vsyscall.lds.S
@@ -35,7 +35,7 @@ SECTIONS
 	 */
 	. = 0x400;
 
-	.text		: { *(.text) } 			:text	=0x90909090
+	.text		: { *(.text) *(.text.*) }	:text	=0x90909090
 	.note		: { *(.note.*) }		:text	:note
 	.eh_frame_hdr	: { *(.eh_frame_hdr ) }		:text	:eh_frame_hdr
 	.eh_frame	: {
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 060fff8..38f18e8 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -42,6 +42,7 @@ SECTIONS
 	.bss :	{
 		__bss_start = .;
 		*(.bss)
+		*(.bss.*)
 		__bss_end = .;
 	}
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..eb5b2a6 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -307,6 +307,7 @@ SECTIONS
 		__bss_start = .;
 		*(.bss..page_aligned)
 		*(.bss)
+		*(.bss.*)
 		. = ALIGN(4);
 		__bss_stop = .;
 	}
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 030a954..079895a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -146,9 +146,22 @@
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
@@ -212,7 +225,8 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata)						\
+		*(.rodata.[A-Za-z0-9_$^]*)				\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
@@ -379,6 +393,7 @@
 		ALIGN_FUNCTION();					\
 		*(.text.hot)						\
 		*(.text)						\
+		*(.text.[A-Za-z0-9_$^]*)				\
 		*(.ref.text)						\
 	DEV_KEEP(init.text)						\
 	DEV_KEEP(exit.text)						\
@@ -512,6 +527,7 @@
 		*(.bss..page_aligned)					\
 		*(.dynbss)						\
 		*(.bss)							\
+		*(.bss.[A-Za-z0-9_$^]*)					\
 		*(COMMON)						\
 	}
 
-- 
1.6.2.4

