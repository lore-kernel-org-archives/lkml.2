Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2JGSKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:10:09 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:60853 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2JGSKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:10:02 -0400
Date: Sun, 7 Oct 2012 18:04:20 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121007180420.GA900@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de, Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org, mingo@kernel.org,
	linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
	Richard Henderson <rth@twiddle.net>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Matt Turner <mattst88@gmail.com>
References: <20121006204736.GA1830@ds20.borg.net>
 <20121007165534.GA8024@redhat.com>
 <20121007171300.GA10942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007171300.GA10942@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 07:13:00PM +0200, Oleg Nesterov wrote:
> On 10/07, Oleg Nesterov wrote:
> >
> > Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
> > But _it seems_ to me that do_notify_resume() is called with irqs disabled.
> > If this is true, then imho arch/alpha should be fixed.
> >
> > Before this commit task_work_run() enabled irqs, but this was the "side
> > effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.
> 
> Could you please test the debugging patch below?

Of course. With that patch applied the kernel (ac3d0da) boots again. The trace line
is printed about once a second, with values '2' and '4'.

Thorsten

> 
> Oleg.
> 
> 
> --- x/arch/alpha/kernel/signal.c
> +++ x/arch/alpha/kernel/signal.c
> @@ -567,11 +567,19 @@ do_signal(struct pt_regs * regs, struct 
>  		ptrace_set_bpt(current);	/* re-set breakpoint */
>  }
>  
> +#include <linux/ratelimit.h>
> +
>  void
>  do_notify_resume(struct pt_regs *regs, struct switch_stack *sw,
>  		 unsigned long thread_info_flags,
>  		 unsigned long r0, unsigned long r19)
>  {
> +	if (irqs_disabled()) {
> +		printk_ratelimited(KERN_WARNING
> +			"NOTIFY with irqs_disabled:%lx\n", thread_info_flags);
> +		local_irq_enable();
> +	}
> +
>  	if (thread_info_flags & _TIF_SIGPENDING)
>  		do_signal(regs, sw, r0, r19);
>  
> 

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
