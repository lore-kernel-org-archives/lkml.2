Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0JIISY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:18:24 -0400
Received: from mail.df.lth.se ([194.47.250.12]:34590 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753393Ab0JIISX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:18:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
Subject: [PATCH] sched: SCHED_RESET_ON_FORK to recalculate load weights
Date: Sat,  9 Oct 2010 10:16:09 +0200
Message-Id: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the following phonomena: a process elevated to SCHED_RR
forks with SCHED_RESET_ON_FORK set, and the child is indeed
SCHED_OTHER, and the niceval is indeed reset to 0. However the
weight is still something enormous like 177522.

So we always need to call set_load_weight(), not just if the
niceval was changed, because the scheduler gives
SCHED_RR/SCHED_FIFO processes very high weights.

Cc: Lennart Poettering <lennart@poettering.net>
Cc: stable@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
This patch solves the problem for me, albeit on kernel 2.6.34 but
it seems to me like the bug is as relevant in the HEAD.

If I'm not mistaken the weights is what is actually controlling
the CPU alottment, so this nasty bug makes the schuduling class
and niceval *look* correct, but if you inspect the actual weight
it's totally wrong.

I found this when playing around with RTKit patches and showing
processes in CGFreak where I display processes in piecharts,
using the actual weights.

If this fix is correct it should probably go into the stable
series as well.
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 91c19db..9ed647f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2537,9 +2537,10 @@ void sched_fork(struct task_struct *p, int clone_flags)
 		if (PRIO_TO_NICE(p->static_prio) < 0) {
 			p->static_prio = NICE_TO_PRIO(0);
 			p->normal_prio = p->static_prio;
-			set_load_weight(p);
 		}
 
+		set_load_weight(p);
+
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:
-- 
1.7.2.3

