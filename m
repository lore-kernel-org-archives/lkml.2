Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab1JDUuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:50:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39617 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933517Ab1JDUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:50:06 -0400
Date: Tue, 4 Oct 2011 21:50:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v2 6/7] clk: Add initial WM831x clock driver
Message-ID: <20111004205002.GA20296@opensource.wolfsonmicro.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-7-git-send-email-mturquette@ti.com>
 <20110925040836.GP24631@ponder.secretlab.ca>
 <20110926093858.GD2946@opensource.wolfsonmicro.com>
 <20111004181818.GD2870@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004181818.GD2870@ponder.secretlab.ca>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 12:18:18PM -0600, Grant Likely wrote:
> On Mon, Sep 26, 2011 at 10:38:58AM +0100, Mark Brown wrote:

> > No, that's not helpful.  The issue isn't the device probe code itself,
> > the issue is things like module unload not doing what they're supposed
> > to do and leaving the device lying around or something - there's rather
> > more going on than just the plain API call.

> Then lets fix the core code.  I see this pattern show up again and
> again of extra boilerplate going around
> platform_driver_{register,unregister}().  That says to me that there
> either needs to be a new helper, or the core code needs to be made
> more verbose.

I'd go with the latter, it's pretty much the approach the subsystems I
help maintain have been taking.  In fast paths it's a bit different but
in slow paths it tends to be helpful to know why things just fell over.

> In fact, I've been considering adding a macro for
> {platform,i2c,spi,...}_drivers that does all the module boilerplate
> for the common case of only registering a driver at init time.
> Something like:

> #define module_platform_driver(__driver) \
> int __driver##_init(void) \
> { \
> 	return platform_driver_register(&(__driver)); \
> } \
> module_init(__driver##_init); \
> void ##__driver##_exit(void) \
> { \
> 	platform_driver_unregister(&(__driver)); \
> } \
> module_exit(##__driver##_exit);

> It's not a lot of code, but I dislike how much boilerplate every
> single driver has to use if it doesn't do anything special.

Yeah, this sort of stuff would be helpful - there's quite a bit of
boilerplate you end up having to write to get drivers going.
