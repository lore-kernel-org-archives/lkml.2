Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1E3O2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:28:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab1E3O15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dlIOJ2jF5DFzuvbUNzIFu/OyRii+SD+0dt3TvVLtsBkZZW5UuIcIy5RWn4ZUSHP+fa
         pOe/1nO3Pj4OZKOBwjqNJsJ0i4G2grV5duJ9f7m8sAnYBWLn2oX+tIVxRXOwLAnu1G0y
         VhnIFRZlTJLELHXs26aKulknu/uJG2KMfJsOE=
MIME-Version: 1.0
In-Reply-To: <BANLkTinYRKKZL-9zntYuxLoa9NxSo70JGA@mail.gmail.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
 <20110525143250.GJ10146@htj.dyndns.org> <201105300528.17384.vda.linux@googlemail.com>
 <20110530084906.GA11773@htj.dyndns.org> <BANLkTinYRKKZL-9zntYuxLoa9NxSo70JGA@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 30 May 2011 16:27:37 +0200
Message-ID: <BANLkTikqRod7B30RCEf2V8Rq5zsz=QeZag@mail.gmail.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 1:40 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>>> I think the API needs fixing. Tracee must never disappear like that
>>> on execve (or in any other case). They must always deliver a
>>> WIFEXITED or WIFSIGNALED notification, allowing tracer to know
>>> that they are gone. We probably also need to document how are these
>>> "I died on execve" notifications are ordered wrt PTRACE_EVENT_EXEC
>>> stop in execve-ing thread.
>>
>> A problem is that by the time de-threading is in progress, it's
>> already too deep and there's no way back and the exec'ing thread has
>> to wait for completion in uninterruptible sleeps - ie. it expects
>> de-threading to finish in finite amount of time and to achieve that it
>> basically sends SIGKILL to all other threads.
>
> Which is fine. Can we make the death from this "internal SIGKILL"
> visible to the tracer of killed tracees?

Ok, let's take a deeper look at API needs. What we need to report, and when?

We have three kinds of threads at execve:
1. execve'ing thread,
2. leader, two cases: (2a) leader is still alive, (2b) leader has exited by now.
3. other threads.

(3) is the most simple: API should report death of these threads.
There is no need to ensure these death notifications are reported
before execve syscall exit is reported. They can be consumed
by tracer later.

(1) execve'ing thread is obviously alive. current kernel already
reports its execve success. The only thing we need to add is
a way to retrieve its former pid, so that tracer can drop
former pid's data, and also to cater for the "two execve's" case.
PTRACE_EVENT_EXEC seems to be a good place to do it.
Say, using GETEVENTMSG?

(2) is the most problematic. If leader is still alive, should
we report its death? This makes sense since if we do,
and if we ensure its death is always reported before
PTRACE_EVENT_EXEC, then the rule is pretty simple:
at PTRACE_EVENT_EXEC, leader is always reported dead.

However, I don't see why we _must_ do it this way.
The life of tracer is not that much worse if at
PTRACE_EVENT_EXEC leader which is still alive
is simply "supplanted" by the execve'ed process.

We definitely must ensure, though, that if leader races with
execve'ing thread and enters exit(2), its death is never reported
*after* PTRACE_EVENT_EXEC - that'd confuse the tracer for sure!
Process which has exited but is still alive?! Not good!

-- 
vda
