Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab0LTRFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:05:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab0LTRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:05:33 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=2O8TBr2BOcUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=Z4Rwk6OoAAAA:8 a=MTx4394miYSEEy3pjJkA:9 a=V8KqgH4zrBled8725Z8A:7 a=K99dEbJTpLy7c-en0eaL27QNT7gA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=jbrJJM5MRmoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 13/15] sched: Protect nohz task cpu affinity
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292862533.5021.41.camel@laptop>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-14-git-send-email-fweisbec@gmail.com>
	 <1292862533.5021.41.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 12:05:30 -0500
Message-ID: <1292864730.22905.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 17:28 +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > Don't allow to change a nohz task cpu affinity as we want them
> > to be bound to a single CPU and we want this affinity not to
> > change.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Anton Blanchard <anton@au1.ibm.com>
> > Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 4412493..bd0a41f 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5712,6 +5712,13 @@ again:
> >  		goto out;
> >  	}
> >  
> > +	/* Nohz tasks must keep their affinity */
> > +	if (test_tsk_thread_flag(p, TIF_NOHZ) &&
> > +	    !cpumask_equal(&p->cpus_allowed, new_mask)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> >  	if (p->sched_class->set_cpus_allowed)
> >  		p->sched_class->set_cpus_allowed(p, new_mask);
> >  	else {
> 
> NAK, this is really way too restrictive.

Agreed, the better solution is to disable the nohz from the task. If the
use just changed its affinity (or something else did), disable the nohz.
Maybe you can add a printk or warning, but I'm not sure about that
either.

-- Steve



