Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1DEItk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:49:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1DEIth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:49:37 -0400
Date: Tue, 5 Apr 2011 08:48:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1301991265.2225.12.camel@twins>
References: <1301991265.2225.12.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Clean up rebalance_domains() load-balance interval calculation
Message-ID: <tip-49c022e657fbe661460d191fbe776a387132e2b3@git.kernel.org>
Git-Commit-ID: 49c022e657fbe661460d191fbe776a387132e2b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Apr 2011 08:49:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49c022e657fbe661460d191fbe776a387132e2b3
Gitweb:     http://git.kernel.org/tip/49c022e657fbe661460d191fbe776a387132e2b3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 10:14:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 Apr 2011 10:29:36 +0200

sched: Clean up rebalance_domains() load-balance interval calculation

Instead of the possible multiple-evaluation of num_online_cpus()
in rebalance_domains() that Linus reported, avoid it altogether
in the normal case since it's implemented with a Hamming weight
function over a cpu bitmask which can be darn expensive for those
with big iron.

This also makes it cleaner, smaller and documents the code.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1301991265.2225.12.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   16 ++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a884551..17b4d22 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6331,6 +6331,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif
 	}
+
+	update_max_interval();
+
 	return NOTIFY_OK;
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c7ec5c8..80ecd09 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3820,6 +3820,17 @@ void select_nohz_load_balancer(int stop_tick)
 
 static DEFINE_SPINLOCK(balancing);
 
+static unsigned long __read_mostly max_load_balance_interval = HZ/10;
+
+/*
+ * Scale the max load_balance interval with the number of CPUs in the system.
+ * This trades load-balance latency on larger machines for less cross talk.
+ */
+static void update_max_interval(void)
+{
+	max_load_balance_interval = HZ*num_online_cpus()/10;
+}
+
 /*
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
@@ -3849,10 +3860,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 		/* scale ms to jiffies */
 		interval = msecs_to_jiffies(interval);
-		if (unlikely(!interval))
-			interval = 1;
-		if (interval > HZ*num_online_cpus()/10)
-			interval = HZ*num_online_cpus()/10;
+		interval = clamp(interval, 1UL, max_load_balance_interval);
 
 		need_serialize = sd->flags & SD_SERIALIZE;
 
