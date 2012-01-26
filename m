Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab2AZF5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 00:57:51 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33247 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2AZF5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 00:57:47 -0500
Message-ID: <0fac69b7cf4ddb2a87065646d8c0309c.squirrel@webmail.greenhost.nl>
In-Reply-To: <201201260209.54513.vda.linux@googlemail.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <201201260032.57937.vda.linux@googlemail.com>
    <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
    <201201260209.54513.vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 06:57:18 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
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
X-Scan-Signature: 12808661ad9e64cdb46d03b2a0987e23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 02:09, Denys Vlasenko wrote:
> Dealt with in Linus tree already: set PTRACE_O_TRACEEXEC option,
> and use PTRACE_GETEVENTMSG in PTRACE_EVENT_EXEC stop to get
> the old TID.

Thanks, getting the old TID is useful, that was the missing bit to
handle execve statelessly.

>
>
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
>
> The situation when an architecture has 32- and 64-bit varieties,
> and sometimes different ABIs (parameter passing comventions),
> is rather typical, it's not a quirk of just one unfortunate
> architecture.

The question is how many of those have a different ABI and can not
be reliably detected at system call entry time. If the ABI can't
be changed at runtime then there's no problem either.

x86_64's case is very peculiar because it can execute a 32-bit compat
syscall while the process itself is in 64-bit mode.

> Please look at strace source, get_scno() function, where
> it reads syscall no and parameters. Let's see....
> - POWERPC: has 32-bit and 64-bit mode
> - X86_64: has 32-bit and 64-bit mode
> - IA64: has i386-compat mode
> - ARM: has more than one ABI
> - SPARC: has 32-bit and 64-bit mode

Fow most of them you can reliably check the mode by looking at registers.

x86_64 and apparently ARM are problematic. Others may too in similar subtle
ways as x86_64, but I can't tell that from strace's code.

ARM looks ok when old cruft isn't enabled (much more likely than compat
mode being disabled in x86_64).

Can SPARC change mode on the fly without detection? Otherwise it looks
like it may be slightly problematic too, though it seems that at least
the ABI is pretty much the same between 32 and 64 bit mode. Same for
PA-RISC. So all in all not sure if they have a problem or not.

To be a problem the only way to figure our what mode the system call
will be is by looking at the trapping/syscall instruction itself. If
that isn't needed, or if there isn't much difference between the modes
anyway, then there's no problem.

>
> Do you want to re-invent a different arch-specific way to report
> syscall type for each of these arches?

Thing is, it is not just 32 versus 64 bit mode. So one way or the other,
you do end up with an arch-specific way of saying what syscall type it is.

It doesn't matter much where that info is stuffed, it will always be arch
specific, because depending on that value people have to do different
arch specific things.

It's fine to somehow give that info together with PTRACE_EVENT_SYSCALL_ENTRY,
but I don't think it's a good idea to have different syscall entry events
depending on what type they are. I suppose the only reason to do that would
be because we're running out of bits elsewhere.

>
>> What was wrong with using eflags again? Is it too simple or something?
>
> It's x86-specific, and abuses a bit in a real register.

If the problem is limited to only a couple of archs, and we can stuff this
info in the register set for all of them, then I'm all for it.

So far it's just x86_64 and ARM with OABI enabled, with the rest either
fine or unclear.

Greetings,

Indan


