Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0KPWmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:42:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38110 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab0KPWmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eIlTh6yoKkBOzADtY74GmS+mT2qju+CmhdugmYCulBgeYrGOrtgo9fSkKZ75stvBKL
         4QIeEETRBzAFQDGkj/YFXqbnk00z4WVI0Wnq4t5eu4taUADL8mHmRfWF3GtWub5FfAIn
         9N4mao8EinDpscw9DA6bFA6kLN9IMUymi/pqk=
From: dirk.brandewie@gmail.com
To: devicetree-discuss@lists.ozlabs.org
Cc: sodaville@linutronix.de, arjan@linux.intel.com, dirk.brandewie@gmail.com,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] of: Add support for linking device tree blobs into vmlinux
Date: Tue, 16 Nov 2010 14:41:36 -0800
Message-Id: <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds support for linking device tree blobs into
vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
.dtb.init.rodata sections into the .init.data section of the vmlinux
image. Modifies scripts/Makefile.lib to add a kbuild command to
compile DTS files to device tree blobs and a rule to create objects to
wrap the blobs for linking.

The DTB's are placed on 32 byte boundries to allow parsing the blob
with driver/of/fdt.c during early boot without having to copy the blob
to get the structure alignment GCC expects.

A DTB is linked in by adding the DTB object to the list of objects to
be linked into vmlinux in the archtecture specific Makefile using
   obj-y += foo.dtb.o

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |   19 +++++++++++++++++--
 scripts/Makefile.lib              |   20 ++++++++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..ea671e7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -67,7 +67,14 @@
  * Align to a 32 byte boundary equal to the
  * alignment gcc 4.5 uses for a struct
  */
-#define STRUCT_ALIGN() . = ALIGN(32)
+#define STRUCT_ALIGNMENT 32
+#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
+
+/* Device tree blobs linked into the kernel need to have proper
+ * structure alignment to be parsed by the flat device tree library
+ * used in early boot
+*/
+#define DTB_ALIGNMENT STRUCT_ALIGNMENT
 
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
@@ -146,6 +153,13 @@
 #define TRACE_SYSCALLS()
 #endif
 
+
+#define KERNEL_DTB()							\
+	. = ALIGN(DTB_ALIGNMENT);					\
+	VMLINUX_SYMBOL(__dtb_start) = .;				\
+	*(.dtb.init.rodata)						\
+	VMLINUX_SYMBOL(__dtb_end) = .;
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -468,7 +482,8 @@
 	MCOUNT_REC()							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
-	MEM_DISCARD(init.rodata)
+	MEM_DISCARD(init.rodata)					\
+	KERNEL_DTB()
 
 #define INIT_TEXT							\
 	*(.init.text)							\
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 4c72c11..29db062 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -200,6 +200,26 @@ quiet_cmd_gzip = GZIP    $@
 cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 	(rm -f $@ ; false)
 
+# DTC
+#  ---------------------------------------------------------------------------
+$(obj)/%.dtb.S: $(obj)/%.dtb FORCE
+	@echo '#include <asm-generic/vmlinux.lds.h>' > $@
+	@echo '.section .dtb.init.rodata,"a"' >> $@
+	@echo '.balign DTB_ALIGNMENT' >> $@
+	@echo '.global __dtb_$(*F)_begin' >> $@
+	@echo '__dtb_$(*F)_begin:' >> $@
+	@echo '.incbin "$<" ' >> $@
+	@echo '__dtb_$(*F)_end:' >> $@
+	@echo '.global __dtb_$(*F)_end' >> $@
+	@echo '.balign DTB_ALIGNMENT' >> $@
+
+DTC = $(objtree)/scripts/dtc/dtc
+
+quiet_cmd_dtc = DTC	$@
+      cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(src)/dts/$*.dts
+
+$(obj)/%.dtb: $(src)/dts/%.dts
+	$(call if_changed,dtc)
 
 # Bzip2
 # ---------------------------------------------------------------------------
-- 
1.7.2.3

