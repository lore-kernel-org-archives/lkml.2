Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0FPUnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:43:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155Ab0FPUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:43:21 -0400
Date: Wed, 16 Jun 2010 13:42:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: sedat.dilek@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>, dmonakhov@openvz.org
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Message-Id: <20100616134231.23ff30da.akpm@linux-foundation.org>
In-Reply-To: <201006091122.35304.rjw@sisk.pl>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	<AANLkTiksbL1qHg7Q0A-6TbX0uUrxra4jctUoIGVk5vnE@mail.gmail.com>
	<201006091122.35304.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 11:22:35 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 09 June 2010, Sedat Dilek wrote:
> > The patch from [1] is still missing.
> > 
> >    "cpufreq-call-nr_iowait_cpu-with-disabled-preemption.patch" from
> > Dmitry Monakhoc
> > 
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
> > 
> > I have already reported this issue on LKML [2] and cpufreq ML [3].
> > 
> > - Sedat -
> > 
> > [1] http://www.spinics.net/lists/cpufreq/msg01631.html
> > [2] http://lkml.org/lkml/2010/5/31/77
> > [3] http://www.spinics.net/lists/cpufreq/msg01637.html
> 
> Thanks, added.

I just merged a different patch whcih should address this:


From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Fix

 BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/3392
 caller is nr_iowait_cpu+0xe/0x1e
 Pid: 3392, comm: s2disk Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
 Call Trace:
 [<c1184c55>] debug_smp_processor_id+0xa5/0xbc
 [<c10282a5>] nr_iowait_cpu+0xe/0x1e
 [<c104ab7c>] update_ts_time_stats+0x32/0x6c
 [<c104ac73>] get_cpu_idle_time_us+0x36/0x58
 [<c124229b>] get_cpu_idle_time+0x12/0x74
 [<c1242963>] cpufreq_governor_dbs+0xc3/0x2dc
 [<c1240437>] __cpufreq_governor+0x51/0x85
 [<c1241190>] __cpufreq_set_policy+0x10c/0x13d
 [<c12413d3>] cpufreq_add_dev_interface+0x212/0x233
 [<c1241b1e>] ? handle_update+0x0/0xd
 [<c1241a18>] cpufreq_add_dev+0x34b/0x35a
 [<c103c973>] ? schedule_delayed_work_on+0x11/0x13
 [<c12c14db>] cpufreq_cpu_callback+0x59/0x63
 [<c1042f39>] notifier_call_chain+0x26/0x48
 [<c1042f7d>] __raw_notifier_call_chain+0xe/0x10
 [<c102efb9>] __cpu_notify+0x15/0x29
 [<c102efda>] cpu_notify+0xd/0xf
 [<c12bfb30>] _cpu_up+0xaf/0xd2
 [<c12b3ad4>] enable_nonboot_cpus+0x3d/0x94
 [<c1055eef>] hibernation_snapshot+0x104/0x1a2
 [<c1058b49>] snapshot_ioctl+0x24b/0x53e
 [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
 [<c10ab91d>] vfs_ioctl+0x2e/0x8c
 [<c10588fe>] ? snapshot_ioctl+0x0/0x53e
 [<c10ac2c7>] do_vfs_ioctl+0x42f/0x45a
 [<c10a0ba5>] ? fsnotify_modify+0x4f/0x5a
 [<c11e9dc3>] ? tty_write+0x0/0x1d0
 [<c10a12d6>] ? vfs_write+0xa2/0xda
 [<c10ac333>] sys_ioctl+0x41/0x62
 [<c10027d3>] sysenter_do_call+0x12/0x2d

The initial fix was to use get_cpu/put_cpu in nr_iowait_cpu.  However,
Arjan stated that "the bug is that it needs to be nr_iowait_cpu(int cpu)".

This patch introduces nr_iowait_cpu(int cpu) and changes to it callers.

akpm: addresses about 30,000,000 different bug reports.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   10 ++++++++--
 include/linux/sched.h            |    2 +-
 kernel/sched.c                   |    4 ++--
 kernel/time/tick-sched.c         |    4 +++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/drivers/cpuidle/governors/menu.c
@@ -137,15 +137,18 @@ static inline int which_bucket(unsigned 
 {
 	int bucket = 0;
 
+	int cpu = get_cpu();
 	/*
 	 * We keep two groups of stats; one with no
 	 * IO pending, one without.
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu())
+	if (nr_iowait_cpu(cpu))
 		bucket = BUCKETS/2;
 
+	put_cpu();
+
 	if (duration < 10)
 		return bucket;
 	if (duration < 100)
@@ -169,13 +172,16 @@ static inline int which_bucket(unsigned 
 static inline int performance_multiplier(void)
 {
 	int mult = 1;
+	int cpu = get_cpu();
 
 	/* for higher loadavg, we are more reluctant */
 
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(cpu);
+
+	put_cpu();
 
 	return mult;
 }
diff -puN include/linux/sched.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu include/linux/sched.h
--- a/include/linux/sched.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff -puN kernel/sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu kernel/sched.c
--- a/kernel/sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/kernel/sched.c
@@ -2864,9 +2864,9 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_iowait_cpu(void)
+unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = this_rq();
+	struct rq *this = cpu_rq(cpu);
 	return atomic_read(&this->nr_iowait);
 }
 
diff -puN kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/kernel/time/tick-sched.c
@@ -159,10 +159,12 @@ update_ts_time_stats(struct tick_sched *
 	ktime_t delta;
 
 	if (ts->idle_active) {
+		int cpu = get_cpu();
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		put_cpu();
 		ts->idle_entrytime = now;
 	}
 
_

