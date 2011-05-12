Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1ELOCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:02:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53066 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab1ELOCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n0ArU5VMdPVKjmiC3XaM9jz/9rVhA37ydzcRsJDzYFR1e8/1kuJ8eUYRquIxeYYRUQ
         iVQsRbxl+GwMbhXnvofy6c2Fl6lKJJPyxuxzf8u3cul67V8w64RFT30fV01+yRqocNL2
         jdxZ5ykMGQkzq4ZmH/m2ENk8Jgm00TBfYKpEw=
MIME-Version: 1.0
In-Reply-To: <20110512074421.GA2429@pengutronix.de>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110512074421.GA2429@pengutronix.de>
Date: Thu, 12 May 2011 16:02:35 +0200
X-Google-Sender-Auth: BURJ8gNQebiMS9bPZCwt9kR6NFI
Message-ID: <BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/12 Sascha Hauer <s.hauer@pengutronix.de>:

> What I'm missing though is a generic way a single pad/mux mode
> combination can be described. Let me take a look around how the
> different subarchs do this:
>
> omap:
>
>        _OMAP3_MUXENTRY(DSS_DATA21, 91,
>                "dss_data21", NULL, "mcspi3_cs0", "dss_data3",
>                "gpio_91", NULL, NULL, "safe_mode"),
>        _OMAP3_MUXENTRY(DSS_DATA22, 92,
>                "dss_data22", NULL, "mcspi3_cs1", "dss_data4",
>                "gpio_92", NULL, NULL, "safe_mode"),
>
> pxa:
>
> #define GPIO16_FFUART_TXD       MFP_CFG_OUT(GPIO16, AF3, DRIVE_HIGH)
> #define GPIO37_FFUART_TXD       MFP_CFG_OUT(GPIO37, AF3, DRIVE_HIGH)
> #define GPIO39_FFUART_TXD       MFP_CFG_OUT(GPIO39, AF2, DRIVE_HIGH)
> #define GPIO83_FFUART_TXD       MFP_CFG_OUT(GPIO83, AF2, DRIVE_HIGH)
> #define GPIO99_FFUART_TXD       MFP_CFG_OUT(GPIO99, AF3, DRIVE_HIGH)
>
> i.MX:
>
> #define _MX51_PAD_UART3_RXD__CSI1_D0            IOMUX_PAD(0x630, 0x240, 2, 0x0000, 0, 0)
> #define _MX51_PAD_UART3_RXD__GPIO1_22           IOMUX_PAD(0x630, 0x240, 3, 0x0000, 0, 0)
> #define _MX51_PAD_UART3_RXD__UART1_DTR          IOMUX_PAD(0x630, 0x240, 0, 0x0000, 0, 0)
> #define _MX51_PAD_UART3_RXD__UART3_RXD          IOMUX_PAD(0x630, 0x240, 1, 0x09f4, 4, 0)
> #define _MX51_PAD_UART3_TXD__CSI1_D1            IOMUX_PAD(0x634, 0x244, 2, 0x0000, 0, 0)
>
> These all basically describe the same thing: put pad x into one of modes
> a, b, c and apply certain flags like drive strength on this.
>
> the other class of pin muxing I know of is that a whole group of pads
> can be switched to a particular mode using a mux register like I think
> is used used in your ux300 driver.
>
> I'd like to have a unified way to describe this.

Hm, so some of the structure I currently have inside the specific U300 driver
need to become generic, in such way that say by activating 8 different
padmux functions at the same, this can boil down to a single register
write instead of 8 different register writes?

> Do you think it's possible to do some consolidation on this level
> aswell? It would really bring different SoCs more together.

I am thinking on the abstract level, now we would have:

Board:
static struct pinmux_map pmx_map[] = {
        PINMUX_MAP("foo0", "foo0-1"),
        PINMUX_MAP("bar0", "bar0-1"),
};
pinmux_register_mappings(pmx_map, ARRAY_SIZE(pmx_map));

Driver:
pmx = pinmux_get("foo0", NULL);
pinmux_enable(pmx);

For each of the mux functions. Now we need a grouping of
these functions.

So if I invent say pinmux function groups and add an argument
to pinmux_register_mappings() so it takes an optional groupname
arg, you can add several mappings and group them:

pinmux_register_mappings("foogrp", pmx_map1, ARRAY_SIZE(pmx_map1));
pinmux_register_mappings("bargrp", pmx_map2, ARRAY_SIZE(pmx_map2));

The pinmux core remember this association and add a
new API:

struct pinmux_group *pmxgrp = pinmux_group_get("foogrp");
pinmux_group_enable(pmxgrp);
pinmux_group_control(pmxgrp, N, N);
pinmux_group_disable(pmxgrp);
pinmux_group_put(pmxgrp);

If then the driver API adds an optional hook like this:
int (*enable_group) (struct pinmux_dev *pmxdev, unsigned *selector,
unsigned num_selectors);
void (*disable_group) (struct pinmux_dev *pmxdev, unsigned *selector,
unsigned num_selectors);

This way the driver can provide each muxing individually, the core keep
track of any grouping and making sure group sets does not clash,
and the driver can implement optional enable/disable calls that write entire
groups of pins at once and the driver knows how to combine these into a
few single register writes.

Would this work?

I see it as a clear, backwards-compatible superset to the current
patchset, so can go in a separate add-on if the current stuff go in first,
so we don't try to drink the entire ocean at once.

Yours,
Linus Walleij
