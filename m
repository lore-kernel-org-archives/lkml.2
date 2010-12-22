Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0LVBJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:09:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55957 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0LVBJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eSPo4P2zh6C7GoqFoYjZrvaP2PxreS29yGVGo2ZjVIeID1FcfekPUpmZbffJ4ZCqXP
         BAmABg3o0w/1bBkAbZYQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/5] Free up pf flag PF_KSOFTIRQD -v2
Date: Tue, 21 Dec 2010 17:09:00 -0800
Message-Id: <1292980144-28796-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1292980144-28796-1-git-send-email-venki@google.com>
References: <1292980144-28796-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset:
This is Part 2 of
"Proper kernel irq time accounting -v4"
http://lkml.indiana.edu/hypermail//linux/kernel/1010.0/01175.html

and applies 2.6.37-rc7.

Part 1 solves the way irqs are accounted in scheduler and tasks. This
patchset solves how irq times are reported in /proc/stat and also not
to include irq time in task->stime, etc.

Example:
Running a cpu intensive loop and network intensive nc on a 4 CPU system
and looking at 'top' output.

With vanilla kernel:
Cpu0  :  0.0% us,  0.3% sy,  0.0% ni, 99.3% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  1.3% us, 27.2% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 71.4% si
Cpu3  :  1.6% us,  1.3% sy,  0.0% ni, 96.7% id,  0.0% wa,  0.0% hi,  0.3% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7555 root      20   0  1760  528  436 R  100  0.0   0:15.79 nc
 7563 root      20   0  3632  268  204 R  100  0.0   0:13.13 loop

Notes:
* Both tasks show 100% CPU, even when one of them is stuck on a CPU thats
  processing 70% softirq.
* no hardirq time.


With "Part 1" patches:
Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  2.0% us, 30.6% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 67.4% si
Cpu3  :  0.7% us,  0.7% sy,  0.3% ni, 98.3% id,  0.0% wa,  0.0% hi,  0.0% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6289 root      20   0  3632  268  204 R  100  0.0   2:18.67 loop
 5737 root      20   0  1760  528  436 R   33  0.0   0:26.72 nc

Notes:
* Tasks show 100% CPU and 33% CPU that correspond to their non-irq exec time.
* no hardirq time.


With "Part 1 + Part 2" patches:
Cpu0  :  1.3% us,  1.0% sy,  0.3% ni, 97.0% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 99.3% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.7% hi,  0.0% si
Cpu2  :  1.3% us, 31.5% sy,  0.0% ni,  0.0% id,  0.0% wa,  8.3% hi, 58.9% si
Cpu3  :  1.0% us,  2.0% sy,  0.3% ni, 95.0% id,  0.0% wa,  0.7% hi,  1.0% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
20929 root      20   0  3632  268  204 R   99  0.0   3:48.25 loop
20796 root      20   0  1760  528  436 R   33  0.0   2:38.65 nc

Notes:
* Both task exec time and hard irq time reported correctly.
* hi and si time are based on fine granularity info and not on samples.
* getrusage would give proper utime/stime split not including irq times
  in that ratio.
* Other places that report user/sys time like, cgroup cpuacct.stat will
  now include only non-irq exectime.

This patch:

Cleanup patch, freeing up PF_KSOFTIRQD and use per_cpu ksoftirqd pointer
instead, as suggested by Eric Dumazet.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/interrupt.h |    7 +++++++
 include/linux/sched.h     |    1 -
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..3802fac 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -426,6 +426,13 @@ extern void raise_softirq(unsigned int nr);
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
+DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+
+static inline struct task_struct *this_cpu_ksoftirqd(void)
+{
+	return this_cpu_read(ksoftirqd);
+}
+
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
  */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2238745..86924ff 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1699,7 +1699,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
diff --git a/kernel/sched.c b/kernel/sched.c
index 297d1a0..bfc9646 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2011,7 +2011,7 @@ void account_system_vtime(struct task_struct *curr)
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 18f4be0..b904be8 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -721,7 +721,6 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
-- 
1.7.3.1

