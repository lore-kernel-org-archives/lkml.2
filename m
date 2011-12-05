Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1LECnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:43:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52150 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1LECnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111204161123.GS27267@pengutronix.de>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<20111204161123.GS27267@pengutronix.de>
Date: Mon, 5 Dec 2011 10:43:02 +0800
Message-ID: <CAA+hA=RM77XORR-cUrFSW_rfn=KG9B1gr-Ny0jcDsU1_NiTT7A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
From: Dong Aisheng <dongas86@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        shawn.guo@freescale.com, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

2011/12/5 Sascha Hauer <s.hauer@pengutronix.de>:
> On Sun, Dec 04, 2011 at 07:49:43PM +0800, Dong Aisheng wrote:
>> Signed-off-by: Dong Aisheng <b29396@freescale.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Shawn Guo <shanw.guo@freescale.com>
>> ---
>>  drivers/pinctrl/pinmux-imx53.c |  514 ++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 514 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinmux-imx53.c b/drivers/pinctrl/pinmux-imx53.c
>> +
>> +/* mx53 pin groups and mux mode */
>> +static const unsigned mx53_fec_pins[] = {
>> +     MX53_FEC_MDC,
>> +     MX53_FEC_MDIO,
>> +     MX53_FEC_REF_CLK,
>> +     MX53_FEC_RX_ER,
>> +     MX53_FEC_CRS_DV,
>> +     MX53_FEC_RXD1,
>> +     MX53_FEC_RXD0,
>> +     MX53_FEC_TX_EN,
>> +     MX53_FEC_TXD1,
>> +     MX53_FEC_TXD0,
>> +};
>> +static const unsigned mx53_fec_mux[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
>
> The FEC_MDC could be routed to PAD_KEY_ROW2 or to PAD_FEC_MDC. Also
> FEC_MDIO could be routed to either PAD_FEC_MDIO or to PAD_KEY_COL2.
> For other fec pins also different options might exist. How does this
> fit into this group scheme?
>
Thanks for the review.
Here it's only one group for fec function.
If i understood right, for current pinmux desgin, pins are arranged in
groups per specifc functions.
For the case FEC_MDC could be routed to KEY_ROW2, we need define a KEY group
for key function.

Currently, i only added one group for one function with the reference
of MX53 LOCO pinmux defines.
And it's a big work which is in the TODO list that for me to manually
add all possible functions and pin groups.
So I send out the patch first to see if any design issue for the FSL
iomux specialist.

>> +
>> +static const unsigned mx53_sd1_pins[] = {
>> +     MX53_SD1_CMD,
>> +     MX53_SD1_CLK,
>> +     MX53_SD1_DATA0,
>> +     MX53_SD1_DATA1,
>> +     MX53_SD1_DATA2,
>> +     MX53_SD1_DATA3,
>> +
>> +};
>> +static const unsigned mx53_sd1_mux[] = { 0, 0, 0, 0, 0, 0 };
>> +
>> +static const unsigned mx53_sd3_pins[] = {
>> +     MX53_PATA_DATA8,
>> +     MX53_PATA_DATA9,
>> +     MX53_PATA_DATA10,
>> +     MX53_PATA_DATA11,
>> +     MX53_PATA_DATA0,
>> +     MX53_PATA_DATA1,
>> +     MX53_PATA_DATA2,
>> +     MX53_PATA_DATA3,
>> +     MX53_PATA_IORDY,
>> +     MX53_PATA_RESET_B,
>> +
>> +};
>> +static const unsigned mx53_sd3_mux[] = { 4, 4, 4, 4, 4, 4, 4, 4, 2, 2 };
>> +
>> +static const unsigned mx53_uart1_pins[] = {
>> +     MX53_CSI0_DAT10,
>> +     MX53_CSI0_DAT11,
>> +};
>> +static const unsigned mx53_uart1_mux[] = { 2, 2 };
>
> For uart1 indeed only one routing possibility exists, but look at uart2:
>
> uart2 txd -> PAD_EIM_D26
>          -> PAD_PATA_DMARQ
>          -> PAD_GPIO_7
>
> uart2 rxd -> PAD_EIM_D27
>          -> PAD_PATA_BUFFER_EN
>          -> PAD_GPIO_8
>
> So this at least means that you should not name the array above
> mx53_uart1_mux, but something like mx53_uart1_option1,
> mx53_uart1_option2 and so on.
>
Yes, acked on this.
I may take this name option.

> Then it's probably possible to use mixtures of different options
> for the uart.
How mixture?
Can you describe more or give an example?

> I don't think that this grouping of pads to their functions makes
> sense. On i.MX every pad is muxed independently and not in groups.
> Which pins belong to which function is board specific and not SoC
> specific.
>
Yes, i noted this.
As i said above, pins seem to be arranged in groups per functions not
per pins itself.
So our to do is define all possible pin function and group for board to use.
But obviously, it's a big work. Especially for your UART2 work, it
might be a headache since many possible combination of pins.
I still not find the good idea.
My current plan is to define all (might be frequently) used functoin
and groups for the exist upstreamed board like 53 Loco and etc, is
that ok?

Regards
Dong Aisheng
