Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab1KPOac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:30:32 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59275 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932392Ab1KPOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:30:30 -0500
Date: Wed, 16 Nov 2011 15:30:13 +0100
From: Patrick Combes <p-combes@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hugo Dupras <h-dupras@ti.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs
 file
Message-ID: <20111116143011.GA5847@una0919255>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com>
 <20111115131636.GA31028@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115131636.GA31028@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:16:37PM +0000, Mark Brown wrote:
> On Fri, Nov 11, 2011 at 10:40:06AM +0100, Patrick Combes wrote:
> 
> > By calling poll() on the /sys/class/gpio/gpioN/value sysfs file, usermode
> > application can take benefit of gpio interrupts.
> > However, depending on the power state reached, this interrupt may not wake-up
> > the CPU.
> > This patch creates a new sysfs file /sys/class/gpio/gpioN/irq_wake to enable
> > usermode application to set the wake properties of a gpio IRQ.
> > This option can be set or not for each gpio to preserve power consumption (e.g
> > embedded systems).
> 
> There's already device global control for this in sysfs via the power
> framework - 

I didn't know so I had a (quick) look at it. It seems to me that this interface
will fit better for a global GPIO wakeup capability. By the way, this is maybe
what you mean by 'global control'...
Therefore, there is still a need (at least I have) for an interface with a
deeper granularity.

> 
> Also...
> 
> > +	else if (sysfs_streq(buf, "enable") || sysfs_streq(buf, "1"))
> > +		status = enable_irq_wake(gpio_to_irq(gpio));
> > +	else if (sysfs_streq(buf, "disable") || sysfs_streq(buf, "0"))
> > +		status = disable_irq_wake(gpio_to_irq(gpio));
> > +	else
> > +		status = -EINVAL;
> 
> ...this doesn't do anything to stop userspace doing multiple enables and
> disables.

Do you mean there is a need to prevent that?
Basically the code above accepts both "1" or "enable" strings to enable the
property. I could limit that to "enable" / "disable" if it is confusing.

> 
> > +	if (gpio_irq_data)
> > +		status = sprintf(buf, " Wakeup %s\n",
> > +					irqd_is_wakeup_set(gpio_irq_data)
> > +					? " enable" : "disable");
> 
> This is *really* non-idiomatic for sysfs output, you'd expect the sysfs
> output to look like the input.  It's supposed to machine parsable...

Maybe good for the debug but not for a parser; I fix it.
