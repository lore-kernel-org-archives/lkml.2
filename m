Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2AZLUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:20:18 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42868 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2AZLUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:20:13 -0500
Message-ID: <6cc0a81f9f84af80bd66bc44a03c8c0b.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <20120125193635.GA30311@redhat.com>
    <201201260032.57937.vda.linux@googlemail.com>
    <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
    <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
    <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
    <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
Date: Thu, 26 Jan 2012 12:20:00 +0100
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
X-Scan-Signature: 488b5a33f748713be529de57fa847022
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 11:31, Jamie Lokier wrote:
> Indan Zupancic wrote:
>> Yes, that's the only reason I'm interested in BPF, really.
>> Most system calls are either always allowed, or always denied.
>> Of the ones that need checking, most of them have file paths.
>> For those I'm not interested in the post-syscall event.
>
> Same here, though for tracing file paths rather than blocking anything.

The jailer I wrote works pretty well as a simplistic strace replacement.
It can only print out the arguments we're checking, but that's usually
the more interesting info.

>> Those issues are not equivalent. ARM only has that OABI thing which
>> is hopefully not used in practice.
>
> I am still using OABI on some currently-sold and still-developed
> devices with userspace libraries that I can't replace or rebuild.
> Maybe I'm the only one, but the issue is still there.  It should be
> supported in ptrace() as long as it's supported in the kernel at all.

It's not a 32 versus 64-bit issue though, so it will be something on
its own anyway. Can as well add an extra ARM specific ptrace command
to get that info, or hack it in some other way. For instance, ip is
(ab)used to tell if it is syscall entry or exit, so doing these tricks
isn't anything new in ARM either.

> I don't know if the PA-RISC thing is real.
>
> But it's occurred to me that there are a lot of 32/64 archs now (I was
> extracting all their syscall number tables last night), and it would
> be good if there were a consistent, arch-independent way to signal if
> the syscall number is in the 32 or 64-bit table - or at least, in the
> same ABI as the tracer gets from <asm/unistd.h>.  For tracers doing
> simple things to avoid needing a ton of arch-specific knowledge.

You can't avoid the arch-specific knowledge, because depending on the
answer, you have to do something arch specific. In ARM's OABI case, it's
reading program memory to find out the system call number, of all things.
(I hope I read the code wrong). So ARM's solution would need to get all
info it needs to handle the system call securely without reading any text
memory, otherwise it's racy.

And then there's the whole confusion what that flag says, some might think
it says in what mode the tracee is instead of what mode the system call is.
That those two can be different is not obvious at all and seems very x86_64
specific.

I'm not sure what you're doing, but perhaps we should share code and write
a kind of Linux ptrace library. The code I wrote was university stuff and
we want to release it, but it will take a while to get things sorted out.
Hopefully it's released in April, maybe before.

Greetings,

Indan


