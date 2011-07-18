Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1GRNI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:08:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44038 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1GRNHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:07:46 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] um: Implement a x86_64 vDSO
Date: Mon, 18 Jul 2011 15:07:36 +0200
Message-Id: <1310994456-14142-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310994456-14142-1-git-send-email-richard@nod.at>
References: <1310994456-14142-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now UML had no x86_64 vDSO.
So glibc always used the vsyscall page for gettimeday()
and friends.
Calls to gettimeday() returned falsely the host time and
confused some programs.

This patch adds a vDSO which turns all __vdso_* calls into
a system call so that UML can trap them.

As glibc still uses the vsyscall page for static binaries this
patch improves the situation only for dynamic binaries.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-x86_64/Makefile               |    2 +
 arch/um/sys-x86_64/asm/elf.h              |    9 +++
 arch/um/sys-x86_64/vdso/Makefile          |   90 +++++++++++++++++++++++++++++
 arch/um/sys-x86_64/vdso/checkundef.sh     |   10 +++
 arch/um/sys-x86_64/vdso/um_vdso.c         |   71 +++++++++++++++++++++++
 arch/um/sys-x86_64/vdso/vdso-layout.lds.S |   64 ++++++++++++++++++++
 arch/um/sys-x86_64/vdso/vdso-note.S       |   12 ++++
 arch/um/sys-x86_64/vdso/vdso.S            |   10 +++
 arch/um/sys-x86_64/vdso/vdso.lds.S        |   32 ++++++++++
 arch/um/sys-x86_64/vdso/vma.c             |   67 +++++++++++++++++++++
 10 files changed, 367 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/sys-x86_64/vdso/Makefile
 create mode 100755 arch/um/sys-x86_64/vdso/checkundef.sh
 create mode 100644 arch/um/sys-x86_64/vdso/um_vdso.c
 create mode 100644 arch/um/sys-x86_64/vdso/vdso-layout.lds.S
 create mode 100644 arch/um/sys-x86_64/vdso/vdso-note.S
 create mode 100644 arch/um/sys-x86_64/vdso/vdso.S
 create mode 100644 arch/um/sys-x86_64/vdso/vdso.lds.S
 create mode 100644 arch/um/sys-x86_64/vdso/vma.c

diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index c1ea9eb..cc70f7a 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -8,6 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
+obj-y += vdso/
+
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
 		lib/rwsem_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
diff --git a/arch/um/sys-x86_64/asm/elf.h b/arch/um/sys-x86_64/asm/elf.h
index 74eb0ac..11a2bfb 100644
--- a/arch/um/sys-x86_64/asm/elf.h
+++ b/arch/um/sys-x86_64/asm/elf.h
@@ -120,4 +120,13 @@ extern long elf_aux_hwcap;
 #define SET_PERSONALITY(ex) do ; while(0)
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+	int uses_interp);
+
+extern unsigned long um_vdso_addr;
+#define AT_SYSINFO_EHDR 33
+#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
+
 #endif
diff --git a/arch/um/sys-x86_64/vdso/Makefile b/arch/um/sys-x86_64/vdso/Makefile
new file mode 100644
index 0000000..5dffe6d
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/Makefile
@@ -0,0 +1,90 @@
+#
+# Building vDSO images for x86.
+#
+
+VDSO64-y		:= y
+
+vdso-install-$(VDSO64-y)	+= vdso.so
+
+
+# files to link into the vdso
+vobjs-y := vdso-note.o um_vdso.o
+
+# files to link into kernel
+obj-$(VDSO64-y)			+= vdso.o vma.o
+
+vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
+
+$(obj)/vdso.o: $(obj)/vdso.so
+
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
+
+export CPPFLAGS_vdso.lds += -P -C
+
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+       -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
+
+$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
+
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
+	$(call if_changed,vdso)
+
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
+CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
+       -fno-omit-frame-pointer -foptimize-sibling-calls
+
+$(vobjs): KBUILD_CFLAGS += $(CFL)
+
+#
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+#
+CFLAGS_REMOVE_vdso-note.o = -pg
+CFLAGS_REMOVE_um_vdso.o = -pg
+
+targets += vdso-syms.lds
+obj-$(VDSO64-y)			+= vdso-syms.lds
+
+#
+# Match symbols in the DSO that look like VDSO*; produce a file of constants.
+#
+sed-vdsosym := -e 's/^00*/0/' \
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+endef
+
+$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+#
+# The DSO images are built using a special linker script.
+#
+quiet_cmd_vdso = VDSO    $@
+      cmd_vdso = $(CC) -nostdlib -o $@ \
+		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
+		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
+
+VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
+
+#
+# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+#
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+PHONY += vdso_install $(vdso-install-y)
+vdso_install: $(vdso-install-y)
diff --git a/arch/um/sys-x86_64/vdso/checkundef.sh b/arch/um/sys-x86_64/vdso/checkundef.sh
new file mode 100755
index 0000000..7ee90a9
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/checkundef.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+nm="$1"
+file="$2"
+$nm "$file" | grep '^ *U' > /dev/null 2>&1
+if [ $? -eq 1 ]; then
+    exit 0
+else
+    echo "$file: undefined symbols found" >&2
+    exit 1
+fi
diff --git a/arch/um/sys-x86_64/vdso/um_vdso.c b/arch/um/sys-x86_64/vdso/um_vdso.c
new file mode 100644
index 0000000..7c441b5
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/um_vdso.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This vDSO turns all calls into a syscall so that UML can trap them.
+ */
+
+
+/* Disable profiling for userspace code */
+#define DISABLE_BRANCH_PROFILING
+
+#include <linux/time.h>
+#include <linux/getcpu.h>
+#include <asm/unistd.h>
+
+int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+{
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+
+	return ret;
+}
+int clock_gettime(clockid_t, struct timespec *)
+	__attribute__((weak, alias("__vdso_clock_gettime")));
+
+int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+
+	return ret;
+}
+int gettimeofday(struct timeval *, struct timezone *)
+	__attribute__((weak, alias("__vdso_gettimeofday")));
+
+time_t __vdso_time(time_t *t)
+{
+	long secs;
+
+	asm volatile("syscall"
+		: "=a" (secs)
+		: "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
+
+	return secs;
+}
+int time(time_t *t) __attribute__((weak, alias("__vdso_time")));
+
+long
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+{
+	/*
+	 * UML does not support SMP, we can cheat here. :)
+	 */
+
+	if (cpu)
+		*cpu = 0;
+	if (node)
+		*node = 0;
+
+	return 0;
+}
+
+long getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
+	__attribute__((weak, alias("__vdso_getcpu")));
diff --git a/arch/um/sys-x86_64/vdso/vdso-layout.lds.S b/arch/um/sys-x86_64/vdso/vdso-layout.lds.S
new file mode 100644
index 0000000..634a2cf
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/vdso-layout.lds.S
@@ -0,0 +1,64 @@
+/*
+ * Linker script for vDSO.  This is an ELF shared object prelinked to
+ * its virtual address, and with only one read-only segment.
+ * This script controls its layout.
+ */
+
+SECTIONS
+{
+	. = VDSO_PRELINK + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+	.data		: {
+	      *(.data*)
+	      *(.sdata*)
+	      *(.got.plt) *(.got)
+	      *(.gnu.linkonce.d.*)
+	      *(.bss*)
+	      *(.dynbss*)
+	      *(.gnu.linkonce.b.*)
+	}
+
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
+
+	/*
+	 * Align the actual code well away from the non-instruction data.
+	 * This is the best thing for the I-cache.
+	 */
+	. = ALIGN(0x100);
+
+	.text		: { *(.text*) }			:text	=0x90909090
+}
+
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
diff --git a/arch/um/sys-x86_64/vdso/vdso-note.S b/arch/um/sys-x86_64/vdso/vdso-note.S
new file mode 100644
index 0000000..79a071e
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/vdso-note.S
@@ -0,0 +1,12 @@
+/*
+ * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
+ * Here we can supply some information useful to userland.
+ */
+
+#include <linux/uts.h>
+#include <linux/version.h>
+#include <linux/elfnote.h>
+
+ELFNOTE_START(Linux, 0, "a")
+	.long LINUX_VERSION_CODE
+ELFNOTE_END
diff --git a/arch/um/sys-x86_64/vdso/vdso.S b/arch/um/sys-x86_64/vdso/vdso.S
new file mode 100644
index 0000000..ec82c16
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/vdso.S
@@ -0,0 +1,10 @@
+#include <linux/init.h>
+
+__INITDATA
+
+	.globl vdso_start, vdso_end
+vdso_start:
+	.incbin "arch/um/sys-x86_64/vdso/vdso.so"
+vdso_end:
+
+__FINIT
diff --git a/arch/um/sys-x86_64/vdso/vdso.lds.S b/arch/um/sys-x86_64/vdso/vdso.lds.S
new file mode 100644
index 0000000..b96b267
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/vdso.lds.S
@@ -0,0 +1,32 @@
+/*
+ * Linker script for 64-bit vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ */
+
+#define VDSO_PRELINK 0xffffffffff700000
+#include "vdso-layout.lds.S"
+
+/*
+ * This controls what userland symbols we export from the vDSO.
+ */
+VERSION {
+	LINUX_2.6 {
+	global:
+		clock_gettime;
+		__vdso_clock_gettime;
+		gettimeofday;
+		__vdso_gettimeofday;
+		getcpu;
+		__vdso_getcpu;
+		time;
+		__vdso_time;
+	local: *;
+	};
+}
+
+VDSO64_PRELINK = VDSO_PRELINK;
diff --git a/arch/um/sys-x86_64/vdso/vma.c b/arch/um/sys-x86_64/vdso/vma.c
new file mode 100644
index 0000000..b62827a
--- /dev/null
+++ b/arch/um/sys-x86_64/vdso/vma.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <linux/init.h>
+
+unsigned int __read_mostly vdso_enabled = 1;
+unsigned long um_vdso_addr;
+
+extern unsigned long task_size;
+extern char vdso_start[], vdso_end[];
+
+static struct page **vdsop;
+
+static int __init init_vdso(void)
+{
+	struct page *um_vdso;
+
+	BUG_ON(vdso_end - vdso_start > PAGE_SIZE);
+
+	um_vdso_addr = task_size - PAGE_SIZE;
+
+	vdsop = kmalloc(GFP_KERNEL, sizeof(struct page *));
+	if (!vdsop)
+		goto oom;
+
+	um_vdso = alloc_page(GFP_KERNEL);
+	if (!um_vdso) {
+		kfree(vdsop);
+
+		goto oom;
+	}
+
+	copy_page(page_address(um_vdso), vdso_start);
+	*vdsop = um_vdso;
+
+	return 0;
+
+oom:
+	printk(KERN_ERR "Cannot allocate vdso\n");
+	vdso_enabled = 0;
+
+	return -ENOMEM;
+}
+subsys_initcall(init_vdso);
+
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (!vdso_enabled)
+		return 0;
+
+	return install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
+		VM_READ|VM_EXEC|
+		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+		VM_ALWAYSDUMP,
+		vdsop);
+}
-- 
1.7.6

