Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0KZNle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:41:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab0KZNld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:41:33 -0500
Date: Fri, 26 Nov 2010 14:40:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20101126134049.GA20840@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Sergey Senozhatsky (1):
      posix-cpu-timers: Rcu_read_lock/unlock protect find_task_by_vpid call


 kernel/posix-cpu-timers.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..05bb717 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
 	if (pid == 0)
 		return 0;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : thread_group_leader(p))) {
+		   same_thread_group(p, current) : has_group_leader_pid(p))) {
 		error = -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return error;
 }
@@ -390,7 +390,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
 		if (pid == 0) {
 			p = current;
@@ -404,7 +404,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p = current->group_leader;
 		} else {
 			p = find_task_by_vpid(pid);
-			if (p && !thread_group_leader(p))
+			if (p && !has_group_leader_pid(p))
 				p = NULL;
 		}
 	}
@@ -414,7 +414,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	} else {
 		ret = -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return ret;
 }
