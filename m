Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0KPRcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:32:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753372Ab0KPRca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:32:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX190sbZ1Rpp03cfp/2gXpvNLhXkkROt8PfNaBhfbKo
	gfPfb96RBhyk6S
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>, zheng.z.yan@intel.com
In-Reply-To: <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
References: <1289900042.27424.253.camel@debian>
	 <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
	 <1289921196.5169.176.camel@maggy.simson.net>
	 <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 10:32:12 -0700
Message-ID: <1289928732.5169.211.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 08:31 -0800, Nikhil Rao wrote:
> On Tue, Nov 16, 2010 at 7:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> > On Tue, 2010-11-16 at 20:38 +0600, Rakib Mullick wrote:
> >
> >> Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
> >> I don't think it directly relates to scheduler benchmarking.
> >
> > It's not generally considered to be a wonderful benchmark, but it is a
> > good indicator, and worth keeping an eye on IMHO.
> >
> > I don't recall whether that patch works with the idle testcase without
> > resetting the throttle, or if it's only a bit less effective.  If it's
> > only a little less effective, I'd be inclined to just whack the reset as
> > Alex did.  Whatever is done has to prevent high frequency balancing.
> >
> 
> >From what I recall, I think removing the reset makes the original
> patch a little less effective. I agree that we can remove the reset if
> it hurts high frequency balancing.

Ok, let's do that.  I added your ack, OK?

From: Alex Shi <alex.shi@intel.com>
Date: Tue, 16 Nov 2010 17:34:02 +0800

    sched: volanomark regression fix

    Commit fab4762 triggers excessive idle balancing, causing a ~30% loss in
    volanomark throughput.  Remove idle balancing throttle reset.

    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Acked-by: Nikhil Rao <ncrao@google.com>
    Reported-by: Alex Shi <alex.shi@intel.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1758,10 +1758,6 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
-
-	/* re-arm NEWIDLE balancing when moving tasks */
-	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
-	this_rq->idle_stamp = 0;
 }
 
 /*


