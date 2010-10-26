Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab0JZMov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:44:51 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37931 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0JZMou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:44:50 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1288001573.15336.52.camel@twins>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	 <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Oct 2010 14:44:34 +0200
Message-ID: <1288097074.15336.211.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 12:12 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-22 at 16:03 -0700, Venkatesh Pallipadi wrote:
> > I started making small changes to the code, but none of the change helped much.
> > I think the problem with the current code is that, even though idle CPUs
> > update load, the fold only happens when one of the CPU is busy
> > and we end up taking its load into global load.
> > 
> > So, I tried to simplify things and doing the updates directly from idle loop.
> > This is only a test patch, and eventually we need to hook it off somewhere
> > else, instead of idle loop and also this is expected work only as x86_64
> > right now.
> > 
> > Peter: Do you think something like this will work? loadavg went
> > quite on two of my test systems after this change (4 cpu and 24 cpu).
> 
> Not really, CPUs can stay idle for _very_ long times (!x86 cpus that
> don't have crappy timers like HPET which roll around every 2-4 seconds).
> 
> But all CPUs staying idle for a long time is exactly the scenario you
> fix before using the decay_load_misses() stuff, except that is for the
> load-balancer per-cpu load numbers not the global cpu load avg. Won't a
> similar approach work here?


The crude patch would be something like the below.. a smarter patch will
try and avoid that loop.

---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   20 +++++++++-----------
 kernel/timer.c        |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7a6e81f..84c1bf1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -143,7 +143,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(void);
+extern void calc_global_load(int ticks);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 41f1869..49a2baf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3171,22 +3171,20 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(void)
+void calc_global_load(int ticks)
 {
-	unsigned long upd = calc_load_update + 10;
 	long active;
 
-	if (time_before(jiffies, upd))
-		return;
-
-	active = atomic_long_read(&calc_load_tasks);
-	active = active > 0 ? active * FIXED_1 : 0;
+	while (!time_before(jiffies, calc_load_update + 10)) {
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
 
-	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
-	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
-	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+		avenrun[0] = calc_load(avenrun[0], EXP_1, active);
+		avenrun[1] = calc_load(avenrun[1], EXP_5, active);
+		avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
-	calc_load_update += LOAD_FREQ;
+		calc_load_update += LOAD_FREQ;
+	}
 }
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index d6ccb90..9f82b2a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1297,7 +1297,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load();
+	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM

