Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2EHSXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:1552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab2EHSXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150636933"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
Date: Tue,  8 May 2012 21:22:25 +0300
Message-Id: <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create realmode.bin and realmode.relocs files. Piggy
pack them into relocatable object that will be included
into .init.data section of the main kernel image.

The first file includes binary image of the real-mode code.
The latter file includes all relocations. The layout of the
binary image is specified in realmode.lds.S. The makefile
generates pa_ prefixed symbols for each exported global.
These are used in 32-bit code and in realmode header to
define symbols that need to be relocated.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Originally-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kbuild                     |    2 +-
 arch/x86/realmode/Makefile          |   20 +++++++++++
 arch/x86/realmode/rm/.gitignore     |    3 ++
 arch/x86/realmode/rm/Makefile       |   63 ++++++++++++++++++++++++++++++++
 arch/x86/realmode/rm/header.S       |   16 +++++++++
 arch/x86/realmode/rm/realmode.lds.S |   68 +++++++++++++++++++++++++++++++++++
 arch/x86/realmode/rmpiggy.S         |   18 ++++++++++
 7 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/realmode/Makefile
 create mode 100644 arch/x86/realmode/rm/.gitignore
 create mode 100644 arch/x86/realmode/rm/Makefile
 create mode 100644 arch/x86/realmode/rm/header.S
 create mode 100644 arch/x86/realmode/rm/realmode.lds.S
 create mode 100644 arch/x86/realmode/rmpiggy.S

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 0e9dec6..e5287d8 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -1,4 +1,3 @@
-
 obj-$(CONFIG_KVM) += kvm/
 
 # Xen paravirtualization support
@@ -7,6 +6,7 @@ obj-$(CONFIG_XEN) += xen/
 # lguest paravirtualization support
 obj-$(CONFIG_LGUEST_GUEST) += lguest/
 
+obj-y += realmode/
 obj-y += kernel/
 obj-y += mm/
 
diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
new file mode 100644
index 0000000..f22a4f8
--- /dev/null
+++ b/arch/x86/realmode/Makefile
@@ -0,0 +1,20 @@
+#
+# arch/x86/realmode/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+#
+
+subdir- := rm
+
+obj-y += rmpiggy.o
+
+$(obj)/rmpiggy.o: $(obj)/rm/realmode.relocs $(obj)/rm/realmode.bin
+
+$(obj)/rm/realmode.bin: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/rm $@
+
+$(obj)/rm/realmode.relocs: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/rm $@
diff --git a/arch/x86/realmode/rm/.gitignore b/arch/x86/realmode/rm/.gitignore
new file mode 100644
index 0000000..b6ed3a2
--- /dev/null
+++ b/arch/x86/realmode/rm/.gitignore
@@ -0,0 +1,3 @@
+pasyms.h
+realmode.lds
+realmode.relocs
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
new file mode 100644
index 0000000..7c3f202
--- /dev/null
+++ b/arch/x86/realmode/rm/Makefile
@@ -0,0 +1,63 @@
+#
+# arch/x86/realmode/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+#
+
+subdir- := wakeup
+
+always := realmode.bin
+
+realmode-y			+= header.o
+
+targets	+= $(realmode-y)
+
+REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))
+
+sed-pasyms := -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p'
+
+quiet_cmd_pasyms = PASYMS  $@
+      cmd_pasyms = $(NM) $(filter-out FORCE,$^) | \
+		   sed $(sed-pasyms) | sort | uniq > $@
+
+$(obj)/pasyms.h: $(REALMODE_OBJS) FORCE
+	$(call if_changed,pasyms)
+
+$(obj)/realmode.lds: $(obj)/pasyms.h
+
+LDFLAGS_realmode.elf := --emit-relocs -T
+CPPFLAGS_realmode.lds += -P -C -I$(obj)
+
+$(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
+	$(call if_changed,ld)
+
+OBJCOPYFLAGS_realmode.bin := -O binary
+
+$(obj)/realmode.bin: $(obj)/realmode.elf
+	$(call if_changed,objcopy)
+
+quiet_cmd_relocs = RELOCS  $@
+      cmd_relocs = scripts/x86-relocs --realmode $< > $@
+$(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
+	$(call if_changed,relocs)
+
+# ---------------------------------------------------------------------------
+
+# How to compile the 16-bit code.  Note we always compile for -march=i386,
+# that way we can complain to the user if the CPU is insufficient.
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
+		   -DDISABLE_BRANCH_PROFILING \
+		   -Wall -Wstrict-prototypes \
+		   -march=i386 -mregparm=3 \
+		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
new file mode 100644
index 0000000..7be17f2
--- /dev/null
+++ b/arch/x86/realmode/rm/header.S
@@ -0,0 +1,16 @@
+/*
+ * Real-mode blob header; this should match realmode.h and be
+ * readonly; for mutable data instead add pointers into the .data
+ * or .bss sections as appropriate.
+ */
+
+#include <linux/linkage.h>
+#include <asm/page_types.h>
+
+		.section ".header", "a"
+
+ENTRY(real_mode_header)
+		.long	pa_text_start
+		.long	pa_ro_end
+		.long	pa_end
+END(real_mode_header)
diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
new file mode 100644
index 0000000..c5b8a4f
--- /dev/null
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -0,0 +1,68 @@
+/*
+ * realmode.lds.S
+ *
+ * Linker script for the real-mode code
+ */
+
+#include <asm/page_types.h>
+
+#undef i386
+
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+
+SECTIONS
+{
+	real_mode_seg = 0;
+
+	. = 0;
+	.header : {
+		pa_real_mode_base = .;
+		*(.header)
+	}
+
+	. = ALIGN(4);
+	.rodata : {
+		*(.rodata)
+		*(.rodata.*)
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.text : {
+		pa_text_start = .;
+		*(.text)
+		*(.text.*)
+	}
+
+	.text32 : {
+		*(.text32)
+		*(.text32.*)
+		pa_ro_end = .;
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.data : {
+		*(.data)
+		*(.data.*)
+	}
+
+	. = ALIGN(128);
+	.bss : {
+		*(.bss*)
+	}
+
+	/* End signature for integrity checking */
+	. = ALIGN(4);
+	.signature : {
+		*(.signature)
+		pa_end = .;
+	}
+
+	/DISCARD/ : {
+		*(.note*)
+		*(.debug*)
+		*(.eh_frame*)
+	}
+
+#include "pasyms.h"
+}
diff --git a/arch/x86/realmode/rmpiggy.S b/arch/x86/realmode/rmpiggy.S
new file mode 100644
index 0000000..6047d7f
--- /dev/null
+++ b/arch/x86/realmode/rmpiggy.S
@@ -0,0 +1,18 @@
+/*
+ * Wrapper script for the realmode binary as a transport object
+ * before copying to low memory.
+ */
+#include <linux/linkage.h>
+#include <asm/page_types.h>
+
+	.section ".init.data","aw"
+
+	.balign PAGE_SIZE
+
+ENTRY(real_mode_blob)
+	.incbin	"arch/x86/realmode/rm/realmode.bin"
+END(real_mode_blob)
+
+ENTRY(real_mode_relocs)
+	.incbin	"arch/x86/realmode/rm/realmode.relocs"
+END(real_mode_relocs)
-- 
1.7.9.5

