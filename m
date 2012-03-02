Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2CBRW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:22:57 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23221 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab2CBRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:22:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+5gBXaxk7HWQ7Hw/3r2B8u
Date: Fri, 2 Mar 2012 09:22:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] mmc: omap_hsmmc: Simplify init for twl6030 MMC
 card detect
Message-ID: <20120302172251.GJ18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185535.29210.71546.stgit@kaulin.local>
 <4F50643B.9050500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50643B.9050500@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rajendra Nayak <rnayak@ti.com> [120301 21:38]:
> On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> >--- a/arch/arm/mach-omap2/board-omap4panda.c
> >+++ b/arch/arm/mach-omap2/board-omap4panda.c
> >@@ -153,8 +153,8 @@ static struct omap2_hsmmc_info mmc[] = {
> >  	{
> >  		.mmc		= 1,
> >  		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
> >-		.gpio_wp	= -EINVAL,
> >  		.gpio_cd	= -EINVAL,
> >+		.gpio_wp	= -EINVAL,
> 
> stray change.

Hmm I'd like to keep this change before this ordering gets copied
to ten other board files that we may have in testing-board for a while..
I'll add a comment to the patch description about that.

> >--- a/drivers/mmc/host/omap_hsmmc.c
> >+++ b/drivers/mmc/host/omap_hsmmc.c
> >@@ -34,6 +34,7 @@
> >  #include<linux/gpio.h>
> >  #include<linux/regulator/consumer.h>
> >  #include<linux/pm_runtime.h>
> >+#include<linux/i2c/twl.h>
> >  #include<plat/dma.h>
> >  #include<mach/hardware.h>
> >  #include<plat/board.h>
> >@@ -578,6 +579,32 @@ static void omap_hsmmc_gpio_free(struct omap_hsmmc_host *host)
> >  		gpio_free(host->gpio_cd);
> >  }
> >
> >+#ifdef CONFIG_TWL4030_CORE
> >+static int omap_hsmmc_init_twl6030(struct omap_hsmmc_host *host)
> >+{
> >+	struct omap_mmc_platform_data *pdata = host->pdata;
> >+	struct omap_mmc_slot_data *slot =&pdata->slots[0];
> >+	int irq;
> >+
> >+	if (gpio_is_valid(host->gpio_cd) || host->id)
> 
> I have a series, which I am asking Chris to pull, which completely
> gets rid of all host->id based hard-codings' in the driver.
> Isn't there a better way to do this than rely on the device instance?

Yes I was thinking about that too. I guess we need to pass some
flag in pdata for twl6030 card detect. I was thinking about using
the gpiochip_cd, but twl6030 is not gpio based card detect, so
a separate flag is better.

BTW, with -rc5, looks like re-inserting omap_hsmmc on omap4 fails
to detect any cards, and then fails to unload. This works on omap3
just fine. Any ideas why that would be?

Regards,

Tony
