Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2AZBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:09:26 -0500
Received: from mail2.shareable.org ([80.68.89.115]:38366 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2AZBJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:09:23 -0500
Date: Thu, 26 Jan 2012 01:08:58 +0000
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
Message-ID: <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com>
 <201201260032.57937.vda.linux@googlemail.com>
 <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Thu, January 26, 2012 00:32, Denys Vlasenko wrote:
> > On Wednesday 25 January 2012 20:36, Oleg Nesterov wrote:
> >> IOW. Currently ptrace_report_syscall() does
> >>
> >> 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
> >>
> >> We can add the new events,
> >>
> >> 	PTRACE_EVENT_SYSCALL_ENTRY
> >> 	PTRACE_EVENT_SYSCALL_COMPAT_ENTRY
> >> 	PTRACE_EVENT_SYSCALL_EXIT
> >> 	PTRACE_EVENT_SYSCALL_COMPAT_EXIT
> >
> > We can get away with just the first one.
> > (1) It's unlikely people would want to get native sysentry events but not compat ones,
> > thus first two options can be combined into one;
> 
> True.
> 
> > (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> > (3) if we would flag syscall entry with an event value in wait status, then syscall
> > exit will be already distinquisable.
> 
> False for execve which messes everything up by changing TID sometimes.

Is it disambiguated by PTRACE_EVENT_EXEC happening before the execve
returns, and you knowing the TID always changes to the PID?  I haven't
yet checked which TID gets the PTRACE_EVENT_EXEC event, but if it's
not the old one, perhaps that could be changed.

It would be good to improve the threaded execve() behaviour for all
the disappearing TIDs to issue a disappearing event, and the winning
execve changing-TID to issue an I-am-changing-TID even, anyway.

> > Thus, minimally we need one new option, PTRACE_O_TRACE_SYSENTRY -
> > "on syscall entry ptrace stop, set a nonzero event value in wait status"
> > , and two event values: PTRACE_EVENT_SYSCALL_ENTRY (for native entry),
> > PTRACE_EVENT_SYSCALL_ENTRY1 for compat one.
> 
> Not all code wants to receive a syscall exit event all the time, so
> if you add PTRACE_O_TRACE_SYSENTRY, please add PTRACE_O_TRACE_SYSEXIT
> too. That would pretty much halve ptrace's overhead for my use case.
> But this is orthogonal to the compat problem.

I agree.  I would like to ignore the exit for most syscalls but see a
few of them.  I guess PTRACE_SETOPTIONS could be used to toggle it,
with some overhead.  But in the spirit of this thread,
PTRACE_O_TRACE_BPF would be even better, to completely ignore
irrelevant syscalls :-)

> > To future-proof this scheme we may reserve a few more event values
> > PTRACE_EVENT_SYSCALL_ENTRY2, PTRACE_EVENT_SYSCALL_ENTRY3, etc,
> > if we'll ever have arches with more than one non-native syscall
> > entry. I'm no expert, but looking at strace code, ARM may already have
> > more than one additional convention how to pass syscall args.
> 
> Please, no! This way lays madness, just one PTRACE_EVENT_SYSCALL_ENTRY,
> no PTRACE_EVENT_SYSCALL_ENTRY1 or PTRACE_EVENT_SYSCALL_ENTRY2, that
> would be horrible. Keep arch specific stuff in arch specific areas,
> please don't spread it around.
> 
> What was wrong with using eflags again? Is it too simple or something?

Well it doesn't deal with the equivalent issue on ARM and PA-RISC.

-- Jamie
