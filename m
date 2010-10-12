Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0JLK0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:26:30 -0400
Received: from home.kolivas.org ([59.167.196.135]:41063 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab0JLK03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:26:29 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 06:26:28 EDT
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
Date: Tue, 12 Oct 2010 21:26:15 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-ck1; KDE/4.4.5; x86_64; ; )
Cc: William Pitcock <nenolod@dereferenced.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de
References: <20101012093044.GD20366@elte.hu> <201010122057.37272.kernel@kolivas.org> <20101012101645.GA32486@elte.hu>
In-Reply-To: <20101012101645.GA32486@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010122126.15722.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 21:16:45 Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:> > It's a fun feature I've been playing with that was going to make it into
> > the next -ck, albeit disabled by default. Here's what the patch
> > changelog was
> 
> > going to say:
> Find below the reply Peter sent to William's v5 patch. I suspect there
> will be a v6 to address those problems :)
> 
> (William: please Cc: Con too to future updates of your patch.)
> 
> Thanks,

In case it helps, here's the full patch as it would be for BFS357.
It's a simple deadline *= fork_depth (more comments than code.)

---

Make it possible to have interactivity and responsiveness at very high load
levels by having a hierarchical tree based penalty. This is achieved by
making deadlines offset by the fork depth from init. This has a similar effect
to 'nice'ing loads that are fork heavy (such as 'make'), and biases CPU and
latency towards threaded desktop applications.

When a new process is forked, its fork depth is inherited from its parent
across fork() and then is incremented by one. That fork_depth is then used
to cause a relative offset of its deadline. Threads keep the same fork_depth
as their parent process as these tend to belong to threaded desktop apps.

Using a dual core machine as an example, and running the "browser benchmark"
at http://service.futuremark.com/peacekeeper/index.action shows the effect
this patch has.

The benchmark runs a number of different browser based workloads, and gives
a score in points, where higher is better.

Running the benchmark under various different loads with the feature enabled/
disabled:

Load            Disabled        Enabled
None            2437            2437
make -j2        1642            2293
make -j24       208             2187
make -j42       failed          1626

As can be seen, on the dual core machine, a load of 2 makes the benchmark run
almost precisely 1/3 slower as would be expected with BFS' fair CPU
distribution of 3 processes between 2 CPUs. Enabling this feature makes this
benchmark progress almost unaffected at this load, and only once the load is
more than 20 times higher does it hinder the benchmark to the same degree.

Other side effects of this patch are that it weakly partitions CPU entitlement
to different users, and provides some protection against fork bombs.

Note that this drastically affects CPU distribution,  No assumption as to CPU
distribution should be made based on past behaviour. It can be difficult to
apportion a lot of CPU to a fork heavy workload with this enabled, and the
effects of 'nice' are compounded.

Unlike other approaches to improving latency under load of smaller timeslices,
enabling this feature has no detrimental effect on throughput under load.

This feature is disabled in this patch by default as it may lead to unexpected
changes in CPU distribution and there may be real world regressions.

There is a sysctl to enable/disable this feature in
/proc/sys/kernel/fork_depth_penalty

---
 Documentation/sysctl/kernel.txt |   16 ++++++++++++++++
 include/linux/sched.h           |    2 ++
 kernel/sched_bfs.c              |   37 +++++++++++++++++++++++++++++++++----
 kernel/sysctl.c                 |   10 ++++++++++
 4 files changed, 61 insertions(+), 4 deletions(-)

Index: linux-2.6.36-rc7-ck2/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.36-rc7-ck2.orig/Documentation/sysctl/kernel.txt	2010-10-12 11:44:12.294066709 +1100
+++ linux-2.6.36-rc7-ck2/Documentation/sysctl/kernel.txt	2010-10-12 11:49:36.916804219 +1100
@@ -29,6 +29,7 @@ show up in /proc/sys/kernel:
 - ctrl-alt-del
 - dentry-state
 - domainname
+- fork_depth_penalty
 - hostname
 - hotplug
 - iso_cpu
@@ -235,6 +236,21 @@ see the hostname(1) man page.
 
 ==============================================================
 
+fork_depth_penalty: (BFS CPU scheduler only)
+
+Whether to penalise CPU according to fork depth. This ends up favouring CPU
+distribution and latency greatly towards threaded desktop applications over
+heavily forked workloads such as compilation, and has the added side-effect
+of weakly partitioning CPU by user. Enabling this changes normal concepts of
+fairness as it has the effect of 'nice'ing workloads such as compilation with
+make.
+
+0: Disabled.
+
+1: Enabled.
+
+==============================================================
+
 hotplug:
 
 Path for the hotplug policy agent.
Index: linux-2.6.36-rc7-ck2/include/linux/sched.h
===================================================================
--- linux-2.6.36-rc7-ck2.orig/include/linux/sched.h	2010-10-12 11:44:12.281066921 +1100
+++ linux-2.6.36-rc7-ck2/include/linux/sched.h	2010-10-12 11:46:46.541564134 +1100
@@ -1188,6 +1188,8 @@ struct task_struct {
 #ifdef CONFIG_SCHED_BFS
 	int time_slice;
 	u64 deadline;
+	/* Depth of forks from init */
+	int fork_depth;
 	struct list_head run_list;
 	u64 last_ran;
 	u64 sched_time; /* sched_clock time spent running */
Index: linux-2.6.36-rc7-ck2/kernel/sched_bfs.c
===================================================================
--- linux-2.6.36-rc7-ck2.orig/kernel/sched_bfs.c	2010-10-12 11:44:12.257067311 +1100
+++ linux-2.6.36-rc7-ck2/kernel/sched_bfs.c	2010-10-12 12:02:19.062552716 +1100
@@ -138,6 +138,10 @@ int rr_interval __read_mostly = 6;
  */
 int sched_iso_cpu __read_mostly = 70;
 
+
+/* fork_depth_penalty - Whether to penalise CPU according to fork depth. */
+int fork_depth_penalty __read_mostly;
+
 /*
  * The relative length of deadline for each priority(nice) level.
  */
@@ -1635,6 +1639,12 @@ void wake_up_new_task(struct task_struct
 	parent = p->parent;
 	/* Unnecessary but small chance that the parent changed CPU */
 	set_task_cpu(p, task_cpu(parent));
+	/*
+	 * fork_depth is inherited and incremented when we spawn a new
+	 * process and not a thread.
+	 */
+	if (!(clone_flags & CLONE_THREAD))
+		p->fork_depth++;
 	activate_task(p, rq);
 	trace_sched_wakeup_new(p, 1);
 	if (!(clone_flags & CLONE_VM) && rq->curr == parent &&
@@ -2526,7 +2536,21 @@ static inline u64 prio_deadline_diff(int
 
 static inline u64 task_deadline_diff(struct task_struct *p)
 {
-	return prio_deadline_diff(TASK_USER_PRIO(p));
+	u64 pdd = prio_deadline_diff(TASK_USER_PRIO(p));
+
+	if (fork_depth_penalty) {
+		/*
+		 * With fork_depth_penalty enabled, we offset deadline
+		 * according to how deeply the process has forked from init,
+		 * thus creating a hierarchical tree-based penalty. This has
+		 * the effect of distributing better latency and CPU more to
+		 * "foreground" type threaded desktop applications. It also
+		 * softly partitions CPU by user. Only init has a depth of 0.
+		 */
+		if (likely(p->fork_depth > 1))
+			pdd *= p->fork_depth;
+	}
+	return pdd;
 }
 
 static inline u64 static_deadline_diff(int static_prio)
@@ -3513,7 +3537,7 @@ SYSCALL_DEFINE1(nice, int, increment)
  *
  * This is the priority value as seen by users in /proc.
  * RT tasks are offset by -100. Normal tasks are centered around 1, value goes
- * from 0 (SCHED_ISO) up to 82 (nice +19 SCHED_IDLEPRIO).
+ * from 0 (SCHED_ISO) upwards (nice +19 SCHED_IDLEPRIO).
  */
 int task_prio(const struct task_struct *p)
 {
@@ -3525,8 +3549,13 @@ int task_prio(const struct task_struct *
 
 	/* Convert to ms to avoid overflows */
 	delta = NS_TO_MS(p->deadline - grq.niffies);
-	delta = delta * 40 / ms_longest_deadline_diff();
-	if (delta > 0 && delta <= 80)
+	/* Deadlines are approximately 10x larger with fork_depth_penalty */
+	if (fork_depth_penalty)
+		delta *= 4;
+	else
+		delta *= 40;
+	delta /= ms_longest_deadline_diff();
+	if (delta > 0)
 		prio += delta;
 	if (idleprio_task(p))
 		prio += 40;
Index: linux-2.6.36-rc7-ck2/kernel/sysctl.c
===================================================================
--- linux-2.6.36-rc7-ck2.orig/kernel/sysctl.c	2010-10-12 11:44:12.269067116 +1100
+++ linux-2.6.36-rc7-ck2/kernel/sysctl.c	2010-10-12 12:03:10.238592352 +1100
@@ -121,6 +121,7 @@ static int __maybe_unused one_hundred = 
 #ifdef CONFIG_SCHED_BFS
 extern int rr_interval;
 extern int sched_iso_cpu;
+extern int fork_depth_penalty;
 static int __read_mostly one_thousand = 1000;
 #endif
 #ifdef CONFIG_PRINTK
@@ -834,6 +835,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+	{
+		.procname	= "fork_depth_penalty",
+		.data		= &fork_depth_penalty,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
 	{

-- 
-ck
