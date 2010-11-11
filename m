Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0KKV5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:57:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0KKV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:57:07 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=75LVkdshKLYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1DpePtYp2FtOJ1AukeIA:9 a=NMEqsgyhlqhL3VuIsccA:7 a=L-voDrilBoZLPCmUSiPgh6uP5IQA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] tracing - fix recursive user stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <4CDB3538.4080605@cn.fujitsu.com>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
	 <1289390172-9730-3-git-send-email-jolsa@redhat.com>
	 <4CDB3538.4080605@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Nov 2010 16:57:04 -0500
Message-ID: <1289512624.12418.350.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 08:13 +0800, Li Zefan wrote:
> Jiri Olsa wrote:
> > The user stack trace can fault when examining the trace. Which
> > would call the do_page_fault handler, which would trace again,
> > which would do the user stack trace, which would fault and call
> > do_page_fault again ...
> > 
> > Thus this is causing a recursive bug. We need to have a recursion
> > detector here.
> > 
> 
> I guess this is from what I reported to Redhat, triggered by
> the ftrace stress test. ;)
> 
> This patch should be the first patch, otherwise you introduce
> a regression. Though it merely a problem in this case, better
> avoid it.

Yeah, this should go into urgent, and the other patch can be queued for
38.


> 
> A nitpick below:
> 
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/trace.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 82d9b81..0215e87 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1284,6 +1284,8 @@ void trace_dump_stack(void)
> >  	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
> >  }
> >  
> > +static DEFINE_PER_CPU(int, user_stack_count);
> > +
> >  void
> >  ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  {
> > @@ -1302,6 +1304,18 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  	if (unlikely(in_nmi()))
> >  		return;
> >  
> > +	/*
> > +	 * prevent recursion, since the user stack tracing may
> > +	 * trigger other kernel events.
> > +	 */
> > +	preempt_disable();
> > +	if (__get_cpu_var(user_stack_count))
> > +		goto out;
> > +
> > +	__get_cpu_var(user_stack_count)++;
> > +
> > +
> > +
> 
> redundant blank lines.

I can pull this patch with the fix.

Thanks!

-- Steve

> 
> >  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
> >  					  sizeof(*entry), flags, pc);
> >  	if (!event)
> > @@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  	save_stack_trace_user(&trace);
> >  	if (!filter_check_discard(call, entry, buffer, event))
> >  		ring_buffer_unlock_commit(buffer, event);
> > +
> > +	__get_cpu_var(user_stack_count)--;
> > +
> > + out:
> > +	preempt_enable();
> >  }
> >  
> >  #ifdef UNUSED


