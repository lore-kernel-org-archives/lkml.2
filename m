Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2GLTmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:42:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43446 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2GLTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:42:07 -0400
From: Denys Vlasenko <vda.linux@gmail.com>
To: linux-kernel@vger.kernel.org, "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2] Extend core dump note section to contain file names of mapped files
Date: Thu, 12 Jul 2012 21:42:02 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207122142.02137.vda.linux@googlemail.com>
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

Compared to previous version, code is simplified
as suggested by Oleg Nesterov.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b52956..8e60c38 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1372,6 +1372,72 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
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
 
@@ -1386,6 +1452,7 @@ struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
 	struct memelfnote auxv;
+	struct memelfnote files;
 	size_t size;
 	int thread_notes;
 };
@@ -1562,6 +1629,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
+	fill_files_note(&info->files);
+	info->size += notesize(&info->files);
+
 	return 1;
 }
 
@@ -1590,6 +1660,8 @@ static int write_note_info(struct elf_note_info *info,
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
+		if (first && !writenote(&info->files, file, foffset))
+			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
 			if (t->notes[i].data &&
@@ -1616,6 +1688,7 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
+	vfree(info->files.data);
 }
 
 #else
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 999b4f5..5e6c08f 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -372,6 +372,7 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+#define NT_FILE		0x46494c45
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */

