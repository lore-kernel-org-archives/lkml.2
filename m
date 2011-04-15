Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1DOTSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:18:06 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7737 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab1DOTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:18:02 -0400
Message-ID: <4DA899E3.30409@caviumnetworks.com>
Date: Fri, 15 Apr 2011 12:17:55 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
CC: tglx@linutronix.de, mathieu.desnoyers@efficios.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, dwalker@fifo99.com,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org>
In-Reply-To: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2011 19:18:00.0830 (UTC) FILETIME=[D5F809E0:01CBFBA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 11:42 AM, Abhijeet Dharmapurikar wrote:
[...]
>
> +/**
> + *	irq_read_line - read the value on an irq line
> + *	@irq: Interrupt number representing a hardware line
> + *
> + *	This function may be called from IRQ context only when
> + *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !

What does it return?  I can see that -EINVAL is returned if it isn't 
applicable to this irq.  But what if chip->irq_read_line is implemented?




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
>   /*
>    * Internal function that tells the architecture code whether a
>    * particular irq has been exclusively allocated or is available

