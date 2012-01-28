Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2A1MIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:08:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2A1MIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:08:50 -0500
Date: Sat, 28 Jan 2012 04:08:29 -0800
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Message-ID: <tip-30fd049afcfed50e022704036e8629d6bdfe84e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1327422836.27181.5.camel@localhost.localdomain>
References: <1327422836.27181.5.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove sched_switch
Git-Commit-ID: 30fd049afcfed50e022704036e8629d6bdfe84e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:08:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30fd049afcfed50e022704036e8629d6bdfe84e6
Gitweb:     http://git.kernel.org/tip/30fd049afcfed50e022704036e8629d6bdfe84e6
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Tue, 24 Jan 2012 22:33:56 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 13:28:53 +0100

sched: Remove sched_switch

Currently we don't utilize the sched_switch field anymore.

But, simply removing sched_switch field from the middle of the
sched_stat output will break tools.

So, to stay compatible we hardcode it to zero and remove the
field from the scheduler data structures.

Update the schedstat documentation accordingly.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327422836.27181.5.camel@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/scheduler/sched-stats.txt |    3 ++-
 kernel/sched/debug.c                    |    1 -
 kernel/sched/sched.h                    |    1 -
 kernel/sched/stats.c                    |    4 ++--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..8259b34 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) This field is a legacy array expiration count field used in the O(1)
+	scheduler. We kept it for ABI compatibility, but it is always set to zero.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2a075e1..09acaa1 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -288,7 +288,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 	P(yld_count);
 
-	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..8a2c768 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -462,7 +462,6 @@ struct rq {
 	unsigned int yld_count;
 
 	/* schedule() stats */
-	unsigned int sched_switch;
 	unsigned int sched_count;
 	unsigned int sched_goidle;
 
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..903ffa9e 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -32,9 +32,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
