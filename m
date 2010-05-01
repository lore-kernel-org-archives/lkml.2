Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0EAIpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 04:45:31 -0400
Received: from www.tglx.de ([62.245.132.106]:43714 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0EAIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 04:45:29 -0400
Date: Sat, 1 May 2010 10:45:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add clocksource_register_hz/khz interface
In-Reply-To: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1005011042290.25342@localhost.localdomain>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, John Stultz wrote:
> +/**
> + * clocksource_register - Used to install new clocksources
> + * @t:		clocksource to be registered

  Can you fix the kernel doc please ?

> + *
> + * Returns -EBUSY if registration fails, zero otherwise.
> + */
> +int clocksource_register_hz(struct clocksource *cs, u32 hz)
> +{
> +	
> +	/* Ideally we want to use  some of the limits used in 
> +	 * clocksource_max_deferment, to provide a more informed
> +	 * MAX_UPDATE_LENGTH. But for now this just gets the
> +	 * regiseter interface working properly.
> +	 */
> +	clocks_calc_mult_shift(&cs->mult, &cs->shift, hz,
> +				      NSEC_PER_SEC, MAX_UPDATE_LENGTH);
> +	cs->max_idle_ns = clocksource_max_deferment(cs);
> +
> +	mutex_lock(&clocksource_mutex);
> +	clocksource_enqueue(cs);
> +	clocksource_select();
> +	clocksource_enqueue_watchdog(cs);
> +	mutex_unlock(&clocksource_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL(clocksource_register_hz);

  EXPORT_SYMBOL_GPL please

> +
> +/**
> + * clocksource_register - Used to install new clocksources
> + * @t:		clocksource to be registered
> + *
> + * Returns -EBUSY if registration fails, zero otherwise.
> + */
> +int clocksource_register_khz(struct clocksource *cs, u32 khz)
> +{

  shouldn't that be a simple inline wrapper which does

  return clocksource_register_hz(cs, khz * 1000);

Thanks,

	tglx
