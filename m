Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2AZLsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:48:15 -0500
Received: from mail2.shareable.org ([80.68.89.115]:40784 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2AZLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:48:13 -0500
Date: Thu, 26 Jan 2012 11:47:41 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120126114741.GG18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com>
 <201201260032.57937.vda.linux@googlemail.com>
 <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
 <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
 <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk>
 <6cc0a81f9f84af80bd66bc44a03c8c0b.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc0a81f9f84af80bd66bc44a03c8c0b.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Thu, January 26, 2012 11:31, Jamie Lokier wrote:
> > Indan Zupancic wrote:
> >> Yes, that's the only reason I'm interested in BPF, really.
> >> Most system calls are either always allowed, or always denied.
> >> Of the ones that need checking, most of them have file paths.
> >> For those I'm not interested in the post-syscall event.
> >
> > Same here, though for tracing file paths rather than blocking anything.
> 
> The jailer I wrote works pretty well as a simplistic strace replacement.
> It can only print out the arguments we're checking, but that's usually
> the more interesting info.

In theory such a thing should be easy to write, but as we both found,
ptrace() on Linux has a huge number of difficult quirks to deal with
to trace reliably.  At least it's getting better with later kernels.

> >> Those issues are not equivalent. ARM only has that OABI thing which
> >> is hopefully not used in practice.
> >
> > I am still using OABI on some currently-sold and still-developed
> > devices with userspace libraries that I can't replace or rebuild.
> > Maybe I'm the only one, but the issue is still there.  It should be
> > supported in ptrace() as long as it's supported in the kernel at all.
> 
> It's not a 32 versus 64-bit issue though, so it will be something on
> its own anyway. Can as well add an extra ARM specific ptrace command
> to get that info, or hack it in some other way. For instance, ip is
> (ab)used to tell if it is syscall entry or exit, so doing these tricks
> isn't anything new in ARM either.

In theory, aren't we supposed to know whether it's entry/exit anyway?
Why does strace care?  Have there been kernel bugs in the past?  Maybe
it was just to deal with SIGTRAP-after-exit in the past, which could
be delivered at an unpredictable time if blocked and then unblocked by
sigreturn().

> You can't avoid the arch-specific knowledge, because depending on the
> answer, you have to do something arch specific. In ARM's OABI case, it's
> reading program memory to find out the system call number, of all things.
> (I hope I read the code wrong). So ARM's solution would need to get all
> info it needs to handle the system call securely without reading any text
> memory, otherwise it's racy.

A few archs read program memory to get the syscall number even now, in
the current strace source.  Look for PEEKTEXT: S390, ARM, SPARC use it
on every syscall entry, and X86_64 has it commented out.

As we know, all of them are buggy if the memory is modified while
reading it, and it's silly because the kernel knows the syscall
number.

> And then there's the whole confusion what that flag says, some might think
> it says in what mode the tracee is instead of what mode the system call is.
> That those two can be different is not obvious at all and seems very x86_64
> specific.

My rough read of PARISC entry code suggests it has two entry methods,
similar to ARM and x86_64, but I'm not really familiar with PARISC and
I don't have a machine handy to try it out :-)

> I'm not sure what you're doing, but perhaps we should share code and write
> a kind of Linux ptrace library. The code I wrote was university stuff and
> we want to release it, but it will take a while to get things sorted out.
> Hopefully it's released in April, maybe before.

I've been thinking along similar lines.  The idea came up when I was
hacking on strace last year and it so wanted to be cleaned up (but now
strace is in good hands, my work on it is obsolete); now I'm doing
ptracing for other purposes.  Denys' ptrace API document, currently in
strace git, is extremely useful.

Denys, would you be interested in further refactoring strace to use a
"libsystrace" sort of thing which abstracts the detail of archs,
tracing (and maybe syscall argument layout) away from the printing and
user-interface, for strace's use and other users?  I would be happy to
help with that and keep strace's non-Linux support as well (if there's
any way to test the latter...)  I seem to be going in the direction of
a library like that anyway for another project.

The seccomp-BPF stuff could also benefit from a part dealing with
syscall argument layout, as it too needs needs that arch-specific
knowledge.  I have a script in progress which extracts all the
per-arch and per-ABI syscall numbers, syscall argument layouts and
kernel function names to keep track of arch-specific fixups, from a
Linux source tree.  It currently works on all archs except it breaks
on x86 which insists on being diferent ;-)

-- Jamie
