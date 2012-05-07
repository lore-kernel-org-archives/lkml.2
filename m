Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2EGTE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:04:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:44434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2EGTE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141079335"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: suresh@aristanetworks.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/2] coredump: flush the fpu exit state for proper multi-threaded core dump
Date: Mon,  7 May 2012 12:07:20 -0700
Message-Id: <1336417641-29771-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <y>
References: <y>
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

Fix this by explicitly flushing the fpu state in do_exit() by calling
prepare_to_copy()

Reported-by: Suresh Nalluru <suresh@aristanetworks.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/exit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..913f2a6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -974,6 +974,8 @@ void do_exit(long code)
 		tty_audit_exit();
 	audit_free(tsk);
 
+	prepare_to_copy(tsk);
+
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
-- 
1.7.6.5

