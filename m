Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2D1Uz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 16:55:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50881 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2D1UzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 16:55:25 -0400
Date: Sat, 28 Apr 2012 21:55:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: avoid calling do_signal() after fork from a
 kernel thread
Message-ID: <20120428205517.GW6871@ZenIV.linux.org.uk>
References: <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
 <20120427231526.GP6871@ZenIV.linux.org.uk>
 <20120427235023.GR6871@ZenIV.linux.org.uk>
 <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 02:51:43PM -0400, Chris Metcalf wrote:
> Calling interrupt_return will check the privilege of the context we're
> returning to avoid the possibility of kernel threads doing any kind
> of userspace actions (including signal handling) after a fork.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> Al, thanks for noticing this.  I've queued it up for 3.4.
> 
> Do you have a case that might provoke the signal behavior in the
> unpatched code?  The patched code passes our internal regressions.
> 
>  arch/tile/kernel/intvec_32.S |    2 +-
>  arch/tile/kernel/intvec_64.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
> index 5d56a1e..d0f48ca 100644
> --- a/arch/tile/kernel/intvec_32.S
> +++ b/arch/tile/kernel/intvec_32.S
> @@ -1274,7 +1274,7 @@ STD_ENTRY(ret_from_fork)
>  	FEEDBACK_REENTER(ret_from_fork)
>  	{
>  	 movei  r30, 0               /* not an NMI */
> -	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
> +	 j      interrupt_return
>  	}
>  	STD_ENDPROC(ret_from_fork)

Umm...  I'm not sure that it's correct.  For one thing, ret_from_fork is
used both for kernel threads and for plain old fork(2).  In the latter
case you want .Lresume_userspace, not interrupt_return.  For another,
there's kernel_execve() and if it fails (binary doesn't exist/has wrong
format/etc.) you'll get to .Lresume_userspace with EX1_PL(regs->ex1)
unchanged, i.e. the kernel one...

Frankly, with the way you have that stuff done I'd rather do just this:

int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
{
	if (!user_mode(regs))
		return 0;
	....
}

and be done with that.  Unless I'm seriously misreading your code it'll do
the right thing with no changes to asm glue.  As for the reproducer, just
guess the PID of modprobe when you are e.g. trying to mount a filesystem
with fs driver modular and not loaded; fork(), have parent wait a bit
and call mount(), while the child keeps sending something more or less
innocent (SIGCHLD, for example) to the guessed PID.  And either have
/sbin/modprobe chmod -x before doing that (you'll need to remember to
chmod it back before reboot, of course) or just
mount --bind /dev/null /sbin/modprobe.  Either way, kernel_execve() will
fail.  And if you manage to hit the sucker just as it's being spawned,
you'll get the kernel_thread() codepath as well.

FWIW, I like what you've done with do_work_pending() - it's much cleaner
than usual loops and tests in assembler.  The only question is, what's
going on with
	push_extra_callee_saves r0
you are doing there - seems possibly over the top for situations when
SIGPENDING isn't set and, more seriously, what if you go through that
loop many times?  You slap them again and again into pt_regs, overwriting
anything ptrace() might've done to r34..r51, right?

Smells like something that should be done only once, not on each iteration
through the loop...
