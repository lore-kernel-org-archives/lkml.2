Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab0JKOho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:37:44 -0400
Received: from mail.df.lth.se ([194.47.250.12]:34661 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754918Ab0JKOhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:37:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
Subject: [PATCH] sched: drop all load weight manipulation for RT tasks
Date: Mon, 11 Oct 2010 16:36:51 +0200
Message-Id: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load weights are for the CFS, they do not belong in the RT
task. This makes all RT scheduling classes leave the
CFS weights alone.

This fixes a real bug as well: I noticed the following
phonomena: a process elevated to SCHED_RR forks with
SCHED_RESET_ON_FORK set, and the child is indeed SCHED_OTHER,
and the niceval is indeed reset to 0. However the
weight inserted by set_load_weight() remains at 0. giving the
task insignificat priority.

With this fix, the weight is reset to what the task had before
being elevated to SCHED_RR/SCHED_FIFO.

Cc: Lennart Poettering <lennart@poettering.net>
Cc: stable@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Note: in 2.6.34 and earlier kernels, the phenomenon is the
inverse: the tasks return from SCHED_RR/SCHED_FIFO with huge
weights. For the stable series the earlier patch inserting
recalculation of load weights at SCHED_RESET_ON_FORK is likely
more desirable.
---
 kernel/sched.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a04b8e6..07f39b5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1855,12 +1855,6 @@ static void dec_nr_running(struct rq *rq)
 
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
-		p->se.load.weight = 0;
-		p->se.load.inv_weight = WMULT_CONST;
-		return;
-	}
-
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
-- 
1.7.2.3

