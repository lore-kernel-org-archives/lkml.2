Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1FBPOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:14:15 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56208 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1FBPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XeYgflbyMPUV6qqoR9kQk+Hr+yi5XY0nfVRY/FPAOxzm2z+zI5/rQKKykRLlwIZaKM
         6TSiIUcw6za7yN/IUDurT2YGmBKV8I27v59mGBW/+++w7vPztz+YPU2VNr7JA22vJJMm
         oEDN1zwdA7PJIOjH0sJVUXcuaAG/ChtdIcaA8=
MIME-Version: 1.0
In-Reply-To: <20110531135116.GA4799@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
 <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com> <20110530164252.GB11325@redhat.com>
 <201105310143.12280.vda.linux@googlemail.com> <20110531135116.GA4799@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 2 Jun 2011 17:12:49 +0200
Message-ID: <BANLkTinqtBS+je=6T6fbOhmaETskeufu5A@mail.gmail.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 3:51 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> I think the better (more general) question is "what if both threads
>> are traced by _different_ tracers?".
>
> I don't really understand why do you think this is more general...

Because it reveals more problems, and thus allows to think about
a solution for all of them. Here it is again:


On Tue, May 31, 2011 at 1:43 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> If we think "tracedness" is attached to thread (task struct):
>
> tracer 0 (traces leader) sees:
> status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
> <tracee is gone>
>
> tracer 1 (traces execve'ing thread) sees:
> status:0004057f WIFSTOPPED sig:5 (TRAP) event:EXEC, and pid has changed!
>
> What is bad about it:
> * tracer 0 expects yet another notification, "status:00000000 WIFEXITED exitcode:0"
>  or similar, but it will never come.
> * tracer 1 can be rather confused by getting EVENT_EXEC from a tracee it knows
>  nothing about (since the pid has changed!). If it has more than one tracee,
>  it can't guess which one did that. (Yes, it can resort to ugly racy hacks...)
>
> I think the second case is "less broken". What API changes can make it better
> for userspace?
>
> First, returning old pid via GETEVENTMSG helps with second
> badness - tracer 1 can fetch it, and understand which of his tracees
> changed pid just now.
>
> And second, if we'd return "status:00000000 WIFEXITED exitcode:0" thing
> on execve _for leader too_, then tracer 0 will be happy (it will see consistent
> sequence of events).
> If it's hard to do, then alternatively, we can add this information
> to EVENT_EXIT somehow. Normally, GETEVENTMSG returns exit status.
> Can be hijack a bit there to say "dont expect WIFEXITED on me"?


>> And second, if we'd return "status:00000000 WIFEXITED exitcode:0" thing
>> on execve _for leader too_, then tracer 0 will be happy (it will see consistent
>> sequence of events).
>
> Once again, we can only do this before the execing thread changes its
> pid. This means that this thread should look at the leader, and if it
> is traced it should wait until the tracer does do_wait(). I do not think
> this is good.

I understand, but so far I don't see any better solution. Current behavior
is simply not acceptable. Here is it again:

> tracer 0 (traces leader) sees:
> status:0006057f WIFSTOPPED sig:5 (TRAP) event:EXIT
> <tracee is gone>

It's a total "WTF?" situation. As far as tracer is concerned, tracee just
vanished into thin air: no WIFEXITED seen, and since this tracer doesn't
see execve because it doesn't trace execve'ing thread, it has no way
to understand what the hell happened. Tracer will sit in waitpid forever.
If it had not requested EVENT_EXIT to be shown, it wouldn't even get the
EVENT_EXIT shown above which tells it that tracee is _probably_ gone.


> And, once again, even if we do this, we need to change the current
> behaviour with do_wait(ptraced_exited_leader_thread), see another
> discussion.

I wrote a test program and the behavior is worse than I thought.
I have a case where exited leader causes waitpid to hang and not report
ptrace events from other tracees, without any execve!
I'll sent the program in another thread.
-- 
vda
