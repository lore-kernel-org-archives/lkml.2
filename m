Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2IJRMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:12:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2IJRMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:12:19 -0400
Message-ID: <1347297124.2124.42.camel@twins>
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE
 handler
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Date: Mon, 10 Sep 2012 19:12:04 +0200
In-Reply-To: <20120910165653.GA28033@linux.vnet.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
	 <500D2162.8010209@redhat.com>
	 <1347023509.10325.53.camel@oc6622382223.ibm.com>
	 <504A37B0.7020605@linux.vnet.ibm.com>
	 <1347046931.7332.51.camel@oc2024037011.ibm.com>
	 <20120908084345.GU30238@linux.vnet.ibm.com>
	 <1347283005.10325.55.camel@oc6622382223.ibm.com>
	 <1347293035.2124.22.camel@twins>
	 <20120910165653.GA28033@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 22:26 +0530, Srikar Dronamraju wrote:
> > +static bool __yield_to_candidate(struct task_struct *curr, struct task_struct *p)
> > +{
> > +     if (!curr->sched_class->yield_to_task)
> > +             return false;
> > +
> > +     if (curr->sched_class != p->sched_class)
> > +             return false;
> 
> 
> Peter, 
> 
> Should we also add a check if the runq has a skip buddy (as pointed out
> by Raghu) and return if the skip buddy is already set. 

Oh right, I missed that suggestion.. the performance improvement went
from 81% to 139% using this, right?

It might make more sense to keep that separate, outside of this
function, since its not a strict prerequisite.

> > 
> > +     if (task_running(p_rq, p) || p->state)
> > +             return false;
> > +
> > +     return true;
> > +} 


> > @@ -4323,6 +4340,10 @@ bool __sched yield_to(struct task_struct *p,
> bool preempt)
> >       rq = this_rq();
> >  
> >  again:
> > +     /* optimistic test to avoid taking locks */
> > +     if (!__yield_to_candidate(curr, p))
> > +             goto out_irq;
> > +

So add something like:

	/* Optimistic, if we 'raced' with another yield_to(), don't bother */
	if (p_rq->cfs_rq->skip)
		goto out_irq;
> 
> 
> >       p_rq = task_rq(p);
> >       double_rq_lock(rq, p_rq);
> 
> 
But I do have a question on this optimization though,.. Why do we check
p_rq->cfs_rq->skip and not rq->cfs_rq->skip ?

That is, I'd like to see this thing explained a little better.

Does it go something like: p_rq is the runqueue of the task we'd like to
yield to, rq is our own, they might be the same. If we have a ->skip,
there's nothing we can do about it, OTOH p_rq having a ->skip and
failing the yield_to() simply means us picking the next VCPU thread,
which might be running on an entirely different cpu (rq) and could
succeed?


