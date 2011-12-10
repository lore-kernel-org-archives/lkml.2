Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab1LJOhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:37:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41566 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1LJOhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:37:03 -0500
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 22:37:02 +0800
Message-ID: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
Subject: [PATCH 1/1] x86: Add process memory layout to coredump file
From: t cheney <cdmalord@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just add memory layout(same as /proc/pid/maps) to
coredump file. The layout is appended to corenote segment with
flag NT_MAPS=7.

Signed-off-by: cheney <cdmalord@gmail.com>
---
 fs/binfmt_elf.c     |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/elf.h |    1 +
 2 files changed, 208 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 21ac5ee..d9d07f4 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
+#include <linux/seq_file.h>

 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
@@ -1200,6 +1201,12 @@ static int notesize(struct memelfnote *en)
 #define DUMP_WRITE(addr, nr, foffset)	\
 	do { if (!dump_write(file, (addr), (nr))) return 0; *foffset +=
(nr); } while(0)

+static struct vm_area_struct *first_vma(struct task_struct *tsk,
+	struct vm_area_struct *gate_vma);
+static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+	struct vm_area_struct *gate_vma);
+/*extern char *mangle_path(char *s, char *p, char *esc);
+*/
 static int alignfile(struct file *file, loff_t *foffset)
 {
 	static const char buf[4] = { 0, };
@@ -1207,6 +1214,156 @@ static int alignfile(struct file *file, loff_t *foffset)
 	return 1;
 }

+static int pad_spaces(char *p, int len)
+{
+	int i;
+	len = 25 + sizeof(void *) * 6 - len;
+	if (len < 1)
+		len = 1;
+	i = len;
+	while (i--)
+		*p++ = ' ';
+	return len;
+}
+
+const char *get_vma_name(struct vm_area_struct *vma)
+{
+	const char *name = arch_vma_name(vma);
+	if (!name) {
+		struct mm_struct *mm = vma->vm_mm;
+		if (mm) {
+			if (vma->vm_start <= mm->brk &&
+				vma->vm_end >= mm->start_brk) {
+				name = "[heap]";
+			} else if (vma->vm_start <= mm->start_stack &&
+				vma->vm_end >= mm->start_stack) {
+				name = "[stack]";
+			}
+		} else {
+			name = "[vdso]";
+		}
+	}
+	return name;
+}
+
+/*  handle memory map in core
+ *  if filp=0 it just calculate the size of maps.
+ */
+static int core_handle_maps(struct file *file, struct memelfnote *notes,
+		loff_t *foffset)
+{
+	size_t maps_size = 0;
+	size_t len;
+	size_t space;
+	struct vm_area_struct *vma, *gate_vma;
+	int flags;
+	struct inode *inode;
+	unsigned long ino;
+	unsigned long long pgoff;
+	unsigned long start, end;
+	dev_t dev;
+	char *esc = "\n";
+	char *p;
+	char *s;
+	char *buf = notes->data;
+	size_t core_limit = notes->datasz;
+	gate_vma = get_gate_vma(current->mm);
+
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+		vma = next_vma(vma, gate_vma)) {
+		flags = vma->vm_flags;
+		ino = 0;
+		dev = 0;
+		space = 0;
+		inode = NULL;
+		pgoff = 0;
+		len = 0;
+		if (vma->vm_file) {
+			inode = vma->vm_file->f_dentry->d_inode;
+			dev = inode->i_sb->s_dev;
+			ino = inode->i_ino;
+			pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
+		}
+		start = vma->vm_start;
+		if (stack_guard_page_start(vma, start))
+			start += PAGE_SIZE;
+		end = vma->vm_end;
+		if (stack_guard_page_end(vma, end))
+			end -= PAGE_SIZE;
+		len = sprintf(buf, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu",
+			start,
+			end,
+			flags & VM_READ ? 'r' : '-',
+			flags & VM_WRITE ? 'w' : '-',
+			flags & VM_EXEC ? 'x' : '-',
+			flags & VM_MAYSHARE ? 's' : 'p',
+			pgoff,
+			MAJOR(dev), MINOR(dev), ino);
+		maps_size += len;
+		if (file) {
+			if (maps_size > core_limit)
+				break;
+			DUMP_WRITE(buf, len, foffset);
+		}
+		if (vma->vm_file) {
+			space = pad_spaces(buf, len);
+			s = buf + space;
+			p = d_path(&vma->vm_file->f_path, s, maps_size-1);
+			if (!IS_ERR(p)) {
+				char *last;
+				last = mangle_path(s, p, esc);
+				len = last - buf;
+				maps_size += len;
+				if (file) {
+					if (maps_size > core_limit)
+						 break;
+					DUMP_WRITE(buf, len, foffset);
+				}
+			}
+		} else {
+			const char *name = get_vma_name(vma);
+			if (name) {
+				space = pad_spaces(buf, len);
+				maps_size += space;
+				maps_size += strlen(name);
+				if (file) {
+					if (maps_size > core_limit)
+						 break;
+					DUMP_WRITE(buf, space, foffset);
+					DUMP_WRITE(name, strlen(name), foffset);
+				}
+			}
+		}
+		maps_size++;
+		if (file) {
+			if (maps_size > core_limit)
+				break;
+			DUMP_WRITE("\n", 1, foffset);
+		}
+	}
+	return maps_size;
+}
+
+static int writemaps(struct file *file, struct memelfnote *men,
+	loff_t *foffset)
+{
+	struct elf_note en;
+	en.n_namesz = strlen(men->name) + 1;
+	en.n_descsz = men->datasz;
+	en.n_type = men->type;
+
+	DUMP_WRITE(&en, sizeof(en), foffset);
+	DUMP_WRITE(men->name, en.n_namesz, foffset);
+	if (!alignfile(file, foffset))
+		return 0;
+	if (!core_handle_maps(file, men, foffset))
+		return 0;
+	if (!alignfile(file, foffset))
+		return 0;
+
+	return 1;
+}
+
 static int writenote(struct memelfnote *men, struct file *file,
 			loff_t *foffset)
 {
@@ -1374,6 +1531,8 @@ struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
 	struct memelfnote auxv;
+	/* maps is for memory layout */
+	struct memelfnote maps;
 	size_t size;
 	int thread_notes;
 };
@@ -1460,6 +1619,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
 	unsigned int i;
+	int maps_size;

 	info->size = 0;
 	info->thread = NULL;
@@ -1468,6 +1628,21 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	if (psinfo == NULL)
 		return 0;

+	info->maps.data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (info->maps.data == NULL) {
+		kfree(psinfo);
+		return 0;
+	}
+	/* Just calculate maps' size  */
+	maps_size = core_handle_maps(NULL, &info->maps, NULL);
+	if (!maps_size) {
+		kfree(psinfo);
+		kfree(info->maps.data);
+		return 0;
+	}
+	fill_note(&info->maps, "CORE", NT_MAPS, maps_size, info->maps.data);
+	info->size += notesize(&info->maps);
+
 	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);

 	/*
@@ -1572,6 +1747,10 @@ static int write_note_info(struct elf_note_info *info,
 		t = t->next;
 	} while (t);

+	/* Write maps */
+	if (!writemaps(file, &info->maps, foffset))
+		return 0;
+
 	return 1;
 }

@@ -1588,6 +1767,7 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
+	kfree(info->maps.data);
 }

 #else
@@ -1648,6 +1828,7 @@ struct elf_note_info {
 	struct memelfnote *notes;
 	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
+	char *maps;                     /* NT_MAPS */
 	struct list_head thread_list;
 	elf_fpregset_t *fpu;
 #ifdef ELF_CORE_COPY_XFPREGS
@@ -1663,12 +1844,16 @@ static int elf_note_info_init(struct
elf_note_info *info)
 	INIT_LIST_HEAD(&info->thread_list);

 	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Add maps into notes */
+	info->notes = kmalloc((6+1) * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
+	info->maps = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!info->maps)
+		goto notes_free;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		goto notes_free;
+		goto maps_free;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
 		goto psinfo_free;
@@ -1689,6 +1874,8 @@ static int elf_note_info_init(struct elf_note_info *info)
 	kfree(info->prstatus);
  psinfo_free:
 	kfree(info->psinfo);
+ maps_free:
+	kfree(info->maps);
  notes_free:
 	kfree(info->notes);
 	return 0;
@@ -1699,6 +1886,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  long signr, struct pt_regs *regs)
 {
 	struct list_head *t;
+	int maps_size;

 	if (!elf_note_info_init(info))
 		return 0;
@@ -1761,6 +1949,14 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  sizeof(*info->xfpu), info->xfpu);
 #endif

+	info->notes[info->numnote].data = info->maps;
+	/* Just calculate maps's size */
+	maps_size = core_handle_maps(NULL, info->notes + info->numnote, NULL);
+	if (!maps_size)
+		return 0;
+	fill_note(info->notes + info->numnote++, "CORE", NT_MAPS,
+		maps_size, info->maps);
+
 	return 1;
 }

@@ -1783,9 +1979,16 @@ static int write_note_info(struct elf_note_info *info,
 	int i;
 	struct list_head *t;

-	for (i = 0; i < info->numnote; i++)
+	for (i = 0; i < info->numnote; i++) {
+		/* Write maps */
+		if (info->notes[i].type == NT_MAPS) {
+			if (!writemaps(file, info->notes + i, foffset))
+				return 0;
+			continue;
+		}
 		if (!writenote(info->notes + i, file, foffset))
 			return 0;
+	}

 	/* write out the thread status notes section */
 	list_for_each(t, &info->thread_list) {
@@ -1812,6 +2015,7 @@ static void free_note_info(struct elf_note_info *info)
 	kfree(info->psinfo);
 	kfree(info->notes);
 	kfree(info->fpu);
+	kfree(info->maps);
 #ifdef ELF_CORE_COPY_XFPREGS
 	kfree(info->xfpu);
 #endif
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 31f0508..b9d710b 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -381,6 +381,7 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+#define NT_MAPS         7
 #define NT_PRXFPREG     0x46e62b7f      /* copied from
gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
-- 
1.5.3.4
