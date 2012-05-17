Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499Ab2EQAR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:17:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975Ab2EQARy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:17:54 -0400
Date: Wed, 16 May 2012 17:17:36 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-11aeca0b3a083a457f5c34fe8c677d5e86a0c6b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh@aristanetworks.com, suresh.b.siddha@intel.com, oleg@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, suresh@aristanetworks.com,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
References: <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] coredump:
  ensure the fpu state is flushed for proper multi-threaded core dump
Git-Commit-ID: 11aeca0b3a083a457f5c34fe8c677d5e86a0c6b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 17:17:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11aeca0b3a083a457f5c34fe8c677d5e86a0c6b3
Gitweb:     http://git.kernel.org/tip/11aeca0b3a083a457f5c34fe8c677d5e86a0c6b3
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 May 2012 15:03:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 15:16:48 -0700

coredump: ensure the fpu state is flushed for proper multi-threaded core dump

Nalluru reported hitting the BUG_ON(__thread_has_fpu(tsk)) in
arch/x86/kernel/xsave.c:__sanitize_i387_state() during the coredump
of a multi-threaded application.

A look at the exit seqeuence shows that other threads can still be on the
runqueue potentially at the below shown exit_mm() code snippet:

		if (atomic_dec_and_test(&core_state->nr_threads))
			complete(&core_state->startup);

===> other threads can still be active here, but we notify the thread
===> dumping core to wakeup from the coredump_wait() after the last thread
===> joins this point. Core dumping thread will continue dumping
===> all the threads state to the core file.

		for (;;) {
			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
			if (!self.task) /* see coredump_finish() */
				break;
			schedule();
		}

As some of those threads are on the runqueue and didn't call schedule() yet,
their fpu state is still active in the live registers and the thread
proceeding with the coredump will hit the above mentioned BUG_ON while
trying to dump other threads fpustate to the coredump file.

BUG_ON() in arch/x86/kernel/xsave.c:__sanitize_i387_state() is
in the code paths for processors supporting xsaveopt. With or without
xsaveopt, multi-threaded coredump is broken and maynot contain
the correct fpustate at the time of exit.

In coredump_wait(), wait for all the threads to be come inactive, so
that we are sure all the extended register state is flushed to
the memory, so that it can be reliably copied to the core file.

Reported-by: Suresh Nalluru <suresh@aristanetworks.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 fs/exec.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b1fd202..8e2ddeb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1930,8 +1930,21 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
-	if (core_waiters > 0)
+	if (core_waiters > 0) {
+		struct core_thread *ptr;
+
 		wait_for_completion(&core_state->startup);
+		/*
+		 * Wait for all the threads to become inactive, so that
+		 * all the thread context (extended register state, like
+		 * fpu etc) gets copied to the memory.
+		 */
+		ptr = core_state->dumper.next;
+		while (ptr != NULL) {
+			wait_task_inactive(ptr->task, 0);
+			ptr = ptr->next;
+		}
+	}
 
 	return core_waiters;
 }
