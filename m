Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0JHG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:57:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40979 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752014Ab0JHG5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:57:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19dfp42VCxd0szEu1Kia6MIEVKys53RDQz+BvdTGF
	0b60hLxrggTbx7
Subject: Re: [PATCH 2/2] sched: use the old min_vruntime when normalizing
 on dequeue
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <AANLkTimR3pmxNF5TLTyEHZjPTrQeLrTB+HLsj-X6jPRx@mail.gmail.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	 <1285742774-5013-2-git-send-email-dima@android.com>
	 <AANLkTimR3pmxNF5TLTyEHZjPTrQeLrTB+HLsj-X6jPRx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 08:57:03 +0200
Message-Id: <1286521023.8189.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 14:00 -0700, Dima Zavin wrote: 
> Mike,
> 
> Thanks for the Ack for patch 1/2, could you take a look at this one too?

Ok, did that.  I'd do it like below instead.

> Should I re-upload the series as v2 or you can pick the latest from
> patch 1 and take this one?

Peter's the merge point, I just help break stuff ;-)

I tested the below with pinned/unpinned mixes of sleepers and hogs, and
saw no ill effects.  My thought on the logic is embedded in the comment.

From: Dima Zavin <dima@android.com>
Subject: [PATCH 2/2] sched: use the old min_vruntime when normalizing on dequeue
Date: Tue, 28 Sep 2010 23:46:14 -0700

After pulling the thread off the run-queue during a cgroup change,
the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
then gets normalized to this new value. This can then lead to the thread
getting an unfair boost in the new group if the vruntime of the next
task in the old run-queue was way further ahead.

Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 kernel/sched_fair.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -826,15 +826,17 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
 
 	/*
-	 * Normalize the entity after updating the min_vruntime because the
-	 * update can refer to the ->curr item and we need to reflect this
-	 * movement in our normalized position.
+	 * Normalize vruntime prior to updating min_vruntime.  Any motion
+	 * referring to ->curr will have been captured by update_curr() above.
+	 * We don't want to preserve what lag might become as a result of
+	 * this dequeue, we want to preserve what lag is at dequeue time.
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	update_min_vruntime(cfs_rq);
 }
 
 /*


