Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab2IROxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:53:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39876 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2IROxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:53:44 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v2 2/2] coredump: add a new elf note with siginfo of the signal
Date: Tue, 18 Sep 2012 16:53:15 +0200
Message-Id: <1347979995-1452-3-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
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
---
 fs/binfmt_elf.c     |   22 ++++++++++++++++++++--
 include/linux/elf.h |    5 +++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d5fb3ec..6872e45 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1371,6 +1371,15 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+static void fill_siginfo_note(struct memelfnote *note, siginfo_t *csigdata, siginfo_t *siginfo)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	copy_siginfo_to_user((siginfo_t __user *) csigdata, siginfo);
+	set_fs(old_fs);
+	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1384,7 +1393,9 @@ struct elf_thread_core_info {
 struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
+	struct memelfnote signote;
 	struct memelfnote auxv;
+	siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
 };
@@ -1558,6 +1569,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
+	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	info->size += notesize(&info->signote);
+
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
@@ -1587,6 +1601,8 @@ static int write_note_info(struct elf_note_info *info,
 
 		if (first && !writenote(&info->psinfo, file, foffset))
 			return 0;
+		if (first && !writenote(&info->signote, file, foffset))
+			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
 
@@ -1680,6 +1696,7 @@ struct elf_note_info {
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu;
 #endif
+	siginfo_t csigdata;
 	int thread_status_size;
 	int numnote;
 };
@@ -1689,8 +1706,8 @@ static int elf_note_info_init(struct elf_note_info *info)
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Allocate space for ELF notes */
+	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1762,6 +1779,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 
 	info->numnote = 2;
 
+	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
 	fill_auxv_note(&info->notes[info->numnote++], current->mm);
 
 	/* Try to dump the FPU. */
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

