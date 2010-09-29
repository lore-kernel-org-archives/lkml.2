Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0I2TWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:22:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab0I2TWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:22:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=YnuObGyHnNvicQfIKknlYC8dLXBYb/qAGmCoacnUCbp2Ptj9FR8qXHahSdTfg+oaq
	QktegyqOajYSfg4/R2QZw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 7/7] Export per cpu hardirq and softirq time in proc -v3
Date: Wed, 29 Sep 2010 12:21:36 -0700
Message-Id: <1285788096-29471-8-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285788096-29471-1-git-send-email-venki@google.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can predict this change being debated.

There is already per CPU and system level irq time in /proc/stat, which
on arch like x86 is based on sampled data. Earlier patches in this series
adds a fine grained irq time option for such archs. And exporting this
fine grained irq time to userspace seems helpful.

How should it be exported though? I considered:
(1) Changing the currently exported info in /proc/stat to directly use this
    new fine grained irq times. Doing that though will likely break the sum
    view to the user as user/system/ and other times there are still sample
    based and only irq time will be fine grained. So, user will almost always
    see sum time != 100% in top etc.
(2) Changing the currently exported info in /proc/stat to indirectly use this
    new fine grained irq times. By still doing the cpustat updating on ticks,
    but looking at the fine grained stats to figure out whether the time should
    be hardirq/softirq/user/system/idle. Doing that will be a lot of code
    churn in kernel/sched.c:account_*_tick code which is already sort of
    complicated.
(3) Add a new interface in /proc. Implied an additional file read and buffer
    allocation, etc which I want to avoid if possible.
(4) Don't export this info at all. I am ok with this as a alternative. But,
    I needed this to be exported somewhere for my testing atleast.
(5) piggyback on /proc/interrupts and /proc/softirqs. Assuming users interested
    in this kind of info are already looking into those files, we wont have
    overhead of additional file read. There is still a likely hood of breaking
    some apps which only expect interrupt count in those files.

So, here is the patch that does (5)

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 Documentation/filesystems/proc.txt |    9 +++++++++
 fs/proc/interrupts.c               |   11 ++++++++++-
 fs/proc/softirqs.c                 |    8 ++++++++
 include/linux/sched.h              |    3 +++
 kernel/sched.c                     |   27 +++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..4456011 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -536,6 +536,11 @@ the threshold vector does not exist on x86_64 platforms.  Others are
 suppressed when the system is a uniprocessor.  As of this writing, only
 i386 and x86_64 platforms support the new IRQ vector displays.
 
+Another addition to /proc/interrupt is "Time:" line at the end which
+displays time spent by corresponding CPU processing interrupts in USER_HZ units.
+This time is based on fine grained accouting when CONFIG_VIRT_CPU_ACCOUNTING
+or CONFIG_IRQ_TIME_ACCOUNTING is active, otherwise it is tick sample based.
+
 Of some interest is the introduction of the /proc/irq directory to 2.4.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
@@ -824,6 +829,10 @@ Provides counts of softirq handlers serviced since boot time, for each cpu.
  HRTIMER:          0          0          0          0
      RCU:       1678       1769       2178       2250
 
+Addition to /proc/softirqs is "Time:" line at the end which
+displays time spent by corresponding CPU processing softirqs in USER_HZ units.
+This time is based on fine grained accouting when CONFIG_VIRT_CPU_ACCOUNTING
+or CONFIG_IRQ_TIME_ACCOUNTING is active, otherwise it is tick sample based.
 
 1.3 IDE devices in /proc/ide
 ----------------------------
diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index 05029c0..66d913a 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -3,6 +3,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqnr.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 
 /*
@@ -23,7 +24,15 @@ static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 
 static void int_seq_stop(struct seq_file *f, void *v)
 {
-	/* Nothing to do */
+	int j;
+
+	seq_printf(f, "\n");
+	seq_printf(f, "Time:");
+	for_each_possible_cpu(j)
+		seq_printf(f, " %10lu", (unsigned long)get_cpu_hardirq_time(j));
+	seq_printf(f, "  Interrupt Processing Time\n");
+	seq_printf(f, "\n");
+
 }
 
 static const struct seq_operations int_seq_ops = {
diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
index 1807c24..f028329 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 
 /*
@@ -21,6 +22,13 @@ static int show_softirqs(struct seq_file *p, void *v)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
 		seq_printf(p, "\n");
 	}
+
+	seq_printf(p, "\n");
+	seq_printf(p, "    Time:");
+	for_each_possible_cpu(j)
+		seq_printf(p, " %10lu", (unsigned long)get_cpu_softirq_time(j));
+	seq_printf(p, "\n");
+
 	return 0;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8adf166..6562daf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,6 +1826,9 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
+extern clock_t get_cpu_hardirq_time(int cpu);
+extern clock_t get_cpu_softirq_time(int cpu);
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
diff --git a/kernel/sched.c b/kernel/sched.c
index bfbe064..a171647 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -73,6 +73,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 
+#include <asm/cputime.h>
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 
@@ -1999,6 +2000,22 @@ static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 	}
 }
 
+clock_t get_cpu_hardirq_time(int cpu)
+{
+	if (!sched_clock_irqtime)
+		return cputime64_to_clock_t(kstat_cpu(cpu).cpustat.irq);
+
+	return nsec_to_clock_t(per_cpu(cpu_hardirq_time, cpu));
+}
+
+clock_t get_cpu_softirq_time(int cpu)
+{
+	if (!sched_clock_irqtime)
+		return cputime64_to_clock_t(kstat_cpu(cpu).cpustat.softirq);
+
+	return nsec_to_clock_t(per_cpu(cpu_softirq_time, cpu));
+}
+
 #else
 
 static u64 irq_time_cpu(int cpu)
@@ -2008,6 +2025,16 @@ static u64 irq_time_cpu(int cpu)
 
 static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
 
+clock_t get_cpu_hardirq_time(int cpu)
+{
+	return cputime64_to_clock_t(kstat_cpu(cpu).cpustat.irq);
+}
+
+clock_t get_cpu_softirq_time(int cpu)
+{
+	return cputime64_to_clock_t(kstat_cpu(cpu).cpustat.softirq);
+}
+
 #endif
 
 #include "sched_idletask.c"
-- 
1.7.1

