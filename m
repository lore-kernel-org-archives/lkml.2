Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2AXB1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:27:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49803 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2AXB0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:26:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 10:25:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] proc:  speedup /proc/stat handling
Message-Id: <20120124102509.6f552a23.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F1D3792.4090800@parallels.com>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20120123191643.21ffba0c.kamezawa.hiroyu@jp.fujitsu.com>
	<4F1D3792.4090800@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 14:33:54 +0400
Glauber Costa <glommer@parallels.com> wrote:

> On 01/23/2012 02:16 PM, KAMEZAWA Hiroyuki wrote:
> > On Fri, 20 Jan 2012 16:59:24 +0100
> > Eric Dumazet<eric.dumazet@gmail.com>  wrote:
 >>
> >> An alternative to 1) would be to remember the largest m->count reached
> >> in show_stat()
> >>
> >
> > nice catch. But how about using usual seq_file rather than single_open() ?
> > I just don't like multi-page buffer for this small file...very much.
> >
> > A rough patch here, maybe optimization will not be enough. (IOW, this may be slow.)
> >
> 
> I myself don't like it very much, at least at first sight.
> Even with optimizations applied, I doubt we can make this approach 
> faster than what we currently do for /proc/stat.
> 
IIUC, most of cost comes from printing " 0".

> Also, the code gets a lot harder to read and grasp. Problem is, unlike 
> most of the stuff using seq_file, /proc/stat shows a lot of different 
> kinds of information, not a single kind of easily indexable information.
> 

I think current one is too simple. But yes, may not be worth to to use usual
seq_file sequence.

I did some optimization around number(). Because my environ is small.
size of /proc/stat is 2780.
[kamezawa@bluextal test]$ wc -c /proc/stat
2780 /proc/stat

Test program is this.
== test program (read 1000 tiems.)==

#!/usr/bin/python

num = 0

with open("/proc/stat") as f:
        while num < 1000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1


== Before patch (3.3-rc1) ==
[kamezawa@bluextal test]$ time ./stat_check.py

real    0m0.142s
user    0m0.022s
sys     0m0.117s

== After patch ==
[root@bluextal test]# time ./stat_check.py

real    0m0.096s
user    0m0.024s
sys     0m0.069s


==
In above, most of improvements comes from replacing seq_printf() with seq_puts().

If the number of cpu increases, the most costly one will be kstat_irqs().

perf record after patch:
    19.03%  stat_check.py  [kernel.kallsyms]    [k] memcpy
     7.83%  stat_check.py  [kernel.kallsyms]    [k] seq_puts
     6.83%  stat_check.py  [kernel.kallsyms]    [k] kstat_irqs
     5.75%  stat_check.py  [kernel.kallsyms]    [k] radix_tree_lookup
     5.24%  stat_check.py  libpython2.6.so.1.0  [.] 0x8ccb0
     4.35%  stat_check.py  [kernel.kallsyms]    [k] vsnprintf
     3.68%  stat_check.py  [kernel.kallsyms]    [k] sub_preempt_count
     3.45%  stat_check.py  [kernel.kallsyms]    [k] number

If we can find kstat_irqs()==0 without walking all possible cpus, we can
cut most of costs...

Anyway, this is my final version. I'll go to my usual work ;)

==
>From dae43400c9fc7328163eeee7770dc8d7c714ea8b Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 23 Jan 2012 19:18:31 +0900
Subject: [PATCH] proc: use usual seq_file ops for /proc/stat rather than single_open.

Now, /proc/stat uses single_open() for showing information. This means
the all data will be gathered and buffered once to a (big) buf.

Now, /proc/stat shows stats per cpu and stats per IRQs. To get information
in once-shot, it allocates a big buffer (until KMALLOC_MAX_SIZE).

Eric Dumazet reported that the bufsize calculation doesn't take
the numner of IRQ into account and the information cannot be
got in one-shot. (By this, seq_read() will allocate buffer again
and read the whole data gain...)

This patch changes /proc/stat to use seq_open() rather than single_open()
and provides  ->start(), ->next(), ->stop(), ->show().

By this, /proc/stat will not need to take care of size of buffer.

BTW, most time consuming routine in /proc/stat is number() and
vsprintf() to show tons of "0" in /proc/stat. Handling this by
seq_puts() improves performance much.

Changelog:
 - reduced loop of ->next(), ->show()
 - call seq_puts(" 0") when seq_printf(" %u%") && value == 0.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c |  293 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 222 insertions(+), 71 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..b32354c 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -49,22 +49,114 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
-static int show_stat(struct seq_file *p, void *v)
+enum proc_stat_stage /*the numbers are used as *pos and iter->stage */
+{
+	SHOW_TOTAL_CPU_STAT,
+	SHOW_PERCPU_STAT,
+	SHOW_TOTAL_IRQS,
+	SHOW_IRQ_DETAILS, 
+	SHOW_TIMES,
+	SHOW_TOTAL_SOFTIRQ,
+	SHOW_SOFTIRQ_DETAILS,
+	SHOW_EOL,
+	END_STATS,
+};
+
+/*
+ * for reduce the number of calling ->next(), ->show() IRQ numbers are
+ * handled in batch.
+ */
+struct seq_stat_iter {
+	int stage;
+	unsigned long jiffies;
+	int cpu_iter;
+	int irq_iter;
+	int softirq_iter;
+	/* cached information */
+	u64 irq_sum;
+	u64 softirq_sum;
+	u32 per_softirq_sums[NR_SOFTIRQS];
+};
+
+void *proc_stat_start(struct seq_file *p, loff_t *pos)
+{
+	struct seq_stat_iter *iter = p->private;
+
+	/* At lseek(), *pos==0 is passed.(see travers() in seq_file.c */
+	if (!*pos) {
+		struct timespec boottime;
+
+		iter->stage = SHOW_TOTAL_CPU_STAT;
+		iter->cpu_iter = 0;
+		iter->irq_iter = 0;
+		iter->softirq_iter = 0;
+		getboottime(&boottime);
+		iter->jiffies = boottime.tv_sec;
+	}
+	if (iter->stage == END_STATS)
+		return NULL;
+	return iter;
+}
+
+void proc_stat_stop(struct seq_file *p, void *v)
+{
+	return;
+}
+
+/*
+ * Unlike other seq_files, we update private itertor and it can be updated
+ * by ->show().
+ */
+void *proc_stat_next(struct seq_file *p, void *v, loff_t *pos)
+{
+	struct seq_stat_iter *iter = p->private;
+
+	switch (iter->stage) {
+	case SHOW_TOTAL_CPU_STAT:
+		iter->stage = SHOW_PERCPU_STAT;
+		iter->cpu_iter = cpumask_first(cpu_online_mask);
+		break;
+	case SHOW_PERCPU_STAT: /* cpu_iter is updated in ->show() */
+		if (iter->cpu_iter >= nr_cpu_ids)
+			iter->stage = SHOW_TOTAL_IRQS;
+		break;
+	case SHOW_TOTAL_IRQS:
+		iter->stage = SHOW_IRQ_DETAILS;
+		iter->irq_iter = 0;
+		break;
+	case SHOW_IRQ_DETAILS: /* irq_iter is updated in ->show() */
+		if (iter->irq_iter >= nr_irqs) /* see include/linux/irqnr.h */
+			iter->stage = SHOW_TIMES;
+		break;
+	case SHOW_TIMES:
+		iter->stage = SHOW_TOTAL_SOFTIRQ;
+		break;
+	case SHOW_TOTAL_SOFTIRQ:
+		iter->stage = SHOW_SOFTIRQ_DETAILS;
+		iter->softirq_iter = 0;
+		break;
+	case SHOW_SOFTIRQ_DETAILS: /*softirq_iter is updated in ->show() */
+		if (iter->softirq_iter >= NR_SOFTIRQS)
+			iter->stage = SHOW_EOL;
+		break;
+	case SHOW_EOL:
+		iter->stage = END_STATS;
+		return NULL;
+	default:
+		break;
+	}
+	return iter;
+}
+
+static int show_total_cpu_stat(struct seq_file *p, struct seq_stat_iter *iter)
 {
-	int i, j;
-	unsigned long jif;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 guest, guest_nice;
-	u64 sum = 0;
-	u64 sum_softirq = 0;
-	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
-	struct timespec boottime;
+	int i, j;
 
-	user = nice = system = idle = iowait =
-		irq = softirq = steal = 0;
+	user = nice = system = idle = iowait = 0;
+	irq = softirq = steal = 0;
 	guest = guest_nice = 0;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
@@ -77,19 +169,19 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		sum += kstat_cpu_irqs_sum(i);
-		sum += arch_irq_stat_cpu(i);
+		iter->irq_sum += kstat_cpu_irqs_sum(i);
+		iter->irq_sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
 
-			per_softirq_sums[j] += softirq_stat;
-			sum_softirq += softirq_stat;
+			iter->per_softirq_sums[j] += softirq_stat;
+			iter->softirq_sum += softirq_stat;
 		}
 	}
-	sum += arch_irq_stat();
+	iter->irq_sum += arch_irq_stat();
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+	return seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 		"%llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
@@ -101,22 +193,31 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(steal),
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
-	for_each_online_cpu(i) {
-		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
-		idle = get_idle_time(i);
-		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p,
+}
+
+static int show_online_cpu_stat(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	u64 user, nice, system, idle, iowait, irq, softirq, steal;
+	u64 guest, guest_nice;
+	int cpu = iter->cpu_iter;
+	int ret;
+
+	/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
+	while (cpu < nr_cpu_ids) {
+		user = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+		nice = kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+		system = kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+		idle = get_idle_time(cpu);
+		iowait = get_iowait_time(cpu);
+		irq = kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+		softirq = kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+		steal = kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+		guest = kcpustat_cpu(cpu).cpustat[CPUTIME_GUEST];
+		guest_nice = kcpustat_cpu(cpu).cpustat[CPUTIME_GUEST_NICE];
+		ret = seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
-			i,
+			cpu,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
 			(unsigned long long)cputime64_to_clock_t(system),
@@ -127,55 +228,105 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(steal),
 			(unsigned long long)cputime64_to_clock_t(guest),
 			(unsigned long long)cputime64_to_clock_t(guest_nice));
+		if (ret)
+			return ret;
+		cpu = cpumask_next(iter->cpu_iter, cpu_online_mask);
+		iter->cpu_iter = cpu;
 	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
-
-	seq_printf(p,
-		"\nctxt %llu\n"
-		"btime %lu\n"
-		"processes %lu\n"
-		"procs_running %lu\n"
-		"procs_blocked %lu\n",
-		nr_context_switches(),
-		(unsigned long)jif,
-		total_forks,
-		nr_running(),
-		nr_iowait());
-
-	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
-
-	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_printf(p, " %u", per_softirq_sums[i]);
-	seq_putc(p, '\n');
+	return 0;
+		
+}
+
+static int show_irq_details(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	int ret;
+	/*
+	 * we update iterater in ->show()...seems Ugly but for avoiding 
+	 * tons of function calls, print out here as much as possible
+	 */
+	do {
+		unsigned int irqs = kstat_irqs(iter->irq_iter);
+
+		if (irqs)
+			ret = seq_printf(p, " %u", kstat_irqs(irqs));
+		else
+			ret = seq_puts(p, " 0");
+		if (!ret)
+			iter->irq_iter += 1;
+	} while (!ret && iter->irq_iter < nr_irqs);
+
+	return 0;
+}
+
+static int show_softirq_details(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	int ret;
+
+	do {
+		int softirqs = iter->per_softirq_sums[iter->softirq_iter];
+
+		if (softirqs)
+			ret = seq_printf(p, " %u", softirqs);
+		else
+			ret = seq_puts(p, " 0");
+		if (!ret)
+			iter->softirq_iter += 1;
+	} while (!ret && iter->irq_iter < NR_SOFTIRQS);
+	return 0;
+}
+
+static int proc_stat_show(struct seq_file *p, void *v)
+{
+	struct seq_stat_iter *iter = v;
 
+	switch (iter->stage) {
+	case SHOW_TOTAL_CPU_STAT:
+		return show_total_cpu_stat(p, iter);
+	case SHOW_PERCPU_STAT:
+		return show_online_cpu_stat(p, iter);
+	case SHOW_TOTAL_IRQS:
+		return seq_printf(p, "intr %llu", 
+				(unsigned long long)iter->irq_sum);
+	case SHOW_IRQ_DETAILS:
+		return show_irq_details(p, iter);
+	case SHOW_TIMES:
+		return seq_printf(p,
+				"\nctxt %llu\n"
+				"btime %lu\n"
+				"processes %lu\n"
+				"procs_running %lu\n"
+				"procs_blocked %lu\n",
+				nr_context_switches(),
+				(unsigned long)iter->jiffies,
+				total_forks,
+				nr_running(),
+				nr_iowait());
+	case SHOW_TOTAL_SOFTIRQ:
+		return seq_printf(p, "softirq %llu",
+			(unsigned long long)iter->softirq_sum);
+	case SHOW_SOFTIRQ_DETAILS:
+		return show_softirq_details(p, iter);
+	case SHOW_EOL:
+		return seq_putc(p, '\n');
+	}
 	return 0;
 }
 
+static const struct seq_operations show_stat_op = {
+        .start  = proc_stat_start,
+        .next   = proc_stat_next,
+        .stop   = proc_stat_stop,
+        .show   = proc_stat_show
+};
+
 static int stat_open(struct inode *inode, struct file *file)
 {
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
-	char *buf;
-	struct seq_file *m;
 	int res;
 
 	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
+	res = seq_open_private(file, &show_stat_op,
+		sizeof(struct seq_stat_iter));
+
 	return res;
 }
 
@@ -183,7 +334,7 @@ static const struct file_operations proc_stat_operations = {
 	.open		= stat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release_private,
 };
 
 static int __init proc_stat_init(void)
-- 
1.7.4.1




