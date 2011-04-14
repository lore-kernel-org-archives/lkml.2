Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1DNIi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:38:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:49794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab1DNIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:38:53 -0400
Date: Thu, 14 Apr 2011 08:38:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-b84cb5df1f9ad6da3f214c638d5fb08d0c99de1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.394638826@chello.nl>
References: <20110405152729.394638826@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Remove rq argument from ttwu_stat()
Git-Commit-ID: b84cb5df1f9ad6da3f214c638d5fb08d0c99de1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b84cb5df1f9ad6da3f214c638d5fb08d0c99de1f
Gitweb:     http://git.kernel.org/tip/b84cb5df1f9ad6da3f214c638d5fb08d0c99de1f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:40 +0200

sched: Remove rq argument from ttwu_stat()

In order to call ttwu_stat() without holding rq->lock we must remove
its rq argument. Since we need to change rq stats, account to the
local rq instead of the task rq, this is safe since we have IRQs
disabled.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.394638826@chello.nl
---
 kernel/sched.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 871dd9e..5ec2e8b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2410,9 +2410,11 @@ static void update_avg(u64 *avg, u64 sample)
 #endif
 
 static void
-ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
+ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
 #ifdef CONFIG_SCHEDSTATS
+	struct rq *rq = this_rq();
+
 #ifdef CONFIG_SMP
 	int this_cpu = smp_processor_id();
 
@@ -2561,9 +2563,10 @@ out_activate:
 	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
-	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 	__task_rq_unlock(rq);
+
+	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
@@ -2600,7 +2603,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
-	ttwu_stat(rq, p, smp_processor_id(), 0);
+	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
 }
