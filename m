Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2IROzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:55:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2IROzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:55:40 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v2] coredump: extend core dump note section to contain file names of mapped files
Date: Tue, 18 Sep 2012 16:55:29 +0200
Message-Id: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This note has the following format:

long count     -- how many files are mapped
long page_size -- units for file_ofs
array of [COUNT] elements of
   long start
   long end
   long file_ofs
followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

If file name is not available, "" string is encoded.

Changes since previous version: rediffed on top of NT_SIGINFO patches.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 fs/binfmt_elf.c     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/elf.h |    1 +
 2 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 6872e45..843d5ea 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1380,6 +1380,72 @@ static void fill_siginfo_note(struct memelfnote *note, siginfo_t *csigdata, sigi
 	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
 }
 
+#define MAX_FILE_NOTE_SIZE (4*1024*1024)
+
+static void fill_files_note(struct memelfnote *note)
+{
+	struct vm_area_struct *vma;
+	struct file *file;
+	unsigned count, word_count, size, remaining;
+	long *data;
+	long *start_end_ofs;
+	char *name;
+
+	count = 0;
+	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+		file = vma->vm_file;
+		if (!file)
+			continue;
+		count++;
+	}
+
+	size = count * 64;
+	word_count = 2 + 3 * count;
+ alloc:
+	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
+		goto err;
+	size = round_up(size, PAGE_SIZE);
+	data = vmalloc(size);
+	if (!data)
+		goto err;
+
+	start_end_ofs = data;
+	name = (void*)&start_end_ofs[word_count];
+	remaining = size - word_count * sizeof(long);
+
+	*start_end_ofs++ = count;
+	*start_end_ofs++ = PAGE_SIZE;
+	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+		const char *filename;
+
+		file = vma->vm_file;
+		if (!file)
+			continue;
+		filename = d_path(&file->f_path, name, remaining);
+		if (IS_ERR(filename)) {
+			if (PTR_ERR(filename) == -ENAMETOOLONG) {
+				vfree(data);
+				size = size * 5 / 4;
+				goto alloc;
+			}
+			/* continue; - WRONG, we must have COUNT elements */
+			filename = "";
+		}
+		/* d_path() fills at the end, move it to front */
+		do
+			remaining--;
+		while ((*name++ = *filename++) != '\0');
+
+		*start_end_ofs++ = vma->vm_start;
+		*start_end_ofs++ = vma->vm_end;
+		*start_end_ofs++ = vma->vm_pgoff;
+	}
+
+	size = name - (char*)data;
+	fill_note(note, "CORE", NT_FILE, size, data);
+ err: ;
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1395,6 +1461,7 @@ struct elf_note_info {
 	struct memelfnote psinfo;
 	struct memelfnote signote;
 	struct memelfnote auxv;
+	struct memelfnote files;
 	siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
@@ -1575,6 +1642,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
+	fill_files_note(&info->files);
+	info->size += notesize(&info->files);
+
 	return 1;
 }
 
@@ -1605,6 +1675,8 @@ static int write_note_info(struct elf_note_info *info,
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
+		if (first && !writenote(&info->files, file, foffset))
+			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
 			if (t->notes[i].data &&
@@ -1631,6 +1703,7 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
+	vfree(info->files.data);
 }
 
 #else
@@ -1707,7 +1780,7 @@ static int elf_note_info_init(struct elf_note_info *info)
 	INIT_LIST_HEAD(&info->thread_list);
 
 	/* Allocate space for ELF notes */
-	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
+	info->notes = kmalloc(8 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1777,10 +1850,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_note(info->notes + 1, "CORE", NT_PRPSINFO,
 		  sizeof(*info->psinfo), info->psinfo);
 
-	info->numnote = 2;
+	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
+	fill_auxv_note(info->notes + 3, current->mm);
+	fill_files_note(info->notes + 4);
 
-	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
-	fill_auxv_note(&info->notes[info->numnote++], current->mm);
+	info->numnote = 5;
 
 	/* Try to dump the FPU. */
 	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
@@ -1842,6 +1916,9 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
+	/* Free data allocated by fill_files_note(): */
+	vfree(info->notes[4].data);
+
 	kfree(info->prstatus);
 	kfree(info->psinfo);
 	kfree(info->notes);
diff --git a/include/linux/elf.h b/include/linux/elf.h
index dc62da7..59ef406 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -377,6 +377,7 @@ typedef struct elf64_shdr {
  * in the future to accomodate more fields, don't assume it is fixed!
  */
 #define NT_SIGINFO      0x53494749
+#define NT_FILE         0x46494c45
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
-- 
1.7.7.6

