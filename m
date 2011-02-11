Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1BKH5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:57:37 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56605 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab1BKH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:57:36 -0500
Message-ID: <4D54EBE0.3050408@metafoo.de>
Date: Fri, 11 Feb 2011 08:57:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 17/75] genirq: Consolidate IRQ_DISABLED
References: <20110210222908.661199947@linutronix.de> <20110210223255.961530799@linutronix.de>
In-Reply-To: <20110210223255.961530799@linutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 12:36 AM, Thomas Gleixner wrote:
> Index: linux-2.6-tip/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/chip.c
> +++ linux-2.6-tip/kernel/irq/chip.c
> @@ -192,11 +192,14 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread)
>
>  int irq_startup(struct irq_desc *desc)
>  {
> -	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
> +	desc->status &= ~IRQ_DISABLED;
>  	desc->depth = 0;
>
> -	if (desc->irq_data.chip->irq_startup)
> -		return desc->irq_data.chip->irq_startup(&desc->irq_data);
> +	if (desc->irq_data.chip->irq_startup) {
> +		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
> +		desc->status &= IRQ_MASKED;

Although it is fixed in patch 45 of this series, I guess it should rather be
desc->status &= ~IRQ_MASKED here too.

> +		return ret;
> +	}
