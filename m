Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0IMFTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:19:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:53078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab0IMFTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:19:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="656618480"
Subject: Re: high power consumption in recent kernels
From: "Alex,Shi" <alex.shi@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
References: <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:21:17 +0800
Message-ID: <1284355277.26157.8109.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 22:54 +0800, Norbert Preining wrote:
> On Fr, 10 Sep 2010, Shi, Alex wrote:
> > In the powertop source code, the "extra timer interrupt" come from /proc/timer_stats. If my understanding is correct, so many "extra timer interrupt" and the nohz_ratemlimit checking make your system can not go to deep C states. but don't know what the effect for "load balancing tick" come from "extra timer interrupt". So maybe reduce the "extra timer interrupt" is  helpful on your system. Could you like to try this? 
> 
> Can you be more specific how to do that?
> 
> - revert the nohz patch (can you send me a patch for that)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..e66c52e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,8 +274,14 @@ extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
+extern int nohz_ratelimit(int cpu);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline int nohz_ratelimit(int cpu)
+{
+       return 0;
+}
+
 #endif
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..25399e7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1182,6 +1182,17 @@ static void resched_task(struct task_struct *p)
 		smp_send_reschedule(cpu);
 }
 
+int nohz_ratelimit(int cpu)
+{
+       struct rq *rq = cpu_rq(cpu);
+       u64 diff = rq->clock - rq->nohz_stamp;
+
+       rq->nohz_stamp = rq->clock;
+
+       return diff < (NSEC_PER_SEC / HZ) >> 1;
+}
+
+
 static void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..d6bca17 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu)|| nohz_ratelimit(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {

> - how to reduce the "extra timer interrupt"?
The timer was listed in /proc/timer_stats, you can post its contents,
and let's see what is abnormal here. 

> 
> Thanks
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> CAIRNPAT (n.)
> A large piece of dried dung found in mountainous terrain above the
> cowline which leads the experienced tracker to believe that hikers
> have recently passed.
> 			--- Douglas Adams, The Meaning of Liff


