Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2DCJNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:13:14 -0400
Received: from antcom.de ([188.40.178.216]:57526 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab2DCJNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:13:13 -0400
Message-ID: <4F7ABF26.8030606@antcom.de>
Date: Tue, 03 Apr 2012 11:13:10 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, Srinivas Bakki <srinivas.bakki@nxp.com>,
        Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH] gpio: Device tree support for LPC32xx
References: <1333407513-18231-1-git-send-email-stigge@antcom.de> <201204030829.21911.arnd@arndb.de>
In-Reply-To: <201204030829.21911.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

thanks for your further suggestions. I'm integrating them, comments below:

On 04/03/2012 10:29 AM, Arnd Bergmann wrote:
>> +- gpio-lines: Number of GPIOs in that subnode/GPIO group
> 
> While I suggested the gpio-lines property, I'm not sure if it's worth
> including it when you don't actually use it.

Right. I'm actually removing it now since for enabling individual GPIO 
lines selectively, it's not flexible enough, anyway: only the first n 
lines of a GPIO "group" could be chosen.

However, I will keep (and document) the possible status="disabled" 
property to disable whole GPIO groups of LPC32xx, if really necessary.

Looks like all LPC32xx variants have and will have the same GPIO layout.

To fix disruptiveness of this patch, I'll make it support both DT and 
non-DT so it doesn't depend on LPC32xx being switched together 
atomically. (Posting below).

Roland



        if (pdev->dev.of_node) {
                for_each_child_of_node(pdev->dev.of_node, node) {
                        if (of_device_is_available(node)) {
                                u32 index;
                                struct gpio_chip *chip;
                                if (of_property_read_u32(node, "reg", &index) <  0)
                                        continue;
                                if (index >= ARRAY_SIZE(lpc32xx_gpiochip))
                                        continue;
                                chip = &lpc32xx_gpiochip[index].chip;
                                chip->of_node = of_node_get(node);
                                gpiochip_add(chip);
                        }
                }
        } else {
                for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
                	gpiochip_add(&lpc32xx_gpiochip[i].chip);
        }
