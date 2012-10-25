Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab2JYMdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:33:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60224 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999Ab2JYMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFromkv_VYgiQsERR=PbrwYqgux=teF_HSZxCtk2BCsk1A@mail.gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
	<20121025073127.GB971@gmail.com>
	<5088F0EE.8030900@stericsson.com>
	<20121025082341.GC3348@gmail.com>
	<CAPDyKFromkv_VYgiQsERR=PbrwYqgux=teF_HSZxCtk2BCsk1A@mail.gmail.com>
Date: Thu, 25 Oct 2012 14:33:01 +0200
Message-ID: <CACRpkdaoGV3+iQHV-gHd3n1mROTZvCuuu59+U_zHpK=yXs6Bsw@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> Depending on clock type, a clk_disable is actually not going to "gate"
> the clock, that might happen only in unprepare. This depends on if the
> clock is a fast or slow clock.

Hm thats interesting. Now I need to drill down into this.
So looking at it in this case:

clk_disable() from the GPIO block of the pin controller will
hit "gpio.0", "gpio.1" etc in drivers/clk/ux500/u8500_clk.c.

These are PRCC (Programmable Clock Controller) clocks
registered using clk_reg_prcc_pclk() from clk-prcc.c.

pclk:s are using the clk_prcc_pclk_ops and these point to
clk_prcc_pclk_enable()/clk_prcc_pclk_disable() for
enable/disable respectively.

These will just write a PRCC register.

And prepare() and unprepare() are not implemented for
this clock.

So far we can conclude that clk_enable()/disable()
will indeed achieve the desired effect of gating the
clock to the GPIO block per se, so we are saving
some power for sure.

However the prepare()/unprepare() calls will of course
also accumulate upwards and in e.g. the example of
"gpio.0" and "gpio.1" the parent is "per1clk" which is the
clock for the entire peripheral group.

(At this point I can stick in a reminder of the idea to
restructure the device tree in peripheral groups, because
that exercise will certainly pay off the day we try to encode
clocks in the device tree, I think the point can be clearly
seen as we proceed...)

This "per1clk" is registered using clk_req_prcmu_gate()
from clk-prcmu.c.

Looking at that clock type we find it's a plain software
dummy for the clk_enable()/clk_disable() path.
The real action is happening in the prepare()/unprepare()
path.

So to be able to shut down the entire peripheral cluster,
indeed both functions need to be called.

So in accordance with this we can see that the patch
should be applied, in some form.

However it is not removing the initial clk_prepare()
so the entire patch will be pointless, the prepare count
will currently always be > 0.

I'll mangle Lee's patch a bit, hold on..

Yours,
Linus Walleij
