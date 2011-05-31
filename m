Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1EaNSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:18:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1EaNSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p053fhldZxFHazsSV3+CohuFhbp6mC2RbanK2WNreFjyMS2GXX1mbdIghNIyq9JZgn
         zFc170C+5201e4IIfS0G+Z0ZgBB3m40++RHSoCyjDN1WCcqkmbVsuhZU0Ypo24rZRAkp
         d071ASe25kAOh6CLQhNF1ROa1zlKmFQvDYdAs=
MIME-Version: 1.0
In-Reply-To: <1306812384.7903.3.camel@marge.simson.net>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	<1306244383.1465.59.camel@gandalf.stny.rr.com>
	<BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
	<1306812384.7903.3.camel@marge.simson.net>
Date: Tue, 31 May 2011 21:18:30 +0800
Message-ID: <BANLkTi=e=69xvJZ1+56xzuFyhmdN0hZHRQ@mail.gmail.com>
Subject: [PATCH resend] sched: fix need_resched() when checking peempt
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT preempt check tests the wrong task if NEED_RESCHED is set. It currently
checks the local CPU task. It is suppose to check the task that is running on
the run queue we are about to wake another task on.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..9b8d5dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1096,7 +1096,7 @@ static void check_preempt_curr_rt(struct rq *rq,
struct task_struct *p, int flag
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == rq->curr->prio && !need_resched())
+	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 #endif
 }
