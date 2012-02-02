Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2BBCbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:31:17 -0500
Received: from linux-sh.org ([111.68.239.195]:55410 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2BBCbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:31:15 -0500
Date: Thu, 2 Feb 2012 11:29:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC idle] Make arm, sh, and x86 stop using RCU when idle
Message-ID: <20120202022959.GA24442@linux-sh.org>
References: <20120202004253.GA10946@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202004253.GA10946@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:42:53PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> RCU's shiny new diagnostics (thank you, Frederic!) for using RCU when idle
> located a few problems in arm, sh, and x86.  This patch series contains
> alleged fixes for these problems.  And they are real problems -- if RCU
> believes that the CPU is idle, it is ignoring it.  Which means that the
> idle CPU can say "rcu_read_lock()" all it like, but there will be no
> useful effect.
> 
> I was tempted to break these up, but doing so is bad for bisectability.
> 
Presumably the same changes will also need to be reflected in cpuidle?

If so, here's a start:

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..97adcd4 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -18,6 +18,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <trace/events/power.h>
 
 #include "cpuidle.h"
@@ -89,6 +90,8 @@ int cpuidle_idle_call(void)
 	next_state = cpuidle_curr_governor->select(drv, dev);
 	if (need_resched()) {
 		local_irq_enable();
+		rcu_idle_enter();
+		rcu_idle_exit();
 		return 0;
 	}
 
@@ -96,9 +99,11 @@ int cpuidle_idle_call(void)
 
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
+	rcu_idle_enter();
 
 	entered_state = target_state->enter(dev, drv, next_state);
 
+	rcu_idle_exit();
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
@@ -173,8 +178,10 @@ static int poll_idle(struct cpuidle_device *dev,
 
 	t1 = ktime_get();
 	local_irq_enable();
+	rcu_idle_enter();
 	while (!need_resched())
 		cpu_relax();
+	rcu_idle_exit();
 
 	t2 = ktime_get();
 	diff = ktime_to_us(ktime_sub(t2, t1));
