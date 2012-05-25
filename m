Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab2EYNIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab2EYNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:08:45 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_sZAObhRAXAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nrACCIEEAAAA:8 a=U0oLAHXfSC_TPMjz3lQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337951322.13348.246.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] sched/rt: Remove redundant check before
 push_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 May 2012 09:08:42 -0400
In-Reply-To: <1337938798.9783.172.camel@laptop>
References: <4FBF29B2.9030904@ct.jp.nec.com>
	 <4FBF2A1D.2090302@ct.jp.nec.com> <1337938798.9783.172.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 11:39 +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 15:43 +0900, Hiroshi Shimamoto wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > 
> > Currently rq->rt.overloaded is checked twice in switched_to_rt().
> > Remove the first one which out of push_rt_task().
> 
> Steven was this on purpose to avoid the call or can I apply this thing?
> 

Yeah, I think I added that as a way to avoid the call, but I never did
any benchmarks to see if it was actually better (extra check to avoid
the call, or just do the call and remove the duplicate check).

It would be a good idea to see how ofter that check happens in the real
world. As two or more RT tasks on the same CPU is only something that
happens on a real RT system (as the common case that is).

It's a micro optimization, as a double duplicate check should be fast as
everything is nicely in the cache line. But an extra call may be
expensive. But it's not a big difference to me if you take the patch or
not.

> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > ---
> >  kernel/sched/rt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> > index c5565c3..a601a70 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -1907,7 +1907,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
> >  	 */
> >  	if (p->on_rq && rq->curr != p) {
> >  #ifdef CONFIG_SMP
> > -		if (rq->rt.overloaded && push_rt_task(rq) &&
> > +		if (push_rt_task(rq) &&
> >  		    /* Don't resched if we changed runqueues */
> >  		    rq != task_rq(p))

If you decide to take this patch, it may be better to switch it to:

		/* Don't resched if we changed runqueues */
		if (push_rt_task(rq) && rq != task_rq(p))

-- Steve



> >  			check_resched = 0;
> 
> 


