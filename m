Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2CHV3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:29:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265Ab2CHV3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:29:32 -0500
Date: Thu, 8 Mar 2012 16:29:24 -0500
From: Jason Baron <jbaron@redhat.com>
To: roland@hack.frob.com, akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com,
        linux-kernel@vger.kernel.org
Message-Id: <ea634716621fe6b05e34e986eb12a21cc8a954f2.1331238525.git.jbaron@redhat.com>
In-Reply-To: <cover.1331238525.git.jbaron@redhat.com>
References: <cover.1331238525.git.jbaron@redhat.com>
Subject: [PATCH 1/2 v2] core dump: drop VM_ALWAYSDUMP flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VM_ALWAYSDUMP flag is currently used by the coredump code to indicate that
a vma is part of a vsyscall or vdso section. However, we can determine if a vma
is in one these sections by checking it against the gate_vma and checking for a
non-NULL return value from arch_vma_name(). Thus, freeing a valuable vma bit.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/arm/kernel/process.c          |    2 +-
 arch/hexagon/kernel/vdso.c         |    3 +--
 arch/mips/kernel/vdso.c            |    3 +--
 arch/powerpc/kernel/vdso.c         |   10 ++--------
 arch/s390/kernel/vdso.c            |   10 ++--------
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +--
 arch/tile/mm/elf.c                 |    8 +-------
 arch/unicore32/kernel/process.c    |    2 +-
 arch/x86/um/mem_32.c               |    8 --------
 arch/x86/um/vdso/vma.c             |    3 +--
 arch/x86/vdso/vdso32-setup.c       |   17 ++---------------
 arch/x86/vdso/vma.c                |    3 +--
 fs/binfmt_elf.c                    |   27 +++++++++++++++++++++++++--
 include/linux/mm.h                 |    1 -
 mm/memory.c                        |    8 +-------
 15 files changed, 40 insertions(+), 68 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..565ac89 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -536,7 +536,7 @@ int vectors_user_mapping(void)
 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
 				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_ALWAYSDUMP | VM_RESERVED,
+				       VM_RESERVED,
 				       NULL);
 }
 
diff --git a/arch/hexagon/kernel/vdso.c b/arch/hexagon/kernel/vdso.c
index 16277c3..f212a45 100644
--- a/arch/hexagon/kernel/vdso.c
+++ b/arch/hexagon/kernel/vdso.c
@@ -78,8 +78,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	/* MAYWRITE to allow gdb to COW and set breakpoints. */
 	ret = install_special_mapping(mm, vdso_base, PAGE_SIZE,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      &vdso_page);
 
 	if (ret)
diff --git a/arch/mips/kernel/vdso.c b/arch/mips/kernel/vdso.c
index e5cdfd6..0f1af58 100644
--- a/arch/mips/kernel/vdso.c
+++ b/arch/mips/kernel/vdso.c
@@ -88,8 +88,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      &vdso_page);
 
 	if (ret)
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 7d14bb6..d36ee10 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -263,17 +263,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	 * the "data" page of the vDSO or you'll stop getting kernel updates
 	 * and your nice userland gettimeofday will be totally dead.
 	 * It's fine to use that for setting breakpoints in the vDSO code
-	 * pages though
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
+	 * pages though.
 	 */
 	rc = install_special_mapping(mm, vdso_base, vdso_pages << PAGE_SHIFT,
 				     VM_READ|VM_EXEC|
-				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				     VM_ALWAYSDUMP,
+				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				     vdso_pagelist);
 	if (rc) {
 		current->mm->context.vdso_base = 0;
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index d73630b..904df23 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -253,17 +253,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	 * on the "data" page of the vDSO or you'll stop getting kernel
 	 * updates and your nice userland gettimeofday will be totally dead.
 	 * It's fine to use that for setting breakpoints in the vDSO code
-	 * pages though
-	 *
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
+	 * pages though.
 	 */
 	rc = install_special_mapping(mm, vdso_base, vdso_pages << PAGE_SHIFT,
 				     VM_READ|VM_EXEC|
-				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				     VM_ALWAYSDUMP,
+				     VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				     vdso_pagelist);
 	if (rc)
 		current->mm->context.vdso_base = 0;
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 1d6d51a..5ca5797 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -73,8 +73,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 				      VM_READ | VM_EXEC |
-				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
 				      syscall_pages);
 	if (unlikely(ret))
 		goto up_fail;
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 55e58e9..1a00fb6 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -117,17 +117,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 *
-	 * Make sure the vDSO gets into every core dump.  Dumping its
-	 * contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to
-	 * see what PC values meant.
 	 */
 	vdso_base = VDSO_BASE;
 	retval = install_special_mapping(mm, vdso_base, PAGE_SIZE,
 					 VM_READ|VM_EXEC|
-					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-					 VM_ALWAYSDUMP,
+					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 					 vdso_pages);
 
 #ifndef __tilegx__
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 52edc2b..432b429 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -381,7 +381,7 @@ int vectors_user_mapping(void)
 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
 				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_ALWAYSDUMP | VM_RESERVED,
+				       VM_RESERVED,
 				       NULL);
 }
 
diff --git a/arch/x86/um/mem_32.c b/arch/x86/um/mem_32.c
index 639900a..f40281e 100644
--- a/arch/x86/um/mem_32.c
+++ b/arch/x86/um/mem_32.c
@@ -23,14 +23,6 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
 
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
-
 	return 0;
 }
 __initcall(gate_vma_init);
diff --git a/arch/x86/um/vdso/vma.c b/arch/x86/um/vdso/vma.c
index 91f4ec9..af91901 100644
--- a/arch/x86/um/vdso/vma.c
+++ b/arch/x86/um/vdso/vma.c
@@ -64,8 +64,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	err = install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
 		VM_READ|VM_EXEC|
-		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-		VM_ALWAYSDUMP,
+		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 		vdsop);
 
 	up_write(&mm->mmap_sem);
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 468d591..a944020 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -250,13 +250,7 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
 	return 0;
 }
 
@@ -343,17 +337,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (compat_uses_vma || !compat) {
 		/*
 		 * MAYWRITE to allow gdb to COW and set breakpoints
-		 *
-		 * Make sure the vDSO gets into every core dump.
-		 * Dumping its contents makes post-mortem fully
-		 * interpretable later without matching up the same
-		 * kernel and hardware config to see what PC values
-		 * meant.
 		 */
 		ret = install_special_mapping(mm, addr, PAGE_SIZE,
 					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-					      VM_ALWAYSDUMP,
+					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 					      vdso32_pages);
 
 		if (ret)
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 153407c..17e1827 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -124,8 +124,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	ret = install_special_mapping(mm, addr, vdso_size,
 				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				      VM_ALWAYSDUMP,
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				      vdso_pages);
 	if (ret) {
 		current->mm->context.vdso = NULL;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 07d096c..93b7adb 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1095,6 +1095,29 @@ out:
  */
 
 /*
+ * The purpose of always_dump_vma() is to make sure that special kernel mappings
+ * that are useful for post-mortem analysis are included in every core dump.
+ * In that way we ensure that the core dump is fully interpretable later
+ * without matching up the same kernel and hardware config to see what PC values
+ * meant. These special mappings include - vDSO, vsyscall, and other
+ * architecture specific mappings
+ */
+static bool always_dump_vma(struct vm_area_struct *vma)
+{
+	/* Any vsyscall mappings? */
+	if (vma == get_gate_vma(vma->vm_mm))
+		return true;
+	/*
+	 * arch_vma_name() returns non-NULL for special architecture mappings,
+	 * such as vDSO sections.
+	 */
+	if (arch_vma_name(vma))
+		return true;
+
+	return false;
+}
+
+/*
  * Decide what to dump of a segment, part, all or none.
  */
 static unsigned long vma_dump_size(struct vm_area_struct *vma,
@@ -1102,8 +1125,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 {
 #define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
 
-	/* The vma can be set up to tell us the answer directly.  */
-	if (vma->vm_flags & VM_ALWAYSDUMP)
+	/* always dump the vdso and vsyscall sections */
+	if (always_dump_vma(vma))
 		goto whole;
 
 	/* Hugetlb memory check */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..a296709 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -111,7 +111,6 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
 #endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
-#define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
diff --git a/mm/memory.c b/mm/memory.c
index fa2f04e..9b55ab0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3611,13 +3611,7 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_end = FIXADDR_USER_END;
 	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
 	gate_vma.vm_page_prot = __P101;
-	/*
-	 * Make sure the vDSO gets into every core dump.
-	 * Dumping its contents makes post-mortem fully interpretable later
-	 * without matching up the same kernel and hardware config to see
-	 * what PC values meant.
-	 */
-	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
 	return 0;
 }
 __initcall(gate_vma_init);
-- 
1.7.7.6

