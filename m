Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2A0HYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:24:21 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:51266 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2A0HYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:24:19 -0500
Message-ID: <da6b0694076aad94aa8afa3740126cca.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120126114741.GG18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
    <20120125193635.GA30311@redhat.com>
    <201201260032.57937.vda.linux@googlemail.com>
    <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
    <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
    <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
    <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
    <6cc0a81f9f84af80bd66bc44a03c8c0b.squirrel@webmail.greenhost.nl>
    <20120126114741.GG18613@jl-vm1.vm.bytemark.co.uk>
Date: Fri, 27 Jan 2012 08:23:50 +0100
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
X-Scan-Signature: ac7e290c1021e6491e133d15cfe88b06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 26, 2012 12:47, Jamie Lokier wrote:
> Indan Zupancic wrote:
>> On Thu, January 26, 2012 11:31, Jamie Lokier wrote:
>> > Indan Zupancic wrote:
>> >> Yes, that's the only reason I'm interested in BPF, really.
>> >> Most system calls are either always allowed, or always denied.
>> >> Of the ones that need checking, most of them have file paths.
>> >> For those I'm not interested in the post-syscall event.
>> >
>> > Same here, though for tracing file paths rather than blocking anything.
>>
>> The jailer I wrote works pretty well as a simplistic strace replacement.
>> It can only print out the arguments we're checking, but that's usually
>> the more interesting info.
>
> In theory such a thing should be easy to write, but as we both found,
> ptrace() on Linux has a huge number of difficult quirks to deal with
> to trace reliably.  At least it's getting better with later kernels.

It's not that bad, there are a few quirks, but not that many.
The ptrace specific code is less than 500 lines of code, with
a couple of hundred lines of header files. Linux ptrace specific
stuff creeps in elsewhere too though, like that execve mess.

>> It's not a 32 versus 64-bit issue though, so it will be something on
>> its own anyway. Can as well add an extra ARM specific ptrace command
>> to get that info, or hack it in some other way. For instance, ip is
>> (ab)used to tell if it is syscall entry or exit, so doing these tricks
>> isn't anything new in ARM either.
>
> In theory, aren't we supposed to know whether it's entry/exit anyway?
> Why does strace care?  Have there been kernel bugs in the past?  Maybe
> it was just to deal with SIGTRAP-after-exit in the past, which could
> be delivered at an unpredictable time if blocked and then unblocked by
> sigreturn().

Maybe. I don't why ARM does that ip thing.

Although in theory you know the entry/exits if you keep track, but one
mistake or unexpected behaviour (like execve for my code) and you can get
it wrong. So for robustness sake it's good if it can be double checked.

>> You can't avoid the arch-specific knowledge, because depending on the
>> answer, you have to do something arch specific. In ARM's OABI case, it's
>> reading program memory to find out the system call number, of all things.
>> (I hope I read the code wrong). So ARM's solution would need to get all
>> info it needs to handle the system call securely without reading any text
>> memory, otherwise it's racy.
>
> A few archs read program memory to get the syscall number even now, in
> the current strace source.  Look for PEEKTEXT: S390, ARM, SPARC use it
> on every syscall entry, and X86_64 has it commented out.

I did look for PEEKTEXT. For ARM it's to check if OABI is used (and
if it is, the syscall is in memory, otherwise it's in r7). Strace only
uses it on S390 to handle old style ABI, 2.6 is fine. On SPARC Strace
does it to figure out what personality is used. But that can only be
changed via personality(2) and not secretly at runtime, or so it seems,
so SPARC should be safe too. But I can't really figure out the kernel
SPARC code to be honest, so I may be wrong. It seems the trap instruction
differs between SPARC 32 and 64-bit, but on the other hand they both use
the same syscall table, so at least the syscall nr can't be confused.

> As we know, all of them are buggy if the memory is modified while
> reading it, and it's silly because the kernel knows the syscall
> number.

Only ARM OABI is really problematic in that regard, but that's not a
32 versus 64-bit issue.

I don't know anything about OABI, can you link an OABI program against
an EABI library? If you can then libc can be EABI and the kernel doesn't
need OABI support.

>> And then there's the whole confusion what that flag says, some might think
>> it says in what mode the tracee is instead of what mode the system call is.
>> That those two can be different is not obvious at all and seems very x86_64
>> specific.
>
> My rough read of PARISC entry code suggests it has two entry methods,
> similar to ARM and x86_64, but I'm not really familiar with PARISC and
> I don't have a machine handy to try it out :-)

It has a unified syscall table, so does it really matter?

>> I'm not sure what you're doing, but perhaps we should share code and write
>> a kind of Linux ptrace library. The code I wrote was university stuff and
>> we want to release it, but it will take a while to get things sorted out.
>> Hopefully it's released in April, maybe before.
>
> I've been thinking along similar lines.  The idea came up when I was
> hacking on strace last year and it so wanted to be cleaned up (but now
> strace is in good hands, my work on it is obsolete); now I'm doing
> ptracing for other purposes.  Denys' ptrace API document, currently in
> strace git, is extremely useful.
>
> Denys, would you be interested in further refactoring strace to use a
> "libsystrace" sort of thing which abstracts the detail of archs,
> tracing (and maybe syscall argument layout) away from the printing and
> user-interface, for strace's use and other users?  I would be happy to
> help with that and keep strace's non-Linux support as well (if there's
> any way to test the latter...)  I seem to be going in the direction of
> a library like that anyway for another project.

I actually recommend to leave strace as it is. I've seen the code,
it's full with arch and OS specific stuff scattered all over the
place. Considering it actually works now, why risk breaking anything?
Especially considering you can't test any changes for all supported
platforms. Just leave it be and slowly improve it by tiny bit for
bits you can actually test.

The point of the library would be to make it easier to create new
software, possibly by using all the new features and dropping support
for too old kernels. Strace doesn't really benefit from that.

> The seccomp-BPF stuff could also benefit from a part dealing with
> syscall argument layout, as it too needs needs that arch-specific
> knowledge.

It seems I convinced them to use a cross-platform ABI, so you should
get the system call number and arguments directly.

> I have a script in progress which extracts all the
> per-arch and per-ABI syscall numbers, syscall argument layouts and
> kernel function names to keep track of arch-specific fixups, from a
> Linux source tree.  It currently works on all archs except it breaks
> on x86 which insists on being diferent ;-)

That's handy, but I thought strace had such a script already?
See HACKING-scripts in strace source. Or is yours much better?

Greetings,

Indan


