Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0IJKHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:07:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65200 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0IJKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:06:58 -0400
Message-ID: <4C8A02E6.4080906@nokia.com>
Date: Fri, 10 Sep 2010 13:05:26 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com> <20100908155114.880463fc.akpm@linux-foundation.org> <4C887837.6060508@nokia.com> <20100909093810.GA1988@rakim.wolfsonmicro.main> <4C88D97F.2080804@nokia.com> <20100909131251.GE25855@rakim.wolfsonmicro.main>
In-Reply-To: <20100909131251.GE25855@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2010 10:05:28.0397 (UTC) FILETIME=[B1F077D0:01CB50CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Sep 09, 2010 at 03:56:31PM +0300, Adrian Hunter wrote:
>> Mark Brown wrote:
> 
>>> What do you mean when you say that you would like boards to "hook
>>> directly into the regulator" - what do you want to be able to do?
>>> Is this the notifiers?  Do you need more of them?
> 
>> There would need to be notifiers before and after any change to the
>> voltage.  However the notifiers would have to be set up before or
>> during regulator initialisation because initialisation already can
>> change the voltage e.g. in set_machine_constraints.
> 
> Why do you believe these notifiers are needed?

As I mentioned below, they would be needed to do PBIAS configuration
automatically using notifiers (notifiers would have been overkill
anyway).  However as you don't think that is a good idea, it is no
matter.

>                                                 I would expect that
> anything that needs pre and post change notifications like this is
> actually changing the configuration itself (since if it's that sensitive
> to changes it seems likely that it wouldn't be enthused about having the
> configuration changed while it's trying to do stuff).

Yes, except when it is the regulator core trying to set the initial power
state on or off.

> 
>>> I can't parse this at all I'm afraid.  Could you be more specific about
>>> what you mean by using enable and disable independantly of the board -
>>> clearly the consumer drivers are already able to be board independant?
> 
>> For OMAP3 (and OMAP2 in some cases) the 1st SD/SDIO/MMC controller
>> can operate at either 1.8V or 3V, however at 3V the board must apply
>> voltage level shifting (PBIAS configuation).  Currently the
>> level-shifting is done by board code that must be called before and
>> after the voltage changes.  The omap_hsmmc driver calls the board
>> code via callbacks in platform data (.before_set_reg and
>> .after_set_reg).
> 
> This really sounds like something that's internal to the MMC controller
> driver - based on your description I'm very surprised that boards even
> get visibility of this.  Surely the MMC controller driver should be
> taking care of configuring PBIAS itself, assuming it's something
> internal to the chip?

It is considered that the driver should know only about hsmmc ip not
all of OMAP.  Additionally the OMAP community does not allow the use
of the necessary system control registers outside of the board level
i.e. arch/arm/mach-omap2 etc.  Hence the driver calls down to the
board level.  That is ugly but not a problem.

>                        Adding code to the regulator API so that the OMAP
> MMC driver can be notified of the configuration it has applied to itself
> (and any failures that ensue) feels baroque.

As you wish.  That rules out using the core to turn off the regulator at
boot up, but that is OK, the driver can do it.  At present the driver
makes the mistake of just doing regulator_enable() / disable() to ensure the
regulator is off, without calling down to the board level for the PBIAS
configuration.  It also comments the code as an "ugly hack" whereas
it is really the only way to do it, if the regulator can't do the
PBIAS configuration automatically.  I will just fix the driver and add
better comments.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

