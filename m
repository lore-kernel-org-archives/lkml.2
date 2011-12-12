Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1LLP0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:26:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60883 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1LLP0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:26:18 -0500
Message-ID: <1323703531.21400.1.camel@twins>
Subject: Re: [PATCH -rt] printk: Disable migration instead of preemption
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Date: Mon, 12 Dec 2011 16:25:31 +0100
In-Reply-To: <1323696956-11445-1-git-send-email-rw@linutronix.de>
References: <1323696956-11445-1-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 14:35 +0100, Richard Weinberger wrote:
> There is no need do disable preemption in vprintk(),
> disable_migrate() is sufficient.
> This fixes also a the following bug in -rt:
> 
> [   14.759233] BUG: sleeping function called from invalid context
> at /home/rw/linux-rt/kernel/rtmutex.c:645

> ---
>  kernel/printk.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index a50af4e..13d0825 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -898,7 +898,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  	boot_delay_msec();
>  	printk_delay();
>  
> -	preempt_disable();
> +	migrate_disable();
>  	/* This stops the holder of console_sem just where we want him */
>  	raw_local_irq_save(flags);
>  	this_cpu = smp_processor_id();
> @@ -1029,7 +1029,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  out_restore_irqs:
>  	raw_local_irq_restore(flags);
>  
> -	preempt_enable();
> +	migrate_enable();
>  	return printed_len;
>  }
>  EXPORT_SYMBOL(printk);

One has to wonder why this patch makes any difference what so ever, note
how right after/before the preempt_disable/enable there's a
raw_local_irq_save/restore and last time I checked those really did
disable IRQs, even on -rt.


