Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab1GASm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:42:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32815 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1GASm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:42:28 -0400
Subject: [PATCH] sched: Check nr_running before calling pick_next_task in
 schedule().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 00:41:51 +0600
Message-ID: <1309545711.4303.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently at schedule(), when we call pick_next_task we don't check whether current rq is empty or not. Since idle_balance can fail,
its nice to check whether we really have any task on rq or not. If not, we can call idle_sched_class.pick_next_task straight.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 5925275..a4f4f58 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4273,7 +4273,14 @@ need_resched:
 		idle_balance(cpu, rq);
 
 	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	/*  Since idle_balance can fail, its better to check rq->nr_running.
+	 *  Otherwise we can call idle_sched_class.pick_next_task straight,
+	 *  cause we need to do some accounting.
+	 */
+	if (likely(rq->nr_running))
+		next = pick_next_task(rq);
+	else
+		next = idle_sched_class.pick_next_task(rq);
 	clear_tsk_need_resched(prev);
 	rq->skip_clock_update = 0;
 


