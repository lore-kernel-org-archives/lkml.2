Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1G1UNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:13:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13575 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab1G1UNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:13:34 -0400
Date: Thu, 28 Jul 2011 22:13:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH] sched: take rt_rq->rt_runtime_lock around rt_rq->rt_runtime
 modification
Message-ID: <alpine.LNX.2.00.1107282211370.20477@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everywhere (that I could find) where we modify rt_rq->rt_runtime we hold 
rt_rq->rt_runtime_lock except in alloc_rt_sched_group(). Shouldn't we do 
so - as per this patch. ???

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..d5a3737 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8488,7 +8488,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 			goto err_free_rq;
 
 		init_rt_rq(rt_rq, cpu_rq(i));
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

