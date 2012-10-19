Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332Ab2JSC6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:58:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:52306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928Ab2JSCtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [ 46/76] nohz: Fix one jiffy count too far in idle cputime
Date: Thu, 18 Oct 2012 19:47:10 -0700
Message-Id: <20121019024357.525266666@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 2b17c545a4cdbbbadcd7f1e9684c2d7db8f085a6 upstream.

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
Link: http://lkml.kernel.org/r/1349308004-3482-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -835,7 +835,7 @@ static enum hrtimer_restart tick_sched_t
 		 */
 		if (ts->tick_stopped) {
 			touch_softlockup_watchdog();
-			if (idle_cpu(cpu))
+			if (is_idle_task(current))
 				ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));


