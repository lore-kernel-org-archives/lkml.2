Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1DZOBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:01:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:14502 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab1DZOBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="684128497"
Date: Tue, 26 Apr 2011 16:01:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 3/4] TPS65910: IRQ: Add interrupt controller
Message-ID: <20110426140116.GB3175@sortiz-mobl>
References: <F26256FF-CD37-496F-9DB0-35E9D5407DBB@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F26256FF-CD37-496F-9DB0-35E9D5407DBB@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Thu, Apr 21, 2011 at 09:35:49AM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> This module controls the interrupt handling for the tps chip. The
> interrupt sources are the following:
>
> - GPIO falling/rising edge detection
> - Battery voltage below/above threshold
> - PWRON signal
> - PWRHOLD signal
> - Temperature detection
> - RTC alarm and periodic event
The patch looks good, except for:

> +int tps65910_irq_init(struct tps65910 *tps65910, int irq,
> +		    struct tps65910_platform_data *pdata)
> +{
> +	int ret, cur_irq;
> +	int flags = IRQF_ONESHOT;
> +	u8 reg;
> +
> +	if (!irq) {
> +		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata || !pdata->irq_base) {
> +		dev_warn(tps65910->dev, "No interrupt support, no IRQ base\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Mask top level interrupts */
> +	reg = 0xFF;
> +	tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
> +	reg = 0x03;
> +	tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
> +
> +	mutex_init(&tps65910->irq_lock);
> +	tps65910->chip_irq = irq;
> +	tps65910->irq_base = pdata->irq_base;
> +
> +	/* Register with genirq */
> +	for (cur_irq = tps65910->irq_base;
> +	     cur_irq < TPS65910_NUM_IRQ + tps65910->irq_base;
> +	     cur_irq++) {
> +		irq_set_chip_data(cur_irq, tps65910);
> +		irq_set_chip_and_handler(cur_irq, &tps65910_irq_chip,
> +					 handle_edge_irq);
> +		irq_set_nested_thread(cur_irq, 1);
> +
> +		/* ARM needs us to explicitly flag the IRQ as valid
> +		 * and will set them noprobe when we do so. */
> +#ifdef CONFIG_ARM
> +		set_irq_flags(cur_irq, IRQF_VALID);
> +#else
> +		set_irq_noprobe(cur_irq);
That should be irq_set_noprobe().

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
