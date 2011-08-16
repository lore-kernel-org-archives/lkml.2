Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1HPRl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1HPRl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:41:27 -0400
Date: Tue, 16 Aug 2011 19:38:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 31/41] um: Don't restore current->blocked on error
Message-ID: <20110816173830.GF29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-32-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-32-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> If we fail to setup the signal stack frame then we don't need to
> restore current->blocked because it is not modified by
> setup_signal_stack_*.

Yes. And this is simply wrong if TIF_RESTORE_SIGMASK. We can block
SIGSEGV which we need to dequeue.

ACK

> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/um/kernel/signal.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
> index 1812524..d177685 100644
> --- a/arch/um/kernel/signal.c
> +++ b/arch/um/kernel/signal.c
> @@ -66,13 +66,9 @@ static int handle_signal(struct pt_regs *regs, unsigned long signr,
>  #endif
>  		err = setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
>  
> -	if (err) {
> -		spin_lock_irq(&current->sighand->siglock);
> -		current->blocked = *oldset;
> -		recalc_sigpending();
> -		spin_unlock_irq(&current->sighand->siglock);
> +	if (err)
>  		force_sigsegv(signr, current);
> -	} else {
> +	else {
>  		sigset_t blocked:
>  
>  		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
> -- 
> 1.7.4.4
> 

