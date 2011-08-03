Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1HCNLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab1HCNK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:10:59 -0400
Date: Wed, 3 Aug 2011 15:08:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: avr32: handle_signal() bug?
Message-ID: <20110803130813.GA11708@redhat.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Matt Fleming wrote:
>
> 	 * Block the signal if we were unsuccessful.
> 	 */
> 	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
> 		spin_lock_irq(&current->sighand->siglock);
> 		sigorsets(&current->blocked, &current->blocked,
> 			  &ka->sa.sa_mask);
> 		sigaddset(&current->blocked, sig);
> 		recalc_sigpending();
> 		spin_unlock_irq(&current->sighand->siglock);
> 	}

Agreed, this looks "obviously wrong". We should block the !SA_NODEFER
signal it was delivered.

> Is there some intricacy of the avr32 architecture that I'm missing here?

same question here ;)

> --- a/arch/avr32/kernel/signal.c
> +++ b/arch/avr32/kernel/signal.c
> @@ -238,22 +238,21 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
>  	 */
>  	ret |= !valid_user_regs(regs);
>  
> +	if (ret != 0) {
> +		force_sigsegv(sig, current);
> +		return;
> +	}
> +
>  	/*
> -	 * Block the signal if we were unsuccessful.
> +	 * Block the signal if we were successful.
>  	 */
> -	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
> -		spin_lock_irq(&current->sighand->siglock);
> -		sigorsets(&current->blocked, &current->blocked,
> -			  &ka->sa.sa_mask);
> +	spin_lock_irq(&current->sighand->siglock);
> +	sigorsets(&current->blocked, &current->blocked,
> +		  &ka->sa.sa_mask);
> +	if (!(ka->sa.sa_flags & SA_NODEFER))
>  		sigaddset(&current->blocked, sig);
> -		recalc_sigpending();
> -		spin_unlock_irq(&current->sighand->siglock);
> -	}
> -
> -	if (ret == 0)
> -		return;
> -
> -	force_sigsegv(sig, current);
> +	recalc_sigpending();
> +	spin_unlock_irq(&current->sighand->siglock);
>  }

I think this is correct.

Oleg.

