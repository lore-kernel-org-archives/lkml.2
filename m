Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1LFHLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:11:50 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:47619
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab1LFHLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:11:49 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 15:23:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
Message-ID: <20111206072326.GA3712@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-3-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322999384-7886-3-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 07:49:44PM +0800, Dong Aisheng wrote:
> Signed-off-by: Dong Aisheng <b29396@freescale.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shanw.guo@freescale.com>
> ---
>  drivers/pinctrl/pinmux-imx6q.c |  464 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 464 insertions(+), 0 deletions(-)
> 
As I do not see the device tree probing added in pinmux-imx-core.c,
I expect the patch has not got the chance to run on imx6, right?

> diff --git a/drivers/pinctrl/pinmux-imx6q.c b/drivers/pinctrl/pinmux-imx6q.c
> new file mode 100644
> index 0000000..5641199
> --- /dev/null
> +++ b/drivers/pinctrl/pinmux-imx6q.c
> @@ -0,0 +1,464 @@
> +/*
> + * imx6q pinmux driver based on imx pinmux core
> + *
> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> + * Copyright (C) 2011 Linaro, Inc.
> + *
> + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +
> +#include "pinmux-imx-core.h"
> +
> +#define MX6Q_IOMUXC_MUX_OFSSET	0x4c
> +#define MX6Q_IOMUXC_MAXPIN	(25*25)
> +
I would suggest replace all the occurrences of 'MX6Q'/'mx6q' with
'IMX6Q'/'imx6q' to force the consistency.

> +enum imx_mx6q_pads {

IMO, 'imx6q_pads' is good enough.

> +	MX6Q_SD2_DAT1 = 0,
> +	MX6Q_SD2_DAT2 = 1,
> +	MX6Q_SD2_DAT0 = 2,
> +	MX6Q_RGMII_TXC = 3,
> +	MX6Q_RGMII_TD0 = 4,
> +	MX6Q_RGMII_TD1 = 5,
> +	MX6Q_RGMII_TD2 = 6,
> +	MX6Q_RGMII_TD3 = 7,
> +	MX6Q_RGMII_RX_CTL = 8,
> +	MX6Q_RGMII_RD0 = 9,
> +	MX6Q_RGMII_TX_CTL = 10,
> +	MX6Q_RGMII_RD1 = 11,
> +	MX6Q_RGMII_RD2 = 12,
> +	MX6Q_RGMII_RD3 = 13,
> +	MX6Q_RGMII_RXC = 14,
> +	MX6Q_EIM_A25 = 15,
> +	MX6Q_EIM_EB2 = 16,
> +	MX6Q_EIM_D16 = 17,
> +	MX6Q_EIM_D17 = 18,
> +	MX6Q_EIM_D18 = 19,
> +	MX6Q_EIM_D19 = 20,
> +	MX6Q_EIM_D20 = 21,
> +	MX6Q_EIM_D21 = 22,
> +	MX6Q_EIM_D22 = 23,
> +	MX6Q_EIM_D23 = 24,
> +	MX6Q_EIM_EB3 = 25,
> +	MX6Q_EIM_D24 = 26,
> +	MX6Q_EIM_D25 = 27,
> +	MX6Q_EIM_D26 = 28,
> +	MX6Q_EIM_D27 = 29,
> +	MX6Q_EIM_D28 = 30,
> +	MX6Q_EIM_D29 = 31,
> +	MX6Q_EIM_D30 = 32,
> +	MX6Q_EIM_D31 = 33,
> +	MX6Q_EIM_A24 = 34,
> +	MX6Q_EIM_A23 = 35,
> +	MX6Q_EIM_A22 = 36,
> +	MX6Q_EIM_A21 = 37,
> +	MX6Q_EIM_A20 = 38,
> +	MX6Q_EIM_A19 = 39,
> +	MX6Q_EIM_A18 = 40,
> +	MX6Q_EIM_A17 = 41,
> +	MX6Q_EIM_A16 = 42,
> +	MX6Q_EIM_CS0 = 43,
> +	MX6Q_EIM_CS1 = 44,
> +	MX6Q_EIM_OE = 45,
> +	MX6Q_EIM_RW = 46,
> +	MX6Q_EIM_LBA = 47,
> +	MX6Q_EIM_EB0 = 48,
> +	MX6Q_EIM_EB1 = 49,
> +	MX6Q_EIM_DA0 = 50,
> +	MX6Q_EIM_DA1 = 51,
> +	MX6Q_EIM_DA2 = 52,
> +	MX6Q_EIM_DA3 = 53,
> +	MX6Q_EIM_DA4 = 54,
> +	MX6Q_EIM_DA5 = 55,
> +	MX6Q_EIM_DA6 = 56,
> +	MX6Q_EIM_DA7 = 57,
> +	MX6Q_EIM_DA8 = 58,
> +	MX6Q_EIM_DA9 = 59,
> +	MX6Q_EIM_DA10 = 60,
> +	MX6Q_EIM_DA11 = 61,
> +	MX6Q_EIM_DA12 = 62,
> +	MX6Q_EIM_DA13 = 63,
> +	MX6Q_EIM_DA14 = 64,
> +	MX6Q_EIM_DA15 = 65,
> +	MX6Q_EIM_WAIT = 66,
> +	MX6Q_EIM_BCLK = 67,
> +	MX6Q_DI0_DISP_CLK = 68,
> +	MX6Q_DI0_PIN15 = 69,
> +	MX6Q_DI0_PIN2 = 70,
> +	MX6Q_DI0_PIN3 = 71,
> +	MX6Q_DI0_PIN4 = 72,
> +	MX6Q_DISP0_DAT0 = 73,
> +	MX6Q_DISP0_DAT1 = 74,
> +	MX6Q_DISP0_DAT2 = 75,
> +	MX6Q_DISP0_DAT3 = 76,
> +	MX6Q_DISP0_DAT4 = 77,
> +	MX6Q_DISP0_DAT5 = 78,
> +	MX6Q_DISP0_DAT6 = 79,
> +	MX6Q_DISP0_DAT7 = 80,
> +	MX6Q_DISP0_DAT8 = 81,
> +	MX6Q_DISP0_DAT9 = 82,
> +	MX6Q_DISP0_DAT10 = 83,
> +	MX6Q_DISP0_DAT11 = 84,
> +	MX6Q_DISP0_DAT12 = 85,
> +	MX6Q_DISP0_DAT13 = 86,
> +	MX6Q_DISP0_DAT14 = 87,
> +	MX6Q_DISP0_DAT15 = 88,
> +	MX6Q_DISP0_DAT16 = 89,
> +	MX6Q_DISP0_DAT17 = 90,
> +	MX6Q_DISP0_DAT18 = 91,
> +	MX6Q_DISP0_DAT19 = 92,
> +	MX6Q_DISP0_DAT20 = 93,
> +	MX6Q_DISP0_DAT21 = 94,
> +	MX6Q_DISP0_DAT22 = 95,
> +	MX6Q_DISP0_DAT23 = 96,
> +	MX6Q_ENET_MDIO = 97,
> +	MX6Q_ENET_REF_CLK = 98,
> +	MX6Q_ENET_RX_ER = 99,
> +	MX6Q_ENET_CRS_DV = 100,
> +	MX6Q_ENET_RXD1 = 101,
> +	MX6Q_ENET_RXD0 = 102,
> +	MX6Q_ENET_TX_EN = 103,
> +	MX6Q_ENET_TXD1 = 104,
> +	MX6Q_ENET_TXD0 = 105,
> +	MX6Q_ENET_MDC = 106,
> +	MX6Q_KEY_COL0 = 107,
> +	MX6Q_KEY_ROW0 = 108,
> +	MX6Q_KEY_COL1 = 109,
> +	MX6Q_KEY_ROW1 = 110,
> +	MX6Q_KEY_COL2 = 111,
> +	MX6Q_KEY_ROW2 = 112,
> +	MX6Q_KEY_COL3 = 113,
> +	MX6Q_KEY_ROW3 = 114,
> +	MX6Q_KEY_COL4 = 115,
> +	MX6Q_KEY_ROW4 = 116,
> +	MX6Q_GPIO_0 = 117,
> +	MX6Q_GPIO_1 = 118,
> +	MX6Q_GPIO_9 = 119,
> +	MX6Q_GPIO_3 = 120,
> +	MX6Q_GPIO_6 = 121,
> +	MX6Q_GPIO_2 = 122,
> +	MX6Q_GPIO_4 = 123,
> +	MX6Q_GPIO_5 = 124,
> +	MX6Q_GPIO_7 = 125,
> +	MX6Q_GPIO_8 = 126,
> +	MX6Q_GPIO_16 = 127,
> +	MX6Q_GPIO_17 = 128,
> +	MX6Q_GPIO_18 = 129,
> +	MX6Q_GPIO_19 = 130,
> +	MX6Q_CSI0_PIXCLK = 131,
> +	MX6Q_CSI0_MCLK = 132,
> +	MX6Q_CSI0_DATA_EN = 133,
> +	MX6Q_CSI0_VSYNC = 134,
> +	MX6Q_CSI0_DAT4 = 135,
> +	MX6Q_CSI0_DAT5 = 136,
> +	MX6Q_CSI0_DAT6 = 137,
> +	MX6Q_CSI0_DAT7 = 138,
> +	MX6Q_CSI0_DAT8 = 139,
> +	MX6Q_CSI0_DAT9 = 140,
> +	MX6Q_CSI0_DAT10 = 141,
> +	MX6Q_CSI0_DAT11 = 142,
> +	MX6Q_CSI0_DAT12 = 143,
> +	MX6Q_CSI0_DAT13 = 144,
> +	MX6Q_CSI0_DAT14 = 145,
> +	MX6Q_CSI0_DAT15 = 146,
> +	MX6Q_CSI0_DAT16 = 147,
> +	MX6Q_CSI0_DAT17 = 148,
> +	MX6Q_CSI0_DAT18 = 149,
> +	MX6Q_CSI0_DAT19 = 150,
> +	MX6Q_SD3_DAT7 = 151,
> +	MX6Q_SD3_DAT6 = 152,
> +	MX6Q_SD3_DAT5 = 153,
> +	MX6Q_SD3_DAT4 = 154,
> +	MX6Q_SD3_CMD = 155,
> +	MX6Q_SD3_CLK = 156,
> +	MX6Q_SD3_DAT0 = 157,
> +	MX6Q_SD3_DAT1 = 158,
> +	MX6Q_SD3_DAT2 = 159,
> +	MX6Q_SD3_DAT3 = 160,
> +	MX6Q_SD3_RST = 161,
> +	MX6Q_NANDF_CLE = 162,
> +	MX6Q_NANDF_ALE = 163,
> +	MX6Q_NANDF_WP_B = 164,
> +	MX6Q_NANDF_RB0 = 165,
> +	MX6Q_NANDF_CS0 = 166,
> +	MX6Q_NANDF_CS1 = 167,
> +	MX6Q_NANDF_CS2 = 168,
> +	MX6Q_NANDF_CS3 = 169,
> +	MX6Q_SD4_CMD = 170,
> +	MX6Q_SD4_CLK = 171,
> +	MX6Q_NANDF_D0 = 172,
> +	MX6Q_NANDF_D1 = 173,
> +	MX6Q_NANDF_D2 = 174,
> +	MX6Q_NANDF_D3 = 175,
> +	MX6Q_NANDF_D4 = 176,
> +	MX6Q_NANDF_D5 = 177,
> +	MX6Q_NANDF_D6 = 178,
> +	MX6Q_NANDF_D7 = 179,
> +	MX6Q_SD4_DAT0 = 180,
> +	MX6Q_SD4_DAT1 = 181,
> +	MX6Q_SD4_DAT2 = 182,
> +	MX6Q_SD4_DAT3 = 183,
> +	MX6Q_SD4_DAT4 = 184,
> +	MX6Q_SD4_DAT5 = 185,
> +	MX6Q_SD4_DAT6 = 186,
> +	MX6Q_SD4_DAT7 = 187,
> +	MX6Q_SD1_DAT1 = 188,
> +	MX6Q_SD1_DAT0 = 189,
> +	MX6Q_SD1_DAT3 = 190,
> +	MX6Q_SD1_CMD = 191,
> +	MX6Q_SD1_DAT2 = 192,
> +	MX6Q_SD1_CLK = 193,
> +	MX6Q_SD2_CLK = 194,
> +	MX6Q_SD2_CMD = 195,
> +	MX6Q_SD2_DAT3 = 196

Please add a comma for even the last item.  It's a common patter for
easing the future expanding on the list.

> +};
> +
> +/* Pad names for the pinmux subsystem */
> +static const struct pinctrl_pin_desc mx6q_pads[] = {

Probably use imx6q_pinctrl_pins or imx6q_pinctrl_pads here to
distinguish from the name imx6q_pads suggested above.

Regards,
Shawn

