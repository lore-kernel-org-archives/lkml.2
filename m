Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab0LNJ5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:57:45 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51365 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab0LNJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:57:43 -0500
Date: Tue, 14 Dec 2010 15:27:48 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 2/21] Create elfcore-common.c for ELF class independent core
 generation helpers
Message-ID: <20101214152748.4f755346@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the common code, shared by both native and compat ELF core generation code
to a single instance.These functions could be re-used later for application
core dump infrastructure.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/Makefile                      |    1 
 fs/binfmt_elf.c                  |  129 ---------------------------------------
 fs/elfcore-common.c              |  126 ++++++++++++++++++++++++++++++++++++++
 include/linux/elfcore-internal.h |   35 ++++++++++
 4 files changed, 163 insertions(+), 128 deletions(-)

Index: linux-2.6.36-rc7/fs/binfmt_elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/binfmt_elf.c
+++ linux-2.6.36-rc7/fs/binfmt_elf.c
@@ -46,6 +46,7 @@ static unsigned long elf_map(struct file
  * don't even try.
  */
 #ifdef CONFIG_ELF_CORE
+#include <linux/elfcore-internal.h>
 static int elf_core_dump(struct coredump_params *cprm);
 #else
 #define elf_core_dump	NULL
@@ -1087,98 +1088,6 @@ out:
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
 
-/*
- * Decide what to dump of a segment, part, all or none.
- */
-static unsigned long vma_dump_size(struct vm_area_struct *vma,
-				   unsigned long mm_flags)
-{
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
-
-	/* The vma can be set up to tell us the answer directly.  */
-	if (vma->vm_flags & VM_ALWAYSDUMP)
-		goto whole;
-
-	/* Hugetlb memory check */
-	if (vma->vm_flags & VM_HUGETLB) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
-			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
-			goto whole;
-	}
-
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & (VM_IO | VM_RESERVED))
-		return 0;
-
-	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
-		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?
-		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
-			goto whole;
-		return 0;
-	}
-
-	/* Dump segments that have been written to.  */
-	if (vma->anon_vma && FILTER(ANON_PRIVATE))
-		goto whole;
-	if (vma->vm_file == NULL)
-		return 0;
-
-	if (FILTER(MAPPED_PRIVATE))
-		goto whole;
-
-	/*
-	 * If this looks like the beginning of a DSO or executable mapping,
-	 * check for an ELF header.  If we find one, dump the first page to
-	 * aid in determining what was mapped here.
-	 */
-	if (FILTER(ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
-		u32 __user *header = (u32 __user *) vma->vm_start;
-		u32 word;
-		mm_segment_t fs = get_fs();
-		/*
-		 * Doing it this way gets the constant folded by GCC.
-		 */
-		union {
-			u32 cmp;
-			char elfmag[SELFMAG];
-		} magic;
-		BUILD_BUG_ON(SELFMAG != sizeof word);
-		magic.elfmag[EI_MAG0] = ELFMAG0;
-		magic.elfmag[EI_MAG1] = ELFMAG1;
-		magic.elfmag[EI_MAG2] = ELFMAG2;
-		magic.elfmag[EI_MAG3] = ELFMAG3;
-		/*
-		 * Switch to the user "segment" for get_user(),
-		 * then put back what elf_core_dump() had in place.
-		 */
-		set_fs(USER_DS);
-		if (unlikely(get_user(word, header)))
-			word = 0;
-		set_fs(fs);
-		if (word == magic.cmp)
-			return PAGE_SIZE;
-	}
-
-#undef	FILTER
-
-	return 0;
-
-whole:
-	return vma->vm_end - vma->vm_start;
-}
-
-/* An ELF note in memory */
-struct memelfnote
-{
-	const char *name;
-	int type;
-	unsigned int datasz;
-	void *data;
-};
-
 static int notesize(struct memelfnote *en)
 {
 	int sz;
@@ -1256,16 +1165,6 @@ static void fill_elf_note_phdr(struct el
 	return;
 }
 
-static void fill_note(struct memelfnote *note, const char *name, int type, 
-		unsigned int sz, void *data)
-{
-	note->name = name;
-	note->type = type;
-	note->datasz = sz;
-	note->data = data;
-	return;
-}
-
 /*
  * fill up all the fields in prstatus from the given task struct, except
  * registers which need to be filled up separately.
@@ -1812,32 +1711,6 @@ static void free_note_info(struct elf_no
 
 #endif
 
-static struct vm_area_struct *first_vma(struct task_struct *tsk,
-					struct vm_area_struct *gate_vma)
-{
-	struct vm_area_struct *ret = tsk->mm->mmap;
-
-	if (ret)
-		return ret;
-	return gate_vma;
-}
-/*
- * Helper function for iterating across a vma list.  It ensures that the caller
- * will visit `gate_vma' prior to terminating the search.
- */
-static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
-					struct vm_area_struct *gate_vma)
-{
-	struct vm_area_struct *ret;
-
-	ret = this_vma->vm_next;
-	if (ret)
-		return ret;
-	if (this_vma == gate_vma)
-		return NULL;
-	return gate_vma;
-}
-
 static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 			     elf_addr_t e_shoff, int segs)
 {
Index: linux-2.6.36-rc7/fs/elfcore-common.c
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/fs/elfcore-common.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
+ *
+ * Initial write up for ELF_CORE :
+ * Modelled on fs/exec.c:aout_core_dump()
+ *	 Jeremy Fitzhardinge <jeremy@sw.oz.au>
+ *
+ * Moved common routines used by both native and compat ELF core generation
+ * from binfmt_elf.c to a single instance.
+ *	Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/elf.h>
+#include <asm/uaccess.h>
+#include <asm/param.h>
+#include <asm/page.h>
+
+#include <linux/elfcore-internal.h>
+
+struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret = tsk->mm->mmap;
+
+	if (ret)
+		return ret;
+	return gate_vma;
+}
+/*
+ * Helper function for iterating across a vma list.  It ensures that the caller
+ * will visit `gate_vma' prior to terminating the search.
+ */
+struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret;
+
+	ret = this_vma->vm_next;
+	if (ret)
+		return ret;
+	if (this_vma == gate_vma)
+		return NULL;
+	return gate_vma;
+}
+
+/*
+ * Decide what to dump of a segment, part, all or none.
+ */
+unsigned long vma_dump_size(struct vm_area_struct *vma,
+					 unsigned long mm_flags)
+{
+#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
+
+	/* The vma can be set up to tell us the answer directly.  */
+	if (vma->vm_flags & VM_ALWAYSDUMP)
+		goto whole;
+
+	/* Hugetlb memory check */
+	if (vma->vm_flags & VM_HUGETLB) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
+			goto whole;
+	}
+
+	/* Do not dump I/O mapped devices or special mappings */
+	if (vma->vm_flags & (VM_IO | VM_RESERVED))
+		return 0;
+
+	/* By default, dump shared memory if mapped from an anonymous file. */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?
+		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
+			goto whole;
+		return 0;
+	}
+
+	/* Dump segments that have been written to.  */
+	if (vma->anon_vma && FILTER(ANON_PRIVATE))
+		goto whole;
+	if (vma->vm_file == NULL)
+		return 0;
+
+	if (FILTER(MAPPED_PRIVATE))
+		goto whole;
+
+	/*
+	 * If this looks like the beginning of a DSO or executable mapping,
+	 * check for an ELF header.  If we find one, dump the first page to
+	 * aid in determining what was mapped here.
+	 */
+	if (FILTER(ELF_HEADERS) &&
+	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+		u32 __user *header = (u32 __user *) vma->vm_start;
+		u32 word;
+		mm_segment_t fs = get_fs();
+		/*
+		 * Doing it this way gets the constant folded by GCC.
+		 */
+		union {
+			u32 cmp;
+			char elfmag[SELFMAG];
+		} magic;
+		BUILD_BUG_ON(SELFMAG != sizeof word);
+		magic.elfmag[EI_MAG0] = ELFMAG0;
+		magic.elfmag[EI_MAG1] = ELFMAG1;
+		magic.elfmag[EI_MAG2] = ELFMAG2;
+		magic.elfmag[EI_MAG3] = ELFMAG3;
+		/*
+		 * Switch to the user "segment" for get_user(),
+		 * then put back what elf_core_dump() had in place.
+		 */
+		set_fs(USER_DS);
+		if (unlikely(get_user(word, header)))
+			word = 0;
+		set_fs(fs);
+		if (word == magic.cmp)
+			return PAGE_SIZE;
+	}
+
+#undef	FILTER
+
+	return 0;
+
+whole:
+	return vma->vm_end - vma->vm_start;
+}
Index: linux-2.6.36-rc7/include/linux/elfcore-internal.h
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/include/linux/elfcore-internal.h
@@ -0,0 +1,44 @@
+/*
+ * Common routines for native and compat elf core generation.
+ *
+ * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
+ *
+ * Modelled on fs/exec.c:aout_core_dump()
+ * Jeremy Fitzhardinge <jeremy@sw.oz.au>
+ *
+ * Moved the common routines from binfmt_elf.c to elfcore-common.c
+ *  - Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#ifndef __ELF_CORE_INTERNAL_H
+#define __ELF_CORE_INTERNAL_H
+
+#ifdef __KERNEL__
+
+/* An ELF note in memory */
+struct memelfnote
+{
+	const char *name;
+	int type;
+	unsigned int datasz;
+	void *data;
+};
+
+static inline void fill_note(struct memelfnote *note, const char *name,
+				int type, unsigned int sz, void *data)
+{
+	note->name = name;
+	note->type = type;
+	note->datasz = sz;
+	note->data = data;
+}
+
+extern struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma);
+extern struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma);
+extern unsigned long vma_dump_size(struct vm_area_struct *vma,
+					 unsigned long mm_flags);
+
+#endif
+#endif
Index: linux-2.6.36-rc7/fs/Makefile
===================================================================
--- linux-2.6.36-rc7.orig/fs/Makefile
+++ linux-2.6.36-rc7/fs/Makefile
@@ -42,6 +42,7 @@ obj-y				+= binfmt_script.o
 
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
+obj-$(CONFIG_ELF_CORE)		+= elfcore-common.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
