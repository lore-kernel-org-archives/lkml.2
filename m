Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0H1OtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:49:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37162 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0H1Os7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w9iLsQ56pxRTF81tATBf00wZRTqYfZJo/wi81tVDtAQvn9PGxQprJtNiVOgQHNH0CU
         pdOKHPHB599ZJ3iiJ+4luI7sEsGAJf+frZU9ZLPOYEA0Qp3EChrLId6fsS3lZ9YX5jB8
         aMRSeitSS65TA7bubnd1XkuOvjZdfCiuF7w48=
MIME-Version: 1.0
In-Reply-To: <20100827190306.GB20407@void.printf.net>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
	<20100827190306.GB20407@void.printf.net>
Date: Sat, 28 Aug 2010 16:48:58 +0200
Message-ID: <AANLkTi=20KrUy334JRmMYwK7rbaVYrYCqW-BHZYGPrwT@mail.gmail.com>
Subject: Re: [PATCH] mmc: move regulator handling to core
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Pierre Ossman <pierre@ossman.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Madhusudhan <madhu.cr@ti.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/27 Chris Ball <cjb@laptop.org>:

> Looks like this patch got dropped because of the missing modifications
> to arch/arm/mach-omap2/mmc-twl4030.c.  Are we still interested in the
> patch otherwise, and can anyone help with that?

Actually just before the summer I submitted something not quite similar:
I moved all regulator handling *out* of the MMC core because I didn't
trust the way reference counting was being handled.

There is something very disturbing about this code from
regulator/core/core.c mmc_regulator_set_ocr():

enabled = regulator_is_enabled(supply);
if (enabled < 0)
	return enabled;

if (...) {
	(...)
	voltage = regulator_get_voltage(supply);
	if (voltage < 0)
		result = voltage;
	else if (voltage < min_uV || voltage > max_uV)
		result = regulator_set_voltage(supply, min_uV, max_uV);
	else
		result = 0;

	if (result == 0 && !enabled)
		result = regulator_enable(supply);
} else if (enabled) {
	result = regulator_disable(supply);
}

I didn't realize until today where the problem is: if you have
two hosts on the same regulator this does not handle
concurrency correctly. There is no lock taken between reading
the enabled status and acting on it later in the code.

So it looks to me like it is possible for one slot to enable the
regulator and race with another slot which disables it at the
same time and end up with the regulator disabled :-(

My solution would still be to move the enable/disable out
of the core, so I need to follow up on that.

This old patch however, goes in the opposite direction,
moving it all into the core. If you do this, please fix the
concurrency issue also...

Yours,
Linus Walleij
