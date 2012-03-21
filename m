Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2CUJHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:07:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2CUJHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:07:20 -0400
Message-ID: <1332320819.18960.468.camel@twins>
Subject: RE: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael J. Wang" <mjwang@broadcom.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date: Wed, 21 Mar 2012 10:06:59 +0100
In-Reply-To: <2EF88150C0EF2C43A218742ED384C1BC0FC8438B@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
	 <20120321014050.GA19766@zhy>
	 <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
	 <20120321021229.GB19766@zhy>
	 <2EF88150C0EF2C43A218742ED384C1BC0FC8438B@IRVEXCHMB08.corp.ad.broadcom.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 07:49 +0000, Michael J. Wang wrote:
> > > Should I reformat my patch and send it again?
> > 
> > It'll be better, and I think Peter/Ingo will happy with it.
> > 
> 
> OK.  I will resend now.  Thanks for all your help!

The resend didn't include the more details thing, so I fudged it by
hand. The queued thing now looks like this:

---
Subject: sched, rt: Minor improvement to pick_next_highest_task_rt
From: Michael J Wang <mjwang@broadcom.com>
Date: Mon, 19 Mar 2012 22:26:19 +0000

Avoid extra work by continuing on to the next rt_rq if the highest
prio task in current rt_rq is the same priority as our candidate
task.

More detailed explanation:  if next is not NULL, then we have found a
candidate task, and its priority is next->prio.  Now we are looking
for an even higher priority task in the other rt_rq's.  idx is the
highest priority in the current candidate rt_rq.  In the current 3.3
code, if idx is equal to next->prio, we would start scanning the tasks
in that rt_rq and replace the current candidate task with a task from
that rt_rq.  But the new task would only have a priority that is equal
to our previous candidate task, so we have not advanced our goal of
finding a higher prio task.  So we should avoid the extra work by
continuing on to the next rt_rq if idx is equal to next->prio.

Signed-off-by: Michael J Wang <mjwang@broadcom.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com
---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1428,7 +1428,7 @@ static struct task_struct *pick_next_hig
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;

