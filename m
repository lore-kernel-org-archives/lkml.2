Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1IEBka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 21:40:30 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44684 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1IEBkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 21:40:24 -0400
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Sep 2011 21:40:24 EDT
Message-ID: <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109042311.18793.vda.linux@googlemail.com>
References: <201109042311.18793.vda.linux@googlemail.com>
Date: Mon, 5 Sep 2011 03:15:39 +0200
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 9e13065cce8b87bd20841a69ad89ba06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry to be a bother again, especially because I didn't get to
read all patches yet (360 unread emails, including resends,
not sure where to start catching up), but first couple series
looked good, up to the PTRACE_SEIZE stuff. Anyway, here's my
feedback, feel free to ignore. Keep in mind this is more about
the new ptrace stuff than just the proposed API improvements,
which are IMHO a big step in the right direction, and that I
only have a partial and hazy (user space) view on these things.

On Sun, September 4, 2011 23:11, Denys Vlasenko wrote:
> Hi guys,
>
> I added code to use PTRACE_SEIZE in strace and in the process
> had tasted how API looks like from userspace POV.
>
> It is usable, but API feels somewhat quirky.

Yes, that was my impression too. To me it seems like most complexity is
caused by not hiding ptrace stops, but instead tangling it up with group
stop signals. This shows as a more complex than needed implementation and
a subtle and quirky API. But I haven't looked at the details enough to
more clearly pinpoint the problems, so feel free to totally ignore my
impression. At least till I come up with better arguments.

> Consider the following: one of reasons why we added PTRACE_SEIZE
> is that existing ptrace API has unnecessary complications
> (quirks) such as SIGSTOP on attach, SIGTRAP after execve.

Not sure if it's still the case, but from reading earlier patches
I got the impression it only got worse, instead of seizing the
opportunity to simplify everything.

> But whoever designed strace did not deliberately designed these quirks in,
> he thought it was a good, reasonable design. Only after a second, third,
> tenth look it became obvious in retrospect that some things are
> not exactly right.
>
> Thankfully, quirks in new PTRACE_SEIZE code mostly have the nature of
> "unnecessarily invented entities" as opposed to problems
> in trying to use API in real world tasks, but I still think they are
> annoying enough to be looked at.
>
>
> We already have a mechanism how to modify ptrace behavior: ptrace options.
> But now we introduce a different mechnism to do the same: by using SEIZE
> instead of ATTACH, we magically change some aspects of ptrace.
> In effect, SEIZE sets some options. And these "SEIZE options" can't be
> set or cleared by SETOPTIONS. This is stupid. Why can't we just add
> more options instead of inventing new entities?

Exactly my feeling!

> Why we overloaded
> SEIZE with two functions: "attach to, but don't SIGSTOP the tracee"
> and "change behaviour of ptrace on this tracee"?
>
> If the argument is that we want to set options immediately at attach,
> then I completely agree: yes, we do! Moreover, we want to set some
> _ordinary_ options too, such as PTRACE_O_TRACEEXEC, and we can't
> do that even now, in improved API! It needs more improving.
>
> So my proposal is:
> (a) make SEIZE take a parameter "immediately set these options on attach"

I think that would be a great improvement.

Better than making SEIZE an option itself, which I wanted to propose, but
never got to.

> (b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
>     nothing more.
> (c) make the following new PTRACE_O_foo options:
>    (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"

Why would anyone use that flag? Most users are unaware of the crazy subtle
SIGSTOP notification madness. It is totally unnecessary, just fix waitid()
to honour the absence of the WUNTRACED flag for traced processes. I can't
think of any useful scenario where calling waitid() with WUNTRACED set on
a traced task makes much sense, as the same information is received via
ptrace.

The other part of a simpler, less crazy ptrace is let PTRACE_CONT not
automatically continue a SIGSTOPped process.

Both changes need a new flag of course, e.g. PTRACE_O_SANE.

>    (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with sig=SIGTRAP
>         if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
>        [if the second part is too weird to implement, make (2) require (1)]

I don't understand the need for PTRACE_INTERRUPT: Sending some signal, trapping,
and PTRACE_CONT with zero "data" should have the same effect. Or do you mean that
instead of SIGSTOP, SIGTRAP should be sent? If so, yes, that would be much saner.

>    (3) "enable PTRACE_LISTEN. Works on group-stops even without any other options"

This is a symptom of the complexity I whined about above.

If ptrace has no influence on group stops then PTRACE_LISTEN is not needed at all.
The problem seems to be that SIGSTOP state is the same as ptrace trapped state, or
something like that. Group stops and ptrace stops should be totally orthogonal.
Then crazy things like PTRACE_LISTEN are not needed.

Why not just untangle the two concepts? (Via PTRACE_O_SANE.)

>    (4) "make auto-attached children stop a-la INTERRUPT, not with SIGSTOP"

That would be sane behaviour. But this is just a part of untangling ptrace
from group stops, so is a separate option really needed instead of one that
just makes ptrace behave more sanely in general?

>    (5) "enable saner error codes"

Why do you need a new option for this? Ptrace error codes are close to useless,
how can returning better error codes ever cause problems?

> (d) Remove magic hidden 'I was SEIZEd, not ATTACHed' bit in kernel code.
>     Use bits 1,2,3,4 instead of it.
> (e) Make these bits settable with SETOPTIONS too, to keep API complete.
>
> In strace, I already implicitly use 1,2,3,4. With this proposal, I'd use
> all five, *explicitly*, and also use at least PTRACE_O_TRACEEXEC,
> to avoid the possibility SEIZE races with execve and we get that pesky SIGTRAP.
> Something along the lines:
>
> 	ptrace(PTRACE_SEIZE, pid, 0,
> 		PTRACE_O_TRACEEXEC
> 		| PTRACE_O_TRACESTOP      /* (1) */
> 		| PTRACE_O_TRACEINTERRUPT /* (2) */
> 		| PTRACE_O_TRACELISTEN    /* (3) */
> 		| PTRACE_O_TRACECHILDSTOP /* (4) */
> 		| PTRACE_O_TRACEERRCODES  /* (5) */
> 	);
>
> This will remove the need to set options on first ptrace stop.
>
> This will remove the asymmetry we just introduced in current SEIZE code:
> PTRACE_EVENT_STOP is the only event code which has no corresponding
> PTRACE_O_TRACESTOP option - situation which Occam disapproves.
>
>
> In fact, I am unsure why the new ops (points 2 and 3 above) need enabling.
> Maybe they can be simply be always allowed? Let's see...

My advise is to untangle all ptrace and group stop state from each other
with one PTRACE_O_SANE option. That would replace options 1 to 4. This
gives perhaps less choice, but considering how subtle it already is, I
don't think that simplifying everything is a bad thing.

> Re PTRACE_INTERRUPT: "old-style" check for group-stop,
> namely, "if ptrace(PTRACE_GETSIGINFO) fails, then it's group-stop",

BTW, no one is going to use and know this, except perhaps ten people in the
whole world. Everyone else just thinks that ptrace doesn't pass on SIGSTOP,
as the manpage says, and that the double SIGSTOP event is just a quirk.

> works just fine, therefore, from userspace POV there is no apparent reason
> why PTRACE_INTERRUPT can't work without "flag stops with PTRACE_EVENT_STOP"
> thingy: in this case it can create an
> "WIFSTOPPED(status) = true, ptrace(PTRACE_GETSIGINFO) fails"
> event which is detectable in userspace. PTRACE_EVENT_STOP is not needed for this,
> it's just a "nice to have" thing (it saves one ptrace call).
>
> Re PTRACE_LISTEN: similarly to above, we _do_ know when we are in
> group-stop, even without (1) "flag stops with PTRACE_EVENT_STOP" thingy.
> Therefore we do know when PTRACE_LISTEN makes sense.

It never makes sense...

> Moreover, we can make it so that kernel errors out if PTRACE_LISTEN
> is used in a ptrace stop of a wrong kind.
>
>
> Just to let you see the relevant userspace code which made me think about
> the above issues, here is abridged version of main waitpid loop in strace.
> Note that it is coded in a way that it works both on SEIZE-enabled
> kernels and on old kernels, which have no SEIZE and friends.
> "use_seize" variable is set if we are on a SEIZE-enabled kernel:
>
> 	while (nprocs != 0) {
> 		pid = waitpid(-1, &status, __WALL);
> 		if (pid < 0) ...
>
> 		/* Look up 'pid' in our table of known tracees */
> 		tcp = pid2tcb(pid);
> 		if (tcp == NULL) {  /* Not found. It's auto-attached child */
> 			tcp = alloctcb(pid);
> // post_attach_sigstop is == 0 if use_seize, or == TCB_IGNORE_ONE_SIGSTOP otherwise
> // Basically, it's "do we expect to filter out one SIGSTOP"?
> 			tcp->flags |= TCB_ATTACHED | TCB_STARTUP | post_attach_sigstop;
> 		}
>
> 		if (WIFSIGNALED(status)) {
> 			...
> 			continue;
> 		}
> 		if (WIFEXITED(status)) {
> 			...
> 			continue;
> 		}
> 		if (!WIFSTOPPED(status)) ... /* error, should not happen */

It may happen if you're tracing a child process and are getting a normal SIGCHLD?

>
> 		/* Is this the very first time we see this tracee stopped? */
> 		if (tcp->flags & TCB_STARTUP) {
> 			tcp->flags &= ~TCB_STARTUP;
> 			if (ptrace(PTRACE_SETOPTIONS, tcp->pid, NULL, ptrace_setoptions) < 0)
> 				if (errno != ESRCH)
> 					perror_msg_and_die("PTRACE_SETOPTIONS");
> 		}
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> this if() will not be needed if we set options on attach!
>
> 		sig = WSTOPSIG(status);
>
> 		if (((unsigned)status >> 16) != 0) { /* Ptrace event */
> 			unsigned ev = (unsigned)status >> 16;
> 			if (ev == PTRACE_EVENT_STOP && sig != SIGTRAP) {
> 					stopped = 1;
> 					goto show_stopsig;
> 				}
> 			}
> 			goto restart_tracee_with_sig_0;
> 		}
>
> 		/* Is this post-attach SIGSTOP?
> 		 * Interestingly, the process may stop
> 		 * with STOPSIG equal to some other signal
> 		 * than SIGSTOP if we happend to attach
> 		 * just before the process takes a signal.
> 		 */
> 		if (sig == SIGSTOP && (tcp->flags & TCB_IGNORE_ONE_SIGSTOP)) {
> 			tcp->flags &= ~TCB_IGNORE_ONE_SIGSTOP;
> 			goto restart_tracee_with_sig_0;
> 		}
>
> 		if (sig != syscall_trap_sig) {
> 			siginfo_t si;
>
> 			/* Nonzero (true) if tracee is stopped by signal
> 			 * (as opposed to "tracee received signal") */
> 			stopped = ptrace(PTRACE_GETSIGINFO, pid, 0, &si);
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> here is how we determine whether it is group-stop or signal-delivery stop
> for the "we didn't use SEIZE" case (if we used SEIZE, we would not
> come here on group-stop: see ev == PTRACE_EVENT_STOP check
> and "goto show_stopsig" above).
>
>  show_stopsig:
> 			if (cflag != CFLAG_ONLY_STATS && (qual_flags[sig] & QUAL_SIGNAL)) {
> 				printleader(tcp);
> 				if (!stopped) {
> 					tprints("--- ");
> 					printsiginfo(&si, verbose(tcp));
> 				} else
> 					tprintf("--- stopped by %s ---", signame(sig));
> 				printtrailer();
> 			}
>
> ...and here we decide to use either PTRACE_SYSCALL or PTRACE_LISTEN,
> _based on the value of "stopped" variable_. Here we PTRACE_LISTEN only if
> use_seize is true, but we use that flag only as indicator "this is a new kernel".
> It's easy to see that there are no intrisic reasons
> why it can't also work on newer kernels, but after using old-style ATTACH.

So you're emulating normal group stop behaviour in the tracer, adding band-aids
that make that possible, instead of avoiding these problems by making ptrace
totally transparent for group stop state? Wouldn't it all be much simpler if
ptrace didn't mess with group stop state?

> vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
> 			if (!stopped)  /* It's signal-delivery-stop. Inject the signal */
> 				goto restart_tracee;
>
> 			/* It's group-stop */
> 			if (use_seize) {
> 				/* This ends ptrace-stop, but does _not_ end group-stop */
> 				if (ptrace_restart(PTRACE_LISTEN, tcp, 0) < 0) ... /* err, doesn't happen */
> 				continue;
> 			}
> 			/* Old kernel, no support for PTRACE_LISTEN */
> 			goto restart_tracee;
> 		}
>
> 		/* This is syscall entry or exit */
> 		if (trace_syscall(tcp) < 0 && !tcp->ptrace_errno) {
> 			...drop this tracee, it died...
> 			continue;
> 		}
>
>  restart_tracee_with_sig_0:
> 		sig = 0;
>  restart_tracee:
> 		if (ptrace_restart(PTRACE_SYSCALL, tcp, sig) < 0) ... /* err, doesn't happen */
> 	}
>

Unrelated to this, could someone take a look at "ptrace() behaviour when doing
PTRACE_KILL": https://lkml.org/lkml/2011/8/28/48

I can reproduce the behaviour with on a 2.6.39 kernel, it seems like a ptrace bug.
Basically a tracee manages to execute a kill(2) after the tracer did a PTRACE_KILL
at system call entry.

Greetings,

Indan


