Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0LFRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:36:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38872 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0LFRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KeZMxw657NdZyYfCKIdqRzkVDgNnjPgQZ6Pt+/MX1irY2KMi0KVriiNhrgdo0QMXma
         ZAbyf60EYtGGzAt5E/nPKyzbYvqcVd/JxWCq6h8E20wfokAQjWLJLktsbQp+ycKso0Yv
         aeLFIs4fMBGjHEPipwebyp0jLcg9QQv28VlYk=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 1/4] of: Add support for linking device tree blobs into vmlinux
Date: Mon,  6 Dec 2010 09:35:59 -0800
Message-Id: <76a37fa459aeadce5d11db8a7cc044687a2e0e8c.1291656753.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1291656753.git.dirk.brandewie@gmail.com>
References: <cover.1291656753.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds support for linking device tree blob(s) into
vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
.dtb sections into vmlinux. To maintain compatiblity with the of/fdt
driver code platforms MUST copy the blob to a non-init memory location
before the kernel frees the .init.* sections in the image.

Modifies scripts/Makefile.lib to add a kbuild command to
compile DTS files to device tree blobs and a rule to create objects to
wrap the blobs for linking.

STRUCT_ALIGNMENT is defined in vmlinux.lds.h for use in the rule to
create wrapper objects for the dtb in Makefile.lib.  The
STRUCT_ALIGN() macro in vmlinux.lds.h is modified to use the
STRUCT_ALIGNMENT definition.

The DTB's are placed on 32 byte boundries to allow parsing the blob
with driver/of/fdt.c during early boot without having to copy the blob
to get the structure alignment GCC expects.

A DTB is linked in by adding the DTB object to the list of objects to
be linked into vmlinux in the archtecture specific Makefile using
   obj-y += foo.dtb.o

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
 include/asm-generic/vmlinux.lds.h  |   15 ++++++++++++---
 scripts/Makefile.lib               |   21 ++++++++++++++++++++-
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 0ef00bd..fc18bb1 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1136,6 +1136,21 @@ When kbuild executes, the following steps are followed (roughly):
 	      resulting in the target file being recompiled for no
 	      obvious reason.
 
+    dtc
+	Create flattend device tree blob object suitable for linking
+	into vmlinux. Device tree blobs linked into vmlinux are placed
+	in an init section in the image. Platform code *must* copy the
+	blob to non-init memory prior to calling unflatten_device_tree().
+
+	Example:
+		#arch/x86/platform/ce4100/Makefile
+		clean-files := *dtb.S
+
+		DTC_FLAGS := -p 1024
+		obj-y += foo.dtb.o
+
+		$(obj)/%.dtb: $(src)/%.dts
+			$(call if_changed,dtc)
 
 --- 6.7 Custom kbuild commands
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..024d3b9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -23,7 +23,7 @@
  *	_etext = .;
  *
  *      _sdata = .;
- *	RO_DATA_SECTION(PAGE_SIZE)
+*	RO_DATA_SECTION(PAGE_SIZE)
  *	RW_DATA_SECTION(...)
  *	_edata = .;
  *
@@ -67,7 +67,8 @@
  * Align to a 32 byte boundary equal to the
  * alignment gcc 4.5 uses for a struct
  */
-#define STRUCT_ALIGN() . = ALIGN(32)
+#define STRUCT_ALIGNMENT 32
+#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
 
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
@@ -146,6 +147,13 @@
 #define TRACE_SYSCALLS()
 #endif
 
+
+#define KERNEL_DTB()							\
+	STRUCT_ALIGN();							\
+	VMLINUX_SYMBOL(__dtb_start) = .;				\
+	*(.dtb.init.rodata)						\
+	VMLINUX_SYMBOL(__dtb_end) = .;
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -468,7 +476,8 @@
 	MCOUNT_REC()							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
-	MEM_DISCARD(init.rodata)
+	MEM_DISCARD(init.rodata)					\
+	KERNEL_DTB()
 
 #define INIT_TEXT							\
 	*(.init.text)							\
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 4c72c11..937eabbb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -200,7 +200,26 @@ quiet_cmd_gzip = GZIP    $@
 cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 	(rm -f $@ ; false)
 
-
+# DTC
+#  ---------------------------------------------------------------------------
+
+# Generate an assembly file to wrap the output of the device tree compiler
+$(obj)/%.dtb.S: $(obj)/%.dtb
+	@echo '#include <asm-generic/vmlinux.lds.h>' > $@
+	@echo '.section .dtb.init.rodata,"a"' >> $@
+	@echo '.balign STRUCT_ALIGNMENT' >> $@
+	@echo '.global __dtb_$(*F)_begin' >> $@
+	@echo '__dtb_$(*F)_begin:' >> $@
+	@echo '.incbin "$<" ' >> $@
+	@echo '__dtb_$(*F)_end:' >> $@
+	@echo '.global __dtb_$(*F)_end' >> $@
+	@echo '.balign STRUCT_ALIGNMENT' >> $@
+
+DTC = $(objtree)/scripts/dtc/dtc
+
+quiet_cmd_dtc = DTC $@
+      cmd_dtc = $(DTC) -O dtb -o $@ -b 0 $(DTC_FLAGS) $<
+ooo
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.7.2.3

