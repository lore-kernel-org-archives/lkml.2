Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1CGUo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:44:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CGUoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:44:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
In-Reply-To: Tejun Heo's message of  Tuesday, 1 March 2011 16:24:57 +0100 <20110301152457.GE26074@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20110307204346.19557183C29@magilla.sf.frob.com>
Date: Mon,  7 Mar 2011 12:43:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've only skimmed through this whole thread, and I'm not going to try to
respond to all the details.  I've lost interest in working in this area
and I don't plan to keep up with all the details any more.  If you want
to reach me about kernel subjects after March 11, you'll need to use the
address <roland@hack.frob.com> as I won't be getting @redhat.com any more.

I'll just give you a few thoughts that I don't think have been raised.
Then I'll leave it to Oleg and the rest of you to decide how to move
forward.

I've said before more than once what I think are the important
principles about compatibility that ought to be maintained so as not to
break existing applications such as older versions of GDB and strace
(not to mention things less well-known and not publically visible, where
code has come to depend on details of ptrace behavior and there may not
even be anyone who really knows what they are depending on by now).
When real-world applications have worked in practice, even if the
behavior they were seeing was not pedantically reliable, they should not
be broken.  Saner behavior can be provided when new requests or new
options are used, without breaking any old usage.

I see the appeal of the PTRACE_SEIZE idea, and I don't dismiss it
entirely.  But I am quite skeptical that this is a good approach to be
the sole new mechanism to replace PTRACE_ATTACH with something sane and
predictable.  There are a few things that concern me.

A problem long identified with ptrace is that there is no way to attach
or detach without perturbing some of the user-visible behavior of the
traced threads.  (There will always be some perturbation of the timing
of the thread's activities, but I mean factors other than that alone.)
Not overloading SIGSTOP is certainly an improvement.  But, PTRACE_SEIZE
still has this problem in ways that the proposed PTRACE_ATTACH_NOSTOP
does not.  For any passive tracing use (such as strace -p), you don't
actually want the thing to stop right away, you only want it to stop
when a new event happens (such as the next syscall entry/exit).  The
PTRACE_SEIZE idea does not give the option of attaching without any
perturbation when you don't care about "seizing".

Anything that works via interruption can perturb the user-visible
behavior of a system call already in progress.  It would be nice if all
uninterruptible waits were truly reliably short and if all system call
paths supported syscall restart thoroughly so that they could be
interrupted with TIF_SIGPENDING and then restarted (a la SA_RESTART, or
its equivalent when there is no actual signal to handle) with no change
in semantics that userland can perceive (aside from timing).  But it
just isn't so, and the way the kernel is organized makes it a difficult
and open-ended task (perhaps an impossible one for some cases) to try to
hunt down and fix every violation of that principle or to prevent
introductions of new violations in the future.

The PTRACE_INTERRUPT idea addresses this in two key ways.  Firstly, it's
a separate request not unavoidably implied by attaching, so tracers have
the option of simply not doing it if they don't want to perturb the
tracee at all.  Second, the PTRACE_INTERRUPT idea came with a variant
that's either a parallel request PTRACE_REPORT, or option flags in the
one request, or whatever, that does not interrupt at all.  Instead, it
uses the TIF_NOTIFY_RESUME mechanism (see set_notify_resume() in
linux/tracehook.h) to arrest all user-mode activity without affecting
kernel-mode activity at all (hence, the report/stop may not be immediate
at all if the thread might block in the kernel, but it will immediately
guarantee that no more user instructions will run before a report).
These possibilities give an intelligent tracer the opportunity to
control the user thread in the ways it needs to while avoiding
perturbation of the user-visible semantics of kernel operations.

The other areas of concern with PTRACE_SEIZE are its robustness and
scalability.  The whole point of this request is that the one ptrace
call does a full synchronization with the tracee, blocking until it has
been interrupted and stopped.  This necessarily entails some ping-pong
scheduling to interrupt the thread, yield to it, and wait for it to
stop, and yield back to the tracer thread.  That's fine and useful to
roll into one kernel operation when you want to synchronously arrest a
single tracee thread.  But there are two problems there.

For robustness, the PTRACE_SEIZE block itself must be interruptible.
If the tracer thread will block arbitrarily waiting for the tracee
thread to finish up its kernel activities and stop, then it would be
irresponsible to make it impossible for the tracer thread to be
interrupted from this block.  If it does get interrupted, then in what
state does it leave the tracee?  Normal principles of interrupted and
restartable calls would suggest that it leave the tracee as it was
before, i.e. unattached.  Is that the plan?  If not, then would it
leave the tracee attached but not "seized", which defeats the whole
purpose of simple and predictable behavior for the tracer.  If the
call is not interruptible at all, then that's a recipe for permanently
wedged debugger threads and that's just a lousy thing to permit.  Of
course the bare minimum would be to make it a noninterruptible but
killable wait (TASK_KILLABLE), meaning all you can do is SIGKILL a
wedged debugger.  That's better than nothing, but it's hardly good
enough to allow one to write a robust debugger in any sensible fashion.

Finally, there is the scalability concern.  This synchronization delay
happens inside each single PTRACE_SEIZE call acting on one tracee
thread.  When a debugger wants to attach to a process, it wants to
attach to all the threads in that process, and there can be thousands.
For that to work at all reasonably with nontrivial numbers of threads,
the act of attaching to each individual thread should be asynchronous.
>From the debugger implementor's perspective, it's certainly even more
desireable to have a single kernel call that will attach to all the
threads in the process.  But that needs to be scalable as well, and
it's not necessarily at all what the debugger wants that you stop each
and every thread at attach time.

None of this means at all that PTRACE_SEIZE is worthless.  But it is
certainly inadequate to meet the essential needs that motivate adding
new interfaces in this area.  The PTRACE_ATTACH_NOSTOP idea I
suggested is far from complete for all the issues as well, but it is a
more versatile building block than PTRACE_SEIZE.

I don't intend to debate all these subjects.  As I said, I'm no longer
going to work on this area of the kernel.  I'm glad Oleg and Tejun are
putting effort into improving it, regardless of how the details shake
out.  I've raised some issues that I think have been overlooked by the
discussion so far.  I hope they'll now be considered more carefully in
how the work moves forward.


Thanks,
Roland
