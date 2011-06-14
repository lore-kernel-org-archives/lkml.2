Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1FNRHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:07:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1FNRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=swMjxqDZJU5CbmGIob9EET+JZeIJrYWpFPbo6+yCWgtR50fYiywrNqS6hTQY+uSroC
         2blEF4SNBP1cUSyw8Lgxjx8Rp7uMrHktIvcSzBjq1H+mzW41jq2Bq/H0eG8qs3E9UWaO
         Xt+MgipalbC2bOGdsuzjpnHjt1Hyg+fOC1nwI=
From: Tejun Heo <tj@kernel.org>
To: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] stop_machine: reorganize stop_cpus() implementation
Date: Tue, 14 Jun 2011 19:06:57 +0200
Message-Id: <1308071218-5912-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1308071218-5912-1-git-send-email-tj@kernel.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split __stop_cpus() into stop_cpus_queue() and stop_cpus_locked().
The former handles only the queueing part.  The latter uses the queue
function and is functionally equivalent to __stop_cpus().

The reorganization is to help future improvements to stop_machine()
and doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/stop_machine.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 3d3f47d..198973f 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,10 +136,11 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
-int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+static void stop_cpus_queue(const struct cpumask *cpumask,
+			    cpu_stop_fn_t fn, void *arg,
+			    struct cpu_stop_done *done)
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
 
+static int stop_cpus_locked(const struct cpumask *cpumask,
+			    cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+	stop_cpus_queue(cpumask, fn, arg, &done);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -200,7 +208,7 @@ int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 
 	/* static works are used, process one request at a time */
 	mutex_lock(&stop_cpus_mutex);
-	ret = __stop_cpus(cpumask, fn, arg);
+	ret = stop_cpus_locked(cpumask, fn, arg);
 	mutex_unlock(&stop_cpus_mutex);
 	return ret;
 }
@@ -230,7 +238,7 @@ int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 	/* static works are used, process one request at a time */
 	if (!mutex_trylock(&stop_cpus_mutex))
 		return -EAGAIN;
-	ret = __stop_cpus(cpumask, fn, arg);
+	ret = stop_cpus_locked(cpumask, fn, arg);
 	mutex_unlock(&stop_cpus_mutex);
 	return ret;
 }
-- 
1.7.5.2

