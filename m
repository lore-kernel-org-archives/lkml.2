Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2A0RCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:02:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64877 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2A0RCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:02:09 -0500
Date: Fri, 27 Jan 2012 18:02:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120127170202.GB3391@somewhere>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
 <20120120170232.GF18056@somewhere>
 <1327533221.22710.74.camel@gandalf.stny.rr.com>
 <20120126023726.GI20878@somewhere>
 <20120127103714.GA6294@m.brq.redhat.com>
 <20120127164045.GA3391@somewhere>
 <20120127165416.GD10601@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127165416.GD10601@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 05:54:16PM +0100, Jiri Olsa wrote:
> On Fri, Jan 27, 2012 at 05:40:49PM +0100, Frederic Weisbecker wrote:
> > On Fri, Jan 27, 2012 at 11:37:14AM +0100, Jiri Olsa wrote:
> > > On Thu, Jan 26, 2012 at 03:37:29AM +0100, Frederic Weisbecker wrote:
> > > > On Wed, Jan 25, 2012 at 06:13:41PM -0500, Steven Rostedt wrote:
> > > > > On Fri, 2012-01-20 at 18:02 +0100, Frederic Weisbecker wrote:
> > > > > >  
> > > > > > > +/**
> > > > > > > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > > > > > > + *
> > > > > > > + * This function enables tracing on given cpu by decreasing
> > > > > > > + * the per cpu control variable.
> > > > > > > + * It must be called with preemption disabled and only on
> > > > > > > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > > > > > > + */
> > > > > > > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > > > > > > +{
> > > > > > > +	atomic_t *disabled;
> > > > > > > +
> > > > > > > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> > > > > > > +			 !preempt_count()))
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > > > > > > +	atomic_dec(disabled);
> > > > > > > +}
> > > > > > 
> > > > > > As you're using this for the local CPU exclusively, I suggest you rather
> > > > > > rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"
> > > > > 
> > > > > I wonder if "ftrace_function_local_{dis,en}able(ops)" would be better?
> > > > > That would match something like local_irq_disable/enable.
> > > > 
> > > > Good idea.
> > > > 
> > > > > 
> > > > > > and use __get_cpu_var() that does the preempt check for you.
> > > 
> > > I haven't found preempt check this_cpu_ptr path.. not sure I missed it..
> > > so I'm keeping the implicit preemt check.
> > 
> > #ifdef CONFIG_DEBUG_PREEMPT
> > #define my_cpu_offset per_cpu_offset(smp_processor_id())
> > #else
> > #define my_cpu_offset __my_cpu_offset
> > #endif
> > 
> > #ifdef CONFIG_DEBUG_PREEMPT
> > #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
> > #else
> > #define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
> > #endif
> > 
> > And smp_processor_id() has a preemption check.
> 
> yay.. ok :) so this one is triggered only if there's CONFIG_DEBUG_PREEMPT
> option enabled.. seems to me it'd better to keep the implicit check anyway.
> 
> jirka


This is a debugging option deemed to lower runtime debugging checks in
production.

Is there a good reason to keep the check on every case?
