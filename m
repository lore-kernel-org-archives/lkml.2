Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2DOORr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:17:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2DOORp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:17:45 -0400
Date: Sun, 15 Apr 2012 22:17:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120415141736.GG24997@S2101-09.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <20120414134814.GA3852@pengutronix.de>
 <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:49:04AM +0800, Dong Aisheng wrote:
...
> >> +iomuxc@020e0000 {
> >> +     compatible = "fsl,imx6q-iomuxc";
> >> +     reg = <0x020e0000 0x4000>;
> >> +
> >> +     /* shared pinctrl settings */
> >> +     usdhc4 {
> >> +             pinctrl_usdhc4_1: usdhc4grp-1 {
> >> +                     fsl,pins =      "MX6Q_PAD_SD4_CMD",
> >> +                                     "MX6Q_PAD_SD4_CLK",
> >> +                                     "MX6Q_PAD_SD4_DAT0",
> >> +                                     "MX6Q_PAD_SD4_DAT1",
> >> +                                     "MX6Q_PAD_SD4_DAT2",
> >> +                                     "MX6Q_PAD_SD4_DAT3",
> >> +                                     "MX6Q_PAD_SD4_DAT4",
> >> +                                     "MX6Q_PAD_SD4_DAT5",
> >> +                                     "MX6Q_PAD_SD4_DAT6",
> >> +                                     "MX6Q_PAD_SD4_DAT7";
> >
> > Do we really want to have all combinations of all pins in the devicetree
> > as strings? This is going to be huge.
> >
> Correct.
> My plan is:
> 1) not all combinations, just define frequently used ones since
> it's hard to define all combinations groups for per based IMX.
> (maybe we can try to add a fix-up function which can do minor changes
> based on available ones, then user does not need to write a new group
> caused by only a small change.
> what do you think?)
> 
> 2)  When dt supports macro, will try convert string to integer macro.
> Then it maybe:
> fsl,pins = <MX6Q_PAD_SD4_CMD 0
>                 MX6Q_PAD_SD4_CLK 0
>                 MX6Q_PAD_SD4_DAT0 1
>                 .................>,
> Why i did not start pin id with a raw integer is because it's less
> meaning to user and
> not easy to read in dts file.
> 
We may want to use integer from the beginning to reduce the churn on
driver later.

I'm thinking about documenting the definition we used to have in
iomux-mx*.h in the binding document and assign id to each of them
in order.

pinmux						id
------						--
MX6Q_PAD_SD2_DAT1__USDHC2_DAT1			0
MX6Q_PAD_SD2_DAT1__ECSPI5_SS0			1
MX6Q_PAD_SD2_DAT1__WEIM_WEIM_CS_2		2
...

The ordering between the list and imx6q_pin_regs[] array need to match.

By looking at the binding document, we can just put pinmux-id into
property "fsl,pins" (maybe rename it to "fsl,pinmux-ids") to get the
desired pinmux settings.  With doing so, we can gain the following.

1) The pinmux-id can be used as index to locate the entry in array
   imx6q_pin_regs[], so that the slow string lookup can be avoid.

2) Property "fsl,mux" can be dropped, as it's been encoded in
   imx6q_pin_regs[] entry.

3) Converting the existing board files to device tree will be much
   easier.  We only need to find the pinmux-id of those existing
   definitions and put them in "fsl, pinmux-ids".

4) When DTC support macro, we can simply move the pinmux-id list from
   binding document into dts file.  No driver change is needed at all.

Thoughts?

Regards,
Shawn

> 3) maybe we need a separate imx6q-pinctrl.dtsi when it becomes big
> after adding all device support.
> 
> >> +                     fsl,mux = <0 0 1 1 1 1 1 1 1 1>;
> >
> > Still we lose the precious information which pin can be put into which
> > mode which means that you have to look at the datasheet each time a pin
> > is missing.
> To avoid this, i also put the pad function macro in driver, user can
> look at the pinctrl SoC driver instead of look at the datasheet.
> See:
> [PATCH 2/3] pinctrl: pinctrl-imx: add imx6q pinctrl drive
> +/* imx6q register maps */
> +static struct imx_pin_reg imx6q_pin_regs[] = {
> +       IMX_PIN_REG(MX6Q_PAD_SD2_DAT1, 0x0360, 0x004C, 0, 0x0000, 0),
> /* MX6Q_PAD_SD2_DAT1__USDHC2_DAT1 */
> +       IMX_PIN_REG(MX6Q_PAD_SD2_DAT1, 0x0360, 0x004C, 1, 0x0834, 0),
> /* MX6Q_PAD_SD2_DAT1__ECSPI5_SS0 */
> .......
> 
