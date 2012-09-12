Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2ILXjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:39:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55969 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2ILXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:12 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/2] coredump: add a new elf note with siginfo fields of the signal
Date: Thu, 13 Sep 2012 01:38:44 +0200
Message-Id: <1347493124-10661-2-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing PRSTATUS note contains only si_signo, si_code, si_errno fields
from the siginfo of the signal which caused core to be dumped.

There are tools which try to analyze crashes for possible security
implications, and they want to use, among other data, si_addr field
from the SIGSEGV.

This patch adds a new elf note, NT_SIGINFO, which contains
the remaining fields of siginfo_t.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 fs/binfmt_elf.c     |   52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/elf.h |    5 ++++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 41a40de..5125188d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1371,6 +1371,45 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+struct coredump_siginfo {
+/*	int	csi_signo;	in prstatus.pr_info.si_signo instead */
+/*	int	csi_errno;	in prstatus.pr_info.si_errno */
+/*	int	csi_code;	in prstatus.pr_info.si_code */
+	int	csi_pid;	/* PID of sending process */
+	int	csi_uid;	/* Real UID of sending process */
+/*	int	csi_status;	SIGCHLD never kills, field isn't meaningful */
+/*	clock_t	csi_utime;	SIGCHLD never kills, field isn't meaningful */
+/*	clock_t	csi_stime;	SIGCHLD never kills, field isn't meaningful */
+	void	*csi_ptr;	/* union with si_int */
+	int	csi_tid;	/* POSIX.1b timers */
+	int	csi_overrun;	/* POSIX.1b timers */
+	long	csi_band;	/* SIGIO/POLL: band event */
+	int	csi_fd;		/* SIGIO/POLL: file descriptor */
+	void	*csi_addr;	/* SEGV/BUS: address which caused fault */
+	int	csi_trapno;	/* SEGV/BUS */
+	int	csi_addr_lsb;	/* SEGV/BUS: least significant bit of address */
+	/* Can be extended in the future, if siginfo_t is extended */
+};
+
+static void fill_siginfo_note(struct memelfnote *note, struct coredump_siginfo *data, siginfo_t *siginfo)
+{
+	data->csi_pid      = siginfo->si_pid;
+	data->csi_uid      = siginfo->si_uid;
+	data->csi_ptr      = siginfo->si_ptr;
+	data->csi_overrun  = siginfo->si_overrun;
+	data->csi_tid      = siginfo->si_tid;
+	data->csi_band     = siginfo->si_band;
+	data->csi_fd       = siginfo->si_fd;
+	data->csi_addr     = siginfo->si_addr;
+#ifdef __ARCH_SI_TRAPNO
+	data->csi_trapno   = siginfo->si_trapno;
+#endif
+	/* Prevent signed short->int expansion: */
+	data->csi_addr_lsb = (unsigned short)siginfo->si_addr_lsb;
+
+	fill_note(note, "CORE", NT_SIGINFO, sizeof(*data), data);
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1384,7 +1423,9 @@ struct elf_thread_core_info {
 struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
+	struct memelfnote siginfo;
 	struct memelfnote auxv;
+	struct coredump_siginfo csigdata;
 	size_t size;
 	int thread_notes;
 };
@@ -1558,6 +1599,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
+	fill_siginfo_note(&info->siginfo, &info->csigdata, siginfo);
+	info->size += notesize(&info->siginfo);
+
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
@@ -1587,6 +1631,8 @@ static int write_note_info(struct elf_note_info *info,
 
 		if (first && !writenote(&info->psinfo, file, foffset))
 			return 0;
+		if (first && !writenote(&info->siginfo, file, foffset))
+			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
 
@@ -1680,6 +1726,7 @@ struct elf_note_info {
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu;
 #endif
+	struct coredump_siginfo csigdata;
 	int thread_status_size;
 	int numnote;
 };
@@ -1689,8 +1736,8 @@ static int elf_note_info_init(struct elf_note_info *info)
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Allocate space for ELF notes */
+	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1762,6 +1809,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 
 	info->numnote = 2;
 
+	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
 	fill_auxv_note(&info->notes[info->numnote++], current->mm);
 
 	/* Try to dump the FPU. */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index f930b1a..1e63390 100644
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

