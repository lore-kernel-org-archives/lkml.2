Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2CGVTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:19:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab2CGVTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:19:18 -0500
Date: Wed, 7 Mar 2012 16:19:09 -0500
From: Jason Baron <jbaron@redhat.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, cmetcalf@tilera.com
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
Message-ID: <20120307211909.GB2409@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
 <3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
 <CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
 <20120307185035.GA2409@redhat.com>
 <20120307194302.7BD142C0C3@topped-with-meat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307194302.7BD142C0C3@topped-with-meat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 11:43:02AM -0800, Roland McGrath wrote:
> > well, sure, we can provide an arch interface, for this check. I'm more
> > concerned with the general idea. If it seems ok, I can re-do this bit
> > with an arch interface.
> 
> Anything based on strcmp is dismal.  VM_ALWAYSDUMP was nice and clean.
> A hook along the lines of arch_vma_name would be clean enough I suppose.
> In fact, there is only one instance today (tile) where arch_vma_name()!=NULL
> wouldn't do just what you need.
> 

Yeah, so I think something like the following would work (adding Tile
maintainer to 'cc list).

Thanks,

-Jason



The VM_ALWAYSDUMP flag is currently used by the coredump code to indicate that
a vma is part of a vsyscall or vdso section, and then always dump it. However, we
can determine if a vma is in one of these sections by using 'arch_vma_name()',
and thus re-purpose a valuable vma bit.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/arm/kernel/process.c          |    2 +-
 arch/hexagon/kernel/vdso.c         |    3 +--
 arch/mips/kernel/vdso.c            |    3 +--
 arch/powerpc/kernel/vdso.c         |    3 +--
 arch/s390/kernel/vdso.c            |    3 +--
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +--
 arch/tile/mm/elf.c                 |    3 +--
 arch/unicore32/kernel/process.c    |    2 +-
 arch/x86/um/mem_32.c               |    8 --------
 arch/x86/um/vdso/vma.c             |    3 +--
 arch/x86/vdso/vdso32-setup.c       |   11 ++---------
 arch/x86/vdso/vma.c                |    3 +--
 fs/binfmt_elf.c                    |   22 ++++++++++++++++++++--
 include/linux/mm.h                 |    1 -
 mm/memory.c                        |    8 +-------
 15 files changed, 33 insertions(+), 45 deletions(-)

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
index 7d14bb6..af58021 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -272,8 +272,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
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
index d73630b..25c838c 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -262,8 +262,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
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
index 55e58e9..c4b3ed8 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -126,8 +126,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
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
index 468d591..b4d43dd 100644
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
 
@@ -352,8 +346,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
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
index 07d096c..8a90861 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1094,6 +1094,24 @@ out:
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
 
+/* Determine if the vma should always be output in the coredump */
+static bool always_dump_vma(struct vm_area_struct *vma)
+{
+	const char *vma_name = arch_vma_name(vma);
+
+	if (vma_name) {
+#ifdef CONFIG_TILE
+		/* Tile user-interrupt mapping which we don't always dump */
+		if (is_arch_mappable_range(vma->vm_start, 0))
+			return false;
+#endif
+		return true;
+	}
+	if (vma == get_gate_vma(vma->vm_mm))
+		return true;
+	return false;
+}
+
 /*
  * Decide what to dump of a segment, part, all or none.
  */
@@ -1102,8 +1120,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
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

