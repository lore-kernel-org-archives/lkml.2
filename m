Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1DOTDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:03:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40309 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926Ab1DOTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:03:24 -0400
Date: Fri, 15 Apr 2011 15:03:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        dwalker@fifo99.com, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
Message-ID: <20110415190319.GA24111@Krystal>
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:59:22 up 143 days, 2 min,  4 users,  load average: 0.00, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Abhijeet Dharmapurikar (adharmap@codeaurora.org) wrote:
> Some drivers need to know what the status of the interrupt line is.
> This is especially true for drivers that register a handler with
> IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and in the handler they
> need to know which edge transition it was invoked for.
> 
> The irq_read_line callback in the chip allows the controller to provide
> the real time status of this line. Controllers that can read the status
> of an interrupt line should implement this by doing necessary
> hardware reads and return the logical state of the line.
> 
> Interrupt controllers based on the slow bus architecture should conduct
> the transaction in this callback. The genirq code will call the chip's
> bus lock prior to calling irq_read_line. Obviously since the transaction
> would be completed before returning from irq_read_line it need not do
> any transactions in the bus unlock call.
> 
> Drivers need to be aware whether the interrupt controller is a slow bus
> and call read_irq_line in proper context.

Hrm, this strikes me as odd. Is there any way this generic API could
handle the corner-cases without needed the caller to know this ?

[...]

> +/**
> + *	irq_read_line - read the value on an irq line
> + *	@irq: Interrupt number representing a hardware line
> + *
> + *	This function may be called from IRQ context only when
> + *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !

The comment here seems to imply "be careful when using this extremely
fragile interface", which does not give me the warm safety feeling I
would come to expect from a generic kernel API.

Any ideas on how to improve that ?

Thanks,

Mathieu

> + */
> +int irq_read_line(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	unsigned long flags;
> +	int val;
> +
> +	if (!desc || !desc->irq_data.chip->irq_read_line)
> +		return -EINVAL;
> +
> +	chip_bus_lock(desc);
> +	raw_spin_lock_irqsave(&desc->lock, flags);
> +	val = desc->irq_data.chip->irq_read_line(&desc->irq_data);
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> +	chip_bus_sync_unlock(desc);
> +	return val;
> +}
> +EXPORT_SYMBOL(irq_read_line);
> +
>  /*
>   * Internal function that tells the architecture code whether a
>   * particular irq has been exclusively allocated or is available
> -- 
> 1.7.1
> 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
