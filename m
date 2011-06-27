Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1F0XQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:16:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:60262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1F0XQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:16:31 -0400
Date: Mon, 27 Jun 2011 23:16:06 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-fd7355ba1e936487f5aae6fc058c6cb300e44a64@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tj@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <20110623182056.897818337@sbsiddha-MOBL3.sc.intel.com>
References: <20110623182056.897818337@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] stop_machine: reorganize stop_cpus() implementation
Git-Commit-ID: fd7355ba1e936487f5aae6fc058c6cb300e44a64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 27 Jun 2011 23:16:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd7355ba1e936487f5aae6fc058c6cb300e44a64
Gitweb:     http://git.kernel.org/tip/fd7355ba1e936487f5aae6fc058c6cb300e44a64
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 23 Jun 2011 11:19:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 27 Jun 2011 15:17:07 -0700

stop_machine: reorganize stop_cpus() implementation

Refactor the queuing part of the stop cpus work from __stop_cpus() into
queue_stop_cpus_work().

The reorganization is to help future improvements to stop_machine()
and doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110623182056.897818337@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/stop_machine.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 0cae1cc..4c89ee9 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,10 +136,11 @@ DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
-int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+static void queue_stop_cpus_work(const struct cpumask *cpumask,
+				 cpu_stop_fn_t fn, void *arg,
+				 struct cpu_stop_done *done)
 {
 	struct cpu_stop_work *work;
-	struct cpu_stop_done done;
 	unsigned int cpu;
 
 	/* initialize works and done */
@@ -147,9 +148,8 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 		work = &per_cpu(stop_cpus_work, cpu);
 		work->fn = fn;
 		work->arg = arg;
-		work->done = &done;
+		work->done = done;
 	}
-	cpu_stop_init_done(&done, cpumask_weight(cpumask));
 
 	/*
 	 * Disable preemption while queueing to avoid getting
@@ -161,7 +161,15 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
+}
 
+static int __stop_cpus(const struct cpumask *cpumask,
+		       cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+	queue_stop_cpus_work(cpumask, fn, arg, &done);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
