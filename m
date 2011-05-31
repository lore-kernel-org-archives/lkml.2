Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1EaMc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:32:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:41661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab1EaMc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:32:26 -0400
Date: Tue, 31 May 2011 12:31:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-pwwxl7gdqs5676f1d4cx6pj7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix schedstat.nr_wakeups_migrate
Git-Commit-ID: f339b9dc1f03591761d5d930800db24bc0eda1e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 May 2011 12:31:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f339b9dc1f03591761d5d930800db24bc0eda1e1
Gitweb:     http://git.kernel.org/tip/f339b9dc1f03591761d5d930800db24bc0eda1e1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 31 May 2011 10:49:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 May 2011 14:19:57 +0200

sched: Fix schedstat.nr_wakeups_migrate

While looking over the code I found that with the ttwu rework the
nr_wakeups_migrate test broke since we now switch cpus prior to
calling ttwu_stat(), hence the test is always true.

Cure this by passing the migration state in wake_flags. Also move the
whole test under CONFIG_SMP, its hard to migrate tasks on UP :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-pwwxl7gdqs5676f1d4cx6pj7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8da84b7..483c1ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1063,6 +1063,7 @@ struct sched_domain;
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_MIGRATED	0x04		/* internal use, task got migrated */
 
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_HEAD		2
diff --git a/kernel/sched.c b/kernel/sched.c
index 49cc70b..2fe98ed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2447,6 +2447,10 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 		}
 		rcu_read_unlock();
 	}
+
+	if (wake_flags & WF_MIGRATED)
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+
 #endif /* CONFIG_SMP */
 
 	schedstat_inc(rq, ttwu_count);
@@ -2455,9 +2459,6 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 
-	if (cpu != task_cpu(p))
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-
 #endif /* CONFIG_SCHEDSTATS */
 }
 
@@ -2675,8 +2676,10 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (task_cpu(p) != cpu)
+	if (task_cpu(p) != cpu) {
+		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);
+	}
 #endif /* CONFIG_SMP */
 
 	ttwu_queue(p, cpu);
