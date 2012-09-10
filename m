Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2IJNRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:17:30 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43786 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab2IJNRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:17:23 -0400
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20120908084345.GU30238@linux.vnet.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
	 <500D2162.8010209@redhat.com>
	 <1347023509.10325.53.camel@oc6622382223.ibm.com>
	 <504A37B0.7020605@linux.vnet.ibm.com>
	 <1347046931.7332.51.camel@oc2024037011.ibm.com>
	 <20120908084345.GU30238@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 10 Sep 2012 08:16:45 -0500
Message-ID: <1347283005.10325.55.camel@oc6622382223.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091013-5930-0000-0000-00000BDC50F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 14:13 +0530, Srikar Dronamraju wrote:
> > 
> > signed-off-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index fbf1fd0..c767915 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4844,6 +4844,9 @@ bool __sched yield_to(struct task_struct *p, bool
> > preempt)
> > 
> >  again:
> >  	p_rq = task_rq(p);
> > +	if (task_running(p_rq, p) || p->state || !(p_rq->curr->flags &
> > PF_VCPU)) {
> > +		goto out_no_unlock;
> > +	}
> >  	double_rq_lock(rq, p_rq);
> >  	while (task_rq(p) != p_rq) {
> >  		double_rq_unlock(rq, p_rq);
> > @@ -4856,8 +4859,6 @@ again:
> >  	if (curr->sched_class != p->sched_class)
> >  		goto out;
> > 
> > -	if (task_running(p_rq, p) || p->state)
> > -		goto out;
> 
> Is it possible that by this time the current thread takes double rq
> lock, thread p could actually be running?  i.e is there merit to keep
> this check around even with your similar check above?

I think that's a good idea.  I'll add that back in.
> 
> > 
> >  	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> >  	if (yielded) {
> > @@ -4879,6 +4880,7 @@ again:
> > 
> >  out:
> >  	double_rq_unlock(rq, p_rq);
> > +out_no_unlock:
> >  	local_irq_restore(flags);
> > 
> >  	if (yielded)
> > 
> > 
> 

-Andrew Theurer


