Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2ASLfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:35:02 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42112 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2ASLe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:34:59 -0500
Message-ID: <35485e9b3a228fc3b19e93066f5a11df.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAMnK33WUTvZER9XoGAKsuh27iF3W6qMfJ3nxWfgSa4-jouO=Sw@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com>
    <20120117164523.GA17070@redhat.com>
    <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
    <fbc1f44dffce6079fa7ec827c1b1e40e.squirrel@webmail.greenhost.nl>
    <CAMnK33WAUA7bNFKA8BmLHq9+sdMV9xeOvZ8T1iZSH1GFKNe3ZQ@mail.gmail.com>
    <54555afe915a79f7e77ee0f44ee6cb67.squirrel@webmail.greenhost.nl>
    <CAMnK33WUTvZER9XoGAKsuh27iF3W6qMfJ3nxWfgSa4-jouO=Sw@mail.gmail.com>
Date: Thu, 19 Jan 2012 12:34:33 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Evans" <scarybeasts@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 3c11394861542ed80f8a69179537bf2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 19, 2012 09:16, Chris Evans wrote:
> On Wed, Jan 18, 2012 at 4:14 PM, Indan Zupancic <indan@nul.nu> wrote:
>> On Wed, January 18, 2012 22:13, Chris Evans wrote:
>>> On Wed, Jan 18, 2012 at 4:12 AM, Indan Zupancic <indan@nul.nu> wrote:
>>>> On Wed, January 18, 2012 06:43, Chris Evans wrote:
>>>>> 2) Tracee traps
>>>>> 2b) Tracee could take a SIGKILL here
>>>>> 3) Tracer looks at registers; bad syscall
>>>>> 3b) Or tracee could take a SIGKILL here
>>>>> 4) The only way to stop the bad syscall from executing is to rewrite
>>>>> orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
>>>>> syscall has finished)
>>>>
>>>> Yes, we rewrite it to -1.
>>>>
>>>>> 5) Disaster: the tracee took a SIGKILL so any attempt to address it by
>>>>> pid (such as PTRACE_SETREGS) fails.
>>>>
>>>> I assume that if a task can execute system calls and we get ptrace events
>>>> for that, that we can do other ptrace operations too. Are you saying that
>>>> the kernel has this ptrace gap between SIGKILL and task exit where ptrace
>>>> doesn't work but the task continues executing system calls? That would be
>>>> a huge bug, but it seems very unlikely too, as the task is stopped and
>>>> shouldn't be able to disappear till it is continued by the tracer.
>>>>
>>>> I mean, really? That would be stupid.
>>
>> Okay, I tested this scenario and you're right, we're screwed.
>>
>> What the hell guys?
>
> Steady on :) ptrace() has never been sold as a technology upon which
> its safe to build security solutions.

Well, that can be said of pretty much all kernel functionality.
That is no excuse for crazy behaviour.

I more or less fixed it by turning all SIGKILLs into SIGTERMs.
Perhaps I should use a more obscure signal instead.

>> What about other PID checks in the kernel, are they still
>> safe if the process looks dead but is still active? Or is it a ptrace-only
>> problem?
>>
>>>> If true we have to work around it by disallowing SIGKILL and just sending
>>>> them ourselves within the jail. Meh.
>>
>> I guess this helps a bit. It doesn't prevent external signals, but prisoners
>> don't have control over that.
>
> Well.... a prisoner may be able to play other tricks:
> - Allocate lots of memory... kernel may start spraying around SIGKILLs
> - Sending SIGKILL via prctl()

prctl is disallowed within our jail. Did you had PR_SET_PDEATHSIG in mind?
But doesn't the tracer become the parent when ptracing or not for this?
Or were you thinking about enabling SECCOMP and counting on the SIGKILL
being process-wide instead of thread-specific?

> - Sending SIGKILL via fcntl()

I haven't written the fcntl demultiplexor yet, but I missed fcntl could
be used for sending signals. I knew there was whacky stuff in there, but
didn't expect it to be that bad. Thanks.

> - Sending SIGKILL via clone()

How? And can you send it to another process than yourself?

>
>>
>> Is this SIGKILL specific or is it true for all task ending signals?
>
> Can't remember - try it?

Tried: It's safe with SIGTERM, so I assume the others are fine too.
I'll double check though...

>>
>>>> How will you avoid file path races with BPF?
>>>
>>> There is typically no need for file-path based access control in an FTP server.
>>> Take for example anonymous FTP, which will typically be inside a
>>> chroot() to /var/ftp. Inside that filesystem tree -- if you can open()
>>> it, you can have it.
>>
>> Ah, you count on having root access. We don't.
>>
>> Do you know any more crazy security destroying holes?
>
> Try spraying SIGCONT and / or SIGSTOP at tracees. It may be possible
> to confuse the tracer about whether a SIGTRAP event is syscall entry
> or exit.

Yes, heard about that weirdness before, but it's all ignored. We're
using PTRACE_O_TRACESYSGOOD.

> Try doing an execve() that fails. May cause similar state confusion in
> the tracer.

Our jailer pretty much ignores all signals and only handles syscalls
and task exits. We actually check execve's return value to know if we
have to do our stuff or not.

Greetings,

Indan


