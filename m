Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1E3Qo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:44:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab1E3Qo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:44:26 -0400
Date: Mon, 30 May 2011 18:42:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation,
	draft #3)
Message-ID: <20110530164252.GB11325@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <20110525143250.GJ10146@htj.dyndns.org> <201105300528.17384.vda.linux@googlemail.com> <20110530084906.GA11773@htj.dyndns.org> <BANLkTinYRKKZL-9zntYuxLoa9NxSo70JGA@mail.gmail.com> <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Denys Vlasenko wrote:
>
> On Mon, May 30, 2011 at 1:40 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
> >
> > Which is fine. Can we make the death from this "internal SIGKILL"
> > visible to the tracer of killed tracees?
>
> Ok, let's take a deeper look at API needs. What we need to report, and when?

OK. but I'm afraid I am a bit confused ;)

> We have three kinds of threads at execve:
> 1. execve'ing thread,
> 2. leader, two cases: (2a) leader is still alive, (2b) leader has exited by now.
> 3. other threads.
>
> (3) is the most simple: API should report death of these threads.
> There is no need to ensure these death notifications are reported
> before execve syscall exit is reported.

I guess you mean PTRACE_EVENT_EXIT? Probably yes,

> They can be consumed
> by tracer later.

by wait(WEXITED), OK.

> (1) execve'ing thread is obviously alive. current kernel already
> reports its execve success. The only thing we need to add is
> a way to retrieve its former pid, so that tracer can drop
> former pid's data, and also to cater for the "two execve's" case.

This is only needed if strace doesn't track the tracee's tgids, right?

> PTRACE_EVENT_EXEC seems to be a good place to do it.
> Say, using GETEVENTMSG?

Yes, Tejun suggested the same. Ignoring the pid_ns issues, this is trivial.
If the tracer runs in the parent namespace it is not, we can't simply
record the old tid. Lets ignore the problems with namespaces for now...

> (2) is the most problematic. If leader is still alive, should
> we report its death? This makes sense since if we do,
> and if we ensure its death is always reported before
> PTRACE_EVENT_EXEC,

Note that we simply can't report this after PTRACE_EVENT_EXEC because
its tid was already re-used by the new group leader.

And it is not trivial to report this before. Even if we forget about
the technical problems, please recall that wait() can't work in this
case. Forget about de_thread/exec, suppose that the group leader simply
exits before other threads. Yes, we are going to change this somehow.

But I am not sure it really makes sense to report the death of the old
leader. Why? We know for sure it is already dead at PTRACE_EVENT_EXEC
time, but at the same time it is better to pretend that it is not dead,
it is the execve'ing thread who should be considered dead in some sense.

IOW. Two threads, L is the leader with tid == tgid == 100, and T with
tid = 101. T does execve(). After that we have the process with the
same tgid and its new leader has tid == 100 as well. If we forget about
the actual implementation, it is T who silently disappears, not L.

OTOH, there is a problem: we should trace them both. Otherwise, if we
only trace L, even GETEVENTMSG can't help. And this means we can only
rely on PTRACE_EVENT_EXIT currently. Which needs fixes ;) We could add
another trap, but why it would be better?

In short: I do not think we can make what you want (assuming I understand
your suggestion correctly). Consider the simple example: we are tracing
the single thread and it is the group leader, another (untraced) thread
execs. I do not think we should change de_thread() so that the execing
thread should sleep waiting for waitpid(traced_leader_pid, WEXITED)
from the tracer before it reuses its pid. And in any case, even if we
do this, we should solve another problem with the dead group leader
first.

> We definitely must ensure, though, that if leader races with
> execve'ing thread and enters exit(2), its death is never reported
> *after* PTRACE_EVENT_EXEC

Yes... but this is not possible?

Oleg.

