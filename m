Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1LUQnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:43:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1LUQnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:43:17 -0500
Date: Wed, 21 Dec 2011 17:43:04 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 3/8] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20111221164304.GB1659@m.brq.redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
 <1324468136-3997-4-git-send-email-jolsa@redhat.com>
 <1324483293.5916.89.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324483293.5916.89.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:01:33AM -0500, Steven Rostedt wrote:
> On Wed, 2011-12-21 at 12:48 +0100, Jiri Olsa wrote:

SNIP

> > +/**
> > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > + *
> > + * This function enables tracing on given cpu by decreasing
> > + * the per cpu control variable.
> > + * It must be called with preemption disabled and only on
> > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > + */
> > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > +{
> > +	atomic_t *disabled;
> > +
> > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)) ||
> > +			 !preempt_count())
> 
> The WARN_ON_ONCE() should also include the !preempt_count().
> 

ouch, that was initial intention.. need eye doctor ;)

> 
> > +		return;
> > +
> > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > +	atomic_dec(disabled);
> > +}
> > +

SNIP

> > +
> > +static int control_ops_is_disabled(struct ftrace_ops *ops)
> > +{
> > +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> 
> Again, the use of "this_cpu_ptr" is wrong. Gah! We should nuke all of
> that crap.

will nuke this one..

> 
> 

> >  static int __register_ftrace_function(struct ftrace_ops *ops)
> >  {
> >  	if (ftrace_disabled)
> > @@ -268,15 +324,19 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
> >  	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
> >  		return -EBUSY;
> >  
> > +	if ((ops->flags & FL_GLOBAL_CONTROL) == FL_GLOBAL_CONTROL)
> 
> No biggy, but I usually find:
> 
> 	if (ops->flags & FL_GLOBAL_CONTROL)
> 
> more readable. With what you have, I looked at that condition three
> times to figure out what was different between what was '&'d with the
> flags and what was being equal too. Usually the ((flags & X) == Y) is
> done to check if a subset of bits are set within a mask of bits.

Well, thats what I need to do here. Bail out if both bits are set,
since we dont support both global and control flags set at the same
time.. I'll add some comment to it.

thanks,
jirka
