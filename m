Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0FNPOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:14:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0FNPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RvQCrLTuy3KIgg9+MR0JZ5ls1xRUi4AGxqTk/nbKDv7YXeGeUHaytEFykUzwJOq7io
         c9WtU4eGuiT97f03/AewvE/oU9PskzbR6HgATfifW0ZcVPxUUxEsFZx9+U/CgD7W+vgw
         CNI8ew54k8Z011ODFYJiB3gaR3Z4bNMhVNb+Y=
Date: Mon, 14 Jun 2010 18:17:35 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100614151735.GB3448@swordfish.minsk.epam.com>
References: <20100613203352.GA3577@swordfish>
 <1276461183.2659.4.camel@maxim-laptop>
 <201006140136.18652.rjw@sisk.pl>
 <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614080154.7d6a71fc@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/14/10 08:01), Arjan van de Ven wrote:
> > decided to patch nr_iowait_cpu instead.
> 
> the bug is that it needs to be
> 
> nr_iowait_cpu(int cpu)
> 

Something similar to this?

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
 

