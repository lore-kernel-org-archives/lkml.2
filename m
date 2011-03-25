Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1CYWc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:32:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:52924 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab1CYWcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:32:55 -0400
Date: Fri, 25 Mar 2011 23:32:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] genirq: Split irq_set_affinity() so it can be
 called with lock held
In-Reply-To: <1301081931-11240-4-git-send-email-ddaney@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1103252331490.31464@localhost6.localdomain6>
References: <1301081931-11240-1-git-send-email-ddaney@caviumnetworks.com> <1301081931-11240-4-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, David Daney wrote:

> The .irq_cpu_online() and .irq_cpu_offline() functions may need to
> adjust affinity, but they are called with the descriptor lock held.
> Create __irq_set_affinity_locked() which is called with the lock held.
> Make irq_set_affinity() just a wrapper that acquires the lock.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  include/linux/interrupt.h |    2 ++
>  kernel/irq/manage.c       |   40 ++++++++++++++++++++++++++--------------
>  2 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 59b72ca..815f9fb 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -229,6 +229,8 @@ static inline int check_wakeup_irqs(void) { return 0; }
>  extern cpumask_var_t irq_default_affinity;
>  
>  extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
> +extern int __irq_set_affinity_locked(struct irq_desc *desc,
> +				     const struct cpumask *cpumask);
>  extern int irq_can_set_affinity(unsigned int irq);
>  extern int irq_select_affinity(unsigned int irq);
>  
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 0a2aa73..3d3bed1 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -139,24 +139,12 @@ static inline void
>  irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
>  #endif
>  
> -/**
> - *	irq_set_affinity - Set the irq affinity of a given irq
> - *	@irq:		Interrupt to set affinity
> - *	@cpumask:	cpumask
> - *
> - */
> -int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
> +
> +int __irq_set_affinity_locked(struct irq_desc *desc, const struct cpumask *mask)
>  {
> -	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irq_chip *chip = desc->irq_data.chip;
> -	unsigned long flags;
>  	int ret = 0;
>  
> -	if (!chip->irq_set_affinity)
> -		return -EINVAL;

We want to keep that check here. No need to crash with a NULL pointer
dereference, when we can deal with it gracefully.

Thanks,

	tglx
