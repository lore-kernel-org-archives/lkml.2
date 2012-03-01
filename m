Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2CAMWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:22:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2CAMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:22:13 -0500
Date: Thu, 1 Mar 2012 04:21:31 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-vw8et3445km5b8mpihf4trae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Do not submit new work when PI-blocked
Git-Commit-ID: 3c7d51843b03a6839e9ec7cda724e54d2319a63a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:21:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c7d51843b03a6839e9ec7cda724e54d2319a63a
Gitweb:     http://git.kernel.org/tip/3c7d51843b03a6839e9ec7cda724e54d2319a63a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 17 Jul 2011 20:46:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:46:54 +0100

sched/rt: Do not submit new work when PI-blocked

When we are PI-blocked then we want to get things done ASAP.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-vw8et3445km5b8mpihf4trae@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    8 ++++++++
 kernel/sched/core.c   |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03dd224..c628a91 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2082,12 +2082,20 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return tsk->pi_blocked_on != NULL;
+}
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
 # define rt_mutex_adjust_pi(p)		do { } while (0)
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return false;
+}
 #endif
 
 extern bool yield_to(struct task_struct *p, bool preempt);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2bbdec..25e06a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3227,7 +3227,7 @@ need_resched:
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state)
+	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
