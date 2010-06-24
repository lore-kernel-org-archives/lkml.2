Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0FXGnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:43:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:44833 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0FXGnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="811005222"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277361352.1875.838.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 14:43:11 +0800
Message-ID: <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

On Thu, 2010-06-24 at 14:35 +0800, Peter Zijlstra wrote:
> Something like this, but filled out with some arch code that does the
> self-ipi and calls irq_work_run() should do.
> 
> No need to molest the softirq code, no need for limited vectors of any
> kind.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/irq_callback.h |   13 ++++++++
>  kernel/irq_callback.c        |   66 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
> 
> Index: linux-2.6/include/linux/irq_callback.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/irq_callback.h
> @@ -0,0 +1,13 @@
> +#ifndef _LINUX_IRQ_CALLBACK_H
> +#define _LINUX_IRQ_CALLBACK_H
> +
> +struct irq_work {
> +	struct irq_work *next;
> +	void (*func)(struct irq_work *);
> +};
> +
> +int irq_work_queue(struct irq_work *entry, void (*func)(struct irq_work *));
> +void irq_work_run(void);
> +void irq_work_sync(struct irq_work *entry);
> +
> +#endif /* _LINUX_IRQ_CALLBACK_H */
> Index: linux-2.6/kernel/irq_callback.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/kernel/irq_callback.c
> @@ -0,0 +1,66 @@
> +
> +#include <linux/irq_callback.h>
> +
> +#define CALLBACK_TAIL ((struct irq_work *)-1UL)
> +
> +static DEFINE_PER_CPU(struct irq_work *, irq_work_list) = {
> +	CALLBACK_TAIL,
> +};
> +
> +int irq_work_queue(struct irq_work *entry, void (*func)(struct irq_work *))
> +{
> +	struct irq_work **head;
> +
> +	if (cmpxchg(&entry->next, NULL, CALLBACK_TAIL) != NULL)
> +		return 0;
> +
> +	entry->func = func;
> +
> +	head = &get_cpu_var(irq_work_list);
> +
> +	do {
> +		entry->next = *head;
> +	} while (cmpxchg(head, entry->next, entry) != entry->next);
> +
> +	if (entry->next == CALLBACK_TAIL)
> +		arch_self_ipi();
> +
> +	put_cpu_var(irq_work_list);
> +	return 1;
> +}
> +
> +void irq_work_run(void)
> +{
> +	struct irq_work *list;
> +
> +	list = xchg(&__get_cpu_var(irq_work_list), CALLBACK_TAIL);
> +	while (list != CALLBACK_TAIL) {
> +		struct irq_work *entry = list;
> +
> +		list = list->next;
> +		entry->func(entry);
> +
> +		entry->next = NULL;
> +		/*
> +		 * matches the mb in cmpxchg() in irq_work_queue()
> +		 */
> +		smp_wmb();
> +	}
> +}
> +
> +static int irq_work_pending(struct irq_work *entry)
> +{
> +	/*
> +	 * matches the wmb in irq_work_run
> +	 */
> +	smp_rmb();
> +	return entry->next != NULL;
> +}
> +
> +void irq_work_sync(struct irq_work *entry)
> +{
> +	WARN_ON_ONCE(irqs_disabled());
> +
> +	while (irq_work_pending(entry))
> +		cpu_relax();
> +}

I fact I uses exactly the similar method in my patches, just trigger it
with soft_irq instead of IRQ. Please take a look at
nmi_return_notifier_schedule in

[RFC 2/5] NMI return notifier

Best Regards,
Huang Ying


