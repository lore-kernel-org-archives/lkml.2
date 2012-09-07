Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2IGQcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:32:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34529 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2IGQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:56 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 18/31] arm64: VDSO support
Date: Fri,  7 Sep 2012 17:26:53 +0100
Message-Id: <1347035226-18649-19-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:54.0363 (UTC) FILETIME=[BB8704B0:01CD8D15]
X-MC-Unique: 112090717275413301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GXAsT008419

From: Will Deacon <will.deacon@arm.com>

This patch adds VDSO support for 64-bit applications. The VDSO code is
currently used for sys_rt_sigreturn() and optimised gettimeofday()
(using the user-accessible generic counter).

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/vdso.h              |   41 +++++
 arch/arm64/include/asm/vdso_datapage.h     |   43 +++++
 arch/arm64/kernel/vdso.c                   |  261 ++++++++++++++++++++++++++++
 arch/arm64/kernel/vdso/.gitignore          |    2 +
 arch/arm64/kernel/vdso/Makefile            |   63 +++++++
 arch/arm64/kernel/vdso/gen_vdso_offsets.sh |   15 ++
 arch/arm64/kernel/vdso/gettimeofday.S      |  242 ++++++++++++++++++++++++++
 arch/arm64/kernel/vdso/note.S              |   28 +++
 arch/arm64/kernel/vdso/sigreturn.S         |   37 ++++
 arch/arm64/kernel/vdso/vdso.S              |   33 ++++
 arch/arm64/kernel/vdso/vdso.lds.S          |  100 +++++++++++
 11 files changed, 865 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/vdso.h
 create mode 100644 arch/arm64/include/asm/vdso_datapage.h
 create mode 100644 arch/arm64/kernel/vdso.c
 create mode 100644 arch/arm64/kernel/vdso/.gitignore
 create mode 100644 arch/arm64/kernel/vdso/Makefile
 create mode 100755 arch/arm64/kernel/vdso/gen_vdso_offsets.sh
 create mode 100644 arch/arm64/kernel/vdso/gettimeofday.S
 create mode 100644 arch/arm64/kernel/vdso/note.S
 create mode 100644 arch/arm64/kernel/vdso/sigreturn.S
 create mode 100644 arch/arm64/kernel/vdso/vdso.S
 create mode 100644 arch/arm64/kernel/vdso/vdso.lds.S

diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
new file mode 100644
index 0000000..839ce00
--- /dev/null
+++ b/arch/arm64/include/asm/vdso.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_VDSO_H
+#define __ASM_VDSO_H
+
+#ifdef __KERNEL__
+
+/*
+ * Default link address for the vDSO.
+ * Since we randomise the VDSO mapping, there's little point in trying
+ * to prelink this.
+ */
+#define VDSO_LBASE	0x0
+
+#ifndef __ASSEMBLY__
+
+#include <generated/vdso-offsets.h>
+
+#define VDSO_SYMBOL(base, name)						   \
+({									   \
+	(void *)(vdso_offset_##name - VDSO_LBASE + (unsigned long)(base)); \
+})
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_VDSO_H */
diff --git a/arch/arm64/include/asm/vdso_datapage.h b/arch/arm64/include/asm/vdso_datapage.h
new file mode 100644
index 0000000..de66199
--- /dev/null
+++ b/arch/arm64/include/asm/vdso_datapage.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_VDSO_DATAPAGE_H
+#define __ASM_VDSO_DATAPAGE_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+struct vdso_data {
+	__u64 cs_cycle_last;	/* Timebase at clocksource init */
+	__u64 xtime_clock_sec;	/* Kernel time */
+	__u64 xtime_clock_nsec;
+	__u64 xtime_coarse_sec;	/* Coarse time */
+	__u64 xtime_coarse_nsec;
+	__u64 wtm_clock_sec;	/* Wall to monotonic time */
+	__u64 wtm_clock_nsec;
+	__u32 tb_seq_count;	/* Timebase sequence counter */
+	__u32 cs_mult;		/* Clocksource multiplier */
+	__u32 cs_shift;		/* Clocksource shift */
+	__u32 tz_minuteswest;	/* Whacky timezone stuff */
+	__u32 tz_dsttime;
+	__u32 use_syscall;
+};
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_VDSO_DATAPAGE_H */
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
new file mode 100644
index 0000000..17948fc
--- /dev/null
+++ b/arch/arm64/kernel/vdso.c
@@ -0,0 +1,261 @@
+/*
+ * VDSO implementation for AArch64 and vector page setup for AArch32.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/clocksource.h>
+#include <linux/elf.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <asm/cacheflush.h>
+#include <asm/signal32.h>
+#include <asm/vdso.h>
+#include <asm/vdso_datapage.h>
+
+extern char vdso_start, vdso_end;
+static unsigned long vdso_pages;
+static struct page **vdso_pagelist;
+
+/*
+ * The vDSO data page.
+ */
+static union {
+	struct vdso_data	data;
+	u8			page[PAGE_SIZE];
+} vdso_data_store __page_aligned_data;
+struct vdso_data *vdso_data = &vdso_data_store.data;
+
+#ifdef CONFIG_COMPAT
+/*
+ * Create and map the vectors page for AArch32 tasks.
+ */
+static struct page *vectors_page[1];
+
+static int alloc_vectors_page(void)
+{
+	extern char __kuser_helper_start[], __kuser_helper_end[];
+	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned long vpage;
+
+	vpage = get_zeroed_page(GFP_ATOMIC);
+
+	if (!vpage)
+		return -ENOMEM;
+
+	/* kuser helpers */
+	memcpy((void *)vpage + 0x1000 - kuser_sz, __kuser_helper_start,
+		kuser_sz);
+
+	/* sigreturn code */
+	memcpy((void *)vpage + AARCH32_KERN_SIGRET_CODE_OFFSET,
+		aarch32_sigret_code, sizeof(aarch32_sigret_code));
+
+	flush_icache_range(vpage, vpage + PAGE_SIZE);
+	vectors_page[0] = virt_to_page(vpage);
+
+	return 0;
+}
+arch_initcall(alloc_vectors_page);
+
+int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = AARCH32_VECTORS_BASE;
+	int ret;
+
+	down_write(&mm->mmap_sem);
+	current->mm->context.vdso = (void *)addr;
+
+	/* Map vectors page at the high address. */
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYEXEC,
+				      vectors_page);
+
+	up_write(&mm->mmap_sem);
+
+	return ret;
+}
+#endif /* CONFIG_COMPAT */
+
+static int __init vdso_init(void)
+{
+	struct page *pg;
+	char *vbase;
+	int i, ret = 0;
+
+	vdso_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
+	pr_info("vdso: %ld pages (%ld code, %ld data) at base %p\n",
+		vdso_pages + 1, vdso_pages, 1L, &vdso_start);
+
+	/* Allocate the vDSO pagelist, plus a page for the data. */
+	vdso_pagelist = kzalloc(sizeof(struct page *) * (vdso_pages + 1),
+				GFP_KERNEL);
+	if (vdso_pagelist == NULL) {
+		pr_err("Failed to allocate vDSO pagelist!\n");
+		return -ENOMEM;
+	}
+
+	/* Grab the vDSO code pages. */
+	for (i = 0; i < vdso_pages; i++) {
+		pg = virt_to_page(&vdso_start + i*PAGE_SIZE);
+		ClearPageReserved(pg);
+		get_page(pg);
+		vdso_pagelist[i] = pg;
+	}
+
+	/* Sanity check the shared object header. */
+	vbase = vmap(vdso_pagelist, 1, 0, PAGE_KERNEL);
+	if (vbase == NULL) {
+		pr_err("Failed to map vDSO pagelist!\n");
+		return -ENOMEM;
+	} else if (memcmp(vbase, "\177ELF", 4)) {
+		pr_err("vDSO is not a valid ELF object!\n");
+		ret = -EINVAL;
+		goto unmap;
+	}
+
+	/* Grab the vDSO data page. */
+	pg = virt_to_page(vdso_data);
+	get_page(pg);
+	vdso_pagelist[i] = pg;
+
+unmap:
+	vunmap(vbase);
+	return ret;
+}
+arch_initcall(vdso_init);
+
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				int uses_interp)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long vdso_base, vdso_mapping_len;
+	int ret;
+
+	/* Be sure to map the data page */
+	vdso_mapping_len = (vdso_pages + 1) << PAGE_SHIFT;
+
+	down_write(&mm->mmap_sem);
+	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
+	if (IS_ERR_VALUE(vdso_base)) {
+		ret = vdso_base;
+		goto up_fail;
+	}
+	mm->context.vdso = (void *)vdso_base;
+
+	ret = install_special_mapping(mm, vdso_base, vdso_mapping_len,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				      vdso_pagelist);
+	if (ret) {
+		mm->context.vdso = NULL;
+		goto up_fail;
+	}
+
+up_fail:
+	up_write(&mm->mmap_sem);
+
+	return ret;
+}
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	/*
+	 * We can re-use the vdso pointer in mm_context_t for identifying
+	 * the vectors page for compat applications. The vDSO will always
+	 * sit above TASK_UNMAPPED_BASE and so we don't need to worry about
+	 * it conflicting with the vectors base.
+	 */
+	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso) {
+#ifdef CONFIG_COMPAT
+		if (vma->vm_start == AARCH32_VECTORS_BASE)
+			return "[vectors]";
+#endif
+		return "[vdso]";
+	}
+
+	return NULL;
+}
+
+/*
+ * We define AT_SYSINFO_EHDR, so we need these function stubs to keep
+ * Linux happy.
+ */
+int in_gate_area_no_mm(unsigned long addr)
+{
+	return 0;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	return 0;
+}
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+/*
+ * Update the vDSO data page to keep in sync with kernel timekeeping.
+ */
+void update_vsyscall(struct timespec *ts, struct timespec *wtm,
+		     struct clocksource *clock, u32 mult)
+{
+	struct timespec xtime_coarse;
+	u32 use_syscall = strcmp(clock->name, "arch_sys_counter");
+
+	++vdso_data->tb_seq_count;
+	smp_wmb();
+
+	xtime_coarse = __current_kernel_time();
+	vdso_data->use_syscall			= use_syscall;
+	vdso_data->xtime_coarse_sec		= xtime_coarse.tv_sec;
+	vdso_data->xtime_coarse_nsec		= xtime_coarse.tv_nsec;
+
+	if (!use_syscall) {
+		vdso_data->cs_cycle_last	= clock->cycle_last;
+		vdso_data->xtime_clock_sec	= ts->tv_sec;
+		vdso_data->xtime_clock_nsec	= ts->tv_nsec;
+		vdso_data->cs_mult		= mult;
+		vdso_data->cs_shift		= clock->shift;
+		vdso_data->wtm_clock_sec	= wtm->tv_sec;
+		vdso_data->wtm_clock_nsec	= wtm->tv_nsec;
+	}
+
+	smp_wmb();
+	++vdso_data->tb_seq_count;
+}
+
+void update_vsyscall_tz(void)
+{
+	++vdso_data->tb_seq_count;
+	smp_wmb();
+	vdso_data->tz_minuteswest	= sys_tz.tz_minuteswest;
+	vdso_data->tz_dsttime		= sys_tz.tz_dsttime;
+	smp_wmb();
+	++vdso_data->tb_seq_count;
+}
diff --git a/arch/arm64/kernel/vdso/.gitignore b/arch/arm64/kernel/vdso/.gitignore
new file mode 100644
index 0000000..b8cc94e
--- /dev/null
+++ b/arch/arm64/kernel/vdso/.gitignore
@@ -0,0 +1,2 @@
+vdso.lds
+vdso-offsets.h
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
new file mode 100644
index 0000000..d8064af
--- /dev/null
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -0,0 +1,63 @@
+#
+# Building a vDSO image for AArch64.
+#
+# Author: Will Deacon <will.deacon@arm.com>
+# Heavily based on the vDSO Makefiles for other archs.
+#
+
+obj-vdso := gettimeofday.o note.o sigreturn.o
+
+# Build rules
+targets := $(obj-vdso) vdso.so vdso.so.dbg
+obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
+
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-vdso.so.1 \
+		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+
+obj-y += vdso.o
+extra-y += vdso.lds vdso-offsets.h
+CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+
+# Force dependency (incbin is bad)
+$(obj)/vdso.o : $(obj)/vdso.so
+
+# Link rule for the .so file, .lds has to be first
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso)
+	$(call if_changed,vdsold)
+
+# Strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@ && \
+	cp $@ include/generated/
+endef
+
+$(obj)/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+# Assembly rules for the .S files
+$(obj-vdso): %.o: %.S
+	$(call if_changed_dep,vdsoas)
+
+# Actual build commands
+quiet_cmd_vdsold = VDSOL $@
+      cmd_vdsold = $(CC) $(c_flags) -Wl,-T $^ -o $@
+quiet_cmd_vdsoas = VDSOA $@
+      cmd_vdsoas = $(CC) $(a_flags) -c -o $@ $<
+
+# Install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso.so: $(obj)/vdso.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso.so
diff --git a/arch/arm64/kernel/vdso/gen_vdso_offsets.sh b/arch/arm64/kernel/vdso/gen_vdso_offsets.sh
new file mode 100755
index 0000000..01924ff
--- /dev/null
+++ b/arch/arm64/kernel/vdso/gen_vdso_offsets.sh
@@ -0,0 +1,15 @@
+#!/bin/sh
+
+#
+# Match symbols in the DSO that look like VDSO_*; produce a header file
+# of constant offsets into the shared object.
+#
+# Doing this inside the Makefile will break the $(filter-out) function,
+# causing Kbuild to rebuild the vdso-offsets header file every time.
+#
+# Author: Will Deacon <will.deacon@arm.com
+#
+
+LC_ALL=C
+sed -n -e 's/^00*/0/' -e \
+'s/^\([0-9a-fA-F]*\) . VDSO_\([a-zA-Z0-9_]*\)$/\#define vdso_offset_\2\t0x\1/p'
diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
new file mode 100644
index 0000000..dcb8c20
--- /dev/null
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -0,0 +1,242 @@
+/*
+ * Userspace implementations of gettimeofday() and friends.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/unistd.h>
+
+#define NSEC_PER_SEC_LO16	0xca00
+#define NSEC_PER_SEC_HI16	0x3b9a
+
+vdso_data	.req	x6
+use_syscall	.req	w7
+seqcnt		.req	w8
+
+	.macro	seqcnt_acquire
+9999:	ldr	seqcnt, [vdso_data, #VDSO_TB_SEQ_COUNT]
+	tbnz	seqcnt, #0, 9999b
+	dmb	ishld
+	ldr	use_syscall, [vdso_data, #VDSO_USE_SYSCALL]
+	.endm
+
+	.macro	seqcnt_read, cnt
+	dmb	ishld
+	ldr	\cnt, [vdso_data, #VDSO_TB_SEQ_COUNT]
+	.endm
+
+	.macro	seqcnt_check, cnt, fail
+	cmp	\cnt, seqcnt
+	b.ne	\fail
+	.endm
+
+	.text
+
+/* int __kernel_gettimeofday(struct timeval *tv, struct timezone *tz); */
+ENTRY(__kernel_gettimeofday)
+	.cfi_startproc
+	mov	x2, x30
+	.cfi_register x30, x2
+
+	/* Acquire the sequence counter and get the timespec. */
+	adr	vdso_data, _vdso_data
+1:	seqcnt_acquire
+	cbnz	use_syscall, 4f
+
+	/* If tv is NULL, skip to the timezone code. */
+	cbz	x0, 2f
+	bl	__do_get_tspec
+	seqcnt_check w13, 1b
+
+	/* Convert ns to us. */
+	mov	x11, #1000
+	udiv	x10, x10, x11
+	stp	x9, x10, [x0, #TVAL_TV_SEC]
+2:
+	/* If tz is NULL, return 0. */
+	cbz	x1, 3f
+	ldp	w4, w5, [vdso_data, #VDSO_TZ_MINWEST]
+	seqcnt_read w13
+	seqcnt_check w13, 1b
+	stp	w4, w5, [x1, #TZ_MINWEST]
+3:
+	mov	x0, xzr
+	ret	x2
+4:
+	/* Syscall fallback. */
+	mov	x8, #__NR_gettimeofday
+	svc	#0
+	ret	x2
+	.cfi_endproc
+ENDPROC(__kernel_gettimeofday)
+
+/* int __kernel_clock_gettime(clockid_t clock_id, struct timespec *tp); */
+ENTRY(__kernel_clock_gettime)
+	.cfi_startproc
+	cmp	w0, #CLOCK_REALTIME
+	ccmp	w0, #CLOCK_MONOTONIC, #0x4, ne
+	b.ne	2f
+
+	mov	x2, x30
+	.cfi_register x30, x2
+
+	/* Get kernel timespec. */
+	adr	vdso_data, _vdso_data
+1:	seqcnt_acquire
+	cbnz	use_syscall, 7f
+
+	bl	__do_get_tspec
+	seqcnt_check w13, 1b
+
+	cmp	w0, #CLOCK_MONOTONIC
+	b.ne	6f
+
+	/* Get wtm timespec. */
+	ldp	x14, x15, [vdso_data, #VDSO_WTM_CLK_SEC]
+
+	/* Check the sequence counter. */
+	seqcnt_read w13
+	seqcnt_check w13, 1b
+	b	4f
+2:
+	cmp	w0, #CLOCK_REALTIME_COARSE
+	ccmp	w0, #CLOCK_MONOTONIC_COARSE, #0x4, ne
+	b.ne	8f
+
+	/* Get coarse timespec. */
+	adr	vdso_data, _vdso_data
+3:	seqcnt_acquire
+	ldp	x9, x10, [vdso_data, #VDSO_XTIME_CRS_SEC]
+
+	cmp	w0, #CLOCK_MONOTONIC_COARSE
+	b.ne	6f
+
+	/* Get wtm timespec. */
+	ldp	x14, x15, [vdso_data, #VDSO_WTM_CLK_SEC]
+
+	/* Check the sequence counter. */
+	seqcnt_read w13
+	seqcnt_check w13, 3b
+4:
+	/* Add on wtm timespec. */
+	add	x9, x9, x14
+	add	x10, x10, x15
+
+	/* Normalise the new timespec. */
+	mov	x14, #NSEC_PER_SEC_LO16
+	movk	x14, #NSEC_PER_SEC_HI16, lsl #16
+	cmp	x10, x14
+	b.lt	5f
+	sub	x10, x10, x14
+	add	x9, x9, #1
+5:
+	cmp	x10, #0
+	b.ge	6f
+	add	x10, x10, x14
+	sub	x9, x9, #1
+
+6:	/* Store to the user timespec. */
+	stp	x9, x10, [x1, #TSPEC_TV_SEC]
+	mov	x0, xzr
+	ret	x2
+7:
+	mov	x30, x2
+8:	/* Syscall fallback. */
+	mov	x8, #__NR_clock_gettime
+	svc	#0
+	ret
+	.cfi_endproc
+ENDPROC(__kernel_clock_gettime)
+
+/* int __kernel_clock_getres(clockid_t clock_id, struct timespec *res); */
+ENTRY(__kernel_clock_getres)
+	.cfi_startproc
+	cbz	w1, 3f
+
+	cmp	w0, #CLOCK_REALTIME
+	ccmp	w0, #CLOCK_MONOTONIC, #0x4, ne
+	b.ne	1f
+
+	ldr	x2, 5f
+	b	2f
+1:
+	cmp	w0, #CLOCK_REALTIME_COARSE
+	ccmp	w0, #CLOCK_MONOTONIC_COARSE, #0x4, ne
+	b.ne	4f
+	ldr	x2, 6f
+2:
+	stp	xzr, x2, [x1]
+
+3:	/* res == NULL. */
+	mov	w0, wzr
+	ret
+
+4:	/* Syscall fallback. */
+	mov	x8, #__NR_clock_getres
+	svc	#0
+	ret
+5:
+	.quad	CLOCK_REALTIME_RES
+6:
+	.quad	CLOCK_COARSE_RES
+	.cfi_endproc
+ENDPROC(__kernel_clock_getres)
+
+/*
+ * Read the current time from the architected counter.
+ * Expects vdso_data to be initialised.
+ * Clobbers the temporary registers (x9 - x15).
+ * Returns:
+ *  - (x9, x10) = (ts->tv_sec, ts->tv_nsec)
+ *  - (x11, x12) = (xtime->tv_sec, xtime->tv_nsec)
+ *  - w13 = vDSO sequence counter
+ */
+ENTRY(__do_get_tspec)
+	.cfi_startproc
+
+	/* Read from the vDSO data page. */
+	ldr	x10, [vdso_data, #VDSO_CS_CYCLE_LAST]
+	ldp	x11, x12, [vdso_data, #VDSO_XTIME_CLK_SEC]
+	ldp	w14, w15, [vdso_data, #VDSO_CS_MULT]
+	seqcnt_read w13
+
+	/* Read the physical counter. */
+	isb
+	mrs	x9, cntpct_el0
+
+	/* Calculate cycle delta and convert to ns. */
+	sub	x10, x9, x10
+	/* We can only guarantee 56 bits of precision. */
+	movn	x9, #0xff0, lsl #48
+	and	x10, x9, x10
+	mul	x10, x10, x14
+	lsr	x10, x10, x15
+
+	/* Use the kernel time to calculate the new timespec. */
+	add	x10, x12, x10
+	mov	x14, #NSEC_PER_SEC_LO16
+	movk	x14, #NSEC_PER_SEC_HI16, lsl #16
+	udiv	x15, x10, x14
+	add	x9, x15, x11
+	mul	x14, x14, x15
+	sub	x10, x10, x14
+
+	ret
+	.cfi_endproc
+ENDPROC(__do_get_tspec)
diff --git a/arch/arm64/kernel/vdso/note.S b/arch/arm64/kernel/vdso/note.S
new file mode 100644
index 0000000..b82c85e
--- /dev/null
+++ b/arch/arm64/kernel/vdso/note.S
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ *
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
diff --git a/arch/arm64/kernel/vdso/sigreturn.S b/arch/arm64/kernel/vdso/sigreturn.S
new file mode 100644
index 0000000..20d98ef
--- /dev/null
+++ b/arch/arm64/kernel/vdso/sigreturn.S
@@ -0,0 +1,37 @@
+/*
+ * Sigreturn trampoline for returning from a signal when the SA_RESTORER
+ * flag is not set.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/unistd.h>
+
+	.text
+
+	nop
+ENTRY(__kernel_rt_sigreturn)
+	.cfi_startproc
+	.cfi_signal_frame
+	.cfi_def_cfa	x29, 0
+	.cfi_offset	x29, 0 * 8
+	.cfi_offset	x30, 1 * 8
+	mov	x8, #__NR_rt_sigreturn
+	svc	#0
+	.cfi_endproc
+ENDPROC(__kernel_rt_sigreturn)
diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
new file mode 100644
index 0000000..60c1db5
--- /dev/null
+++ b/arch/arm64/kernel/vdso/vdso.S
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.globl vdso_start, vdso_end
+	.balign PAGE_SIZE
+vdso_start:
+	.incbin "arch/arm64/kernel/vdso/vdso.so"
+	.balign PAGE_SIZE
+vdso_end:
+
+	.previous
diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
new file mode 100644
index 0000000..8154b8d
--- /dev/null
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -0,0 +1,100 @@
+/*
+ * GNU linker script for the VDSO library.
+*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Heavily based on the vDSO linker scripts for other archs.
+ */
+
+#include <linux/const.h>
+#include <asm/page.h>
+#include <asm/vdso.h>
+
+OUTPUT_FORMAT("elf64-littleaarch64", "elf64-bigaarch64", "elf64-littleaarch64")
+OUTPUT_ARCH(aarch64)
+
+SECTIONS
+{
+	. = VDSO_LBASE + SIZEOF_HEADERS;
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
+	. = ALIGN(16);
+
+	.text		: { *(.text*) }			:text	=0xd503201f
+	PROVIDE (__etext = .);
+	PROVIDE (_etext = .);
+	PROVIDE (etext = .);
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+
+	_end = .;
+	PROVIDE(end = .);
+
+	. = ALIGN(PAGE_SIZE);
+	PROVIDE(_vdso_data = .);
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
+}
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
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+	LINUX_2.6.39 {
+	global:
+		__kernel_rt_sigreturn;
+		__kernel_gettimeofday;
+		__kernel_clock_gettime;
+		__kernel_clock_getres;
+	local: *;
+	};
+}
+
+/*
+ * Make the sigreturn code visible to the kernel.
+ */
+VDSO_sigtramp		= __kernel_rt_sigreturn;

