Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2A0Kii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:38:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2A0Kih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:38:37 -0500
Date: Fri, 27 Jan 2012 11:38:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120127103829.GB6294@m.brq.redhat.com>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
 <20120120170232.GF18056@somewhere>
 <1327533221.22710.74.camel@gandalf.stny.rr.com>
 <20120126023726.GI20878@somewhere>
 <20120127103714.GA6294@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127103714.GA6294@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 11:37:14AM +0100, Jiri Olsa wrote:
> On Thu, Jan 26, 2012 at 03:37:29AM +0100, Frederic Weisbecker wrote:
> > On Wed, Jan 25, 2012 at 06:13:41PM -0500, Steven Rostedt wrote:
> > > On Fri, 2012-01-20 at 18:02 +0100, Frederic Weisbecker wrote:
> > > >  
> > > > > +/**
> > > > > + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> > > > > + *
> > > > > + * This function enables tracing on given cpu by decreasing
> > > > > + * the per cpu control variable.
> > > > > + * It must be called with preemption disabled and only on
> > > > > + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> > > > > + */
> > > > > +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> > > > > +{
> > > > > +	atomic_t *disabled;
> > > > > +
> > > > > +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> > > > > +			 !preempt_count()))
> > > > > +		return;
> > > > > +
> > > > > +	disabled = per_cpu_ptr(ops->disabled, cpu);
> > > > > +	atomic_dec(disabled);
> > > > > +}
> > > > 
> > > > As you're using this for the local CPU exclusively, I suggest you rather
> > > > rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"
> > > 
> > > I wonder if "ftrace_function_local_{dis,en}able(ops)" would be better?
> > > That would match something like local_irq_disable/enable.
> > 
> > Good idea.
> > 
> > > 
> > > > and use __get_cpu_var() that does the preempt check for you.
> 
> I haven't found preempt check this_cpu_ptr path.. not sure I missed it..
> so I'm keeping the implicit preemt check.
> Attaching new version of the patch (I'll need to resend whole serie once
> this one is agreed).
> 
> changes:
>  - using this_cpu_ptr to touch ftrace_ops::disable
>  - renamed ftrace_ops:disable API:
> 	void ftrace_function_local_enable(struct ftrace_ops *ops)
> 	void ftrace_function_local_disable(struct ftrace_ops *ops)
> 	int  ftrace_function_local_disabled(struct ftrace_ops *ops)

ops, missed one... using int instead of atomic_t for ftrace_ops::disable

jirka
