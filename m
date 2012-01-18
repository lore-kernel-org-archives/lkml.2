Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2ARFn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:43:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2ARFnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:43:55 -0500
MIME-Version: 1.0
In-Reply-To: <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
References: <20120116183730.GB21112@redhat.com>
	<CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
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
Date: Tue, 17 Jan 2012 21:43:54 -0800
Message-ID: <CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: Chris Evans <scarybeasts@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 8:22 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Wed, January 18, 2012 03:22, Andi Kleen wrote:
>>> I'm pretty sure this isn't about changing cs or far jumps
>>
>> He's assuming that code can only run on two code segments and
>> not arbitarily switch between them which is a completely incorrect
>> assumption.
>
> All I assumed up to now was that cs shows the current mode of the process,
> and that that defines which system call path is taken. Apparently that is
> not true and int 0x80 forces the compat system call path.
>
> Looking at EIP - 2 seems like a secure way to check how we entered the kernel.

For 64-bit processes, you need to look at that (hard due to races) and
_also_ CS.
At least that was the state the last time I played with this in
earnest: http://scary.beasts.org/security/CESA-2009-001.html

I see Linus posted one of the race conditions that "EIP - 2" is
vulnerable to. You can start to chip away at the problem by making
sure your policy doesn't allow mmap() or mprotect() with PROT_EXEC (or
MAP_SHARED) but it's a long battle.

>
>>> I think Indan means code is running with 64-bit cs, but the kernel
>>> treats int $0x80 as a 32-bit syscall and sysenter as a 64-bit syscall,
>>> and there's no way for the ptracer to know which syscall the kernel
>>> will perform, even by looking at all registers.
>
> Yes, that's what I meant.
>
>>> It looks like a hole in ptrace which could be fixed.
>>
>> Possibly, but anything that bases its security on ptrace is typically
>> unfixable racy (just think what happens with multiple threads
>> and syscall arguments), so it's unlikely to do any good.
>
> As far as I know, we fixed all races except symlink races caused by malicious
> code outside the jail.

Are you sure? I've remembered possibly the worst one I encountered,
since my previous e-mail to Jamie:

1) Tracee is compromised; executes fork() which is syscall that isn't allowed
2) Tracee traps
2b) Tracee could take a SIGKILL here
3) Tracer looks at registers; bad syscall
3b) Or tracee could take a SIGKILL here
4) The only way to stop the bad syscall from executing is to rewrite
orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
syscall has finished)
5) Disaster: the tracee took a SIGKILL so any attempt to address it by
pid (such as PTRACE_SETREGS) fails.
6) Syscall fork() executes; possible unsupervised process now running
since the tracer wasn't expecting the fork() to be allowed.


All this ptrace() security headache is why vsftpd is waiting for
Will's seccomp enhancements to hit the kernel. Then they will be used
pronto.


Cheers
Chris

> Those are controllable by limiting what filesystem access
> the prisoners get. A special open() flag which causes open to fail when a part
> of the path is a symlink with a distinguishable error code would solve this for
> us.
>
> Other than that and the abysmal performance, ptrace is fine for jailing.
>
> Greetings,
>
> Indan
>
>
