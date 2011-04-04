Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1DDQFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:05:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab1DDQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:05:12 -0400
Date: Mon, 4 Apr 2011 18:04:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] avr32: init cannot ignore signals sent by
	force_sig_info()
Message-ID: <20110404160447.GB23655@redhat.com>
References: <1301929084-2025-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301929084-2025-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Matt Fleming wrote:
>
> --- a/arch/avr32/kernel/traps.c
> +++ b/arch/avr32/kernel/traps.c
> @@ -95,28 +95,6 @@ void _exception(long signr, struct pt_regs *regs, int code,
>  	info.si_code = code;
>  	info.si_addr = (void __user *)addr;
>  	force_sig_info(signr, &info, current);
> -
> -	/*
> -	 * Init gets no signals that it doesn't have a handler for.
> -	 * That's all very well, but if it has caused a synchronous
> -	 * exception and we ignore the resulting signal, it will just
> -	 * generate the same exception over and over again and we get
> -	 * nowhere.  Better to kill it and let the kernel panic.
> -	 */
> -	if (is_global_init(current)) {
> -		__sighandler_t handler;
> -
> -		spin_lock_irq(&current->sighand->siglock);
> -		handler = current->sighand->action[signr-1].sa.sa_handler;
> -		spin_unlock_irq(&current->sighand->siglock);
> -		if (handler == SIG_DFL) {
> -			/* init has generated a synchronous exception
> -			   and it doesn't have a handler for the signal */
> -			printk(KERN_CRIT "init has generated signal %ld "
> -			       "but has no handler for it\n", signr);
> -			do_exit(signr);
> -		}
> -	}

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

