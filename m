Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2FDMHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:07:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23505 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2FDMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:07:33 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wwwCnHkgN0EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Ft0K1o1f0ei_VT9KoxkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338811649.13348.486.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 04 Jun 2012 08:07:29 -0400
In-Reply-To: <4FCC9FC8.7060302@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	    <1338331514.13348.298.camel@gandalf.stny.rr.com>
	    <4FC5C55E.9000909@hitachi.com>
	   <1338377978.13348.308.camel@gandalf.stny.rr.com>
	   <4FC787D8.4010904@hitachi.com>
	  <1338477346.13348.351.camel@gandalf.stny.rr.com>
	  <4FC8C557.9010407@hitachi.com>
	 <1338560427.13348.466.camel@gandalf.stny.rr.com>
	 <4FCC9FC8.7060302@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 20:45 +0900, Masami Hiramatsu wrote:
> (2012/06/01 23:20), Steven Rostedt wrote:
> > On Fri, 2012-06-01 at 22:36 +0900, Masami Hiramatsu wrote:
> > 
> >> OK, so I've introduced new noprobe tag and replaced __kprobes
> >> with it. And now __kprobes tag which is a combination of noprobe
> >> and notrace, means that the function is not probed and it can be
> >> called from kprobe handler. (thus user must use this with their
> >> handlers and functions which will be used from the handlers)
> >> And also most of __kprobes tags are replaced by noprobe only.
> > 
> > You still haven't answered my question. Why can't function tracer still
> > trace these? If kprobes does not allow it to be probed, it should not
> > interfere with your code. But normal function tracing should still allow
> > these.
> 
> Because those are called from ftrace-based kprobe, which means

But if it has kprobes annotation on it, you can't put a kprobe on it,
thus you can't kprobe function trace on it. But function tracing should
not interfere with kprobe tracing. You can trace these functions with
other function tracers without bothering kprobes. Function tracing
should handle this.

> it is directly invoked from kprobe_ftrace_handler.

So what? ftrace only calls the callbacks to functions that you ask to be
called back for. If you put a probe on scheduler, your call back will
only see the schedule function. It will not see the stack tracer tracing
timers and everything else. The two are agnostic.


>  I think
> that should be handled as a part of ftrace handler.

NO! Why should we limit function tracing just because one of its users
can't call some functions?

How does this make it any different than what it is today? It's just an
optimization for kprobes. Being able to trace things that kprobes can
not, should cause no issue for kprobes. Why would NMI tracing affect
kprobes using function tracer?

Show me an example of a problem that you see.

> Currently, I just added notrace on below two kind of functions
> 
>  - handler functions which can be called intermediately from ftrace

Do they currently break ftrace?

>  - get_kprobe, set_kprobe_instance, etc. internal utility functions
>    which is called directly from kprobe ftrace handler.

Why can't we function trace these?  Note, if we have two function
tracers, A and B. And A's handler calls something that B traces, it
should not be an issue, as long as B does not call something that A
traces.

Now if this does happen, it is trivial to add recursion protection in
the function tracer code itself. Such that B's handler will not be
called if A calls something B traces.

If we just add notrace all over the kernel to protect against this, soon
there will be nothing left to trace.


> 
> 
> > I still do not understand why you need to add 'notrace' at all.
> 
> Because I'd like to solve a recursive call problem.
> 
> I saw a problem which I hit some odd function tracer behavior.
> When I removed notrace from get_kprobe(), which is an essential
> internal function called directly from kprobe_ftrace_handler,
> I hit a kernel crash caused by recursive call right after I
> registered kprobe_ftrace_handler to ftrace. At that time,
> ftrace_ops.filter was empty so I thought there is no function
> traced, but the kprobe_ftrace_handler was called from somewhere.
> So I saw it hit a recursive loop of ftrace_call ->
> kprobe_ftrace_handler -> get_kprobe -> ftrace_call ...

OK, then the recursion protection I want to add will solve this. But why
would the ftrace_call call the kprobe_ftrace_handler? You should be
setting up the filter before registering the trace.

> 
> I think if I just register kprobe's ftrace_ops without start
> tracing, I think we can just do tracing without "notrace".

You should be able to register the filter first, and then register
function tracer. If you register without setting the filter, you will
start tracing all functions.

I think that may be the problem you are seeing. You want to register the
filter first and then the ftrace_ops.

> 
> >> This means that you can trace those by function tracer :)
> >>
> >> BTW, currently kprobes allows user cases pagefault in their
> >> handler (kprobe.fault_handler will handle it). I guess that
> >> can cause some problem with ftrace, isn't it? If so, I need
> >> to deny a kprobe using ftrace if it has fault_handler.
> > 
> > As long as there's recursion protection you are fine. In fact, I may add
> > recursion protection within the assembly itself, that will make all
> > function tracing safe. (does not solve the breakpoint bug from the other
> > thread, but will solve most other things). In fact, this may allow us to
> > remove notraces that were added because of recursion issues.
> 
> OK, I think kprobe already solves that as long as
> get_kprobe and kprobe_running doesn't cause recursion...

I think the issue is to register the filter first. But I still need to
prevent that recursion protection.

-- Steve

