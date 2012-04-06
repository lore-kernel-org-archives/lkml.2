Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2DFHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:19:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39621 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2DFHPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:12 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 01/16] sched: add sched_class->task_dead.
Date: Fri,  6 Apr 2012 09:14:26 +0200
Message-Id: <1333696481-3433-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add a new function to the scheduling class interface. It is called
at the end of a context switch, if the prev task is in TASK_DEAD state.

It might be useful for the scheduling classes that want to be notified
when one of their task dies, e.g. to perform some cleanup actions.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f6b11a..ddfc4dc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,6 +1116,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cc706d..4c8d1c3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3219,6 +3219,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop_delayed(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
-- 
1.7.5.4

