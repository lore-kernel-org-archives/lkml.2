Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1HCKH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:07:26 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:42599 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1HCKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:07:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIIdOU5R8j0b/2dsb2JhbABCp1p4gUABAQQBOhwjBQsIA0YUJQMhh38Cv08OhjQEo2E
Date: Wed, 3 Aug 2011 12:07:16 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC PATCH] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Message-ID: <20110803100716.GS4227@infomag.iguana.be>
References: <201108011357.24745.hartleys@visionengravers.com> <20110802095729.GO4227@infomag.iguana.be> <ADE657CA350FB648AAC2C43247A983F001F3882B8541@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3882B8541@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H Hartley,

> > [...]
> >> @@ -210,43 +126,31 @@ static int __init ep93xx_wdt_init(void)
> >>  {
> >>  	int err;
> >>  
> >> -	err = misc_register(&ep93xx_wdt_miscdev);
> >> +	ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG);
> >> +	ep93xx_wdd.timeout = timeout;
> >> +
> >> +	err = watchdog_register_device(&ep93xx_wdd);
> >> +	if (err)
> >> +		return err;
> >>  
> >> -	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
> >> +	setup_timer(&timer, ep93xx_timer_ping, 1);
> >
> > Shouldn't the bootstatus setting be:
> > ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
> > (or something similar with the WDIOF_OVERHEAT, ... flags).
> 
> The ep93xx watchdog status register doesn't line up nicely with the standard
> WDIOF_* flags.  The register has these bits defined:
> 
> PLSDN		6	Pulse Disable Not
> OVRID		5	Software Override of HWDIS
> SWDIS		4	Software Watchdog Disable
> HWDIS		3	Hardware Watchdog Disable
> URST		2	User Reset Detected
> 3KRST		1	Three-Key Reset Detected
> WD		0	Watchdog Reset Detected

Hmm, it would be nice to have this info also in the driver. Certainly at least a define for the WD bit.
Secondly: what it is doing now is allready incorrect: The WD bit is returned as bit 0 of the bootstatus value.
This is actually: WDIOF_OVERHEAT (Reset due to CPU overheat) instead of
WDIOF_CARDRESET (0x0020 Card previously reset the CPU)...

> The original bootstatus setting just checked for the WD bit.  I would like
> to pass the full status register so that userspace can figure out what caused
> the reset.  Is this an inappropriate abuse of WDIOC_GETBOOTSTATUS?

It's indeed an inappropriate abuse of WDIOC_GETBOOTSTATUS.
The WDIOC_GETBOOTSTATUS should return a result for all watchdog drivers.
The result is based on the WDIOF_* flags
This however does not mean that we can add flags. The 'User Reset detected' looks to me as something that can be usefull in embedded environments. We need to think about this and see what would be usefull in general.

Kind regards,
Wim.

