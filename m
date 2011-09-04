Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1IDVL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:11:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56463 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1IDVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:11:23 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: RFC: PTRACE_SEIZE needs API cleanup?
Date: Sun, 4 Sep 2011 23:11:18 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, dvlasenk@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109042311.18793.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I added code to use PTRACE_SEIZE in strace and in the process
had tasted how API looks like from userspace POV.

It is usable, but API feels somewhat quirky.

Consider the following: one of reasons why we added PTRACE_SEIZE
is that existing ptrace API has unnecessary complications
(quirks) such as SIGSTOP on attach, SIGTRAP after execve.

But whoever designed strace did not deliberately designed these quirks in,
he thought it was a good, reasonable design. Only after a second, third,
tenth look it became obvious in retrospect that some things are
not exactly right.

Thankfully, quirks in new PTRACE_SEIZE code mostly have the nature of
"unnecessarily invented entities" as opposed to problems
in trying to use API in real world tasks, but I still think they are
annoying enough to be looked at.


We already have a mechanism how to modify ptrace behavior: ptrace options.
But now we introduce a different mechnism to do the same: by using SEIZE
instead of ATTACH, we magically change some aspects of ptrace.
In effect, SEIZE sets some options. And these "SEIZE options" can't be
set or cleared by SETOPTIONS. This is stupid. Why can't we just add
more options instead of inventing new entities? Why we overloaded
SEIZE with two functions: "attach to, but don't SIGSTOP the tracee"
and "change behaviour of ptrace on this tracee"?

If the argument is that we want to set options immediately at attach,
then I completely agree: yes, we do! Moreover, we want to set some
_ordinary_ options too, such as PTRACE_O_TRACEEXEC, and we can't
do that even now, in improved API! It needs more improving.

So my proposal is:
(a) make SEIZE take a parameter "immediately set these options on attach"
(b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
    nothing more.
(c) make the following new PTRACE_O_foo options:
   (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"
   (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with sig=SIGTRAP
        if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
       [if the second part is too weird to implement, make (2) require (1)]
   (3) "enable PTRACE_LISTEN. Works on group-stops even without any other options"
   (4) "make auto-attached children stop a-la INTERRUPT, not with SIGSTOP"
   (5) "enable saner error codes"
(d) Remove magic hidden 'I was SEIZEd, not ATTACHed' bit in kernel code.
    Use bits 1,2,3,4 instead of it.
(e) Make these bits settable with SETOPTIONS too, to keep API complete.

In strace, I already implicitly use 1,2,3,4. With this proposal, I'd use
all five, *explicitly*, and also use at least PTRACE_O_TRACEEXEC,
to avoid the possibility SEIZE races with execve and we get that pesky SIGTRAP.
Something along the lines:

	ptrace(PTRACE_SEIZE, pid, 0,
		PTRACE_O_TRACEEXEC
		| PTRACE_O_TRACESTOP      /* (1) */
		| PTRACE_O_TRACEINTERRUPT /* (2) */
		| PTRACE_O_TRACELISTEN    /* (3) */
		| PTRACE_O_TRACECHILDSTOP /* (4) */
		| PTRACE_O_TRACEERRCODES  /* (5) */
	);

This will remove the need to set options on first ptrace stop.

This will remove the asymmetry we just introduced in current SEIZE code:
PTRACE_EVENT_STOP is the only event code which has no corresponding
PTRACE_O_TRACESTOP option - situation which Occam disapproves.


In fact, I am unsure why the new ops (points 2 and 3 above) need enabling.
Maybe they can be simply be always allowed? Let's see...

Re PTRACE_INTERRUPT: "old-style" check for group-stop,
namely, "if ptrace(PTRACE_GETSIGINFO) fails, then it's group-stop",
works just fine, therefore, from userspace POV there is no apparent reason
why PTRACE_INTERRUPT can't work without "flag stops with PTRACE_EVENT_STOP"
thingy: in this case it can create an
"WIFSTOPPED(status) = true, ptrace(PTRACE_GETSIGINFO) fails"
event which is detectable in userspace. PTRACE_EVENT_STOP is not needed for this,
it's just a "nice to have" thing (it saves one ptrace call).

Re PTRACE_LISTEN: similarly to above, we _do_ know when we are in
group-stop, even without (1) "flag stops with PTRACE_EVENT_STOP" thingy.
Therefore we do know when PTRACE_LISTEN makes sense.
Moreover, we can make it so that kernel errors out if PTRACE_LISTEN
is used in a ptrace stop of a wrong kind.


Just to let you see the relevant userspace code which made me think about
the above issues, here is abridged version of main waitpid loop in strace.
Note that it is coded in a way that it works both on SEIZE-enabled
kernels and on old kernels, which have no SEIZE and friends.
"use_seize" variable is set if we are on a SEIZE-enabled kernel:

	while (nprocs != 0) {
		pid = waitpid(-1, &status, __WALL);
		if (pid < 0) ...

		/* Look up 'pid' in our table of known tracees */
		tcp = pid2tcb(pid);
		if (tcp == NULL) {  /* Not found. It's auto-attached child */
			tcp = alloctcb(pid);
// post_attach_sigstop is == 0 if use_seize, or == TCB_IGNORE_ONE_SIGSTOP otherwise
// Basically, it's "do we expect to filter out one SIGSTOP"?
			tcp->flags |= TCB_ATTACHED | TCB_STARTUP | post_attach_sigstop;
		}

		if (WIFSIGNALED(status)) {
			...
			continue;
		}
		if (WIFEXITED(status)) {
			...
			continue;
		}
		if (!WIFSTOPPED(status)) ... /* error, should not happen */

		/* Is this the very first time we see this tracee stopped? */
		if (tcp->flags & TCB_STARTUP) {
			tcp->flags &= ~TCB_STARTUP;
			if (ptrace(PTRACE_SETOPTIONS, tcp->pid, NULL, ptrace_setoptions) < 0)
				if (errno != ESRCH)
					perror_msg_and_die("PTRACE_SETOPTIONS");
		}
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
this if() will not be needed if we set options on attach!

		sig = WSTOPSIG(status);

		if (((unsigned)status >> 16) != 0) { /* Ptrace event */
			unsigned ev = (unsigned)status >> 16;
			if (ev == PTRACE_EVENT_STOP && sig != SIGTRAP) {
					stopped = 1;
					goto show_stopsig;
				}
			}
			goto restart_tracee_with_sig_0;
		}

		/* Is this post-attach SIGSTOP?
		 * Interestingly, the process may stop
		 * with STOPSIG equal to some other signal
		 * than SIGSTOP if we happend to attach
		 * just before the process takes a signal.
		 */
		if (sig == SIGSTOP && (tcp->flags & TCB_IGNORE_ONE_SIGSTOP)) {
			tcp->flags &= ~TCB_IGNORE_ONE_SIGSTOP;
			goto restart_tracee_with_sig_0;
		}

		if (sig != syscall_trap_sig) {
			siginfo_t si;

			/* Nonzero (true) if tracee is stopped by signal
			 * (as opposed to "tracee received signal") */
			stopped = ptrace(PTRACE_GETSIGINFO, pid, 0, &si);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
here is how we determine whether it is group-stop or signal-delivery stop
for the "we didn't use SEIZE" case (if we used SEIZE, we would not
come here on group-stop: see ev == PTRACE_EVENT_STOP check
and "goto show_stopsig" above).

 show_stopsig:
			if (cflag != CFLAG_ONLY_STATS && (qual_flags[sig] & QUAL_SIGNAL)) {
				printleader(tcp);
				if (!stopped) {
					tprints("--- ");
					printsiginfo(&si, verbose(tcp));
				} else
					tprintf("--- stopped by %s ---", signame(sig));
				printtrailer();
			}

...and here we decide to use either PTRACE_SYSCALL or PTRACE_LISTEN,
_based on the value of "stopped" variable_. Here we PTRACE_LISTEN only if
use_seize is true, but we use that flag only as indicator "this is a new kernel".
It's easy to see that there are no intrisic reasons
why it can't also work on newer kernels, but after using old-style ATTACH.
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			if (!stopped)  /* It's signal-delivery-stop. Inject the signal */
				goto restart_tracee;

			/* It's group-stop */
			if (use_seize) {
				/* This ends ptrace-stop, but does _not_ end group-stop */
				if (ptrace_restart(PTRACE_LISTEN, tcp, 0) < 0) ... /* err, doesn't happen */
				continue;
			}
			/* Old kernel, no support for PTRACE_LISTEN */
			goto restart_tracee;
		}

		/* This is syscall entry or exit */
		if (trace_syscall(tcp) < 0 && !tcp->ptrace_errno) {
			...drop this tracee, it died...
			continue;
		}

 restart_tracee_with_sig_0:
		sig = 0;
 restart_tracee:
		if (ptrace_restart(PTRACE_SYSCALL, tcp, sig) < 0) ... /* err, doesn't happen */
	}
