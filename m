Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0LTIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:55:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57063 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754177Ab0LTIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:55:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CQ8sPMhyCX72fTTQENq6Fm6G2sQbR0ugyAUI/zR
	XdZgCeSWtZmctq
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0F1794.3010803@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>
	 <1292834372.8948.27.camel@marge.simson.net>  <4D0F1794.3010803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 09:55:02 +0100
Message-ID: <1292835302.8948.35.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 10:45 +0200, Avi Kivity wrote:
> On 12/20/2010 10:39 AM, Mike Galbraith wrote:
> > On Sun, 2010-12-19 at 11:19 +0200, Avi Kivity wrote:
> > >  On 12/19/2010 12:05 PM, Mike Galbraith wrote:
> >
> > >  >  >   We definitely want to maintain fairness.  Both with a dedicated virt
> > >  >  >   host and with a mixed workload.
> > >  >
> > >  >  That makes it difficult to the point of impossible.
> > >  >
> > >  >  You want a specific task to run NOW for good reasons, but any number of
> > >  >  tasks may want the same godlike power for equally good reasons.
> > >
> > >  I don't want it to run now.  I want it to run before some other task.  I
> > >  don't care if N other tasks run before both.  So no godlike powers
> > >  needed, simply a courteous "after you".
> >
> > Ponders that...
> >
> > What if: we test that both tasks are in the same thread group, if so,
> 
> In my use case, both tasks are in the same thread group, so that works.  
> I don't see why the requirement is needed though.

Because preempting a perfect stranger is not courteous, all tasks have
to play nice.

> > use cfs_rq->next to pass the scheduler a HINT of what you would LIKE to
> > happen.
> 
> Hint is fine, so long as the scheduler seriously considers it.

It will take the hint if the target the target hasn't had too much cpu. 

> > If the current task on that rq is also in your group, resched
> > it, then IFF the task you would like to run isn't too far right, it'll
> > be selected.  If the current task is not one of yours, tough, you can
> > set cfs_rq->next and hope it doesn't get overwritten, but you may not
> > preempt a stranger.  If you happen to be sharing an rq, cool, you
> > accomplished your yield_to().  If not, there's no practical way (I can
> > think of) to ensure that the target runs before you run again if you try
> > to yield, but you did your best to try to get him to the cpu sooner, and
> > in a manner that preserves fairness without dangerous vruntime diddling.
> >
> > Would that be good enough to stop (or seriously improve) cpu wastage?
> 
> The cross-cpu limitation is bothersome.  Since there are many cpus in 
> modern machines, particularly ones used for virt, the probability of the 
> two tasks being on the same cpu is quite low.

What would you suggest?  There is no global execution timeline, so if
you want to definitely run after this task, you're stuck with moving to
his timezone or moving him to yours.  Well, you could sleep a while, but
we know how productive sleeping is.

	-Mike



