Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab0IRTrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:47:55 -0400
Received: from kroah.org ([198.145.64.141]:51524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab0IRTBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:53 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.454635714@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [066/123] sched: Consolidate select_task_rq() callers
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-consolidate-select_task_rq-callers.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 970b13bacba14a8cef6f642861947df1d175b0b3 upstream

sched: Consolidate select_task_rq() callers

Small cleanup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
[ v2: build fix ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2333,6 +2333,14 @@ void task_oncpu_function_call(struct tas
 	preempt_enable();
 }
 
+#ifdef CONFIG_SMP
+static inline
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+{
+	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+}
+#endif
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2386,7 +2394,7 @@ static int try_to_wake_up(struct task_st
 	p->state = TASK_WAKING;
 	task_rq_unlock(rq, &flags);
 
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 
@@ -2601,7 +2609,7 @@ void sched_fork(struct task_struct *p, i
 		p->sched_class = &fair_sched_class;
 
 #ifdef CONFIG_SMP
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
 	set_task_cpu(p, cpu);
 
@@ -3170,7 +3178,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
+	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);


