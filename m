Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2BEENE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:13:04 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44398 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2BEENC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:13:02 -0500
Date: Sun, 5 Feb 2012 05:12:56 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: cgroup_release_agent() with call_usermodehelper() with
 UMH_WAIT_EXEC may crash
Message-ID: <20120205041256.GA2552@osiris.boeblingen.de.ibm.com>
References: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com>
 <20120203160454.GA3092@redhat.com>
 <CA+55aFx0SxW5ST2H1TL6K-457nP1qtAva0+YcnJLNoUUz_PCdg@mail.gmail.com>
 <20120204100342.GA2626@osiris.boeblingen.de.ibm.com>
 <CA+55aFzMm8oGB55GMK4GkzNViVLqWbNjgCkuFpFvG0EExbFQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzMm8oGB55GMK4GkzNViVLqWbNjgCkuFpFvG0EExbFQHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020504-1948-0000-0000-000000D4C766
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 07:16:51AM -0800, Linus Torvalds wrote:
> On Sat, Feb 4, 2012 at 2:03 AM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> >
> > Something like the patch below? Still boots...
> 
> Yes, except that if we touch the comm copying code, let's do what Oleg
> suggested and make it a helper function to create the "comm[]" data
> array instead of open-coding it and adding new random local variables
> to prepare_binprm().
> 
> But looks good otherwise. I'm a *bit* nervous that some
> prepare_binprm() caller hasn't set up bprm->filename that early yet,
> though. It seems like we expect that to be set up by the caller, which
> seems a bit odd, actually.

Ok, I moved it to flush_old_exec() instead like Oleg initially suggested.

>From 04d7f15afe14bbd0ede066b413214ceb2bcf7113 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sat, 4 Feb 2012 10:47:10 +0100
Subject: [PATCH] exec: fix use-after-free bug in setup_new_exec()

Setting the task name is done within setup_new_exec() by accessing
bprm->filename. However this happens after flush_old_exec().
This may result in a use after free bug, flush_old_exec() may
"complete" vfork_done, which will wake up the parent which in turn
may free the passed in filename.
To fix this add a new tcomm field in struct linux_binprm which
contains the now early generated task name until it is used.

Fixes this bug on s390:

[    9.642907] Unable to handle kernel pointer dereference at virtual kernel address 0000000039768000
[    9.642918] Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    9.642934] Modules linked in: qeth_l3 lcs ctcm fsm vmur qeth ccwgroup autofs4 [last unloaded: scsi_wait_scan]
[    9.642965] CPU: 0 Not tainted 3.3.0-rc2-00037-gbd3ce7d-dirty #48
[    9.643011] Process kworker/u:3 (pid: 245, task: 000000003a3dc840, ksp: 0000000039453818)
[    9.643015] Krnl PSW : 0704000180000000 0000000000282e94 (setup_new_exec+0xa0/0x374)
[    9.643026]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[    9.643032] Krnl GPRS: 0000000030844dcb fffffffffffffffd 0000000039768000 0000000000000000
[    9.643039]            00000000000000cd 0000000000243c18 00000000000001f8 0000000039453dd0
[    9.643045]            000000003dc55220 0000000000000000 00000000006f4800 000000003dc55220
[    9.643051]            0000000000000000 00000000005dd958 00000000002830f0 0000000039453a18
[    9.643067] Krnl Code: 0000000000282e84: c0e5ffffff52        brasl   %r14,282d28
[    9.643079]            0000000000282e8a: e320b0c80004        lg      %r2,200(%r11)
[    9.643092]           #0000000000282e90: a7380000            lhi     %r3,0
[    9.643108]           >0000000000282e94: e31020000090        llgc    %r1,0(%r2)
[    9.643123]            0000000000282e9a: 41202001            la      %r2,1(%r2)
[    9.643162]            0000000000282e9e: 1241                ltr     %r4,%r1
[    9.643168]            0000000000282ea0: a7840018            brc     8,282ed0
[    9.643175]            0000000000282ea4: a74e002f            chi     %r4,47
[    9.643183] Call Trace:
[    9.643186] ([<0000000000282e2c>] setup_new_exec+0x38/0x374)
[    9.643192]  [<00000000002dd12e>] load_elf_binary+0x402/0x1bf4
[    9.643201]  [<0000000000280a42>] search_binary_handler+0x38e/0x5bc
[    9.643210]  [<0000000000282b6c>] do_execve_common+0x410/0x514
[    9.643218]  [<0000000000282cb6>] do_execve+0x46/0x58
[    9.643225]  [<00000000005bce58>] kernel_execve+0x28/0x70
[    9.643236]  [<000000000014ba2e>] ____call_usermodehelper+0x102/0x140
[    9.643245]  [<00000000005bc8da>] kernel_thread_starter+0x6/0xc
[    9.643254]  [<00000000005bc8d4>] kernel_thread_starter+0x0/0xc
[    9.643264] INFO: lockdep is turned off.
[    9.643269] Last Breaking-Event-Address:
[    9.643275]  [<00000000002830f0>] setup_new_exec+0x2fc/0x374
[    9.643311]
[    9.643315] Kernel panic - not syncing: Fatal exception: panic_on_oops

Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/exec.c               |   33 +++++++++++++++++----------------
 include/linux/binfmts.h |    3 ++-
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index aeb135c..92ce83a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1071,6 +1071,21 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
+static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
+{
+	int i, ch;
+
+	/* Copies the binary name from after last slash */
+	for (i = 0; (ch = *(fn++)) != '\0';) {
+		if (ch == '/')
+			i = 0; /* overwrite what we wrote */
+		else
+			if (i < len - 1)
+				tcomm[i++] = ch;
+	}
+	tcomm[i] = '\0';
+}
+
 int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
@@ -1085,6 +1100,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	set_mm_exe_file(bprm->mm, bprm->file);
 
+	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
 	/*
 	 * Release all of the old mmap stuff
 	 */
@@ -1116,10 +1132,6 @@ EXPORT_SYMBOL(would_dump);
 
 void setup_new_exec(struct linux_binprm * bprm)
 {
-	int i, ch;
-	const char *name;
-	char tcomm[sizeof(current->comm)];
-
 	arch_pick_mmap_layout(current->mm);
 
 	/* This is the point of no return */
@@ -1130,18 +1142,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	name = bprm->filename;
-
-	/* Copies the binary name from after last slash */
-	for (i=0; (ch = *(name++)) != '\0';) {
-		if (ch == '/')
-			i = 0; /* overwrite what we wrote */
-		else
-			if (i < (sizeof(tcomm) - 1))
-				tcomm[i++] = ch;
-	}
-	tcomm[i] = '\0';
-	set_task_comm(current, tcomm);
+	set_task_comm(current, bprm->tcomm);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index fd88a39..0092102 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -18,7 +18,7 @@ struct pt_regs;
 #define BINPRM_BUF_SIZE 128
 
 #ifdef __KERNEL__
-#include <linux/list.h>
+#include <linux/sched.h>
 
 #define CORENAME_MAX_SIZE 128
 
@@ -58,6 +58,7 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
+	char tcomm[TASK_COMM_LEN];
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
-- 
1.7.9

