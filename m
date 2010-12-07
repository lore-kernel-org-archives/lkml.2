Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0LGCOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:14:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0LGCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:32 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=qbRqJ9YnjtMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9udPefWUCg82JIENG4cA:9 a=yZ1eeh0J3vi-ZUKatnEA:7 a=R3GatoeIHW2k2s5aOP0xTOvsYmcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207021330.835861287@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 10/10] sched: Remove unlikely() from ttwu_post_activation
References: <20101207015834.196176991@goodmis.org>
Content-Disposition: inline; filename=0010-sched-Remove-unlikely-from-ttwu_post_activation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The unlikely() used in ttwu_post_activation() tests if the rq->idle_stamp
is set. But since this is for a wakeup, and wakeups happen when tasks
block on IO, and blocking tasks on IO may put the system into idle,
this can actually be a common occurence.

Running the annotated branch profiler on an average desktop running
firefox, evolution, xchat and distcc, the report shows:

 correct incorrect  %        Function             File              Line
 ------- ---------  -        --------             ----              ----
34884862 146110926  80 ttwu_post_activation      sched.c            2309

80% of the time, this unlikely is incorrect. Best not to assume what the
result is, and just remove the branch annotation.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 269a045..6d24b2e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2458,7 +2458,7 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 
-	if (unlikely(rq->idle_stamp)) {
+	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
-- 
1.7.2.3


