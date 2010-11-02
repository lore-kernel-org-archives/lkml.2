Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab0KBHvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:51:15 -0400
Received: from mail4.comsite.net ([205.238.176.238]:63281 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0KBHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:51:12 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Stephen Caudle <scaudle@codeaurora.org>
Subject: Re: [PATCH] [ARM] gic: Unmask private interrupts on all cores during IRQ enable
In-Reply-To: <1288629595-15331-1-git-send-email-scaudle@codeaurora.org>
References: <1288629595-15331-1-git-send-email-scaudle@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        adharmap@codeaurora.org, linux@arm.linux.org.uk
Date: Tue, 02 Nov 2010 01:51:00 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1288684260_11540@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Nov 2010 about 12:39:55 -0400, Stephen Caudle wrote:
> +#ifdef CONFIG_IRQ_PER_CPU
> +static inline void gic_smp_call_function(struct call_single_data *data)
> +{
> +	int cpu;
> +	int this_cpu = smp_processor_id();
> +
> +	/*
> +	 * Since this function is called with interrupts disabled,
> +	 * smp_call_function can't be used here because it warns (even
> +	 * if wait = 0) when interrupts are disabled.
> +	 *
> +	 * __smp_call_function_single doesn't warn when interrupts are
> +	 * disabled and not waiting, so use it instead.
> +	 */
> +	for_each_online_cpu(cpu)
> +		if (cpu != this_cpu)
> +			__smp_call_function_single(cpu, data, 0);
> +}
> +

So you think that calling __smp_call_function_single with irqs disabled
with a data that is reused is not deadlock prone ?

If you look, __smp_call_function_single will wait in csd_lock until
the previous requested cpu has consumed the request (as it must, because
the data contains both the arguments and the list pointers to link
the element).

> +static void gic_enable_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	struct gic_chip_data *gic_data = get_irq_chip_data(irq);
> +
> +	if (irq >= GIC_PPI_FIRST && irq <= GIC_PPI_LAST) {
> +		gic_data->ppi_data.func = gic_unmask_ppi;
> +		gic_data->ppi_data.info = &desc->irq;
> +		gic_data->ppi_data.flags = 0;

Oh, now the flags (and therefore the lock) are cleared, and the function
is overwritten before it is known that the last cpu has processed this
call function request.

So you could have anything from the wrong function executed to
the last cpu's ipi function call list is crossed with another cpus,
probably leading to other call function data never being processed.  In
the best case other callers to call_function_single will hang forever
waiting for their own (per-cpu by originator) request to be consumed.

If you don't want to wait you must to allocate csd data per cpu, and
never clear flags except at the initial allocation.  You can not
overwrite function or info unless you know its safe if the previous
ofunction(odata) is issued and the new nfunction(ndata) is also safe
as nfunction(odata) or ofunction(ndata) (or you put in additional
barriers so only one has to be safe).

And then someone has to decide delayed mask or unmask is safe.

[note: it may be difficult to impossible to observe these races
with nr_cpus <= 2]

btw, the generic code is moving to passing desc not irq numbers around.

milton
