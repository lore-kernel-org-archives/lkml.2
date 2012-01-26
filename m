Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2AZSGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:06:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2AZSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:06:11 -0500
Date: Thu, 26 Jan 2012 19:05:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20120126180554.GA5183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: b64b223aed5f8aeeb6c046f1b050a8f976b87de0 Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

 Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      rcu: Add missing __cpuinit annotation in rcutorture code

Paul E. McKenney (1):
      sched: Add "const" to is_idle_task() parameter

Rusty Russell (1):
      rcu: Make rcutorture bool parameters really bool (core code)

Tejun Heo (1):
      memblock: Fix alloc failure due to dumb underflow protection in memblock_find_in_range_node()


 include/linux/sched.h |    2 +-
 kernel/rcutorture.c   |    8 ++++----
 mm/memblock.c         |    7 +++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf0eb34..40d8448 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2089,7 +2089,7 @@ extern struct task_struct *idle_task(int cpu);
  * is_idle_task - is the specified task an idle task?
  * @tsk: the task in question.
  */
-static inline bool is_idle_task(struct task_struct *p)
+static inline bool is_idle_task(const struct task_struct *p)
 {
 	return p->pid == 0;
 }
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 88f17b8..a58ac28 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -56,8 +56,8 @@ static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
 static int stat_interval;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
-static int verbose;		/* Print more debug info. */
-static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
+static bool verbose;		/* Print more debug info. */
+static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
@@ -1399,7 +1399,7 @@ rcu_torture_shutdown(void *arg)
  * Execute random CPU-hotplug operations at the interval specified
  * by the onoff_interval.
  */
-static int
+static int __cpuinit
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
@@ -1447,7 +1447,7 @@ rcu_torture_onoff(void *arg)
 	return 0;
 }
 
-static int
+static int __cpuinit
 rcu_torture_onoff_init(void)
 {
 	if (onoff_interval <= 0)
diff --git a/mm/memblock.c b/mm/memblock.c
index 2f55f19..77b5f22 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -106,14 +106,17 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
 
-	/* adjust @start to avoid underflow and allocating the first page */
-	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
 
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
+		if (this_end < size)
+			continue;
+
 		cand = round_down(this_end - size, align);
 		if (cand >= this_start)
 			return cand;
