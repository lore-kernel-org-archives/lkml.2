Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab2EJXa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:30:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:30440 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab2EJXaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164690642"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for proper multi-threaded core dump
Date: Thu, 10 May 2012 16:33:29 -0700
Message-Id: <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
 <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.7.6.5

