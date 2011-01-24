Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1AXSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:09:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1AXSIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:09 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 15/16] KVM-GST: KVM Steal time accounting
Date: Mon, 24 Jan 2011 13:06:36 -0500
Message-Id: <1295892397-11354-16-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch accounts steal time time in kernel/sched.
I kept it from last proposal, because I still see advantages
in it: Doing it here will give us easier access from scheduler
variables such as the cpu rq. The next patch shows an example of
usage for it.

Since functions like account_idle_time() can be called from
multiple places, not only account_process_tick(), steal time
grabbing is repeated in each account function separatedely.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 kernel/sched.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ea3e5ef..3b3e88d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3508,6 +3508,38 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
+cputime_t (*hypervisor_steal_time)(void) = NULL;
+
+/*
+ * We have to at flush steal time information every time something else
+ * is accounted. Since the accounting functions are all visible to the rest
+ * of the kernel, it gets tricky to do them in one place. This helper function
+ * helps us.
+ *
+ * When the system is idle, the concept of steal time does not apply. We just
+ * tell the underlying hypervisor that we grabbed the data, but skip steal time
+ * accounting
+ */
+static int touch_steal_time(int is_idle)
+{
+	u64 steal;
+	struct rq *rq = this_rq();
+
+	if (!hypervisor_steal_time)
+		return 0;
+
+	steal = hypervisor_steal_time();
+
+	if (is_idle)
+		return 0;
+
+	if (steal) {
+		account_steal_time(steal);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3520,6 +3552,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
 
+	if (touch_steal_time(0))
+		return;
+
 	/* Add user time to process. */
 	p->utime = cputime_add(p->utime, cputime);
 	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
@@ -3580,6 +3615,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
 
+	if (touch_steal_time(0))
+		return;
+
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
@@ -3627,6 +3665,8 @@ void account_idle_time(cputime_t cputime)
 	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
+	touch_steal_time(1);
+
 	if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
 	else
-- 
1.7.2.3

