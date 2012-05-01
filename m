Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2EAEbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:31:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53439 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2EAEbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:31:35 -0400
Date: Tue, 1 May 2012 05:31:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120501043129.GF6871@ZenIV.linux.org.uk>
References: <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120428024208.GS6871@ZenIV.linux.org.uk>
 <20120429161818.GA15792@redhat.com>
 <20120429180535.GZ6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429180535.GZ6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 07:05:35PM +0100, Al Viro wrote:
> > Looks like, the patch above fixes that.
> 
> Yes, found that shortly after posting.  No such luck for arm, though...

And for a bunch of other platforms too.  Situation right now:

alpha m68k powerpc sparc: do_notify_resume() reached only when returning to
user mode, no check

arm frv x86 mn10300: in current signal.git reached only when returning to
user mode, check removed

xtensa s390: reached only when returning to user mode, check removed

microblaze: in current signal.git reached only when returning to user mode,
check removed; also fixed bogus restart on sigreturn (a-la what had been
fixed on arm a couple of years ago) along with handling of multiple signal
arrivals.

blackfin: no loop (== multiple signals handling is fucked); no check either
        ret_from_fork doesn't handle signals, etc., userland or not.
        kernel_execve doesn't handle signals, etc., success or no success
        conclusion: check is probably not needed, multiple pending signals are
screwed

score: something very fishy there; fixing bogus restart on sigreturn is
simple, but what exactly clears regs->is_syscall on interrupts et.al.?
I don't see anything similar in there.  Looks like interrupts could be
confused for syscalls wrt restart logics.  And if happens when signal is
pending *and* %r4 contains e.g. -514, we'll get that -514 silently replaced
with -4.  Or cp0_epc gets decremented by 8, resulting in a couple of insns
getting repeated...  And regs->in_syscall is fairly deep in the stack,
so it doesn't look like it was something zeroed by hardware on interrupt...
What am I missing here?

It gets even funnier - in syscall_trace_enter, after we'd
done do_syscall_trace() we have this:
        brl     r8
(i.e. the actual call of sys_whatever_it_was()) followed by
        li      r8, -MAX_ERRNO - 1
        sw      r8, [r0, PT_R7]         # set error flag

        neg     r4, r4                  # error
        sw      r4, [r0, PT_R0]         # set flag for syscall
                                        # restarting
1:      sw      r4, [r0, PT_R2]         # result
        j       syscall_exit
which looks like a result of severe bitrot.  For one thing, regs->regs[0]
is *not* used anywhere in syscall restart logics in arch/score/kernel/signal.c;
for another, the whole thing looks like severely mangled remnants of
	if ((unsigned long)r4 >= (unsigned long)-MAX_ERRNO) {
		regs->regs[7] = 1;
		r4 = -r4;
	}
	regs->regs[4] = r4;
we do on normal (non-traced) syscall path.  Unconverted bits and pieces of
mips?  There return value does go into regs->regs[2] (and regs->regs[0] is
involved in syscall restart logics, while we are at it).  Overall, this
area looks very rotten.  BTW, what's the purpose of syscall_exit: there
and why is it different from syscall_return?  They seem to be identical
except for stray nop in the beginning of the former.  And unless something
very subtle is going on there, that nop *is* a stray one - namely, the
delay slot of immediately preceding "bl schedule_tail"...

Could the maintainers of arch/score tell what's going on?
