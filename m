Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0LNB2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:28:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab0LNB2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:28:47 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=jd_hLwR8bU8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=WHABW5p2riF1_ZjqtDQA:9 a=F82DAbvirJjID9wxfpdRBTyp-2IA:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214012845.669222973@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 20:28:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] sched: Change pick_next_task_rt from unlikely to likely
References: <20101214012803.142630411@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Change-pick_next_task_rt-from-unlikely-to-like.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The if (unlikely(!rt_rq->rt_nr_running)) test in pick_next_task_rt()
tests if there is another rt task ready to run. If so, then pick it.

In most systems, only one RT task runs at a time most of the time.
Running the branch unlikely annotator profiler on a system doing average
work "running firefox, evolution, xchat, distcc builds, etc", it showed the
following:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  324344 135104992  99 _pick_next_task_rt             sched_rt.c           1064

99% of the time the condition is true. When an RT task schedules out,
it is unlikely that another RT task is waiting to run on that same run queue.

Simply remove the unlikely() condition.

Acked-by: Gregory Haskins <ghaskins@novell.com>
Cc:Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1ab66a2..c2266c4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1062,7 +1062,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 
 	rt_rq = &rq->rt;
 
-	if (unlikely(!rt_rq->rt_nr_running))
+	if (!rt_rq->rt_nr_running)
 		return NULL;
 
 	if (rt_rq_throttled(rt_rq))
-- 
1.7.2.3


