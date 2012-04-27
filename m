Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2D0VMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:12:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34390 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2D0VMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:12:49 -0400
Date: Fri, 27 Apr 2012 22:12:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427211244.GO6871@ZenIV.linux.org.uk>
References: <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427202002.8ED632C0BF@topped-with-meat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:20:02PM -0700, Roland McGrath wrote:

> But I will say that the intent of tracehook_signal_handler has always
> been what its kerneldoc says: Call it once when handler setup is
> complete (exactly once per signal delivery, so potentially multiple
> times before actually returning to user mode).  Though it is indeed a
> no-op today when stepping==0, we want its use to continue to conform
> to that exact definition so that one day we could add e.g. a
> PTRACE_EVENT_SIGNAL_HANDLED feature just by hacking tracehook.h and
> not have to go back into every arch's signal code and recover
> understanding of how the call is being used.  (It was more than enough
> work to do that once when I broke out and documented the tracehook.h
> interfaces the first time.)  You know, as if we thought modularity
> were a useful notion.

OK...  FWIW, it sounds like an argument for using it (or a function in
kernel/signal.c that would call it) on all architectures.

Note that there's an extra complication on alpha and itanic - we have more
than just struct pt_regs * there.  If we care about the rest of registers
(struct switch_stack on alpha), we probably need to do something about that.
Hell knows...  On alpha, in particular, we always get switch_stack argument
of do_notify_resume() et.al. at the constant offset below pt_regs one -
        mov     $sp, $16
        bsr     $1, do_switch_stack
        mov     $sp, $17
is how it's done.  So there we could switch to use of container_of().  On
ia64 we have struct sigscratch with pt_regs embedded into it, so there
container_of() is also reasonable.  I wonder how alpha and itanic deal
with do_coredump(), BTW - it gets pt_regs, but not the rest...

Another fun story: x86 and mips has do_notify_resume() with void *unused as
its second argument.  It used to be sigset_t *oldset and it remains unused
since 2006 or so.  Three years later arch/score went in - with the same
void *unused as the second argument of do_notify_resume().  Gotta love the
cargo-cult programming...

BTW, what's the story with 'cookie' argument of get_signal_to_deliver()?
Everything passes NULL in it and nothing actually looks at the value
passed (it's passed further without being looked at, until it reaches
ptrace_signal_deliver(), which ignores it completely on all architectures).
AFAICS, it's a rudiment of something that was used only on sparc and got
discarded as hopeless in commit 28e6103665301ce60634e8a77f0b657c6cc099de
Author: David S. Miller <davem@davemloft.net>
Date:   Sun May 11 02:07:19 2008 -0700
    sparc: Fix debugger syscall restart interactions.
Is there anything else to it?  If not, I'd rather get rid of that thing...
Frankly, I'm somewhat tempted to add something like
struct k_sigcontext {
	int sig;
	siginfo_t info;
	struct k_sigaction ka;
}; and turn get_signal_to_deliver into
bool get_signal_to_deliver(struct k_sigcontext *ctx, struct pt_regs *regs),
with ctx passed through handle_signal/setup_frame/tracehook_signal_deliver
instead of the same triple shoved into three arguments, in more or less
random order as it's done now.  Perhaps let tracehook_signal_deliver() keep
its type and semantics and introduce
void signal_delivered(struct k_sigcontext *, struct pt_regs *, int stepping)
that would be called by all handle_signal() after successful frame setup
and would call tracehook_... itself, after having done block_sigmask()...
