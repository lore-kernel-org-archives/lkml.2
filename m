Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1FINz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:55:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1FINzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:55:53 -0400
Date: Thu, 9 Jun 2011 15:55:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
Message-ID: <20110609135542.GD21100@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.590149293@chello.nl>
 <20110609133228.GB21100@elte.hu>
 <1307626856.3941.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307626856.3941.80.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> +static void __console_flush(void);

I'd suggest moving this function to the right place, so that no 
prototypes are necessary.

> +/*
> + * Special 'atomic' semaphore operations that mimmick down_trylock() + up(),

mimic

> + * except they don't release the semaphore internal lock and optimize the
> + * sem->count fiddling away.
> + *
> + * The advantage is that this construct doesn't generate wakeups on atomic_up()
> + * since any contending semaphore acuiqisition will still be spinning on the

acquisition.

> + * internal lock, instead of having gotten queued on the wait_list.
> + *
> + * printk() uses this to avoid generating wakeups, which would make it unsafe
> + * to use in certain contexts (avoids lock inversion or lock recursion with
> + * the scheduler locks).
> + *
> + * Assumes IRQs are disabled.

I'd add:

    * Note: We emphatically do *not* want this function exported. Ever.

and maybe:

    * Note2: Even asking for that will likely buy you a nasty response.

> + */
> +static int atomic_down_trylock(struct semaphore *sem)
> +{
> +	spin_lock(&sem->lock);
> +	if (sem->count > 0)
> +		return 0;
> +
> +	spin_unlock(&sem->lock);
> +	return 1;
> +}
> +
> +static void atomic_up(struct semaphore *sem)
> +{
> +	spin_unlock(&sem->lock);
> +}
> +
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  {
>  	int printed_len = 0;
> @@ -943,19 +939,14 @@ asmlinkage int vprintk(const char *fmt, 
>  		if (*p == '\n')
>  			new_text_line = 1;
>  	}
> +	printk_cpu = UINT_MAX;
> +	spin_unlock(&logbuf_lock);

Hm, is that printk_cpu setting inside the critical section safe? What 
happens if we get an NMI on this CPU in that window?

Thanks,

	Ingo
