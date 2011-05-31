Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1EaNwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1EaNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:52:52 -0400
Date: Tue, 31 May 2011 15:51:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation,
	draft #3)
Message-ID: <20110531135116.GA4799@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com> <20110530164252.GB11325@redhat.com> <201105310143.12280.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105310143.12280.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Denys Vlasenko wrote:
>
> Let's decide how we want ptrace API to work in this area.
> The behavior I observed with the test program:
>
> 6797: thread 0 (leader): sleeps in pause()
> 6798: thread 1: sleeps in pause()
> 6799: thread 2: execve("/proc/self/exe")
>
> Tracer sees the following:
>
> 6798: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
> 6797: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
> 6798: status:00000000 WIFEXITED exitcode:0
> 6797: status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC
>
> (I tested it with 10 threads and the pattern seems to be the same)
>
> Every thread including leader, but excluding execve'ing one,
> reports EVENT_EXIT.

Yes, this is expected. But let me repeat, there are problems.

The main problem is: it is not clear do we really want EVENT_EXIT
in this case. I think we do, Roland thought we do not. OTOH I never
really the purpose of EVENT_EXIT, but this doesn't matter.

If we decide we do want this notification (in this case), then we
need fixes. EVENT_EXIT is not reliable. Say, the thread can exit
before it dequeues SIGKILL and in this case it doesn't stop.
Also. If we guarantee EVENT_EXIT in this case, then probably the
implicit SIGKILL should not wakeup the TASK_TRACED tracee (except
the new PTRACE_LISTEN case).

In short: currently I do not know what should be documented. I do
not know the original intent, I can only see what the code actually
does. In any case, I strongly believe the code should be changed,
but firtsly we should decide what we want. But not right now,
please ;) There are other connected problems...

> Then every thread. excluding leader and excluding execve'ing one,
> reports WIFEXITED.

Yes.

> ??? do we guarantee that EVENT_EXIT happens?

See above,

> Do we guarantee
> that WIFEXITED happens?

Yes. (excluding leader)

> Note: WIFEXITED of thread 1 can happen before EVENT_EXIT of thread 0.
> IOW: there is no ordering *between* threads for these ptrace-stops.

Sure, why not?

Btw... you are talking about the ordering as it seen by the tracer, it
can differ from the "real" ordering. But this doesn't matter.

> Then we get EVENT_EXEC with pid of the leader.
> execve'ing thread's pid is no longer usable by tracer after this.
>
> ??? do we guarantee that this happens after all EVENT_EXITs and WIFEXITEDs?

Yes. At this time all other threads do not exist.

> > In short: I do not think we can make what you want (assuming I understand
> > your suggestion correctly). Consider the simple example: we are tracing
> > the single thread and it is the group leader, another (untraced) thread
> > execs.
>
> I do not know what would be the right behavior in this case.
> It depends whether we consider "tracedness" to be attached to a pid
> or to a thread of execution.
>
> I think the better (more general) question is "what if both threads
> are traced by _different_ tracers?".

I don't really understand why do you think this is more general...
Nevermind.

> If we think "tracedness" is attached to pid:

No it is not. The tracing is per-thread (task_struct). But the API is
per-pid. The tracee changes its pid. That is all ;)

> First, returning old pid via GETEVENTMSG helps with second
> badness - tracer 1 can fetch it, and understand which of his tracees
> changed pid just now.

OK, we already discussed this. This looks reasonable.

> And second, if we'd return "status:00000000 WIFEXITED exitcode:0" thing
> on execve _for leader too_, then tracer 0 will be happy (it will see consistent
> sequence of events).

Once again, we can only do this before the execing thread changes its
pid. This means that this thread should look at the leader, and if it
is traced it should wait until the tracer does do_wait(). I do not think
this is good.

And, once again, even if we do this, we need to change the current
behaviour with do_wait(ptraced_exited_leader_thread), see another
discussion.

> If it's hard to do, then alternatively, we can add this information
> to EVENT_EXIT somehow. Normally, GETEVENTMSG returns exit status.
> Can be hijack a bit there to say "dont expect WIFEXITED on me"?

Given that this pid will be reused, what does this "me" actually mean?

> Final touch may be to make "I exited because some other thread exec'ed"
> notification different from "I exited because of _exit(0)".
> It would make strace to say what _actually_ happened, which is a good thing.
> Silly ideas department proposes returning WIFSIGNALED, WTERMSIG = 0 ;)

Perhaps, I dunno. Personally I'd prefer to add the new PTRACE_ request
which provides some info about the tracee and its thread group. It can
report tgid, it can report exec-in-progress or group-exit-in-progress.
I don't really know. But in any case I don't think we can change the
current exit_code/etc.

Btw, "I exited because of _exit(0)" is not exactly right. You can use
GETEVENTMSG, it should report SIGKILL.

Oleg.

