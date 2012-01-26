Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2AZA7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:59:49 -0500
Received: from mail2.shareable.org ([80.68.89.115]:36987 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2AZA7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:59:47 -0500
Date: Thu, 26 Jan 2012 00:59:01 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
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
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120126005901.GC18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com>
 <201201260032.57937.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201260032.57937.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
> > On 01/18, Linus Torvalds wrote:
> > >
> > > Using the high bits of 'eflags' might work.
> > 
> > I thought about changing eflags too, this looks very natural to me.
> > 
> > But I do not understand the result of this discussion, are you going
> > to apply this change?
> > 
> > If not...
> > 
> > Not sure this is really better, but there is another idea. Currently we
> > have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
> > Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
> > PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?
> > 
> > IOW. Currently ptrace_report_syscall() does
> > 
> > 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
> > 
> > We can add the new events,
> > 
> > 	PTRACE_EVENT_SYSCALL_ENTRY
> > 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> > 	PTRACE_EVENT_SYSCALL_EXIT
> > 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
> 
> We can get away with just the first one.
> (1) It's unlikely people would want to get native sysentry events but not compat ones,
> thus first two options can be combined into one;

Tracers mainly want to know if it's a 32-bit or 64-bit syscall, not
whether it's compat as such.

I'm thinking it might be a little kinder like this:

#define PTRACE_EVENT_SYSCALL_ENTRY_ABI32 (...)
#define PTRACE_EVENT_SYSCALL_ENTRY_ABI64 (...)

#ifdef CONFIG_64BIT
# define PTRACE_EVENT_SYSCALL_ENTRY         PTRACE_EVENT_SYSCALL_ENTRY_ABI64
# define PTRACE_EVENT_SYSCALL_ENTRY_COMPAT  PTRACE_EVENT_SYSCALL_ENTRY_ABI32
#else
# define PTRACE_EVENT_SYSCALL_ENTRY         PTRACE_EVENT_SYSCALL_ENTRY_ABI32
#endif

So the ABI is represented directly, with the _ENTRY referring to the
tracer's own.  (Other ABI numbers can exist, e.g. OABI and EABI for
ARM, see below.)

This has the two specific advantages:

  1. It can match on specific ABI or regular/compat, as suits the tracer's code.
  2. When a 32-bit *tracer* is running a 64-bit *tracee* as least it knows ;-)

With your idea, what happens in situation 2?  I'm not sure a 32-bit
tracee can do anything useful, because it can't get the 64-bit
registers, but at least it can see when it's got the wrong registers :-)

> (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> (3) if we would flag syscall entry with an event value in wait status, then syscall
> exit will be already distinquisable.
>
> Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
> "on syscall entry ptrace stop, set a nonzero event value in wait status"
> , and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
> PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.

PTRACE_EVENT_SYSCALL_EXIT would cleanly indicate that the new option
is actually working without the tracer needing to do a fork+test, if
PTRACE_ATTACH is used and for some reason the tracer sees a syscall
exit first.  I'm not sure if this can happen but I've heard rumour of
it on some archs or kernel versions.

> To future-proof this scheme we may reserve a few more event values
> PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
> if we'll ever have arches with more than one non-native syscall
> entry.

> I'm no expert, but looking at strace code, ARM may already have
> more than one additional convention how to pass syscall args.

I was just looking at ARM and see exactly the same thing.  The
difference between EABI and OABI calls is significant on ARM, even
though syscall numbers are the same; and the ABI is selected by the
syscall instruction used, not process personality.  The __NR_name
values differ for each ABI, but (if I read arm/kernel/entry-common.S
properly) strace sees the same _NR_name values for both ABIs.

MIPS also has two different 32-bit ABIs, as well as 64-bit, but on
MIPS the syscall numbers are distinct, and should be seen by ptrace.
(Again if I read mips/kernel/ correctly.)

PA-RISC also has two different ABIs, the Linux one and the HPUX one.
The syscall numbers are different but overlap.  I don't know if they
are distinct to ptrace, in which case using the HPUX entry point might
be used to subvert a ptracer unless the ABI number is exposed.

-- Jamie
