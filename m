Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1ARTGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:06:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:53075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab1ARTGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:06:19 -0500
Date: Tue, 18 Jan 2011 19:05:50 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, yong.zhang0@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
References: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Replace rq->bkl_count with rq->rq_sched_info.bkl_count
Message-ID: <tip-fce2097983d914ea8c2338efc6f6e9bb737f6ae4@git.kernel.org>
Git-Commit-ID: fce2097983d914ea8c2338efc6f6e9bb737f6ae4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:05:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fce2097983d914ea8c2338efc6f6e9bb737f6ae4
Gitweb:     http://git.kernel.org/tip/fce2097983d914ea8c2338efc6f6e9bb737f6ae4
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 14 Jan 2011 15:57:39 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:43 +0100

sched: Replace rq->bkl_count with rq->rq_sched_info.bkl_count

Now rq->rq_sched_info.bkl_count is not used for rq, scroll
rq->bkl_count into it. Thus we can save some space for rq.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c       |    5 +----
 kernel/sched_debug.c |    4 +++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6cbff6b..0a169a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -553,9 +553,6 @@ struct rq {
 	/* try_to_wake_up() stats */
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
-
-	/* BKL stats */
-	unsigned int bkl_count;
 #endif
 };
 
@@ -3887,7 +3884,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 #ifdef CONFIG_SCHEDSTATS
 	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), bkl_count);
+		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
 		schedstat_inc(prev, sched_info.bkl_count);
 	}
 #endif
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index e4d3725..eb6cb8e 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -296,9 +296,11 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	P(bkl_count);
+	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
+				rq->rq_sched_info.bkl_count);
 
 #undef P
+#undef P64
 #endif
 	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
