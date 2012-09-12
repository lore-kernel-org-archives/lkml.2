Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2ILXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:39:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49576 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab2ILXjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:04 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 1/2] coredump: pass siginfo_t* to do_coredump() and below, not merely signr
Date: Thu, 13 Sep 2012 01:38:43 +0200
Message-Id: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for the introduction of NT_SIGINFO elf note.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 fs/binfmt_aout.c         |    2 +-
 fs/binfmt_elf.c          |   14 +++++++-------
 fs/binfmt_elf_fdpic.c    |    6 +++---
 fs/binfmt_flat.c         |    2 +-
 fs/coredump.c            |   10 +++++-----
 include/linux/binfmts.h  |    2 +-
 include/linux/coredump.h |    4 ++--
 kernel/signal.c          |    2 +-
 8 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index d146e18..3a65adf 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -89,7 +89,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
-	dump.signal = cprm->signr;
+	dump.signal = cprm->info->si_signo;
 	aout_dump_thread(cprm->regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b4efbc..41a40de 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1479,7 +1479,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -1549,7 +1549,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	 * Now fill in each thread's information.
 	 */
 	for (t = info->thread; t != NULL; t = t->next)
-		if (!fill_thread_core_info(t, view, signr, &info->size))
+		if (!fill_thread_core_info(t, view, siginfo->si_signo, &info->size))
 			return 0;
 
 	/*
@@ -1712,14 +1712,14 @@ static int elf_note_info_init(struct elf_note_info *info)
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
 
 	if (!elf_note_info_init(info))
 		return 0;
 
-	if (signr) {
+	if (siginfo->si_signo) {
 		struct core_thread *ct;
 		struct elf_thread_status *ets;
 
@@ -1737,13 +1737,13 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			int sz;
 
 			ets = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, ets);
+			sz = elf_dump_thread_status(siginfo->si_signo, ets);
 			info->thread_status_size += sz;
 		}
 	}
 	/* now collect the dump for the current */
 	memset(info->prstatus, 0, sizeof(*info->prstatus));
-	fill_prstatus(info->prstatus, current, signr);
+	fill_prstatus(info->prstatus, current, siginfo->si_signo);
 	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
 
 	/* Set up header */
@@ -1950,7 +1950,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, e_phnum, &info, cprm->signr, cprm->regs))
+	if (!fill_note_info(elf, e_phnum, &info, cprm->info, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 3d8fae0..6554f54 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1641,7 +1641,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 		goto cleanup;
 #endif
 
-	if (cprm->signr) {
+	if (cprm->info->si_signo) {
 		struct core_thread *ct;
 		struct elf_thread_status *tmp;
 
@@ -1660,13 +1660,13 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 			int sz;
 
 			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(cprm->signr, tmp);
+			sz = elf_dump_thread_status(cprm->info->si_signo, tmp);
 			thread_status_size += sz;
 		}
 	}
 
 	/* now collect the dump for the current */
-	fill_prstatus(prstatus, current, cprm->signr);
+	fill_prstatus(prstatus, current, cprm->info->si_signo);
 	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
 
 	segs = current->mm->map_count;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 178cb70..ebe6feb 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -107,7 +107,7 @@ static struct linux_binfmt flat_format = {
 static int flat_core_dump(struct coredump_params *cprm)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
-			current->comm, current->pid, (int) cprm->signr);
+			current->comm, current->pid, (int) cprm->info->si_signo);
 	return(1);
 }
 
diff --git a/fs/coredump.c b/fs/coredump.c
index 1935b4d..0027ec0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -463,7 +463,7 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return 0;
 }
 
-void do_coredump(long signr, int exit_code, struct pt_regs *regs)
+void do_coredump(siginfo_t *info, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	struct core_name cn;
@@ -477,7 +477,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	bool need_nonrelative = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
-		.signr = signr,
+		.info = info,
 		.regs = regs,
 		.limit = rlimit(RLIMIT_CORE),
 		/*
@@ -488,7 +488,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		.mm_flags = mm->flags,
 	};
 
-	audit_core_dumps(signr);
+	audit_core_dumps(info->si_signo);
 
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
@@ -512,7 +512,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		need_nonrelative = true;
 	}
 
-	retval = coredump_wait(exit_code, &core_state);
+	retval = coredump_wait(info->si_signo, &core_state);
 	if (retval < 0)
 		goto fail_creds;
 
@@ -524,7 +524,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	ispipe = format_corename(&cn, signr);
+	ispipe = format_corename(&cn, info->si_signo);
 
  	if (ispipe) {
 		int dump_count;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 52fb2eb..f2d1445 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -74,7 +74,7 @@ struct linux_binprm {
 
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
-	long signr;
+	siginfo_t *info;
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 42f9752..be939ce 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -12,9 +12,9 @@
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
 #ifdef CONFIG_COREDUMP
-extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+extern void do_coredump(siginfo_t *info, struct pt_regs *regs);
 #else
-static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+static inline void do_coredump(siginfo_t *info, struct pt_regs *regs) {}
 #endif
 
 #endif /* _LINUX_COREDUMP_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index fb4fd72..546f23d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2370,7 +2370,7 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump(info->si_signo, info->si_signo, regs);
+			do_coredump(info, regs);
 		}
 
 		/*
-- 
1.7.7.6

