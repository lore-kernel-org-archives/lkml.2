Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1E3LkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:40:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45040 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1E3LkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MnpXa7JWJlaXt5gwf8Jjp43edEsbnC+5oELB8vF03ih25iGNxSjwXlt7Gn7019Cjxf
         UZiQHURLIxBweO78xZH+M+xc0rrsRN8jPtapGZlqlC+XbqAR3Vlls/k5Nbq7CuRqMslD
         EonJjaeM/Dk21jtE+HS9GU3bLG9H1VHYNuvYY=
MIME-Version: 1.0
In-Reply-To: <20110530084906.GA11773@htj.dyndns.org>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
 <20110525143250.GJ10146@htj.dyndns.org> <201105300528.17384.vda.linux@googlemail.com>
 <20110530084906.GA11773@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 30 May 2011 13:40:03 +0200
Message-ID: <BANLkTinYRKKZL-9zntYuxLoa9NxSo70JGA@mail.gmail.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:49 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, May 30, 2011 at 05:28:17AM +0200, Denys Vlasenko wrote:
>> On Wednesday 25 May 2011 16:32, Tejun Heo wrote:
>> > >   1.x execve under ptrace.
>> > >
>> > ...
>> > >   ** we get death notification: leader died: **
>> > >  PID0 exit(0)                            = ?
>> > >   ** we get syscall-entry-stop in thread 1: **
>> > >  PID1 execve("/bin/foo", "foo" <unfinished ...>
>> > >   ** we get syscall-entry-stop in thread 2: **
>> > >  PID2 execve("/bin/bar", "bar" <unfinished ...>
>> > >   ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
>> > >   ** we get syscall-exit-stop for PID0: **
>> > >  PID0 <... execve resumed> )             = 0
>> > >
>> > > ??? Question: WHICH execve succeeded? Can tracer figure it out?
>> >
>> > Hmmm... I don't know.  Maybe we can set ptrace message to the original
>> > tid?
>>
>> The problem with execve is bigger than merely reporting this pid.
>>
>> Consider how strace tracks its tracees. Currently, it remembers
>> their pids - sometimes by remembering clone's return values!
>> This is hopelessly broken wrt pid namespaces.
>
> I'm not too familiar with pid namespaces but don't all threads of the
> same process belong to the same namespace?  I don't think strace would
> need to track pids all the time.  It just needs to store pids of
> in-flight exec's and match it on exec completion.  I'm probably
> missing something but why wouldn't that work?

I think I was not clear (or elaborate) enough. I am not worrying
about "two execve's in two threads at once" scenario. I am worried about
the following scenario:

* strace is run as "strace -f PROG ARGS" - that is, "trace children too" mode.
* PROG forks a few times. Now strace traces several processes.
* Now some of those processes create threads. Now, strace traces
several processes, some (or even all) of them are multi-threaded.
* From strace POW, it just knows a bunch of pids it traces. It doesn't
maintain information who is whose parent *or sibling*.
* One of threads in one of the processes execves.
* Because of execve, _some_ threads (not _all_ straced pids, but only some!),
more precisely, only those which comprise the thread group
of the execve'ing thread, are dying, and execve'ing thread
changes its pid on syscall exit and continues executing
as a thread leader of the newly forked, (so far) single-threaded process.
* PROBLEM: how strace knows which of its tracees are dead now?

IOW: consider the following program (pseudo-C):

/* we are pid0 now: thread leader. Single-threaded so far... */
/* create an ordinary child (not a thread) */
child = fork();
if (child==0) { sleep(0.001); exit(0); }
/* create two threads */
pid1 = clone();
pid2 = clone();
/* we have three threads now */
if (we are not pid2) sleep(1); else execve("/proc/self/exe");
/* pid0 and pid1 died, pid2 execve'ed and become "new" pid0 */
/* go back to the beginning */

Now imagine that you run it under "strace -f".
If on execve strace would not bother deleting malloced
struct tcb's which correspond to each running thread,
it will leak memory on each execve.
And because of the fork, it cannot delete ALL struct tcb's
on execve - the child is not killed by execve, it must be
still tracked!


>> This works (I have a patch against a somewhat older strace),
>> but now in light of this "interesting" execve-under-ptrace
>> behavior it appears to have a flaw: all threads except the
>> execve'ing one disappear without any notification to strace,
>> therefore strace doesn't know which tracee data ("struct tcb"
>> in strace-speak) need to be dropped!
>>
>> I am not sure current strace handles this correctly either.
>> I will be very surprised if it does.
>>
>> I think the API needs fixing. Tracee must never disappear like that
>> on execve (or in any other case). They must always deliver a
>> WIFEXITED or WIFSIGNALED notification, allowing tracer to know
>> that they are gone. We probably also need to document how are these
>> "I died on execve" notifications are ordered wrt PTRACE_EVENT_EXEC
>> stop in execve-ing thread.
>
> A problem is that by the time de-threading is in progress, it's
> already too deep and there's no way back and the exec'ing thread has
> to wait for completion in uninterruptible sleeps - ie. it expects
> de-threading to finish in finite amount of time and to achieve that it
> basically sends SIGKILL to all other threads.

Which is fine. Can we make the death from this "internal SIGKILL"
visible to the tracer of killed tracees?


>  If we introduce a trap
> in de-threading itself, we can easily end up with an unkillable
> task.

I don't see the need to ensure that de-threading deaths are visible to tracer
before execve returns. They can be queued and seen by tracer later.


-- 
vda
