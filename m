Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab2IROxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:53:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39876 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2IROxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:53:36 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v2 1/2] coredump: pass siginfo_t* to do_coredump() and below, not merely signr
Date: Tue, 18 Sep 2012 16:53:14 +0200
Message-Id: <1347979995-1452-2-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparatory patch for the introduction of NT_SIGINFO elf note.

With this patch we pass "siginfo_t *siginfo" instead of "int signr" to
do_coredump() and put it into coredump_params. It will be used
by the next patch. Most changes are simple s/signr/siginfo->si_signo/.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
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
index 4b5b511..0e7a6f8 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -65,7 +65,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
-	dump.signal = cprm->signr;
+	dump.signal = cprm->siginfo->si_signo;
 	aout_dump_thread(cprm->regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b4efbc..d5fb3ec 100644
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
+	if (!fill_note_info(elf, e_phnum, &info, cprm->siginfo, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 3d8fae0..a460491 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1641,7 +1641,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 		goto cleanup;
 #endif
 
-	if (cprm->signr) {
+	if (cprm->siginfo->si_signo) {
 		struct core_thread *ct;
 		struct elf_thread_status *tmp;
 
@@ -1660,13 +1660,13 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 			int sz;
 
 			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(cprm->signr, tmp);
+			sz = elf_dump_thread_status(cprm->siginfo->si_signo, tmp);
 			thread_status_size += sz;
 		}
 	}
 
 	/* now collect the dump for the current */
-	fill_prstatus(prstatus, current, cprm->signr);
+	fill_prstatus(prstatus, current, cprm->siginfo->si_signo);
 	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
 
 	segs = current->mm->map_count;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 178cb70..e280352 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -107,7 +107,7 @@ static struct linux_binfmt flat_format = {
 static int flat_core_dump(struct coredump_params *cprm)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
-			current->comm, current->pid, (int) cprm->signr);
+			current->comm, current->pid, (int) cprm->siginfo->si_signo);
 	return(1);
 }
 
diff --git a/fs/coredump.c b/fs/coredump.c
index aad8715..0031270 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -200,7 +200,7 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%ld", cprm->signr);
+				err = cn_printf(cn, "%ld", cprm->siginfo->si_signo);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
@@ -467,7 +467,7 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return 0;
 }
 
-void do_coredump(long signr, int exit_code, struct pt_regs *regs)
+void do_coredump(siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	struct core_name cn;
@@ -481,7 +481,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	bool need_nonrelative = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
-		.signr = signr,
+		.siginfo = siginfo,
 		.regs = regs,
 		.limit = rlimit(RLIMIT_CORE),
 		/*
@@ -492,7 +492,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		.mm_flags = mm->flags,
 	};
 
-	audit_core_dumps(signr);
+	audit_core_dumps(siginfo->si_signo);
 
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
@@ -516,7 +516,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		need_nonrelative = true;
 	}
 
-	retval = coredump_wait(exit_code, &core_state);
+	retval = coredump_wait(siginfo->si_signo, &core_state);
 	if (retval < 0)
 		goto fail_creds;
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 52fb2eb..5f50ffd 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -74,7 +74,7 @@ struct linux_binprm {
 
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
-	long signr;
+	siginfo_t *siginfo;
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 42f9752..1775eb8 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -12,9 +12,9 @@
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
 #ifdef CONFIG_COREDUMP
-extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+extern void do_coredump(siginfo_t *siginfo, struct pt_regs *regs);
 #else
-static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+static inline void do_coredump(siginfo_t *siginfo, struct pt_regs *regs) {}
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

