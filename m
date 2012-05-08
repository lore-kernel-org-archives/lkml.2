Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2EHXPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:15:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:47432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2EHXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:15:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138405374"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: [PATCH 1/3] coredump: flush the fpu exit state for proper multi-threaded core dump
Date: Tue,  8 May 2012 16:18:03 -0700
Message-Id: <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
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

If the coredump is in progress, explicitly flush the fpu state by calling
prepare_to_copy().

Reported-by: Suresh Nalluru <suresh@aristanetworks.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/exit.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..dc90d63 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -656,6 +656,11 @@ static void exit_mm(struct task_struct * tsk)
 		struct core_thread self;
 		up_read(&mm->mmap_sem);
 
+		/*
+		 * Flush the live extended register state to memory.
+		 */
+		prepare_to_copy(tsk);
+
 		self.task = tsk;
 		self.next = xchg(&core_state->dumper.next, &self);
 		/*
-- 
1.7.6.5

