Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab1JGBkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 21:40:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41607 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1JGBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 21:40:19 -0400
Date: Thu, 6 Oct 2011 18:40:14 -0700
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20111007014014.GB5458@google.com>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
 <20110930034815.GF10425@mtj.dyndns.org>
 <1317355529.4588.45.camel@gandalf.stny.rr.com>
 <20110930041424.GH10425@mtj.dyndns.org>
 <1317371699.19415.6.camel@twins>
 <20110930085510.GA23868@mtj.dyndns.org>
 <1317373473.19415.10.camel@twins>
 <20111003011506.GE31799@mtj.dyndns.org>
 <1317637238.20367.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317637238.20367.6.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

Sorry about the delays.  I just moved and things are still pretty
hectic.

On Mon, Oct 03, 2011 at 12:20:38PM +0200, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 18:15 -0700, Tejun Heo wrote:
> > Anyways, I don't think I'm gonna take this one.  There are some
> > attractions to the approach - ie. making the users determine whether
> > they need strict affinity or not and mandating those users to shut
> > down properly from cpu down callbacks and if we're doing this from the
> > scratch, this probably would be a sane choice.  But we already have
> > tons of users and relatively well tested code.  I don't see compelling
> > reasons to perturb that at this point.
>
> So wtf am I going to do with people who want PF_THREAD_BOUND to actually
> do what it means? Put a warning in the scheduler code to flag all
> violations and let you sort out the workqueue fallout?

The only thing workqueue requires is that set_cpus_allowed_ptr() and
cpuset don't diddle with workers.  We can either add another flag or
just add check for PF_WQ_WORKER there.

> I didn't write this change for fun, I actually need to get
> PF_THREAD_BOUND back to sanity, this change alone isn't enough, but it
> gets rid of the worst abuse. This isn't frivolous perturbation.

One thing I was curious about and Steven didn't answer was that
whether the RT's requirement prohibits the bound threads from changing
its own affinity because that's currently explicitly allowed whether
the new affinity is single CPU or any set of CPUs.

> > Also, on a quick glance, the change is breaking non-reentrance
> > guarantee.
>
> How so? Afaict it does exactly what the trustee thread used to do, or is
> it is related to the NON_AFFINE moving the worklets around?

Yeap, that was my bad.  I thought you were pushing out works to other
cpus before flushing local.  Can you please re-post rolled-up patch?
Hopefully at least boot tested?

One thing that's not clear to me is how the new code is gonna handle
long-running work items.  It seems like the code assumes that all
long-running work items should be queued on NON_AFFINE workqueue.  Is
that correct?  The trustee thing is pretty complex but the
requirements there are pretty weird for historical reasons.  If it can
simplify the code while following the requirements (or audit and
update all users), great but I still can't see how it can.

Thanks.

-- 
tejun
