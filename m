Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1FFNMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:12:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43655 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab1FFNMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:12:21 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606131024.GA7386@elte.hu>
References: <4DEB933C.1070900@die-jansens.de>
	 <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu>
	 <20110605153218.GA31471@elte.hu> <4DEBA9CC.4090503@die-jansens.de>
	 <4DEBB05C.8090506@die-jansens.de> <4DEBB3DA.8060001@die-jansens.de>
	 <20110605172052.GA1036@elte.hu> <4DEBBFF9.2030101@die-jansens.de>
	 <20110605185957.GA3452@elte.hu>  <20110606131024.GA7386@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 15:12:08 +0200
Message-ID: <1307365928.2322.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 15:10 +0200, Ingo Molnar wrote:


> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3518539..1b9d2be 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -859,7 +859,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  		zap_locks();
>  	}
>  
> -	lockdep_off();

At the very least you should also do: s/raw_local_irq_/local_irq/ on
this function.

>  	spin_lock(&logbuf_lock);
>  	printk_cpu = this_cpu;
>  
> @@ -947,7 +946,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  	 * Try to acquire and then immediately release the
>  	 * console semaphore. The release will do all the
>  	 * actual magic (print out buffers, wake up klogd,
> -	 * etc). 
> +	 * etc).
>  	 *
>  	 * The console_trylock_for_printk() function
>  	 * will release 'logbuf_lock' regardless of whether it
> @@ -956,7 +955,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  	if (console_trylock_for_printk(this_cpu))
>  		console_unlock();
>  
> -	lockdep_on();
>  out_restore_irqs:
>  	raw_local_irq_restore(flags);
>  

