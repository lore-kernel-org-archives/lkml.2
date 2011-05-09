Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1EIUW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:22:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36999 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1EIUW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:22:27 -0400
Subject: Re: [PATCHv3] x86, mrst: share APB timer code with other platforms
From: john stultz <johnstul@us.ibm.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
In-Reply-To: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
References: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 13:22:22 -0700
Message-ID: <1304972542.2939.20.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 12:10 +0100, Jamie Iles wrote:
> The APB timers are an IP block from Synopsys (DesignWare APB timers)
> and are also found in other systems including ARM SoC's.  This patch
> adds functions for creating clock_event_devices and clocksources from
> APB timers but does not do the resource allocation.  This is handled
> in a higher layer to allow the timers to be created from multiple
> methods such as platform_devices.
> 
> Changes since v2:
> 	- Make eoi() for clock_event_device optional for x86 where eoi
> 	is handled in firmware.
> Changes since v1:
> 	- Use the correct timer for clocksource on x86
> 	- Select the correct timer rating for x86
> 	- Restore freerunning timer behaviour for oneshot event devices
> 	- Reenable event irq correctly for hotplug

Sorry for being slow to review this.

Just a minor nit below.

> +struct dw_apb_clocksource *
> +dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
> +			unsigned long freq)
> +{
> +	struct dw_apb_clocksource *dw_cs = kzalloc(sizeof(*dw_cs), GFP_KERNEL);
> +
> +	if (!dw_cs)
> +		return NULL;
> +
> +	dw_cs->timer.base = base;
> +	dw_cs->timer.freq = freq;
> +	dw_cs->cs.name = name;
> +	dw_cs->cs.rating = rating;
> +	dw_cs->cs.read = __apbt_read_clocksource;
> +	dw_cs->cs.mask = CLOCKSOURCE_MASK(32);
> +	dw_cs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
> +	dw_cs->cs.resume = apbt_restart_clocksource;
> +
> +	return dw_cs;
> +}

So I don't see anything that frees the dw_apb_clocksource structure
after it has been allocated. Should this instead be allocated by the
caller and passed in to be initialized here?

thanks
-john


