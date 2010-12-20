Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0LTKdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:33:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45798 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753955Ab0LTKdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:33:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19o/ulKcMtormdto8CEzbT1XQL2AIU7ZqJ9AMCGtf
	+3wpTBwlpVfE8w
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0F25E8.80305@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>
	 <1292834372.8948.27.camel@marge.simson.net> <4D0F1794.3010803@redhat.com>
	 <1292835302.8948.35.camel@marge.simson.net> <4D0F1BD8.20601@redhat.com>
	 <1292837440.8948.60.camel@marge.simson.net>  <4D0F25E8.80305@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 11:33:13 +0100
Message-ID: <1292841193.11946.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 11:46 +0200, Avi Kivity wrote:
> On 12/20/2010 11:30 AM, Mike Galbraith wrote:
> > >  >
> > >  >  Because preempting a perfect stranger is not courteous, all tasks have
> > >  >  to play nice.
> > >
> > >  I don't want to preempt anybody, simply make the task run before me.
> >
> > I thought you wanted to get the target to the cpu asap?  You just can't
> > have he runs before me cross cpu.
> 
> You're right, of course.  I'm fine with running in parallel.  I'm fine 
> with him running before or instead of me.  I'm not fine with running 
> while the other guy is waiting.

Goody, maybe we're headed down a productive path then.

> > >  Further, this is a kernel internal API, so no need for these types of
> > >  restrictions.  If we expose it to userspace, sure.
> >
> > Doesn't matter whether it's kernel or not afaikt.  If virtualization has
> > to coexist peacefully with other loads, it can't just say "my hints are
> > the only ones that count", and thus shred other loads throughput.
> 
> What does that have to do with being in the same group or not?  I want 
> to maintain fairness (needed for pure virt workloads, one guest cannot 
> dominate another), but I don't see how being in the same thread group is 
> relevant.

My thought is that you can shred your own throughput, but not some other
concurrent load.  I'll have to let that thought stew a bit though.

> Again, I don't want more than one entitlement.  I want to move part of 
> my entitlement to another task.

Folks can keep trying that, but IMO it's too broken to live.

> > >  >  >   >   use cfs_rq->next to pass the scheduler a HINT of what you would LIKE to
> > >  >  >   >   happen.
> > >  >  >
> > >  >  >   Hint is fine, so long as the scheduler seriously considers it.
> > >  >
> > >  >  It will take the hint if the target the target hasn't had too much cpu.
> > >
> > >  Since I'm running and the target isn't, it's clear the scheduler thinks
> > >  the target had more cpu than I did [73].  That's why I want to donate
> > >  cpu time.
> >
> > That's not necessarily true, in fact, it's very often false.  Last/next
> > buddy will allow a task to run ahead of leftmost so we don't always
> > blindly select leftmost and shred cache.
> 
> Ok.
> 
> > >  >
> > >  >  What would you suggest?  There is no global execution timeline, so if
> > >  >  you want to definitely run after this task, you're stuck with moving to
> > >  >  his timezone or moving him to yours.  Well, you could sleep a while, but
> > >  >  we know how productive sleeping is.
> > >
> > >  I don't know.  The whole idea of donating runtime was predicated on CFS
> > >  being completely fair.  Now I find that (a) it isn't (b) donating
> > >  runtimes between tasks on different cpus is problematic.
> >
> > True and true.  However, would you _want_ the scheduler to hold runnable
> > tasks hostage, and thus let CPU go to waste in the name of perfect
> > fairness?  Perfect is the enemy of good applies to that idea imho.
> 
> Sorry, I don't see how it follows.

Let's just forget theoretical views, and concentrate on a forward path.
 
> > >  Moving tasks between cpus is expensive and sometimes prohibited by
> > >  pinning.  I'd like to avoid it if possible, but it's better than nothing.
> >
> > Expensive in many ways, so let's try to not do that.
> >
> > So why do you need this other task to run before you do, even cross cpu?
> > If he's a lock holder, getting him to the cpu will give him a chance to
> > drop, no?  Isn't that what you want to get done?  Drop that lock so you
> > or someone else can get something other than spinning done?
> 
> Correct.  I don't want the other task to run before me, I just don't 
> want to run before it.

OK, so what I gather is that if you can preempt another of your own
threads to get the target to cpu, that would be a good thing whether
he's on the same cpu as yield_to() caller or not.  If the target is
sharing a cpu with you, that's even better.  Correct?

Would a kick/hint option be useful?

	-Mike

