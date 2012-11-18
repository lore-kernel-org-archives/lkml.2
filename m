Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KRFpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 00:45:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46062 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2KRFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 00:45:15 -0500
Date: Sun, 18 Nov 2012 05:45:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: sigaltstack fun (was Re: new execve/kernel_thread design)
Message-ID: <20121118054510.GE16916@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
 <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
 <20121017160702.GY2616@ZenIV.linux.org.uk>
 <20121017161953.GZ2616@ZenIV.linux.org.uk>
 <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
 <20121115215529.GU2616@ZenIV.linux.org.uk>
 <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:59:25AM +0100, Michal Simek wrote:
> Do you have set of tests which should run it?
> 
> 
> > 2) your definition of current_pt_regs() is an exact copy of on in
> > include/linux/ptrace.h; why is "microblaze: Define current_pt_regs"
> > needed at all?  IOW, I'd rather added #include <linux/ptrace.h> to
> > arch/microblaze/kernel/process.c instead...
> 
> Agree. Fixed.
> 
> I have updated that branch or I can send you patches if you like.

Pulled; see #arch-microblaze in there (== beginning of your branch).
As for the other things I'd like to see confirmed...  See #for-michal;
4 commits in there had been hanging around for a long time and if
you are OK with those, I'd like to see them gone into mainline,
by whichever path you prefer.

Another thing that looks like a bug - consider the following testcase:

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
void handler(int n, siginfo_t *foo, void *bar)
{
	char *signame = n == SIGUSR1 ? "SIGUSR1" : "SIGUSR2";
	stack_t stack;
	sigaltstack(NULL, &stack);
	printf("took %s%s\n", signame,
		stack.ss_flags == SS_ONSTACK ? " on altstack" : "");
	if (n == SIGUSR1)
		raise(SIGUSR2);
	printf("%s done\n", signame);
}

main()
{
	struct sigaction s = {
		.sa_sigaction = handler,
		.sa_flags = SA_ONSTACK | SA_SIGINFO
	};
	stack_t stack = {.ss_sp = malloc(16384), .ss_size = 16384};
	sigaction(SIGUSR2, &s, NULL);
	sigaction(SIGUSR1, &s, NULL);
	sigaltstack(&stack, NULL);
	raise(SIGUSR1);
}

Should print
took SIGUSR1 on altstack
took SIGUSR2 on altstack
SIGUSR2 done
SIGUSR1 done
- we raise SIGUSR1, it's marked onstack, we flip to altstack, raise SIGUSR2
and we are still on altstack, obviously.  Now, think what happens on the
way *out* - rt_sigreturn from the second handler will call do_sigaltstack(),
passing it the saved altstack settings... and the user stack pointer we'll
get once we return to caller.  I.e. something within the altstack.  Which
will give you -EPERM.  Which will have microblaze sys_rt_sigreturn() force-feed
you SIGSEGV, AFAICS.

IOW, there's a reason why rt_sigreturn implementations ignore -EPERM from
do_sigaltstack().  A bad one, but...  FWIW, sigaltstack handling is a mess
right now:
	* every architecture has the sucker done separately, even though
there's very little point doing so; worse yet, they tend to come with
asm wrappers from hell, all for no good reason - we need to get userland
stack pointer and that's done in all kinds of messy ways.
	* biarch ones have compat versions that ought to be mergable as
well.
	* rt_sigreturn instances call do_sigaltstack() and ignore just
about everything; -EFAULT is not ignored, but realistically it's impossible
to hit - you'd need a race with munmap() ripping the stack page from under
you just as you've almost finished with sigreturn.  Accesses on both sides
of that stack_t had been done by that point, so nothing short of such munmap()
would do.  Everything else *is* ignored, or we are screwed.  AFAICS, that's
what microblaze has stepped into.

As far as I can tell, the sane way to deal with that would be to introduce
(mandatory) helper that would give you the current userland stack pointer.
It's almost always either user_stack_pointer(current_pt_regs()) or rdusp().
There are few exceptions - itanic has user_stack_pointer giving the backing
store of register stack instead of desired r12 and several architectures
lack user_stack_pointer() even though the stack pointer is saved in pt_regs
and helper is trivial to add.  That dealt with, we can take sys_sigaltstack()
to kernel/signal.c unconditionally.  And kill the wrappers on almost everything.
The next step is unifying compat variants; AFAICS, that's also not a problem.
Then we need bool restore_altstack(const stack_t __user *) and compat
counterpart - originally with "call do_sigaltstack(), fail if and only if
it has returned -EFAULT", then a saner behaviour ("if we are not asked to
change the current settings, just succeed and to hell with on_sig_stack()
check; any other error case means that sigframe had been deliberately messed
with and deserves a failure").

Linus, do you have any objections to the above?  FWIW, I've a tentative
patchset in that direction (most of it from the last cycle); right now
it + stuff currently in signal.git#for-next is at -3.4KLoC and I hadn't
dealt with the biarch side of things yet...
