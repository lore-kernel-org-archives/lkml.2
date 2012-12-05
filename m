Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2LERki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:40:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2LERkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:40:36 -0500
Date: Wed, 5 Dec 2012 17:40:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 23/44] metag: Traps
Message-ID: <20121205174035.GX4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-24-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354723742-6195-24-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:08:41PM +0000, James Hogan wrote:
> +TBIRES tail_end(TBIRES State, unsigned long orig_syscall)
> +{
> +	struct pt_regs *regs = (struct pt_regs *)State.Sig.pCtx;
> +	unsigned long flags;
> +
> +	if (user_mode(regs)) {
> +		local_irq_enable();
> +		/* This is actually a crucial little line - if the process
> +		 * needs swapping out, then this is where it happens!
> +		 */
> +		if (need_resched())
> +			schedule();
> +
> +		flags = current_thread_info()->flags;
> +		if (flags & (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME)) {
> +			/* Note the passing in of the original syscall number.
> +			 * This is used for implementing signal restart.
> +			 */
> +			do_notify_resume(regs, orig_syscall != 0,
> +					 orig_syscall, flags);

Owww....  So
	a) you can't get there with !user_mode(regs)
	b) you handle only one signal (what happens if you fail sigframe
allocation, BTW?  Sure, you get SIGSEGV delivered.  And don't handle it.)
	c) you read ->flags with no protection whatsoever.  It should be
done *before* you enable interrupts, and rechecked after you've done
do_notify_resume() and redisabled them.  The same for schedule().  It really
should be a loop; take a look at how it's done on arm and alpha - there that
loop is in C, not in asm glue.
	d) looks like your sigreturn is, indeed, broken.  It should *not* have
syscall restart logics triggered at all.
