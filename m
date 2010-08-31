Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0HaAl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab0HaAlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:41:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Solar Designer <solar@openwall.com>
X-Fcc: ~/Mail/linus
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        oss-security@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org
CC: Brad Spengler <spender@grsecurity.net>, pageexec@freemail.hu
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger OOM-killer
In-Reply-To: Solar Designer's message of  Monday, 30 August 2010 23:48:06 +0400 <20100830194806.GC25870@openwall.com>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
	<20100830194806.GC25870@openwall.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100831004001.D6483400D8@magilla.sf.frob.com>
Date: Mon, 30 Aug 2010 17:40:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This makes sense to me.  However, introducing a new preemption point
> may violate assumptions under which the code was written and reviewed
> in the past.  In the worst case, we'd introduce/expose race conditions
> allowing for privilege escalation.

This can't be so.  There are already many possibilities for preemption
in the get_user_pages code paths (called from get_arg_page).

> > So, perhaps we want this (count already has a cond_resched in its loop):
> 
> Good point re: count() already having this (I think it did not in 2.2).

Indeed, this too is a clear indication that preemption here is already safe.

> > +		if (signal_pending(current))
> > +			return -ERESTARTNOINTR;
> > +		cond_resched();
> 
> So, in current kernels, you're making it possible for more kinds of
> things to change after prepare_binprm() but before
> search_binary_handler().  We'd need to check for possible implications
> of this.

What "change"?  Preemption is already possible, that's nothing new.
The only difference is that we might notice TIF_SIGPENDING having been
set, and bail out either before or after prepare_binprm, and so never
call search_binary_handler at all.

The user-visible effect of this could be that a process taking many signals
way too fast could get stuck permanently running its signal handlers and
never actually really attempting the execve (but perhaps doing some mm
setup and arg-copying work and then throwing it away, repeatedly).  Before,
the speed of the signals might have been such that the process could get
into the execve syscall, so it might happen to complete when now it would
be more likely to handle another signal before doing the exec instead.

That, and debuggers might ever see -ERESTARTNOHAND status in syscall
tracing for execve (as they already might for many other syscalls, so they
should be fine).

Note that get_user_pages() already fails for SIGKILL.  So a more
conservative change would be just fatal_signal_pending(current) checks.
That lets only SIGKILL short-circuit the execve to kill the process,
without just letting normal signals interrupt execve like they would
interrupt any other system call.  That should have exactly no
user-visible effects (aside from fairer scheduling in CONFIG_PREEMPT=n
kernels, and better responsiveness to SIGKILL in all kernels).  But I
think it's fine and proper to let all signals interrupt execve normally.

> additional risks we're exposed to, if any, when we allow preemption in
> current kernels?

That's not so much the point, since we already have plenty of places in
this code path that have voluntary preemption points.  We're just adding
more, which improves interactive scheduling performance for the rest of the
system when execve takes a long time copying the strings.

> - 64-bit kernel with 32-bit userland support (e.g., CONFIG_IA32_EMULATION);
> - 64-bit build of 64bit_dos.c;
> - 32-bit build of the target program;
> - no dynamic linking in the target program;
> - "ulimit -s unlimited" before running the reproducer program;
> - over 3 GB of RAM in the system.

I reproduced it too.  The lack of dynamic linking is not really a
requirement to get it to hit, though whether it fails in the kernel can
vary with the stack randomization.  (Sometimes it will instead be the
userland dynamic linker dying with a message that mmap failed.)

I think the right fix for that case is this:

diff --git a/fs/exec.c b/fs/exec.c
index 2d94552..0000000 100644  
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -594,6 +594,11 @@ int setup_arg_pages(struct linux_binprm 
 #else
 	stack_top = arch_align_stack(stack_top);
 	stack_top = PAGE_ALIGN(stack_top);
+
+	if (unlikely(stack_top < mmap_min_addr) ||
+	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))
+		return -ENOMEM;
+
 	stack_shift = vma->vm_end - stack_top;
 
 	bprm->p -= stack_shift;

That is consistent with the existing CONFIG_STACK_GROWSUP code's check
(though without the arbitrary 1GB limit it has).  We won't ever get to
shift_arg_pages if there isn't space to do the shift.

Brad made several of the same points that I made earlier and in this
message, so I concur with those. :-) 

Brad mentioned a possible BUG_ON if the executable's mappings clobber
the stack mapping.  With the fix above, I'm not aware how that could
happen.  I think it would just clobber part of the mapping with the
MAP_FIXED mapping, meaning it shortens the stack vma from the bottom, or
maybe splits it in the middle.  Then at user-mode entry point time, the
SP will point into some mapped text or data of the executable, and read
whatever is there instead of argc and argv[], etc.--it won't be as
graceful as an abortive execve, but it will just "safely" crash in some
random but normal userland sort of way.


Thanks,
Roland
