Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab0LUBzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:55:12 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:54831 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab0LUBzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cZyZlrTKYBcSZQC51PM2fvspvsUoiaY7mbhF60Hr0/X7vkULRIMM9VQ42vtb04s7eJ
         v8n/WSsENUYbCo5qjgOAFirHycOZBTHv1lxuc1IY7Y/gY10t2dJTGPmth+xwg1GJ8DFa
         gCkXV5K6nuaAWRRbNI5mvjKwhm654J+b8rxT0=
Date: Tue, 21 Dec 2010 02:55:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 13/15] sched: Protect nohz task cpu affinity
Message-ID: <20101221015504.GP1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-14-git-send-email-fweisbec@gmail.com>
 <1292862533.5021.41.camel@laptop>
 <1292864730.22905.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292864730.22905.27.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:05:30PM -0500, Steven Rostedt wrote:
> On Mon, 2010-12-20 at 17:28 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > Don't allow to change a nohz task cpu affinity as we want them
> > > to be bound to a single CPU and we want this affinity not to
> > > change.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Anton Blanchard <anton@au1.ibm.com>
> > > Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> > > ---
> > >  kernel/sched.c |    7 +++++++
> > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index 4412493..bd0a41f 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -5712,6 +5712,13 @@ again:
> > >  		goto out;
> > >  	}
> > >  
> > > +	/* Nohz tasks must keep their affinity */
> > > +	if (test_tsk_thread_flag(p, TIF_NOHZ) &&
> > > +	    !cpumask_equal(&p->cpus_allowed, new_mask)) {
> > > +		ret = -EBUSY;
> > > +		goto out;
> > > +	}
> > > +
> > >  	if (p->sched_class->set_cpus_allowed)
> > >  		p->sched_class->set_cpus_allowed(p, new_mask);
> > >  	else {
> > 
> > NAK, this is really way too restrictive.
> 
> Agreed, the better solution is to disable the nohz from the task. If the
> use just changed its affinity (or something else did), disable the nohz.
> Maybe you can add a printk or warning, but I'm not sure about that
> either.

Right. Or even better: don't force the nohz task to be affine to
a single cpu.
