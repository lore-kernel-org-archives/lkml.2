Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1GGSTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:19:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1GGSTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:19:15 -0400
Date: Thu, 7 Jul 2011 20:19:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110707181908.GA15171@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Mike Galbraith (1):
      sched, cgroups: Fix MIN_SHARES on 64-bit boxen

Peter Zijlstra (1):
      sched: Disable (revert) SCHED_LOAD_SCALE increase


 include/linux/sched.h |    2 +-
 kernel/sched.c        |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..496770a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -808,7 +808,7 @@ enum cpu_idle_type {
  * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
  * increased costs.
  */
-#if BITS_PER_LONG > 32
+#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
 # define SCHED_LOAD_RESOLUTION	10
 # define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
 # define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..9769c75 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -292,8 +292,8 @@ static DEFINE_SPINLOCK(task_group_lock);
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
-#define MIN_SHARES	2
-#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
+#define MIN_SHARES	(1UL <<  1)
+#define MAX_SHARES	(1UL << 18)
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -8450,10 +8450,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	if (!tg->se[0])
 		return -EINVAL;
 
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	else if (shares > MAX_SHARES)
-		shares = MAX_SHARES;
+	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
 
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
