Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0KEQAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:00:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab0KEQAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:00:41 -0400
Date: Fri, 5 Nov 2010 16:53:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: [PATCH] posix-cpu-timers: workaround to suppress the problems with
	mt exec
Message-ID: <20101105155342.GA13606@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6> <20101102183308.GA17720@redhat.com> <20101103105832.GA30053@swordfish.minsk.epam.com> <20101103124835.GA604@redhat.com> <20101103161059.GA13530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103161059.GA13530@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix-cpu-timers.c correctly assumes that the dying process does
posix_cpu_timers_exit_group() and removes all !CPUCLOCK_PERTHREAD
timers from signal->cpu_timers list.

But, it also assumes that timer->it.cpu.task is always the group
leader, and thus the dead ->task means the dead thread group.

This is obviously not true after de_thread() changes the leader.
After that almost every posix_cpu_timer_ method has problems.

It is not simple to fix this bug correctly. First of all, I think
that timer->it.cpu should use struct pid instead of task_struct.
Also, the locking should be reworked completely. In particular,
tasklist_lock should not be used at all. This all needs a lot of
nontrivial and hard-to-test changes.

Change __exit_signal() to do posix_cpu_timers_exit_group() when
the old leader dies during exec. This is not the fix, just the
temporary hack to hide the problem for 2.6.37 and stable. IOW,
this is obviously wrong but this is what we currently have anyway:
cpu timers do not work after mt exec.

In theory this change adds another race. The exiting leader can
detach the timers which were attached to the new leader. However,
the window between de_thread() and release_task() is small, we
can pretend that sys_timer_create() was called before de_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- kstub/kernel/exit.c~pct_de_thread_race	2010-08-17 12:32:24.000000000 +0200
+++ kstub/kernel/exit.c	2010-11-04 21:30:18.000000000 +0100
@@ -95,6 +95,14 @@ static void __exit_signal(struct task_st
 		sig->tty = NULL;
 	} else {
 		/*
+		 * This can only happen if the caller is de_thread().
+		 * FIXME: this is the temporary hack, we should teach
+		 * posix-cpu-timers to handle this case correctly.
+		 */
+		if (unlikely(has_group_leader_pid(tsk)))
+			posix_cpu_timers_exit_group(tsk);
+
+		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */

