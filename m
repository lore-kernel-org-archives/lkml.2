Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0I1Khv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:37:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:9052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab0I1Kht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:37:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,246,1283756400"; 
   d="scan'208";a="661868542"
Subject: Re: high power consumption in recent kernels
From: "Alex,Shi" <alex.shi@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yakui.zhao@intel.com
In-Reply-To: <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
References: <1284355277.26157.8109.camel@debian>
	 <1284689374.17745.89.camel@debian> <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
	 <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 18:40:26 +0800
Message-ID: <1285670426.21962.43.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> and it seems that still works nicely. I am now running on battery power,
> connected to the internet over bluetooth to my mobile, and get:
> Wakeups-from-idle per second : 452.2    interval: 10.0s
> Power usage (ACPI estimate): 12.4W (3.6 hours) (long term: 8.0W,/5.6h)
> 
> Top causes for wakeups:
>   16.1% ( 79.5)   [yenta, ehci_hcd:usb2, uhci_hcd:usb6, uhci_hcd:usb7, uhci_hcd:
>   14.3% ( 70.7)   [kernel scheduler] Load balancing tick
>   14.1% ( 69.8)   [extra timer interrupt]
>   13.1% ( 64.9)   kworker/0:0
>   10.7% ( 53.0)   USB device  8-2 : BCM2046 Bluetooth Device (Broadcom Corp)
>    8.4% ( 41.8)   [kernel core] hrtimer_start (tick_sched_timer)
>    3.8% ( 19.0)   gnome-terminal
>    2.9% ( 14.6)   icedove-bin
>    2.2% ( 10.7)   PS/2 keyboard/mouse/touchpad interrupt
> 
> Which shows that the "Load balancing tick" and "extra timer interrupt" are
> down to halfway normal levels. I guess when I shutdown the usb/bluetooth
> connection both of them will drop even further.

> Hope you can do something with it!
> 
> Let me know if I should do more testing.
> 
Seems in .36 kernel the extra timer reduced. Guess the following patch
worked. http://lkml.org/lkml/2010/6/9/109

Tim,Yakui and I talked with the issue. We thought the nohz_ratelimit()
only hart the power when lots of interrupts with light load in system.
Since the tick_nohz_stop_sched_tick() only be checked in cpu_idle() and
in irq_exit(), we remove the nohz checking in irq_exit(). The TCP/UDP RR
loop back testing of netperf also benefit from this. But it have no
effect on real network testing. 

Could you like to try the following patch on your system and see how
many power it consumption now? 

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..a4dbb37 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,8 +274,13 @@ extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
+extern int nohz_ratelimit(int cpu);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline int nohz_ratelimit(int cpu)
+{
+	return 0;
+}
 #endif
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..132a21c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1182,6 +1182,16 @@ static void resched_task(struct task_struct *p)
 		smp_send_reschedule(cpu);
 }
 
+int nohz_ratelimit(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 diff = rq->clock - rq->nohz_stamp;
+
+	rq->nohz_stamp = rq->clock;
+
+	return diff < (NSEC_PER_SEC / HZ) >> 1;
+}
+
 static void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..0b5b186 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+		arch_needs_cpu(cpu)|| (inidle && nohz_ratelimit(cpu))) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {


