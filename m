Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2BTVmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:42:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2BTVmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:42:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.155.5 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-9-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:42:04 +0100
Message-ID: <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a NULL
 name field
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> pinctrl_register_mappings() already requires that every mapping table
> entry have a non-NULL name field.
>
> Logically, this makes sense too; drivers should always request a specific
> named state so they know what they're getting. Relying on getting the
> first mentioned state in the mapping table is error-prone, and a nasty
> special case to implement, given that a given the mapping table may define
> multiple states for a device.
>
> Update a few places in the code and documentation that still allowed for
> NULL name fields.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This causes a regression on U300 and most certainly on the Sirf Prima II
as well. The U300 can be fixed up as per below:

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index bb1034f..66555d7 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1645,7 +1645,7 @@ static int __init u300_pinctrl_fetch(void)
                struct pinctrl *p;
                int ret;

-               p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
+               p = pinctrl_get(u300_mux_hogs[i].dev, u300_mux_hogs[i].name);
                if (IS_ERR(p)) {
                        pr_err("u300: could not get pinmux hog %s\n",
                               u300_mux_hogs[i].name);


The drivers/tty/serial/sirfsoc_uart.c asks for it's UART pinctrl like
this:

sirfport->p = pinctrl_get(&pdev->dev, NULL);

I don't know quite what to encode in there, if "deafult" is sensible
we might just

#define PIN_MAP_NAME_DEFAULT "default"
In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
maybe in some <linux/pinctrl/mapnames.h> that both of these
include?

the have the driver ask for:

sirfport->p = pinctrl_get(&pdev->dev, PIN_MAP_NAME_DEFAULT);

(Similar changes can be done for U300, naming all its map
"default".)

Yours,
Linus Walleij
