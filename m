Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0IRTqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:46:40 -0400
Received: from kroah.org ([198.145.64.141]:51567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0IRTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:57 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.872676788@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [071/123] sched: Remove forced2_migrations stats
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-remove-forced2_migrations-stats.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

commit b9889ed1ddeca5a3f3569c8de7354e9e97d803ae upstream

This build warning:

 kernel/sched.c: In function 'set_task_cpu':
 kernel/sched.c:2070: warning: unused variable 'old_rq'

Made me realize that the forced2_migrations stat looks pretty
pointless (and a misnomer) - remove it.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |    6 ------
 kernel/sched_debug.c  |    2 --
 3 files changed, 9 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1178,7 +1178,6 @@ struct sched_entity {
 	u64			nr_failed_migrations_running;
 	u64			nr_failed_migrations_hot;
 	u64			nr_forced_migrations;
-	u64			nr_forced2_migrations;
 
 	u64			nr_wakeups;
 	u64			nr_wakeups_sync;
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2069,7 +2069,6 @@ task_hot(struct task_struct *p, u64 now,
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu);
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
@@ -2077,10 +2076,6 @@ void set_task_cpu(struct task_struct *p,
 
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-#ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, old_rq->clock, NULL))
-			schedstat_inc(p, se.nr_forced2_migrations);
-#endif
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
@@ -2523,7 +2518,6 @@ static void __sched_fork(struct task_str
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -423,7 +423,6 @@ void proc_sched_show_task(struct task_st
 	P(se.nr_failed_migrations_running);
 	P(se.nr_failed_migrations_hot);
 	P(se.nr_forced_migrations);
-	P(se.nr_forced2_migrations);
 	P(se.nr_wakeups);
 	P(se.nr_wakeups_sync);
 	P(se.nr_wakeups_migrate);
@@ -499,7 +498,6 @@ void proc_sched_set_task(struct task_str
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
 	p->se.nr_wakeups_migrate		= 0;


