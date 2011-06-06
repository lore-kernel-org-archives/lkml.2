Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1FFOBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:01:01 -0400
Received: from r00tworld.com ([212.85.137.150]:52887 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1FFOA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:00:59 -0400
From: pageexec@freemail.hu
To: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 06 Jun 2011 15:58:44 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
In-reply-to: <BANLkTi=viR9DaQu2hzX4THdpDqfOZq-cXw@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DECC07A.8317.124A847C@pageexec.freemail.hu>, <BANLkTi=viR9DaQu2hzX4THdpDqfOZq-cXw@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 15:59:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 8:43, Andrew Lutomirski wrote:

> >> and it's less flexible
> >
> > why? as in, what kind of flexibility do you need that int xx can provide but a page
> > fault cannot?
> 
> The ability to make time() fast when configured that way.

true, nx and fast time() at vsyscall addresses will never mix. but it's a temporary
problem for anyone who cares, a trivial glibc patch fixes it.

> >> and it could impact a fast path in the kernel.
> >
> > a page fault is never a fast path, after all the cpu has just taken an exception
> > (vs. the syscall/sysenter style actually fast user->kernel transition) and is
> > about to make page table changes (and possibly TLB flushes).
> 
> Sure it is.  It's a path that's optimized carefully and needs to be as
> fast as possible.  Just because it's annoyingly slow doesn't mean we
> get to make it even slower.

sorry, but stating that the pf handler is a fast path doesn't make it so ;).
the typical pf is caused by userland to either fill in non-present pages
or do c-o-w, a few well predicted conditional branches in those paths are
simply not measurable (actually, those conditional branches would not be
on those paths, at least they aren't in PaX). seriously, try it ;).

> >> > another thing to consider for using the int xx redirection scheme (speaking
> >> > of which, it should just be an int3):
> >>
> >> Why?  0xcd 0xcc traps no matter what offset you enter it at.
> >
> > but you're wasting/abusing an IDT entry for no real gain (and it's lots of code
> > for such a little change). also placing sw interrupts among hw ones is what can
> > result in (ab)use like this:
> 
> I think it's less messy than mucking with the page fault handler.

do you know what that mucking looks like? ;) prepare for the most complex code
you've ever seen (it's in __bad_area_nosemaphore):

 779 #ifdef CONFIG_X86_64
 780 »·······if (mm && (error_code & PF_INSTR) && mm->context.vdso) {
 781 »·······»·······if (regs->ip == (unsigned long)vgettimeofday) {
 782 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, gettimeofday);
 783 »·······»·······»·······return;
 784 »·······»·······} else if (regs->ip == (unsigned long)vtime) {
 785 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, clock_gettime);
 786 »·······»·······»·······return;
 787 »·······»·······} else if (regs->ip == (unsigned long)vgetcpu) {
 788 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, getcpu);
 789 »·······»·······»·······return;
 790 »·······»·······}
 791 »·······}
 792 #endif

if there's complexity involved with the nx vsyscall page approach, it's certainly
not in the pf handler, rather in the moving of data/code into the vdso (something
that you have done or will do too eventually, so it's not an argument really against
my approach).

> >> I don't think that making the page NX is viable until at least 2012.
> >> We really want to wait for that glibc release.
> >
> > sure, if for mainline users performance impact is that much more important
> > then timing the nx approach for later is no problem (i'll just have to do
> > more work till then to revert/adapt this in PaX ;).
> 
> I think my approach is at least as paranoid as yours.  Why won't it
> work (if int 0xcc is disallowed from outside the vsyscall page)?

it's not about paranoia or what works ;). the question is, what goals are you
trying to achieve and what is the best way to achieve them. to me it appeared so
far that the fundamental problem you guys realized and wanted to do something
about is that 'attacker can rely on known code at known addresses in his exploit
attempts'. now if you only worry about the 'syscalls at fixed address' subset
of this problem, then sure, anything that removes them or makes them uniquely
identifiable solves that subset of the problem. but if you worry about the
bigger problem (as stated above) then your approach is not enough (in fact,
even my approach is not good enough since data can still be read or relied
upon in the vsyscall page at known addresses, so nothing short of removing it
cuts it really and i'm glad we're getting close to that goal finally).

> > it's *irrelevant*. this change you propose would go into future kernels,
> > it would not affect existing ones, obviously. therefore anyone possibly
> > affected would have to update his kernel first at which point they have
> > no excuse to not update their libc of whatever flavour as well.
> 
> That's not true.  New kernels are explicitly supposed to work with old
> userspace.

trust me, the nx vsyscall approach i implemented in PaX works with those old
userlands, even without users knowing it as it's not a configurable feature ;).

> Lots of users of old RHEL versions, for example, nonetheless run new kernels.  

if they go to the trouble of running fresh new vanilla kernels, they can surely
afford to patch a few lines in glibc? or if RH backports this to the RHEL kernel,
they can surely do the same with glibc?

