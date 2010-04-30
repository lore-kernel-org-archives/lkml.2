Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0D3Q7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:59:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab0D3Q6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:44 -0400
Date: Fri, 30 Apr 2010 10:51:35 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, eparis@parisplace.org,
       paulmck@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, eparis@parisplace.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271880131-3951-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1271880131-3951-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix RCU lockdep splat in set_task_cpu on fork path
Message-ID: <tip-8b08ca52f5942c21564bbb90ccfb61053f2c26a1@git.kernel.org>
Git-Commit-ID: 8b08ca52f5942c21564bbb90ccfb61053f2c26a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 10:51:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b08ca52f5942c21564bbb90ccfb61053f2c26a1
Gitweb:     http://git.kernel.org/tip/8b08ca52f5942c21564bbb90ccfb61053f2c26a1
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 21 Apr 2010 13:02:07 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 30 Apr 2010 12:03:17 +0200

rcu: Fix RCU lockdep splat in set_task_cpu on fork path

Add an RCU read-side critical section to suppress this false
positive.

Located-by: Eric Paris <eparis@parisplace.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <1271880131-3951-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index de0bd26..3c2a54f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+	/*
+	 * Strictly speaking this rcu_read_lock() is not needed since the
+	 * task_group is tied to the cgroup, which in turn can never go away
+	 * as long as there are tasks attached to it.
+	 *
+	 * However since task_group() uses task_subsys_state() which is an
+	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
+	 */
+	rcu_read_lock();
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
@@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
+	rcu_read_unlock();
 }
 
 #else
