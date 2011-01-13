Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1AMGNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 01:13:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58475 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750912Ab1AMGNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 01:13:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sO3RWzUCso+7oCC1z5wPMjeblAk2D/5ao25WT7y
	fNFESTKIfQSRgo
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=x-nO-Z7hG9b5t2FvuznHXaTSLPdS05wkXYMKA@mail.gmail.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	 <1294890890.8089.39.camel@marge.simson.net>
	 <AANLkTi=x-nO-Z7hG9b5t2FvuznHXaTSLPdS05wkXYMKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 07:13:08 +0100
Message-ID: <1294899188.8089.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 13:59 +0800, Yong Zhang wrote:
> On Thu, Jan 13, 2011 at 11:54 AM, Mike Galbraith <efault@gmx.de> wrote:
> > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> >
> > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> >
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> This looks more clear ;)
> 
> And a little comment below
> 
> >
> > ---
> >  kernel/sched.c           |    3 ++-
> >  kernel/sched_autogroup.c |   27 +++++++++++++++++++++++++++
> >  kernel/sched_autogroup.h |    4 ++++
> >  3 files changed, 33 insertions(+), 1 deletion(-)
> > @@ -106,6 +128,11 @@ task_wants_autogroup(struct task_struct
> >        return true;
> >  }
> >
> > +static inline bool task_group_is_autogroup(struct task_group *tg)
> > +{
> > +       return tg != &root_task_group && tg->autogroup;
> 
> Isn't just checking tg->autogroup sufficient?
> 
> if tg == &root_task_group
> 
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -4874,7 +4874,8 @@ recheck:
> >                 * assigned.
> >                 */
> >                if (rt_bandwidth_enabled() && rt_policy(policy) &&
> > -                               task_group(p)->rt_bandwidth.rt_runtime == 0) {
> > +                               task_group(p)->rt_bandwidth.rt_runtime == 0 &&
> 
> this check will fail.

Yes, it's intended to fail.  I intend to make it explicit throughout
autogroup that root_task_group is not an autogroup, and will drop the
test for root_task_group then.

	-Mike

