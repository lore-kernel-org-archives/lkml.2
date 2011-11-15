Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1KONQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:16:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39124 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1KONQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:16:39 -0500
Date: Tue, 15 Nov 2011 13:16:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Patrick Combes <p-combes@ti.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hugo Dupras <h-dupras@ti.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs
 file
Message-ID: <20111115131636.GA31028@sirena.org.uk>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321004406-15663-1-git-send-email-p-combes@ti.com>
X-Cookie: diplomacy, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:40:06AM +0100, Patrick Combes wrote:

> By calling poll() on the /sys/class/gpio/gpioN/value sysfs file, usermode
> application can take benefit of gpio interrupts.
> However, depending on the power state reached, this interrupt may not wake-up
> the CPU.
> This patch creates a new sysfs file /sys/class/gpio/gpioN/irq_wake to enable
> usermode application to set the wake properties of a gpio IRQ.
> This option can be set or not for each gpio to preserve power consumption (e.g
> embedded systems).

There's already device global control for this in sysfs via the power
framework - 

Also...

> +	else if (sysfs_streq(buf, "enable") || sysfs_streq(buf, "1"))
> +		status = enable_irq_wake(gpio_to_irq(gpio));
> +	else if (sysfs_streq(buf, "disable") || sysfs_streq(buf, "0"))
> +		status = disable_irq_wake(gpio_to_irq(gpio));
> +	else
> +		status = -EINVAL;

...this doesn't do anything to stop userspace doing multiple enables and
disables.

> +	if (gpio_irq_data)
> +		status = sprintf(buf, " Wakeup %s\n",
> +					irqd_is_wakeup_set(gpio_irq_data)
> +					? " enable" : "disable");

This is *really* non-idiomatic for sysfs output, you'd expect the sysfs
output to look like the input.  It's supposed to machine parsable...
