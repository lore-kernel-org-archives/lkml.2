Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1HNQGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:52074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab1HNQFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:55 -0400
Date: Sun, 14 Aug 2011 16:05:38 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-c37495fd0f64fc139b5a07d242bcb485174d1206@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110617015919.832743148@goodmis.org>
References: <20110617015919.832743148@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Balance RT tasks when forked as well
Git-Commit-ID: c37495fd0f64fc139b5a07d242bcb485174d1206
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:05:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c37495fd0f64fc139b5a07d242bcb485174d1206
Gitweb:     http://git.kernel.org/tip/c37495fd0f64fc139b5a07d242bcb485174d1206
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 16 Jun 2011 21:55:22 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:52 +0200

sched: Balance RT tasks when forked as well

When a new task is woken, the code to balance the RT task is currently
skipped in the select_task_rq() call. But it will be pushed if the rq
is currently overloaded with RT tasks anyway. The issue is that we
already queued the task, and if it does get pushed, it will have to
be dequeued and requeued on the new run queue. The advantage with
pushing it first is that we avoid this requeuing as we are pushing it
off before the task is ever queued.

See commit 318e0893ce3f524 ("sched: pre-route RT tasks on wakeup")
for more details.

The return of select_task_rq() when it is not a wake up has also been
changed to return task_cpu() instead of smp_processor_id(). This is more
of a sanity because the current only other user of select_task_rq()
besides wake ups, is an exec, where task_cpu() should also be the same
as smp_processor_id(). But if it is used for other purposes, lets keep
the task on the same CPU. Why would we mant to migrate it to the current
CPU?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hillf Danton <dhillf@gmail.com>
Link: http://lkml.kernel.org/r/20110617015919.832743148@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 70107a3..2153a87 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1017,10 +1017,12 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	struct rq *rq;
 	int cpu;
 
-	if (sd_flag != SD_BALANCE_WAKE)
-		return smp_processor_id();
-
 	cpu = task_cpu(p);
+
+	/* For anything but wake ups, just return the task_cpu */
+	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+		goto out;
+
 	rq = cpu_rq(cpu);
 
 	rcu_read_lock();
@@ -1059,6 +1061,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	}
 	rcu_read_unlock();
 
+out:
 	return cpu;
 }
 
