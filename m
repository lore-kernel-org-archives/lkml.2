Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1JTOSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:18:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39910 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1JTOSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <20111020131042.GH32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<20111020023140.GC32007@S2100-06.ap.freescale.net>
	<CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
	<20111020131042.GH32007@S2100-06.ap.freescale.net>
Date: Thu, 20 Oct 2011 16:18:49 +0200
Message-ID: <CACRpkdYah+MSPCcHKhD+Wh11u2V3XR_3T8aCFxKpL0Znh+gh9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 3:10 PM, Shawn Guo <shawn.guo@freescale.com> wrote:

>> without the common definition from  PIN_CONFIG_PULL to
>> PIN_CONFIG_USER, many platforms will need to definite them repeatedly.
>> that is what we hate.
>>
> I prefer to completely leave the encoding of this 'u32 param' to pinctrl
> drivers, so that they can map the bit definition of 'param' to the
> controller register as much as they can. On imx, we have one register
> accommodating all pin configuration options for one pin, so we can
> write 'param' directly into register with exactly same bit definition
> as register.

I understand this argument, because it makes it more convenient to
write drivers and you can cut a few corners.

However I would prefer to keep things more abstract, and the reason
is that we strive to have drivers reused across SoCs. For example
drivers/tty/serial/amba-pl011.c is used on a multitude of SoCs,
U300, Nomadik, Ux500, ARM Versatile, ARM Vexpress, LPC32XX
etc etc.

What if this common driver suddenly need to bias a pin? Is it:

#include <linus/pinctrl/pinctrl.h>

ret = pin_config(pctldev, pin, PIN_CONFIG_BIAS_HIGH, 0);

Or (OK silly example but you get the point):

#include <linus/pinctrl/pinctrl.h>

if (machine_is_u300())
    ret = pin_config(pctldev, pin, PIN_CONFIG_U300_BIAS_VDD, 0);
else if (machine_is_nomadik())
    ret = pin_config(pctldev, pin, PIN_CONFIG_NOMADIK_BIAS_UP, 0);
else if (machine_is_ux500())
    ret = pin_config(pctldev, pin, PIN_CONFIG_UX500_PULLHIGH, 0);
else if (machine_is_versatile())
    ret = pin_config(pctldev, pin, PIN_CONFIG_VERSATILE_POW, 0);
else if (machine_is_vexpress())
    ret = pin_config(pctldev, pin, PIN_CONFIG_VEXPRESS_XTRA, 0);
else if (machine_is_lpc32xx())
    ret = pin_config(pctldev, pin, PIN_CONFIG_LPC_SUPPLY, 0);
...

IMO we have enough strange and custom things in the kernel
already and we need to make things more abstract, not the least
so that people can understand what the code is doing.

Yours,
Linus Walleij
