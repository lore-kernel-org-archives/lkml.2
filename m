Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2IXOh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:37:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:47 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v4 4/4] coredump: extend core dump note section to contain file names of mapped files
Date: Mon, 24 Sep 2012 16:36:03 +0200
Message-Id: <1348497363-341-5-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
References: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
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

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 fs/binfmt_elf.c        |  110 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/compat_binfmt_elf.c |    1 +
 include/linux/elf.h    |    1 +
 3 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 289ec5e..cff1b36 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -27,6 +27,7 @@
 #include <linux/compiler.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/vmalloc.h>
 #include <linux/security.h>
 #include <linux/random.h>
 #include <linux/elf.h>
@@ -36,6 +37,9 @@
 #include <asm/param.h>
 #include <asm/page.h>
 
+#ifndef user_long_t
+#define user_long_t long
+#endif
 #ifndef user_siginfo_t
 #define user_siginfo_t siginfo_t
 #endif
@@ -1385,6 +1389,93 @@ static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
 	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
 }
 
+#define MAX_FILE_NOTE_SIZE (4*1024*1024)
+/*
+ * Format of NT_FILE note:
+ *
+ * long count     -- how many files are mapped
+ * long page_size -- units for file_ofs
+ * array of [COUNT] elements of
+ *   long start
+ *   long end
+ *   long file_ofs
+ * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
+ */
+static void fill_files_note(struct memelfnote *note)
+{
+	struct vm_area_struct *vma;
+	unsigned count, size, names_ofs, remaining, n;
+	user_long_t *data;
+	user_long_t *start_end_ofs;
+	char *name_base, *name_curpos;
+
+	/* *Estimated* file count and total data size needed */
+	count = current->mm->map_count;
+	size = count * 64;
+
+	names_ofs = (2 + 3 * count) * sizeof(data[0]);
+ alloc:
+	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
+		goto err;
+	size = round_up(size, PAGE_SIZE);
+	data = vmalloc(size);
+	if (!data)
+		goto err;
+
+	start_end_ofs = data + 2;
+	name_base = name_curpos = ((char *)data) + names_ofs;
+	remaining = size - names_ofs;
+	count = 0;
+	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+		struct file *file;
+		const char *filename;
+
+		file = vma->vm_file;
+		if (!file)
+			continue;
+		filename = d_path(&file->f_path, name_curpos, remaining);
+		if (IS_ERR(filename)) {
+			if (PTR_ERR(filename) == -ENAMETOOLONG) {
+				vfree(data);
+				size = size * 5 / 4;
+				goto alloc;
+			}
+			continue;
+		}
+
+		/* d_path() fills at the end, move name down */
+		/* n = strlen(filename) + 1: */
+		n = (name_curpos + remaining) - filename;
+		remaining = filename - name_curpos;
+		memmove(name_curpos, filename, n);
+		name_curpos += n;
+
+		*start_end_ofs++ = vma->vm_start;
+		*start_end_ofs++ = vma->vm_end;
+		*start_end_ofs++ = vma->vm_pgoff;
+		count++;
+	}
+
+	/* Now we know exact count of files, can store it */
+	data[0] = count;
+	data[1] = PAGE_SIZE;
+	/*
+	 * Count usually is less than current->mm->map_count,
+	 * we need to move filenames down.
+	 */
+	n = current->mm->map_count - count;
+	if (n != 0) {
+		unsigned shift_bytes = n * 3 * sizeof(data[0]);
+		memmove(name_base - shift_bytes, name_base,
+			name_curpos - name_base);
+		name_curpos -= shift_bytes;
+	}
+
+	size = name_curpos - (char *)data;
+	fill_note(note, "CORE", NT_FILE, size, data);
+ err: ;
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1400,6 +1491,7 @@ struct elf_note_info {
 	struct memelfnote psinfo;
 	struct memelfnote signote;
 	struct memelfnote auxv;
+	struct memelfnote files;
 	user_siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
@@ -1580,6 +1672,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
+	fill_files_note(&info->files);
+	info->size += notesize(&info->files);
+
 	return 1;
 }
 
@@ -1610,6 +1705,8 @@ static int write_note_info(struct elf_note_info *info,
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
+		if (first && !writenote(&info->files, file, foffset))
+			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
 			if (t->notes[i].data &&
@@ -1636,6 +1733,7 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
+	vfree(info->files.data);
 }
 
 #else
@@ -1712,7 +1810,7 @@ static int elf_note_info_init(struct elf_note_info *info)
 	INIT_LIST_HEAD(&info->thread_list);
 
 	/* Allocate space for ELF notes */
-	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
+	info->notes = kmalloc(8 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1782,10 +1880,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
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
@@ -1847,6 +1946,9 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
+	/* Free data allocated by fill_files_note(): */
+	vfree(info->notes[4].data);
+
 	kfree(info->prstatus);
 	kfree(info->psinfo);
 	kfree(info->notes);
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 0fbcf63..a81147e 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -40,6 +40,7 @@
 /*
  * Some data types as stored in coredump.
  */
+#define user_long_t		compat_long_t
 #define user_siginfo_t		compat_siginfo_t
 #define copy_siginfo_to_user	copy_siginfo_to_user32
 
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

