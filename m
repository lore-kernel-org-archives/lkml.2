Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0EAOud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:50:33 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:62817 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0EAOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:24:58 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, x86@kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 012/100] c/r: extend arch_setup_additional_pages()
Date: Sat,  1 May 2010 10:14:54 -0400
Message-Id: <1272723382-19470-13-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Add "start" argument, to request to map vDSO to a specific place,
and fail the operation if not.

This is useful for restart(2) to ensure that memory layout is restore
exactly as needed.

Changelog[v19]:
  - [serge hallyn] Fix potential use-before-set ret
Changelog[v2]:
  - [ntl] powerpc: vdso build fix (ckpt-v17)

Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 arch/powerpc/include/asm/elf.h     |    1 +
 arch/powerpc/kernel/vdso.c         |   13 ++++++++++++-
 arch/s390/include/asm/elf.h        |    2 +-
 arch/s390/kernel/vdso.c            |   13 ++++++++++++-
 arch/sh/include/asm/elf.h          |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c |    2 +-
 arch/x86/include/asm/elf.h         |    3 ++-
 arch/x86/vdso/vdso32-setup.c       |    9 +++++++--
 arch/x86/vdso/vma.c                |   11 ++++++++---
 fs/binfmt_elf.c                    |    2 +-
 10 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index c376eda..0b06255 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -266,6 +266,7 @@ extern int ucache_bsize;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 #define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);
 
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index d84d192..74210ab 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -188,7 +188,8 @@ static void dump_vdso_pages(struct vm_area_struct * vma)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
@@ -220,6 +221,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	vdso_base = VDSO32_MBASE;
 #endif
 
+	/* in case restart(2) mandates a specific location */
+	if (start)
+		vdso_base = start;
+
 	current->mm->context.vdso_base = 0;
 
 	/* vDSO has a problem and was disabled, just don't "enable" it for the
@@ -249,6 +254,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	/* Add required alignment. */
 	vdso_base = ALIGN(vdso_base, VDSO_ALIGNMENT);
 
+	/* for restart(2), double check that we got we asked for */
+	if (start && vdso_base != start) {
+		rc = -EBUSY;
+		goto fail_mmapsem;
+	}
+
 	/*
 	 * Put vDSO base into mm struct. We need to do this before calling
 	 * install_special_mapping or the perf counter mmap tracking code
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 354d426..5081938 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -216,6 +216,6 @@ do {									    \
 struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-int arch_setup_additional_pages(struct linux_binprm *, int);
+int arch_setup_additional_pages(struct linux_binprm *, unsigned long, int);
 
 #endif
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 6bc9c19..54dad2f 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -195,7 +195,8 @@ static void vdso_init_cr5(void)
  * This is called from binfmt_elf, we create the special vma for the
  * vDSO and insert it into the mm struct tree
  */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	struct page **vdso_pagelist;
@@ -226,6 +227,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	vdso_pages = vdso32_pages;
 #endif
 
+	/* in case restart(2) mandates a specific location */
+	if (start)
+		vdso_base = start;
+
 	/*
 	 * vDSO has a problem and was disabled, just don't "enable" it for
 	 * the process
@@ -248,6 +253,12 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		goto out_up;
 	}
 
+	/* for restart(2), double check that we got we asked for */
+	if (start && vdso_base != start) {
+		rc = -EINVAL;
+		goto out_up;
+	}
+
 	/*
 	 * Put vDSO base into mm struct. We need to do this before calling
 	 * install_special_mapping or the perf counter mmap tracking code
diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
index ce830fa..4128c30 100644
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -201,6 +201,7 @@ do {									\
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 
 extern unsigned int vdso_enabled;
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 242117c..6dbdfe1 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -58,7 +58,7 @@ int __init vsyscall_init(void)
 }
 
 /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm, unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..3761be8 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -312,9 +312,10 @@ struct linux_binprm;
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       unsigned long start,
 				       int uses_interp);
 
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+extern int syscall32_setup_pages(struct linux_binprm *, unsigned long start, int exstack);
 #define compat_arch_setup_additional_pages	syscall32_setup_pages
 
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 02b442e..62043c1 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -310,7 +310,8 @@ int __init sysenter_setup(void)
 }
 
 /* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
@@ -331,13 +332,17 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (compat)
 		addr = VDSO_HIGH_BASE;
 	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+		addr = get_unmapped_area(NULL, start, PAGE_SIZE, 0, 0);
 		if (IS_ERR_VALUE(addr)) {
 			ret = addr;
 			goto up_fail;
 		}
 	}
 
+	/* for restart(2), double check that we got we asked for */
+	if (start && addr != start)
+		goto up_fail;
+
 	current->mm->context.vdso = (void *)addr;
 
 	if (compat_uses_vma || !compat) {
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..b813286 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -100,23 +100,28 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 
 /* Setup a VMA at program startup for the vsyscall page.
    Not called for compat tasks */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+int arch_setup_additional_pages(struct linux_binprm *bprm,
+				unsigned long start, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
-	int ret;
+	int ret = -EINVAL;
 
 	if (!vdso_enabled)
 		return 0;
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, vdso_size);
+	addr = start ? : vdso_addr(mm->start_stack, vdso_size);
 	addr = get_unmapped_area(NULL, addr, vdso_size, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
+	/* for restart(2), double check that we got we asked for */
+	if (start && addr != start)
+		goto up_fail;
+
 	current->mm->context.vdso = (void *)addr;
 
 	ret = install_special_mapping(mm, addr, vdso_size,
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 535e763..6434003 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -923,7 +923,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	set_binfmt(&elf_format);
 
 #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
-	retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
+	retval = arch_setup_additional_pages(bprm, 0, !!elf_interpreter);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
-- 
1.6.3.3

