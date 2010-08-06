Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110Ab0HFVuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:50:40 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41357 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0HFVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O4JxwYw3ZHFbjZRzNPBlJsOe8owc/B3OoH23NUXRbZBcHIl2sOI501SHbQCHF9czyS
         yW+2aJSk8UxAUFcHDnont2b9sj41X42x2w4PKBrQ/DjpydrLowapItvG09LQjHsllf1X
         fXRVdVncbWGF4L5SiiA2rHhprifNrBO0ldWE8=
Date: Fri, 6 Aug 2010 23:50:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: wake up tasks reading trace_pipe on write to
	trace_marker
Message-ID: <20100806215029.GC5345@nowhere>
References: <20100727224408.GB4142@joi.lan> <1281127136.3352.13.camel@gandalf.stny.rr.com> <20100806205549.GB5345@nowhere> <1281130175.3352.15.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281130175.3352.15.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 05:29:35PM -0400, Steven Rostedt wrote:
> On Fri, 2010-08-06 at 22:55 +0200, Frederic Weisbecker wrote:
> 
> > > This can't work. trace_printk() and friends must be able to be used
> > > anywhere. This can cause race conditions with the rq locks in the
> > > scheduler.
> > > 
> > > But you do bring up a good idea. That is, perhaps we should have a way
> > > to attach to known safe tracepoints that we can hook to to check if a
> > > wake up should happen or not.
> > 
> > 
> > This could be a simple macro that takes the name of the trace event:
> > 
> > 
> > DEFINE_EVENT(event_tpl, event_name, ...);
> > 
> > 
> > TRACE_EVENT_NO_WAKE(event_name);
> > 
> 
> Yeah, that may be worth doing for 2.6.37. Might as well also add a
> trace_printk_nowake() too, when you know you are in dangerous locations
> like the scheduler or NMI.



Yeah.


 
> 
> > I think trace events should be wakeable by default as it looks safe for
> > most of them. But probably we don't want that per event class.
> > 
> > In the unsafe list, I only have some sched and lock events in
> > mind, but I bet there are some others.
> 
> Yep, will put that on my todo list.
> 
> Thanks,


Cool. This is going to be useful in perf as well. The "nmi" argument in
perf_swevent_add tells wether we can wake up or not. If not we do a
kind of delayed wake up using a self IPI.

Currently we always consider we can't wake up when a trace event triggers.
If we know we can wake up, this is going to be less costly.

