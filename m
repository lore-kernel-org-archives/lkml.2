Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2AZGea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 01:34:30 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:60542 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2AZGeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 01:34:25 -0500
Message-ID: <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <20120125193635.GA30311@redhat.com>
    <201201260032.57937.vda.linux@googlemail.com>
    <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
    <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
Date: Thu, 26 Jan 2012 07:34:13 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Jamie Lokier" <jamie@shareable.org>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Andrew Lutomirski" <luto@mit.edu>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
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
X-Scan-Signature: b76837ecbba1170f708de966edddc2d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 02:08, Jamie Lokier wrote:
> Is it disambiguated by PTRACE_EVENT_EXEC happening before the execve
> returns, and you knowing the TID always changes to the PID?  I haven't
> yet checked which TID gets the PTRACE_EVENT_EXEC event, but if it's
> not the old one, perhaps that could be changed.

Please don't ever change the behaviour of PTRACE_EVENT_EXEC, it's
barely documented already, but if if ever changes it will be also
unreliable.

It's still unclear if the PTRACE_EVENT_EXEC comes before or after
or instead of the post-execve ptrace event. I guess before, but
can I count on that? If it is after then I get a stray weird
execve event that messes up the system call cadence.

> It would be good to improve the threaded execve() behaviour for all
> the disappearing TIDs to issue a disappearing event, and the winning
> execve changing-TID to issue an I-am-changing-TID even, anyway.

As Denys said, you get the event with the new PID, and apparently with
the latest kernel you can get the old TID with PTRACE_GETEVENTMSG.

So all the info is there to handle it statelessly now.

My point was that stateless handling is much preferred to stateful
handling, and hence why not having the syscall mode available for
the syscall exit event would be inconvenient sometimes (meaning the
real mode can be different than guessed).

>> > Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
>> > "on syscall entry ptrace stop, set a nonzero event value in wait status"
>> > , and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
>> > PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.
>>
>> Not all code wants to receive a syscall exit event all the time, so
>> if you add PTRACE_O_TRACE_SYSENTRY, please add PTRACE_O_TRACE_SYSEXIT
>> too. That would pretty much halve ptrace's overhead for my use case.
>> But this is orthogonal to the compat problem.
>
> I agree.  I would like to ignore the exit for most syscalls but see a
> few of them.  I guess PTRACE_SETOPTIONS could be used to toggle it,
> with some overhead.

Yes, that's what I had in mind.

> But in the spirit of this thread,
> PTRACE_O_TRACE_BPF would be even better, to completely ignore
> irrelevant syscalls :-)

Yes, that's the only reason I'm interested in BPF, really.
Most system calls are either always allowed, or always denied.
Of the ones that need checking, most of them have file paths.
For those I'm not interested in the post-syscall event.

>> > To future-proof this scheme we may reserve a few more event values
>> > PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
>> > if we'll ever have arches with more than one non-native syscall
>> > entry. I'm no expert, but looking at strace code, ARM may already have
>> > more than one additional convention how to pass syscall args.
>>
>> Please, no! This way lays madness, just one PTRACE_EVENT_SYSCALL_ENTRY,
>> no PTRACE_EVENT_SYSCALL_ENTRY1 or PTRACE_EVENT_SYSCALL_ENTRY2, that
>> would be horrible. Keep arch specific stuff in arch specific areas,
>> please don't spread it around.
>>
>> What was wrong with using eflags again? Is it too simple or something?
>
> Well it doesn't deal with the equivalent issue on ARM and PA-RISC.

Those issues are not equivalent. ARM only has that OABI thing which
is hopefully not used in practice. Can you switch modes on-the-fly in
PA-RISC without doing a system call? Both ARM and PA-RISC use only one
struct pt_regs and one syscall table.

Greetings,

Indan


