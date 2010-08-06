Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab0HFU4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:56:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62122 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934680Ab0HFUz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q06aErti8b6r97QK4MFKCmXJuLXtF7PuBskgtoq6edMgccyXDl2zGqZjzii7H2fBP7
         LeokwGi2fbWJCBUxnUKJaRz9dfWdKE+xDs0+xhgRXPqdRcNPprMtinuGd9a+Sf/jEdmr
         LSA/xOKe8O0BsKmNyZhM2bfAzBg9oBz5gv1ns=
Date: Fri, 6 Aug 2010 22:55:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: wake up tasks reading trace_pipe on write to
	trace_marker
Message-ID: <20100806205549.GB5345@nowhere>
References: <20100727224408.GB4142@joi.lan> <1281127136.3352.13.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281127136.3352.13.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 04:38:56PM -0400, Steven Rostedt wrote:
> On Wed, 2010-07-28 at 00:44 +0200, Marcin Slusarz wrote:
> > Currently we rely on other code periodically waking up trace reader.
> > If there aren't any other data than markers, reader will never be woken up.
> > Fix it.
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > ---
> >  kernel/trace/trace.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 086d363..02e04c8 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1520,6 +1520,7 @@ int trace_array_vprintk(struct trace_array *tr,
> >  	if (!filter_check_discard(call, entry, buffer, event)) {
> >  		ring_buffer_unlock_commit(buffer, event);
> >  		ftrace_trace_stack(buffer, irq_flags, 6, pc);
> > +		trace_wake_up();
> >  	}
> >  
> 
> This can't work. trace_printk() and friends must be able to be used
> anywhere. This can cause race conditions with the rq locks in the
> scheduler.
> 
> But you do bring up a good idea. That is, perhaps we should have a way
> to attach to known safe tracepoints that we can hook to to check if a
> wake up should happen or not.


This could be a simple macro that takes the name of the trace event:


DEFINE_EVENT(event_tpl, event_name, ...);


TRACE_EVENT_NO_WAKE(event_name);

I think trace events should be wakeable by default as it looks safe for
most of them. But probably we don't want that per event class.

In the unsafe list, I only have some sched and lock events in
mind, but I bet there are some others.

