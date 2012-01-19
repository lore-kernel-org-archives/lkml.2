Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2ASXzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:55:38 -0500
Received: from mail2.shareable.org ([80.68.89.115]:35526 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2ASXzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:55:36 -0500
Date: Thu, 19 Jan 2012 23:54:46 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Indan Zupancic <indan@nul.nu>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20120119235446.GR7180@jl-vm1.vm.bytemark.co.uk>
References: <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org>
 <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
 <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk>
 <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, Jan 19, 2012 at 8:01 AM, Jamie Lokier <jamie@shareable.org> wrote:
> > Andrew Lutomirski wrote:
> >> It's reasonable, obvious, and even more wrong than it appears.  On
> >> Xen, there's an extra 64-bit GDT entry, and it gets used by default.
> >> (I got bitten by this in some iteration of the vsyscall emulation
> >> patches -- see user_64bit_mode for the correct and
> >> unusable-from-user-mode way to do this.)
> >
> > Here it is:
> >
> >        static inline bool user_64bit_mode(struct pt_regs *regs)
> 
> This is pointless, even if it worked, which it clearly doesn't on Xen
> (or other random situations).
> 
> Why would you care?
> 
> The issue is *not* whether somebody is running in 32-bit mode or 64-bit mode.
> 
> The problem is the system call itself, and that can be 32-bit or
> 64-bit independently of the execution mode. So knowing the user-mode
> mode is simply not relevant.

Sorry, you're responding to a different question than the one I was
talking about.  My bad for adding to the confusion.

Mine was: strace currently checks the CS value and may have a bug on
existing/older kernels if Xen is involved when using the *normal*
syscall entry point (not int $0x80).  Can we patch strace to solve
that on those kernels in a generic way, or does the fix need to
hard-code knowledge of Xen's CS values (and any similar PV hypervisors
if there are any).

No amount of patching newer kernels will fix that, but it would be
nice if newer kernels made it unambiguous.

You've usefully pointed out that there's no reliable way to tell if
the tracee is executing in long mode.  If we're adding pseudo-flags to
say what kind of syscall it is, it would be no bad thing to have a
pseudo-flag to say if userspace is in long mode -- made available to
breakpoints and single-stepping as well.

-- Jamie
