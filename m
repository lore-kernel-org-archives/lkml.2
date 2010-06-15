Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0FOGP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:15:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46238 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0FOGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eosOmyPJv2W415QxHp6vhj/lAyYFm45dlYLKKodoWwN3pPa9JYP1dORywbpTHFDTiP
         +Q3aaXDzRQ6UkJ3FqtgiG2IE8HXSQuZqcMc+JlqhzB/RVlplIE36AjSiTAzJXHN+Fv7H
         owRJM4Af5QQhfch3xcqAhEtBT0rWJPD3s6UnQ=
Date: Tue, 15 Jun 2010 09:19:27 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615061927.GA3312@swordfish>
References: <20100613203352.GA3577@swordfish>
 <1276461183.2659.4.camel@maxim-laptop>
 <201006140136.18652.rjw@sisk.pl>
 <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614204021.52c50cdc@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 
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

Initially fix was to use get_cpu/put_cpu in nr_iowait_cpu. However, 
Arjan van de Ven stated that "the bug is that it needs to be nr_iowait_cpu(int cpu)".

This patch introduces nr_iowait_cpu(int cpu) and changes to it callers.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 52ff8aa..4871ed5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -137,14 +137,17 @@ static inline int which_bucket(unsigned int duration)
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
+	
+	put_cpu();
 
 	if (duration < 10)
 		return bucket;
@@ -169,14 +172,17 @@ static inline int which_bucket(unsigned int duration)
 static inline int performance_multiplier(void)
 {
 	int mult = 1;
-
+	int cpu = get_cpu();
+	
 	/* for higher loadavg, we are more reluctant */
 
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(cpu);
 
+	put_cpu();
+	
 	return mult;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..747fcae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..f61b48e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..101e8aa 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -159,10 +159,12 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
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
 
