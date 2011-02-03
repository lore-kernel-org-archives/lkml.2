Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1BCTGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:06:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1BCTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AhcFmO7zOHgWzJuV/m7ULpiKl40djG0CI8KsDByaJaI7gdh1+H3TQU6nvEKNTDUVJ5
         FHOIFqw+v9neRcNpd4+FFaqF9eZs7aOhqZVu9DEDy5GelkIgl102spqA7ZojtpvYIMTl
         F8hSzxIOm8GiLhorDUk3OXRCEwWV9AG4p053g=
Date: Thu, 3 Feb 2011 20:06:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Message-ID: <20110203190643.GC1769@nowhere>
References: <1294867725.3237.230.camel@localhost.localdomain>
 <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
 <4D494AB1.1040508@hitachi.com>
 <20110202122620.GA11427@elte.hu>
 <1296665124.3145.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296665124.3145.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:45:22AM -0500, Eric Paris wrote:
> On Wed, 2011-02-02 at 13:26 +0100, Ingo Molnar wrote:
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> > > Hi Eric,
> > > 
> > > (2011/02/01 23:58), Eric Paris wrote:
> > > > On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
> > > >> Some time ago Adam posted a patch to allow for a generic seccomp
> > > >> implementation (unlike the current seccomp where your choice is all
> > > >> syscalls or only read, write, sigreturn, and exit) which got little
> > > >> traction and it was suggested he instead do the same thing somehow using
> > > >> the tracing code:
> > > >> http://thread.gmane.org/gmane.linux.kernel/833556
> > > 
> > > Hm, interesting idea :)
> > > But why would you like to use tracing code? just for hooking?
> > 
> > What I suggested before was to reuse the scripting engine and the tracepoints.
> > 
> > I.e. the "seccomp restrictions" can be implemented via a filter expression - and the 
> > scripting engine could be generalized so that such 'sandboxing' code can make use of 
> > it.
> > 
> > For example, if you want to restrict a process to only allow open() syscalls to fd 4 
> > (a very restrictive sandbox), it could be done via this filter expression:
> > 
> > 	'fd == 4'
> > 
> > etc. Note that obviously the scripting engine needs to be abstracted out somewhat - 
> > but this is the basic idea, to reuse the callbacks and reuse the scripting engine 
> > for runtime filtering of syscall parameters.
> 
> Any pointers on what is involved in this abstraction?  I can work out
> the details, but I don't know the big picture well enough to even start
> to move forwards.....

In the big picture, the filtering code is very tight to the tracing code.
Creation, initialization, removal of filters is all made on top of the
trace events structures (struct ftrace_event_call) because we apply and
interpret filters on the fields of trace events, which are what we save
in a trace.

Example:

If you look at the sched switch trace events, we have several fields
like prev_comm and next_comm. These are defined in the TRACE_EVENT()
macros calls. So when we apply a filter like "prev_comm == firefox-bin",
we enter the filtering code with the trace_event structure for sched
switch events and iterate through its fields to find one called
prev_comm and then we work on top of that.
I think you won't work with trace events, so you need to make the
filtering code more tracing-agnostic.

But I think it's quite workable and shouldn't be too hard to split that
into a filtering backend. Many parts are already pretty standalone.

Also I suspect the tracepoints are not what you need. Or may be
they are. But as Masami said, the syscall tracepoint is called late.
It's workable though. The other problem is that preemption is disabled
when tracepoints are called, which is probably not what you want.
One day I think we'll need to unify the tracepoints and notifier
code but until then, better keep tracepoints for tracing.

Now once you have the filtering code more generic, you still
need an arch backend to map register contents and layout into syscall
arguments name and type. On top of which you can finally use the filtering
code. For that you can use, again, some code we use for tracing, which
are syscalls metadata: informations generated on build time
that have syscalls fields and type.
And that also needs to be split up, but it's more trivial
than the filtering part.

Note for now, filtering + syscalls metadata only works on top
of raw arguments value. Syscalls metadata don't know much
about type semantics and won't help you to dereference
syscall argument pointers. Only raw syscall parameter values.
Similarly, the filtering code can't evaluate pointer dereferencing
expression evaluation, only direct values comprehension.

But please note this is all features we want in the long term
anyway, using the kprobe expression code to intepret dereferencing,
and have more type introspection into kernel structures for
smarter syscalls metadata. And we can do that all gradually
without breaking backward.

Now with the current features you'll already have access to
a much more powerful seccomp implementation.

And if you have questions about anything, please don't hesitate.
