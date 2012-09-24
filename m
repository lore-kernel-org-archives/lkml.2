Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2IXOgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:36:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2IXOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:41 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v4 3/4] coredump: add a new elf note with siginfo of the signal
Date: Mon, 24 Sep 2012 16:36:02 +0200
Message-Id: <1348497363-341-4-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
References: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing PRSTATUS note contains only si_signo, si_code, si_errno fields
from the siginfo of the signal which caused core to be dumped.

There are tools which try to analyze crashes for possible security
implications, and they want to use, among other data, si_addr field
from the SIGSEGV.

This patch adds a new elf note, NT_SIGINFO, which contains
the complete siginfo_t of the signal which killed the process.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/binfmt_elf.c        |   27 +++++++++++++++++++++++++--
 fs/compat_binfmt_elf.c |    6 ++++++
 include/linux/elf.h    |    5 +++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d5fb3ec..289ec5e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -36,6 +36,10 @@
 #include <asm/param.h>
 #include <asm/page.h>
 
+#ifndef user_siginfo_t
+#define user_siginfo_t siginfo_t
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
@@ -1371,6 +1375,16 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
+		siginfo_t *siginfo)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	copy_siginfo_to_user((user_siginfo_t __user *) csigdata, siginfo);
+	set_fs(old_fs);
+	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1384,7 +1398,9 @@ struct elf_thread_core_info {
 struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
+	struct memelfnote signote;
 	struct memelfnote auxv;
+	user_siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
 };
@@ -1558,6 +1574,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
+	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	info->size += notesize(&info->signote);
+
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
@@ -1587,6 +1606,8 @@ static int write_note_info(struct elf_note_info *info,
 
 		if (first && !writenote(&info->psinfo, file, foffset))
 			return 0;
+		if (first && !writenote(&info->signote, file, foffset))
+			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
 
@@ -1680,6 +1701,7 @@ struct elf_note_info {
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu;
 #endif
+	user_siginfo_t csigdata;
 	int thread_status_size;
 	int numnote;
 };
@@ -1689,8 +1711,8 @@ static int elf_note_info_init(struct elf_note_info *info)
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Allocate space for ELF notes */
+	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1762,6 +1784,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 
 	info->numnote = 2;
 
+	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
 	fill_auxv_note(&info->notes[info->numnote++], current->mm);
 
 	/* Try to dump the FPU. */
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 112e45a..0fbcf63 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -38,6 +38,12 @@
 #define elf_addr_t	Elf32_Addr
 
 /*
+ * Some data types as stored in coredump.
+ */
+#define user_siginfo_t		compat_siginfo_t
+#define copy_siginfo_to_user	copy_siginfo_to_user32
+
+/*
  * The machine-dependent core note format types are defined in elfcore-compat.h,
  * which requires asm/elf.h to define compat_elf_gregset_t et al.
  */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 0a05051..dc62da7 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -372,6 +372,11 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+/*
+ * Note to userspace developers: size of NT_SIGINFO note may increase
+ * in the future to accomodate more fields, don't assume it is fixed!
+ */
+#define NT_SIGINFO      0x53494749
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
-- 
1.7.7.6

