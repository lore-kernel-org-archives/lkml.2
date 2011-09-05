Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1IEJYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:24:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33294 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1IEJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:24:15 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
Date: Mon, 5 Sep 2011 11:24:09 +0200
User-Agent: KMail/1.8.2
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com
References: <201109042311.18793.vda.linux@googlemail.com> <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
In-Reply-To: <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109051124.09775.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011 03:15, Indan Zupancic wrote:
> > We already have a mechanism how to modify ptrace behavior: ptrace options.
> > But now we introduce a different mechnism to do the same: by using SEIZE
> > instead of ATTACH, we magically change some aspects of ptrace.
> > In effect, SEIZE sets some options. And these "SEIZE options" can't be
> > set or cleared by SETOPTIONS. This is stupid. Why can't we just add
> > more options instead of inventing new entities?
> 
> Exactly my feeling!
> 
> > Why we overloaded
> > SEIZE with two functions: "attach to, but don't SIGSTOP the tracee"
> > and "change behaviour of ptrace on this tracee"?
> >
> > If the argument is that we want to set options immediately at attach,
> > then I completely agree: yes, we do! Moreover, we want to set some
> > _ordinary_ options too, such as PTRACE_O_TRACEEXEC, and we can't
> > do that even now, in improved API! It needs more improving.
> >
> > So my proposal is:
> > (a) make SEIZE take a parameter "immediately set these options on attach"
> 
> I think that would be a great improvement.
> 
> Better than making SEIZE an option itself, which I wanted to propose, but
> never got to.

Can't do. In pre-existing ptrace API, options can be set only after attach.
Therefore, it's not possible to set an option which affects ATTACH behavior.


> > (b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
> >     nothing more.
> > (c) make the following new PTRACE_O_foo options:
> >    (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"
> 
> Why would anyone use that flag?

Well, it's nice to not require GETSIGINFO in order to know whether this stop
is group-stop.

> Most users are unaware of the crazy subtle SIGSTOP notification madness.
> It is totally unnecessary, just fix waitid() 
> to honour the absence of the WUNTRACED flag for traced processes.

Can't do. Existing programs depend on current ptrace behavior.

> I can't 
> think of any useful scenario where calling waitid() with WUNTRACED set on
> a traced task makes much sense, as the same information is received via
> ptrace.

Can't do. Existing programs depend on current ptrace behavior.


> The other part of a simpler, less crazy ptrace is let PTRACE_CONT not
> automatically continue a SIGSTOPped process.

Can't do. gdb depends on current ptrace behavior that PTRACE_CONT
restarts tracee after SIGSTOP.


> >    (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with sig=SIGTRAP
> >         if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
> >        [if the second part is too weird to implement, make (2) require (1)]
> 
> I don't understand the need for PTRACE_INTERRUPT: Sending some signal, trapping,
> and PTRACE_CONT with zero "data" should have the same effect.

Except that sending a signal will race with someone else sendng the same signal.
It's nicer when this can be avoided.


> Or do you mean that 
> instead of SIGSTOP, SIGTRAP should be sent? If so, yes, that would be much saner.

Yes, that's how it works in 3.1 already.


> >    (3) "enable PTRACE_LISTEN. Works on group-stops even without any other options"
> 
> This is a symptom of the complexity I whined about above.
> 
> If ptrace has no influence on group stops then PTRACE_LISTEN is not needed at all.
> The problem seems to be that SIGSTOP state is the same as ptrace trapped state, or
> something like that. Group stops and ptrace stops should be totally orthogonal.
> Then crazy things like PTRACE_LISTEN are not needed.
> 
> Why not just untangle the two concepts? (Via PTRACE_O_SANE.)

You are a bit late to the party. Thre was a LONG discussion how to implement
proper group-stop handling. You need to write a much more detailed proposal
than this vague suggestion "let's add one flag which makes everythng better".
How EXACTLY this flag will change ptrace bhavior?


> >    (5) "enable saner error codes"
> 
> Why do you need a new option for this? Ptrace error codes are close to useless,
> how can returning better error codes ever cause problems?

Now ESRCH means "no such process, or process is not attached to us, or process
is not stopped (it is running), or process has exited (it is a zombie now)".
I'd like to make it into four different error codes.


> > In fact, I am unsure why the new ops (points 2 and 3 above) need enabling.
> > Maybe they can be simply be always allowed? Let's see...
> 
> My advise is to untangle all ptrace and group stop state from each other
> with one PTRACE_O_SANE option. That would replace options 1 to 4. This
> gives perhaps less choice, but considering how subtle it already is, I
> don't think that simplifying everything is a bad thing.

Again, please write a document how proposed PTRACE_O_SANE affects ptrace.
*In details*.


> > Re PTRACE_INTERRUPT: "old-style" check for group-stop,
> > namely, "if ptrace(PTRACE_GETSIGINFO) fails, then it's group-stop",
> 
> BTW, no one is going to use and know this, except perhaps ten people in the
> whole world.

It is documented behavior. Latest released strace already uses it.


> Everyone else just thinks that ptrace doesn't pass on SIGSTOP, 
> as the manpage says, and that the double SIGSTOP event is just a quirk.

We have an updated manpage. We are trying to push it into manpages git.


> > 		if (!WIFSTOPPED(status)) ... /* error, should not happen */
> 
> It may happen if you're tracing a child process and are getting a normal SIGCHLD?

What?


> > ...and here we decide to use either PTRACE_SYSCALL or PTRACE_LISTEN,
> > _based on the value of "stopped" variable_. Here we PTRACE_LISTEN only if
> > use_seize is true, but we use that flag only as indicator "this is a new kernel".
> > It's easy to see that there are no intrisic reasons
> > why it can't also work on newer kernels, but after using old-style ATTACH.
> 
> So you're emulating normal group stop behaviour in the tracer, adding band-aids
> that make that possible, instead of avoiding these problems by making ptrace
> totally transparent for group stop state? Wouldn't it all be much simpler if
> ptrace didn't mess with group stop state?

As I said, gdb already depends on current ptrace behavior. We can't break it.

-- 
vda
