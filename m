Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2LERQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:16:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2LERQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:16:10 -0500
Date: Wed, 5 Dec 2012 17:16:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 19/44] metag: Signal handling
Message-ID: <20121205171609.GW4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (__copy_from_user(&st, &frame->uc.uc_stack, sizeof(st)))
> +		goto badframe;
> +	/* It is more difficult to avoid calling this function than to
> +	   call it and ignore errors.  */
> +	do_sigaltstack((__force const stack_t __user *)&st, NULL, regs->REG_SP);

"Dear sparse, please shut the fuck up.  This function might expect a userland
pointer for some reason, but I've just copied the damn thing on stack and
if I say that it's at userland address, at userland address it is".

1) __force-cast will make sparse to STFU, indeed
2) address of local variable is not a userland pointer.  In particular,
copy_from_user() will barf on it, unless you play with set_fs(), which
you don't do.
3) do_sigaltstack() *does* copy_from_user(), so it'll simply fail and do
nothing; adding set_fs() games would have prevented that, but why the hell
bother creating a local copy in the first place?  Just give &frame->uc.uc_stack
to do_sigaltstack() and check that it hasn't returned -EFAULT.
4) sh et.al. were broken in exactly the same way.  Fixed in mainline now.
5) if you need a force-cast, it might be worth figuring out what's going on.

> +static void do_signal(struct pt_regs *regs, int from_syscall,
> +		      unsigned int orig_syscall)
> +{
> +	struct k_sigaction ka;
> +	siginfo_t info;
> +	int signr;
> +
> +	/*
> +	 * We want the common case to go fast, which
> +	 * is why we may in certain cases get here from
> +	 * kernel mode. Just return without doing anything
> +	 * if so.
> +	 */
> +	if (!user_mode(regs))
> +		return;

Can you really get here with !user_mode(regs)?  If so, you are very likely
screwed and badly.

> +	if (from_syscall) {
> +		/* Restart the system call - no handlers present */
> +		switch (syscall_get_error(current, regs)) {
> +		case -ERESTARTNOHAND:
> +		case -ERESTARTSYS:
> +		case -ERESTARTNOINTR:
> +			regs->REG_SYSCALL = orig_syscall;
> +			regs->REG_PC -= 4;

... and what's to prevent getting here again?  Unless you only handle one
signal and bugger off to userland immediately, which is also quite broken.
BTW, what's to stop the syscall restart triggering if you catch a signal
while in rt_sigreturn(2)?
