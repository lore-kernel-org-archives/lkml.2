Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2JELoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:44:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab2JELoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:44:14 -0400
Date: Fri, 5 Oct 2012 04:43:55 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-2b17c545a4cdbbbadcd7f1e9684c2d7db8f085a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1349308004-3482-1-git-send-email-fweisbec@gmail.com>
References: <1349308004-3482-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] nohz:
  Fix one jiffy count too far in idle cputime
Git-Commit-ID: 2b17c545a4cdbbbadcd7f1e9684c2d7db8f085a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 04:44:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b17c545a4cdbbbadcd7f1e9684c2d7db8f085a6
Gitweb:     http://git.kernel.org/tip/2b17c545a4cdbbbadcd7f1e9684c2d7db8f085a6
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 4 Oct 2012 01:46:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 10:22:20 +0200

nohz: Fix one jiffy count too far in idle cputime

When we stop the tick in idle, we save the current jiffies value
in ts->idle_jiffies. This snapshot is substracted from the later
value of jiffies when the tick is restarted and the resulting
delta is accounted as idle cputime. This is how we handle the
idle cputime accounting without the tick.

But sometimes we need to schedule the next tick to some time in
the future instead of completely stopping it. In this case, a
tick may happen before we restart the periodic behaviour and
from that tick we account one jiffy to idle cputime as usual but
we also increment the ts->idle_jiffies snapshot by one so that
when we compute the delta to account, we substract the one jiffy
we just accounted.

To prepare for stopping the tick outside idle, we introduced a
check that prevents from fixing up that ts->idle_jiffies if we
are not running the idle task. But we use idle_cpu() for that
and this is a problem if we run the tick while another CPU
remotely enqueues a ttwu to our runqueue:

CPU 0:                            CPU 1:

tick_sched_timer() {              ttwu_queue_remote()
       if (idle_cpu(CPU 0))
           ts->idle_jiffies++;
}

Here, idle_cpu() notes that &rq->wake_list is not empty and
hence won't consider the CPU as idle. As a result,
ts->idle_jiffies won't be incremented. But this is wrong because
we actually account the current jiffy to idle cputime. And that
jiffy won't get substracted from the nohz time delta. So in the
end, this jiffy is accounted twice.

Fix this by changing idle_cpu(smp_processor_id()) with
is_idle_task(current). This way the jiffy is substracted
correctly even if a ttwu operation is enqueued on the CPU.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # 3.5+
Link: http://lkml.kernel.org/r/1349308004-3482-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f423bdd..a402608 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -835,7 +835,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		 */
 		if (ts->tick_stopped) {
 			touch_softlockup_watchdog();
-			if (idle_cpu(cpu))
+			if (is_idle_task(current))
 				ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));
