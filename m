Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0KLPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:45:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab0KLPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:45:13 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=k53nsy2gcNIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pcCPffVJ2f5W7mNEU0oA:9 a=pJPsNrAjaPwj1GSoe-MA:7 a=l0HIUq57SYiX5e_0yVA3vG4KwrcA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] tracing: Fix recursive user stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <1289575271.3185.256.camel@edumazet-laptop>
References: <20101112151045.672405637@goodmis.org>
	 <20101112151223.183540991@goodmis.org>
	 <1289575271.3185.256.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 10:45:11 -0500
Message-ID: <1289576711.12418.401.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:21 +0100, Eric Dumazet wrote:
> Le vendredi 12 novembre 2010 à 10:10 -0500, Steven Rostedt a écrit :
> > pièce jointe document texte brut
> > (0003-tracing-Fix-recursive-user-stack-trace.patch)
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The user stack trace can fault when examining the trace. Which
> > would call the do_page_fault handler, which would trace again,
> > which would do the user stack trace, which would fault and call
> > do_page_fault again ...
> > 
> > Thus this is causing a recursive bug. We need to have a recursion
> > detector here.
> > 
> > [ Resubmitted by Jiri Olsa ]
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > LKML-Reference: <1289390172-9730-3-git-send-email-jolsa@redhat.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
> 
> 	if (__this_cpu_read(user_stack_count))
> 		goto out;
> 
> > +	__get_cpu_var(user_stack_count)++;
> 
> 	__this_cpu_inc(user_stack_count);

Thanks, I'll update and resubmit.

-- Steve

> 
> > +
> > +
> > +
> >  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
> >  					  sizeof(*entry), flags, pc);
> >  	if (!event)
> > @@ -1319,6 +1333,11 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
> >  	save_stack_trace_user(&trace);
> >  	if (!filter_check_discard(call, entry, buffer, event))
> >  		ring_buffer_unlock_commit(buffer, event);
> > +
> > +	__get_cpu_var(user_stack_count)--;
> 	__this_cpu_dec(user_stack_count);
> 
> > +
> > + out:
> > +	preempt_enable();
> >  }
> >  
> >  #ifdef UNUSED
> 


