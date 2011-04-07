Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1DGRiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:38:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1DGRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:38:12 -0400
Date: Thu, 7 Apr 2011 19:38:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20110407173801.GA24944@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: Clean up rebalance_domains() load-balance interval calculation


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
 
