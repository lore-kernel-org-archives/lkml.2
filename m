Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab1LFJuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:50:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34900 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab1LFJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:50:48 -0500
Date: Tue, 6 Dec 2011 01:50:24 -0800
From: tip-bot for Mike Galbraith <mgalbraith@suse.de>
Message-ID: <tip-76854c7e8f3f4172fef091e78d88b3b751463ac6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321971504.6855.15.camel@marge.simson.net>
References: <1321971504.6855.15.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use rt.nr_cpus_allowed to recover select_task_rq() cycles
Git-Commit-ID: 76854c7e8f3f4172fef091e78d88b3b751463ac6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:50:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76854c7e8f3f4172fef091e78d88b3b751463ac6
Gitweb:     http://git.kernel.org/tip/76854c7e8f3f4172fef091e78d88b3b751463ac6
Author:     Mike Galbraith <mgalbraith@suse.de>
AuthorDate: Tue, 22 Nov 2011 15:18:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:51:26 +0100

sched: Use rt.nr_cpus_allowed to recover select_task_rq() cycles

rt.nr_cpus_allowed is always available, use it to bail from select_task_rq()
when only one cpu can be used, and saves some cycles for pinned tasks.

See the line marked with '*' below:

  # taskset -c 3 pipe-test

   PerfTop:     997 irqs/sec  kernel:89.5%  exact:  0.0% [1000Hz cycles],  (all, CPU: 3)
------------------------------------------------------------------------------------------------

             Virgin                                    Patched
             samples  pcnt function                    samples  pcnt function
             _______ _____ ___________________________ _______ _____ ___________________________

             2880.00 10.2% __schedule                  3136.00 11.3% __schedule
             1634.00  5.8% pipe_read                   1615.00  5.8% pipe_read
             1458.00  5.2% system_call                 1534.00  5.5% system_call
             1382.00  4.9% _raw_spin_lock_irqsave      1412.00  5.1% _raw_spin_lock_irqsave
             1202.00  4.3% pipe_write                  1255.00  4.5% copy_user_generic_string
             1164.00  4.1% copy_user_generic_string    1241.00  4.5% __switch_to
             1097.00  3.9% __switch_to                  929.00  3.3% mutex_lock
              872.00  3.1% mutex_lock                   846.00  3.0% mutex_unlock
              687.00  2.4% mutex_unlock                 804.00  2.9% pipe_write
              682.00  2.4% native_sched_clock           713.00  2.6% native_sched_clock
              643.00  2.3% system_call_after_swapgs     653.00  2.3% _raw_spin_unlock_irqrestore
              617.00  2.2% sched_clock_local            633.00  2.3% fsnotify
              612.00  2.2% fsnotify                     605.00  2.2% sched_clock_local
              596.00  2.1% _raw_spin_unlock_irqrestore  593.00  2.1% system_call_after_swapgs
              542.00  1.9% sysret_check                 559.00  2.0% sysret_check
              467.00  1.7% fget_light                   472.00  1.7% fget_light
              462.00  1.6% finish_task_switch           461.00  1.7% finish_task_switch
              437.00  1.5% vfs_write                    442.00  1.6% vfs_write
              431.00  1.5% do_sync_write                428.00  1.5% do_sync_write
*             413.00  1.5% select_task_rq_fair          404.00  1.5% _raw_spin_lock_irq
              386.00  1.4% update_curr                  402.00  1.4% update_curr
              385.00  1.4% rw_verify_area               389.00  1.4% do_sync_read
              377.00  1.3% _raw_spin_lock_irq           378.00  1.4% vfs_read
              369.00  1.3% do_sync_read                 340.00  1.2% pipe_iov_copy_from_user
              360.00  1.3% vfs_read                     316.00  1.1% __wake_up_sync_key
              342.00  1.2% hrtick_start_fair            313.00  1.1% __wake_up_common

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321971504.6855.15.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    3 +++
 kernel/sched/rt.c   |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 96a9ece..8e534a0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2744,6 +2744,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
+	if (p->rt.nr_cpus_allowed == 1)
+		return prev_cpu;
+
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 023b355..58a4844 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1200,6 +1200,9 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 
 	cpu = task_cpu(p);
 
+	if (p->rt.nr_cpus_allowed == 1)
+		goto out;
+
 	/* For anything but wake ups, just return the task_cpu */
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;
