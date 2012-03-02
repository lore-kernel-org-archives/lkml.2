Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2CBRaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:30:22 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35997 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab2CBRaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:30:21 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RQD+SmQH17koTcK6Zx/QV
Date: Fri, 2 Mar 2012 09:30:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Start getting rid of pdata callbacks with
 gpio_find_by_chip_name()
Message-ID: <20120302173017.GK18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <4F508DAE.9000005@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F508DAE.9000005@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rajendra Nayak <rnayak@ti.com> [120302 00:35]:
> Hi Tony,
> 
> On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> >Hi all,
> >
> >This series adds gpio_find_by_name() that allows finding
> >GPIOs on specific gpio_chips. As the GPIO numbers can be
> >dynamic, it's hard to find the GPIO numbers from drivers
> >using them directly.
> >
> >So far we've dealt with this using platform specific callbacks,
> >but that is messy. This series removes the needs for these
> >callbacks for omap hsmmc driver. Further callbacks can be
> >removed people are OK with adding gpio_find_by_name().
> >
> >This series is based on the omap fixes-non-critical that's
> >needed for the arch/arm/mach-omap2 parts of this series.
> 
> I tested these on my beagle/panda/omap4sdp and they seem to
> work fine, also fixing the broken panda card detect (due to
> missing card_detect_irq in the board file). There are still
> issues however when I build twl4030-gpio as a module, which I
> already commented on, and the fact that the init sequence now
> works by luck :)

Hmm it should not be luck based, loading omap_hsmmc module
should fail with a sensible error if the configured card detect
or write protect is not available.

I guess this is with twl6030 non-gpio based card detect?

If so, I'll add something to pass the twl6030 card detect from
pdata so we can fail with a sensible error in that case too.

Also, sounds like twl as module and mmc built in case won't
work without deferred probe. But at least there is a sensible
error for that. And maybe we can prevent that in Kconfig.

> The other issue also is that the multiple insmod/rmmod test
> suggested by Russell still fails, since the second time around
> the gpio_requests in the board callback fail because they are
> not freed when you do a module unload/unbind.
> That would need this patch from me to add the .teardown
> hooks
> http://marc.info/?l=linux-omap&m=133007767831297&w=2

Yes let's add the teardown patch as a fix for now, but let's
plan on getting rid of the twl_setup callback function
completely.

With these patches LCD and WLAN too can request the twl gpios
directly from the driver based on gpio_chip + gpio offset.

Regards,

Tony
