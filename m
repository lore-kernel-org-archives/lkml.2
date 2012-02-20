Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2BTAWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:22:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2BTAW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:22:29 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 30/30] x32: Add x32 VDSO support
Date: Sun, 19 Feb 2012 16:08:08 -0800
Message-Id: <1329696488-16970-31-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:22:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Add support for the x32 VDSO.  The x32 VDSO takes advantage of the
similarity between the x86-64 and the x32 ABIs to contain the same
content, only the container is different, as the x32 VDSO obviously is
an x32 shared object.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/vdso/.gitignore     |    2 +
 arch/x86/vdso/Makefile       |   46 ++++++++++++++++++++++++-
 arch/x86/vdso/vdso32-setup.c |    6 +++
 arch/x86/vdso/vdsox32.S      |   22 ++++++++++++
 arch/x86/vdso/vdsox32.lds.S  |   32 +++++++++++++++++
 arch/x86/vdso/vma.c          |   78 +++++++++++++++++++++++++++++++++++++----
 6 files changed, 177 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/vdso/vdsox32.S
 create mode 100644 arch/x86/vdso/vdsox32.lds.S

diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 60274d5..3282874 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,5 +1,7 @@
 vdso.lds
 vdso-syms.lds
+vdsox32.lds
+vdsox32-syms.lds
 vdso32-syms.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 5d17950..fd14be1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -3,21 +3,29 @@
 #
 
 VDSO64-$(CONFIG_X86_64)		:= y
+VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
 vdso-install-$(VDSO64-y)	+= vdso.so
+vdso-install-$(VDSOX32-y)	+= vdsox32.so
 vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
+vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
+
+# Filter out x32 objects.
+vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
+
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
+obj-$(VDSOX32-y)		+= vdsox32.o
 obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
-vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
+vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
@@ -73,6 +81,42 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
 #
+# X32 processes use x32 vDSO to access 64bit kernel data.
+#
+# Build x32 vDSO image:
+# 1. Compile x32 vDSO as 64bit.
+# 2. Convert object files to x32.
+# 3. Build x32 VDSO image with x32 objects, which contains 64bit codes
+# so that it can reach 64bit address space with 64bit pointers.
+#
+
+targets += vdsox32-syms.lds
+obj-$(VDSOX32-y)		+= vdsox32-syms.lds
+
+CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
+VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
+			   -Wl,-soname=linux-vdso.so.1 \
+			   -Wl,-z,max-page-size=4096 \
+			   -Wl,-z,common-page-size=4096
+
+vobjx32s-y := $(vobj64s:.o=-x32.o)
+vobjx32s := $(foreach F,$(vobjx32s-y),$(obj)/$F)
+
+# Convert 64bit object file to x32 for x32 vDSO.
+quiet_cmd_x32 = X32     $@
+      cmd_x32 = $(OBJCOPY) -O elf32-x86-64 $< $@
+
+$(obj)/%-x32.o: $(obj)/%.o FORCE
+	$(call if_changed,x32)
+
+targets += vdsox32.so vdsox32.so.dbg vdsox32.lds $(vobjx32s-y)
+
+$(obj)/vdsox32.o: $(src)/vdsox32.S $(obj)/vdsox32.so
+
+$(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
+	$(call if_changed,vdso)
+
+#
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
 obj-$(VDSO32-y)			+= vdso32-syms.lds
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 468d591..01b8a0d 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -317,6 +317,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	int ret = 0;
 	bool compat;
 
+#ifdef CONFIG_X86_X32_ABI
+	extern int x32_setup_additional_pages(struct linux_binprm *, int);
+	if (test_thread_flag(TIF_X32))
+		return x32_setup_additional_pages (bprm, uses_interp);
+#endif
+
 	if (vdso_enabled == VDSO_DISABLED)
 		return 0;
 
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
new file mode 100644
index 0000000..d6b9a7f
--- /dev/null
+++ b/arch/x86/vdso/vdsox32.S
@@ -0,0 +1,22 @@
+#include <asm/page_types.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+__PAGE_ALIGNED_DATA
+
+	.globl vdsox32_start, vdsox32_end
+	.align PAGE_SIZE
+vdsox32_start:
+	.incbin "arch/x86/vdso/vdsox32.so"
+vdsox32_end:
+	.align PAGE_SIZE /* extra data here leaks to userspace. */
+
+.previous
+
+	.globl vdsox32_pages
+	.bss
+	.align 8
+	.type vdsox32_pages, @object
+vdsox32_pages:
+	.zero (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
+	.size vdsox32_pages, .-vdsox32_pages
diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
new file mode 100644
index 0000000..373ca9a
--- /dev/null
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -0,0 +1,32 @@
+/*
+ * Linker script for x32 vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ */
+
+#define VDSO_PRELINK 0
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
+VDSOX32_PRELINK = VDSO_PRELINK;
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 153407c..1bbcc62 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -24,7 +24,44 @@ extern unsigned short vdso_sync_cpuid;
 extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
-static void __init patch_vdso(void *vdso, size_t len)
+#ifdef CONFIG_X86_X32_ABI
+extern char vdsox32_start[], vdsox32_end[];
+extern struct page *vdsox32_pages[];
+static unsigned vdsox32_size;
+
+static void __init patch_vdsox32(void *vdso, size_t len)
+{
+	Elf32_Ehdr *hdr = vdso;
+	Elf32_Shdr *sechdrs, *alt_sec = 0;
+	char *secstrings;
+	void *alt_data;
+	int i;
+
+	BUG_ON(len < sizeof(Elf32_Ehdr));
+	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
+
+	sechdrs = (void *)hdr + hdr->e_shoff;
+	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		Elf32_Shdr *shdr = &sechdrs[i];
+		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
+			alt_sec = shdr;
+			goto found;
+		}
+	}
+
+	/* If we get here, it's probably a bug. */
+	pr_warning("patch_vdsox32: .altinstructions not found\n");
+	return;  /* nothing to patch */
+
+found:
+	alt_data = (void *)hdr + alt_sec->sh_offset;
+	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+}
+#endif
+
+static void __init patch_vdso64(void *vdso, size_t len)
 {
 	Elf64_Ehdr *hdr = vdso;
 	Elf64_Shdr *sechdrs, *alt_sec = 0;
@@ -47,7 +84,7 @@ static void __init patch_vdso(void *vdso, size_t len)
 	}
 
 	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso: .altinstructions not found\n");
+	pr_warning("patch_vdso64: .altinstructions not found\n");
 	return;  /* nothing to patch */
 
 found:
@@ -60,12 +97,20 @@ static int __init init_vdso(void)
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
 
-	patch_vdso(vdso_start, vdso_end - vdso_start);
+	patch_vdso64(vdso_start, vdso_end - vdso_start);
 
 	vdso_size = npages << PAGE_SHIFT;
 	for (i = 0; i < npages; i++)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
+#ifdef CONFIG_X86_X32_ABI
+	patch_vdsox32(vdsox32_start, vdsox32_end - vdsox32_start);
+	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdsox32_size = npages << PAGE_SHIFT;
+	for (i = 0; i < npages; i++)
+		vdsox32_pages[i] = virt_to_page(vdsox32_start + i*PAGE_SIZE);
+#endif
+
 	return 0;
 }
 subsys_initcall(init_vdso);
@@ -103,7 +148,10 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 
 /* Setup a VMA at program startup for the vsyscall page.
    Not called for compat tasks */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+static int setup_additional_pages(struct linux_binprm *bprm,
+				  int uses_interp,
+				  struct page **pages,
+				  unsigned size)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
@@ -113,8 +161,8 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		return 0;
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, vdso_size);
-	addr = get_unmapped_area(NULL, addr, vdso_size, 0, 0);
+	addr = vdso_addr(mm->start_stack, size);
+	addr = get_unmapped_area(NULL, addr, size, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
@@ -122,11 +170,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	current->mm->context.vdso = (void *)addr;
 
-	ret = install_special_mapping(mm, addr, vdso_size,
+	ret = install_special_mapping(mm, addr, size,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				      VM_ALWAYSDUMP,
-				      vdso_pages);
+				      pages);
 	if (ret) {
 		current->mm->context.vdso = NULL;
 		goto up_fail;
@@ -137,6 +185,20 @@ up_fail:
 	return ret;
 }
 
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	return setup_additional_pages (bprm, uses_interp, vdso_pages,
+				       vdso_size);
+}
+
+#ifdef CONFIG_X86_X32_ABI
+int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	return setup_additional_pages (bprm, uses_interp, vdsox32_pages,
+				       vdsox32_size);
+}
+#endif
+
 static __init int vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
-- 
1.7.6.5

