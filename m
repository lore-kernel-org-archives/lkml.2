Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1E3XnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:43:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44807 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1E3XnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BtXW0NfhSi7OEXXZDazvX7RLiyHas4rvQhCAvkZHgf8E+m/3AMSldp87N/xIkkKHvR
         yQTYU3MsnoA4utIdBNv79mpaxInu0Wwrs1ZwmPToGLQSg0GIuJ0yVUVIGGngrXygACfR
         vjrrwMM3sVoP/XoJlHQZ9Q0RQAyVKR1Pl7N0k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
Date: Tue, 31 May 2011 01:43:12 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com> <20110530164252.GB11325@redhat.com>
In-Reply-To: <20110530164252.GB11325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105310143.12280.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011 18:42, Oleg Nesterov wrote:
> On 05/30, Denys Vlasenko wrote:
> >
> > On Mon, May 30, 2011 at 1:40 PM, Denys Vlasenko
> > <vda.linux@googlemail.com> wrote:
> > >
> > > Which is fine. Can we make the death from this "internal SIGKILL"
> > > visible to the tracer of killed tracees?
> >
> > Ok, let's take a deeper look at API needs. What we need to report, and when?
> 
> OK. but I'm afraid I am a bit confused ;)

I am trying to write up the ptrace API (in this particular thread, wrt execve).

Basically, I try to sync up your / Jan's / Tejun's knowledge about the following:

* how current kernels are supposed to work, both:
  - what we promise, and
  - what we DON'T promise
    (such as "don't expect ptrace ops to always succeed,
    you may get ESRCH any time", or "wait(WHOHANG) may return spurious 0"...)
* what actually does work (modulo unknown bugs),
* what is known to be "slightly" broken, but likely to be fixed,
  and finally,
* what is broken so hopelessly that some API changes/additions will be needed,


While working on thie document, and thanks to your request to run actual test
with multi-threaded execve, we just discovered that our idea of how API
works now doesn't match reality: other threads do not die silently.
They do emit death notifications. Only execve'ing thread itself
"disappears".

Let's decide how we want ptrace API to work in this area.
The behavior I observed with the test program:

6797: thread 0 (leader): sleeps in pause()
6798: thread 1: sleeps in pause()
6799: thread 2: execve("/proc/self/exe")

Tracer sees the following:

6798: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
6797: status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
6798: status:00000000 WIFEXITED exitcode:0
6797: status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC

(I tested it with 10 threads and the pattern seems to be the same)

Every thread including leader, but excluding execve'ing one,
reports EVENT_EXIT.

Then every thread. excluding leader and excluding execve'ing one,
reports WIFEXITED.

(question to you, Oleg:)
??? do we guarantee that EVENT_EXIT happens? Do we guarantee
that WIFEXITED happens? (If not, do you think we can fix it,
or we are better to not include such a guarantee in the API?)
Do we guarantee the order between them?

Note: WIFEXITED of thread 1 can happen before EVENT_EXIT of thread 0.
IOW: there is no ordering *between* threads for these ptrace-stops.
(I saw reordering with more threads)

Then we get EVENT_EXEC with pid of the leader.
execve'ing thread's pid is no longer usable by tracer after this.

??? do we guarantee that this happens after all EVENT_EXITs and WIFEXITEDs?


> > (1) execve'ing thread is obviously alive. current kernel already
> > reports its execve success. The only thing we need to add is
> > a way to retrieve its former pid, so that tracer can drop
> > former pid's data, and also to cater for the "two execve's" case.
> 
> This is only needed if strace doesn't track the tracee's tgids, right?
> 
> > PTRACE_EVENT_EXEC seems to be a good place to do it.
> > Say, using GETEVENTMSG?
> 
> Yes, Tejun suggested the same. Ignoring the pid_ns issues, this is trivial.
> If the tracer runs in the parent namespace it is not, we can't simply
> record the old tid. Lets ignore the problems with namespaces for now...

Yes, this would make tracee's life much easier if we'd tell it
what was the pid of the tracee which exec'ed, and therefore this pid
is gone.


> OTOH, there is a problem: we should trace them both. Otherwise, if we
> only trace L, even GETEVENTMSG can't help.

In practice, people do this more rarely than tracing every thread.
But anyway, I have an idea...


> And this means we can only 
> rely on PTRACE_EVENT_EXIT currently. Which needs fixes ;)

What is broken?


> In short: I do not think we can make what you want (assuming I understand
> your suggestion correctly). Consider the simple example: we are tracing
> the single thread and it is the group leader, another (untraced) thread
> execs.

I do not know what would be the right behavior in this case.
It depends whether we consider "tracedness" to be attached to a pid
or to a thread of execution.

I think the better (more general) question is "what if both threads
are traced by _different_ tracers?".

Possible answers:


If we think "tracedness" is attached to pid:

tracer 0 (traces leader) sees:
status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC
<continues tracing>

tracer 1 (traces execve'ing thread) sees:
<nothing, tracee is gone>

What is bad about it:
* tracer 2 has no idea whatsoever that its tracee is gone.


If we think "tracedness" is attached to thread (task struct):

tracer 0 (traces leader) sees:
status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
<tracee is gone>

tracer 1 (traces execve'ing thread) sees:
status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC, and pid has changed!

What is bad about it:
* tracer 0 expects yet another notification, "status:00000000 WIFEXITED exitcode:0"
  or similar, but it will never come.
* tracer 1 can be rather confused by getting EVENT_EXEC from a tracee it knows
  nothing about (since the pid has changed!). If it has more than one tracee,
  it can't guess which one did that. (Yes, it can resort to ugly racy hacks...)


I think the second case is "less broken". What API changes can make it better
for userspace?

First, returning old pid via GETEVENTMSG helps with second
badness - tracer 1 can fetch it, and understand which of his tracees
changed pid just now.

And second, if we'd return "status:00000000 WIFEXITED exitcode:0" thing
on execve _for leader too_, then tracer 0 will be happy (it will see consistent
sequence of events).
If it's hard to do, then alternatively, we can add this information
to EVENT_EXIT somehow. Normally, GETEVENTMSG returns exit status.
Can be hijack a bit there to say "dont expect WIFEXITED on me"?


Final touch may be to make "I exited because some other thread exec'ed"
notification different from "I exited because of _exit(0)".
It would make strace to say what _actually_ happened, which is a good thing.
Silly ideas department proposes returning WIFSIGNALED, WTERMSIG = 0 ;)

-- 
vda
