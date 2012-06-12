Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2FLKYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:24:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2FLKYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:24:07 -0400
Date: Tue, 12 Jun 2012 12:24:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <20120522032554.GA11358@gmail.com>
Message-ID: <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
References: <20120522032554.GA11358@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ZOg2wU0uns8wEeRtKQgruWQT5xsOsyNWGrTaHTW4lip
 C+Mwq92OlE1kt8KUsoDtXLegLvo4x1T16Ci3P+jgG4Gp/vIe4+
 N/8816KZNrY3U/ZihJctj/UnEa5b3wZemgpMu4WY6PMKIS7rI0
 b8bAWTaxfnQJa+whwIkK5ENhyv8Mkj9/2mHxo7aA0JwUnmyPhM
 h7Gg+wRJEpNyJIeHmq94y7MTkpvFO4w2dYGmU1CwAWhOlrldUz
 7UpjtHX7Txcm8uUYGzemynKc1yfJto2eMFyYEJ4VFHZs71Ou0+
 uoyJ0yKTYpQkirXTnLnbH7fmZ0Bi7ezlPxTJDm8K0fOIBHNiA5
 MjkjISYnO+kli5dV8iUSb5FpvcWFDN69JPWtEb5fqeh5ODQa5X
 ij4sTvEunBQ+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

On Tue, 22 May 2012, Ingo Molnar wrote:

> Linus,
> 
> Please pull the latest irq-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus
> 
>    HEAD: e0d8ffd1df44518cb9ac9b1807d1f13cc100fc2f hexagon: Remove select of not longer existing Kconfig switches
> 
> A collection of small fixes.
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Thomas Gleixner (7):
>       genirq: Streamline irq_action
>       genirq: Reject bogus threaded irq requests

Correct me if I'm wrong, but the above patch, however good and correct in 
principle, breaks all existing drivers, that currently use 
request_threaded_irq() in this "bogus" way, namely, with NULL handler and 
without the IRQF_ONESHOT flag? Of those drivers I counted 73 in today's 
Linus' tree with a total of 92 call occurrences. Isn't this a bit too 
brutal? How about either doing it more gently (first just issue a warning) 
or first fixing them all? The current approach seems to just cause a bunch 
of regressions to me? I can provide a list of affected files, if someone 
volunteers to fix them all;-)

Thanks
Guennadi

>       genirq: Be more informative on irq type mismatch
>       genirq: Allow check_wakeup_irqs to notice level-triggered interrupts
>       genirq: Do not consider disabled wakeup irqs
>       arm: Select core options instead of redefining them
>       hexagon: Remove select of not longer existing Kconfig switches
> 
> 
>  arch/arm/Kconfig          |   10 +-------
>  arch/hexagon/Kconfig      |    2 -
>  include/linux/interrupt.h |    8 +++---
>  kernel/irq/chip.c         |    4 ++-
>  kernel/irq/manage.c       |   46 ++++++++++++++++++++++++++++++--------------
>  kernel/irq/pm.c           |    7 +++++-
>  kernel/irq/resend.c       |    7 ++++-
>  7 files changed, 51 insertions(+), 33 deletions(-)

[snip]

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 89a3ea8..585f638 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -565,8 +565,8 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>  		 * IRQF_TRIGGER_* but the PIC does not support multiple
>  		 * flow-types?
>  		 */
> -		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
> -				chip ? (chip->name ? : "unknown") : "unknown");
> +		pr_debug("genirq: No set_type function for IRQ %d (%s)\n", irq,
> +			 chip ? (chip->name ? : "unknown") : "unknown");
>  		return 0;
>  	}
>  
> @@ -600,7 +600,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>  		ret = 0;
>  		break;
>  	default:
> -		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
> +		pr_err("genirq: Setting trigger mode %lu for irq %u failed (%pF)\n",
>  		       flags, irq, chip->irq_set_type);
>  	}
>  	if (unmask)
> @@ -837,8 +837,7 @@ void exit_irq_thread(void)
>  
>  	action = kthread_data(tsk);
>  
> -	printk(KERN_ERR
> -	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
> +	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
>  	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
>  
>  	desc = irq_to_desc(action->irq);
> @@ -878,7 +877,6 @@ static int
>  __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  {
>  	struct irqaction *old, **old_ptr;
> -	const char *old_name = NULL;
>  	unsigned long flags, thread_mask = 0;
>  	int ret, nested, shared = 0;
>  	cpumask_var_t mask;
> @@ -972,10 +970,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		 */
>  		if (!((old->flags & new->flags) & IRQF_SHARED) ||
>  		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
> -		    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
> -			old_name = old->name;
> +		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
>  			goto mismatch;
> -		}
>  
>  		/* All handlers must agree on per-cpuness */
>  		if ((old->flags & IRQF_PERCPU) !=
> @@ -1031,6 +1027,27 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		 * all existing action->thread_mask bits.
>  		 */
>  		new->thread_mask = 1 << ffz(thread_mask);
> +
> +	} else if (new->handler == irq_default_primary_handler) {
> +		/*
> +		 * The interrupt was requested with handler = NULL, so
> +		 * we use the default primary handler for it. But it
> +		 * does not have the oneshot flag set. In combination
> +		 * with level interrupts this is deadly, because the
> +		 * default primary handler just wakes the thread, then
> +		 * the irq lines is reenabled, but the device still
> +		 * has the level irq asserted. Rinse and repeat....
> +		 *
> +		 * While this works for edge type interrupts, we play
> +		 * it safe and reject unconditionally because we can't
> +		 * say for sure which type this interrupt really
> +		 * has. The type flags are unreliable as the
> +		 * underlying chip implementation can override them.
> +		 */
> +		pr_err("genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
> +		       irq);
> +		ret = -EINVAL;
> +		goto out_mask;
>  	}
>  
>  	if (!shared) {
> @@ -1078,7 +1095,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  
>  		if (nmsk != omsk)
>  			/* hope the handler works with current  trigger mode */
> -			pr_warning("IRQ %d uses trigger mode %u; requested %u\n",
> +			pr_warning("genirq: irq %d uses trigger mode %u; requested %u\n",
>  				   irq, nmsk, omsk);
>  	}
>  
> @@ -1115,14 +1132,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	return 0;
>  
>  mismatch:
> -#ifdef CONFIG_DEBUG_SHIRQ
>  	if (!(new->flags & IRQF_PROBE_SHARED)) {
> -		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
> -		if (old_name)
> -			printk(KERN_ERR "current handler: %s\n", old_name);
> +		pr_err("genirq: Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
> +		       irq, new->flags, new->name, old->flags, old->name);
> +#ifdef CONFIG_DEBUG_SHIRQ
>  		dump_stack();
> -	}
>  #endif
> +	}
>  	ret = -EBUSY;
>  
>  out_mask:

[snip]

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
