Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777Ab2FGL2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:28:32 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48678 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2FGL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206070332100.9501@axis700.grange>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
	<4FBCF9F0.1010901@wwwdotorg.org>
	<Pine.LNX.4.64.1205231659310.21980@axis700.grange>
	<4FBD01A6.4080807@wwwdotorg.org>
	<Pine.LNX.4.64.1206070332100.9501@axis700.grange>
Date: Thu, 7 Jun 2012 13:28:29 +0200
Message-ID: <CACRpkdbtUbi0_k-uupJ0RT-4c9cVCvnqp_xnUgKCpA8MQtVhsQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 4:05 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> [Stephen]
>> If using device tree, the bus-width property should be used. If not
>> using device tree, presumably you'd add an equivalent field to the
>> platform data.
>
> Wouldn't adding a bus-width field to the platform data be redundant,
> considering it's already available in the pinctrl configuration?

Maybe, but Documentation/devicetree/bindings/mmc/mmc.txt
mandates that you specify this width anyway I think, it's
stated as "requiered".

The bindings should be useable also for systems which does not
have pinctrl.

> Or should we request several configurations from the driver?

Do you mean several states?

> One of the 3 bus widthes, and additionally
> a card-detection and a write-protect configurations?

Isn't the card detection and write protect GPIO lines that
will be requested with gpio_request()? This is usually the case,
so I need to ask. GPIOs are usually muxed in on a per-pin basis
as a result of the gpio_request() call.

I don't know how your setup works but we have something like
this for an external SD card:

NB: I use these macros to shorten the lines, it's just simple hogs
on our primary pin controller:

#define DB8500_MUX(group,func,dev) \
        PIN_MAP_MUX_GROUP_DEFAULT(dev, "pinctrl-db8500", group, func)
#define DB8500_PIN(pin,conf,dev) \
        PIN_MAP_CONFIGS_PIN_DEFAULT(dev, "pinctrl-db8500", pin, conf)

/* Mux in SDI0 (here called MC0) used for removable MMC/SD/SDIO cards */
DB8500_MUX("mc0_a_1", "mc0", "sdi0"),
DB8500_PIN("GPIO18_AC2", out_hi, "sdi0"), /* CMDDIR */
DB8500_PIN("GPIO19_AC1", out_hi, "sdi0"), /* DAT0DIR */
DB8500_PIN("GPIO20_AB4", out_hi, "sdi0"), /* DAT2DIR */
DB8500_PIN("GPIO22_AA3", in_nopull, "sdi0"), /* FBCLK */
DB8500_PIN("GPIO23_AA4", out_lo, "sdi0"), /* CLK */
DB8500_PIN("GPIO24_AB2", in_pu, "sdi0"), /* CMD */
DB8500_PIN("GPIO25_Y4", in_pu, "sdi0"), /* DAT0 */
DB8500_PIN("GPIO26_Y2", in_pu, "sdi0"), /* DAT1 */
DB8500_PIN("GPIO27_AA2", in_pu, "sdi0"), /* DAT2 */
DB8500_PIN("GPIO28_AA1", in_pu, "sdi0"), /* DAT3 */

When "default" is selected, the group mc0_a_1 is muxed in
on function mc0, and the 10 pins are configured.(out_hi etc
are lists of configuration values).

We coul name this state "4bitsd" or so, and have another state
called "8bitemmc". Nothing stops you from also configuring pull-ups
on GPIO pins etc in this table.

We have several ports, here is an eMMC:

/* Mux in SDI2 (here called MC2) used for for PoP eMMC */
DB8500_MUX("mc2_a_1", "mc2", "sdi2"),
DB8500_PIN("GPIO128_A5", out_lo, "sdi2"), /* CLK */
DB8500_PIN("GPIO129_B4", in_pu, "sdi2"), /* CMD */
DB8500_PIN("GPIO130_C8", in_nopull, "sdi2"), /* FBCLK */
DB8500_PIN("GPIO131_A12", in_pu, "sdi2"), /* DAT0 */
DB8500_PIN("GPIO132_C10", in_pu, "sdi2"), /* DAT1 */
DB8500_PIN("GPIO133_B10", in_pu, "sdi2"), /* DAT2 */
DB8500_PIN("GPIO134_B9", in_pu, "sdi2"), /* DAT3 */
DB8500_PIN("GPIO135_A9", in_pu, "sdi2"), /* DAT4 */
DB8500_PIN("GPIO136_C7", in_pu, "sdi2"), /* DAT5 */
DB8500_PIN("GPIO137_A7", in_pu, "sdi2"), /* DAT6 */
DB8500_PIN("GPIO138_C5", in_pu, "sdi2"), /* DAT7 */

Isn't you board similarly hard-coded from the platform or
device tree? It seems less kludgy to ask DT or platform data
about the bus width if that is all.

Yours,
Linus Walleij
