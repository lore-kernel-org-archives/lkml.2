Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2IUSjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:39:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51061 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2IUSjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:39:36 -0400
Date: Fri, 21 Sep 2012 19:39:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120921183934.GK13973@ZenIV.linux.org.uk>
References: <20120917032651.GU13973@ZenIV.linux.org.uk>
 <1348244799-16013-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348244799-16013-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 12:26:36PM -0400, Mark Salter wrote:
> Here are a set of c6x patches to work with your experimental-kernel_thread
> branch.
> 
> Mark Salter (3):
>   c6x: add ret_from_kernel_thread(), simplify kernel_thread()
>   c6x: switch to generic kernel_execve
>   c6x: switch to generic sys_execve

Applied and pushed...

FWIW, the current status:

alpha - done, tested on hardware
arm - done, tested on qemu
c6x - done by maintainer
frv - done, untested
m68k - done, tested on aranym; there's a known issue in copy_thread() in
case of coldfire-MMU, presumably to be handled in m68k tree (I can do it
in this one instead, if m68k folks would prefer it that way)
mn10300 - done, untested
powerpc - done, tested on qemu (32bit and 64bit)
s390 - done, tested on hercules (31bit and 64bit)
x86 - done, tested on kvm guests (32bit and 64bit)
um - done, tested on amd64 host (32bit and 64bit)

avr32 - no
blackfin - no, should be easy to write, NFI how to test
cris - no
h8300 - no
hexagon - no
ia64 - no
m32r - no
microblaze - no
mips - no, and if I understood Ralf correctly, he prefers to deal with his
asm glue surgery first.
openrisc - no
parisc - no, and there might be interesting issues writing that stuff.  One
good thing is that I can test it on actual hw (32bit only, though)
score - no (and AFAICS that port is essentially abandonware)
sh - no
sparc - no, will get around to it.  That I can test on actual hw...
tile - no
unicore32 - no, should be easy to copy arm solution
xtensa - no

The future plans for that series are
	* kill daemonize() - only one caller, it's in drivers/staging and
it's trivial to eliminate.
	* convert powerpc eeh_event_handler() to kthread_run()
	* pull the calls of do_exit()/sys_exit() into the kernel_thread
callbacks themselves; there are very few such callbacks (kernel_thread() is
really a very low-level thing) and most of them never return - either loop
forever, or call exit() themselves, or do kernel_execve() and panic() on
failure of that (kernel_init()).  It boils down to adding do_exit() on
failure in ____call_usermodehelper(), adding do_exit() in the end of
wait_for_helper() and adding do_exit() on failure in do_linuxrc().  That's
it.  What we get out of that is removal of asm glue calling exit() after
the call of kernerl_thread() payload - on each architecture.
	* once that is done (and assuming we have all architectures converted),
we can do the following trick:
void __init kernel_init_guts(void)
{
	/* current kernel_init() sans the call of init_post() */
}
int __ref kernel_init(void *unused)
{
	kernel_init_guts();
	/* stuff currently in init_post() */
}
and we can drastically simplify kernel_execve().  Note that there are only
3 callers, all of them in kernel_thread() payloads.  Moreover, at that point
we have the whole path to caller of the payload (i.e. ret_from_kernel_thread)
alive and well (that's what the trick above is for).  So let's just replace
kernel_execve() with doing do_execve() *on* *default* *pt_regs*.  And turn
ret_from_kernel_thread into
	call schedule_tail()
	find the payload function and its argument
	call the payload
	go to normal return from syscall path (i.e. what ret_from_kernel_execve
is doing, but without any need to do magic to stack pointer, etc.)
Note that this is practically the same thing as ret_from_fork, except for
calling the damn payload.  Which either does exit(), or returns after
successful do_execve().  
	At that point we can get rid of pt_regs argument of do_execve().
And search_binary_handler().  And all kinds of foo_load_binary().  When said
foo_load_binary() wants pt_regs, it should simply call current_pt_regs() and
be done with that...
	* I'm considering generic implementations of fork/vfork/clone -
all it takes is current_user_stack_pointer() (defaulting to
user_stack_pointer(current_pt_regs()); all architectures that don't
have said userland stack pointer stored in pt_regs happen to have such
function already, called rdusp() in all such cases).  That helper is
enough to make practically all instances of fork/vfork/clone identical.
Again, it's up to the architecture whether it wants to use that or not,
but it promises quite a bit of boilerplate removal *AND* we are getting
rid of wonders like
asmlinkage int sys_fork(long r10, long r11, long r12, long r13, long mof, long srp, struct pt_regs *regs)
or
asmlinkage int sys_fork(unsigned long r0, unsigned long r1, unsigned long r2,
        unsigned long r3, unsigned long r4, unsigned long r5, unsigned long r6,
        struct pt_regs regs)

and similar bits of black magic.  And black magic it is - in the second case
(m32r) we are *badly* abusing C ABI.  Took me a while to figure out WTF
was going on there - in reality, (void *)&regs will be equal to (void *)&r4.
Compiler has every right to be unhappy.
	* first 4 arguments go in registers (and are unused)
	* arguments 5, 6 and 7 are expected to be on top of stack
	* argument 8 is expected to be passed as a pointer to copy, also
on stack.
So compiler expects r0 to r3 in registers, with r4, r5, r6, &regs, regs
on top of stack.  In reality, pt_regs ther starts with 3 longs and pointer
to pt_regs.  Initialized with the address of structure itself.  So we get
r4 aliased to regs.r4, r5 - to regs.r5, r6 - to regs.r6 and what would've
been a hidden pointer to regs - to regs.pt_regs.  The worst part is, all
that trickery is absolutely pointless - the pointer we are looking for is
(sp & ~(THREAD_SIZE - 1)) + constant, so it actually costs *more* to do
it that way; we fetch the sucker from *(sp + constant_offset), which is
going to be slower, even leaving aside the price of storing it there
back when we'd been setting the pt_regs up on the way in.  Kernel isn't
IOCCC, damnit...

And it's not the worst example, actually ;-/  All that crap is brittle and
ugly, for no reason whatsoever.  Sigh...
