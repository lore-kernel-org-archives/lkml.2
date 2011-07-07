Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1GGMSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:18:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39345 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1GGMSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:18:43 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>, "Chemparathy, Cyril" <cyril@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 7 Jul 2011 17:48:32 +0530
Subject: RE: [RFC/RFT 2/2] davinci: use generic memory mapped gpio for
 tnetv107x
Thread-Topic: [RFC/RFT 2/2] davinci: use generic memory mapped gpio for
 tnetv107x
Thread-Index: Acw8KG/K72xbzIcHTqWY0k3/yKs7MAAcZUzw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D9B523F@dbde02.ent.ti.com>
References: <cover.1309840042.git.nsekhar@ti.com>
 <6639b07562e3e6643dd07d5ed3907cb5158ce16b.1309840042.git.nsekhar@ti.com>
 <20110706220240.GF5371@ponder.secretlab.ca>
In-Reply-To: <20110706220240.GF5371@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Jul 07, 2011 at 03:32:40, Grant Likely wrote:
> On Tue, Jul 05, 2011 at 10:41:00AM +0530, Sekhar Nori wrote:

> > +#define TNETV107X_N_GPIO_DEV	DIV_ROUND_UP(TNETV107X_N_GPIO, 32)
> > +
> > +static struct resource gpio_resources[TNETV107X_N_GPIO_DEV][4] = {
> > +	[0 ... TNETV107X_N_GPIO_DEV - 1] = {
> 
> If all the data is identical, why does this need to be an array?

The data is initialized identically, but there is
a loop down below which updates the start and end
address for each GPIO device. This way I get to
initialize the name and flags statically.

BTW, I just noticed that I forgot to initialize the
flags in the resource structure below. Will fix
that.

> 
> > +		{
> > +			.name	= "dat",
> > +			.start	= TNETV107X_GPIO_BASE + 0x4,
> > +			.end	= TNETV107X_GPIO_BASE + 0x4 + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "set",
> > +			.start	= TNETV107X_GPIO_BASE + 0x10,
> > +			.end	= TNETV107X_GPIO_BASE + 0x10 + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "dirin",
> > +			.start	= TNETV107X_GPIO_BASE + 0x1c,
> > +			.end	= TNETV107X_GPIO_BASE + 0x1c + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "en",
> > +			.start	= TNETV107X_GPIO_BASE + 0x28,
> > +			.end	= TNETV107X_GPIO_BASE + 0x28 + 0x4 - 1,
> > +		},
> > +	},
> > +};
> 
> Wow, this ends up looking horrible. (yes, I know it is not your
> fault).  I backed off earlier on using resources for the offsets, but
> I want to change my mind again and make interface a register range +
> offsets to the control registers.

Okay. More work on cleaning the generic driver :)

> 
> > +
> > +static struct platform_device gpio_device[] = {
> > +	[0 ... TNETV107X_N_GPIO_DEV - 1] = {
> > +		.name		= "basic-mmio-gpio",
> > +		.num_resources	= 4,
> > +	},
> > +};
> > +
> > +static struct bgpio_pdata gpio_pdata[TNETV107X_N_GPIO_DEV];
> > +
> > +static void __init tnetv107x_gpio_init(void)
> > +{
> > +	int i, j;
> > +
> > +	for (i = 1; i < TNETV107X_N_GPIO_DEV; i++) {
> > +		for (j = 0; j < 4; j++) {
> > +			gpio_resources[i][j].start += 0x4 * i;
> > +			gpio_resources[i][j].end += 0x4 * i;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < TNETV107X_N_GPIO_DEV; i++) {
> > +		int base = i * 32;
> > +
> > +		gpio_device[i].id = i;
> > +		gpio_device[i].resource = gpio_resources[i];
> > +
> > +		gpio_pdata[i].base = base;
> > +		gpio_pdata[i].ngpio = TNETV107X_N_GPIO - base;
> 
> ?  This doesn't look right.  Shouldn't ngpio be the same for each gpio
> controller instance?

Yes, ngpio is same (32) for each GPIO device except for
the last GPIO device which may have lesser number of
valid GPIO pins. The if statement below takes care of that.

> 
> > +		if (gpio_pdata[i].ngpio > 32)
> > +			gpio_pdata[i].ngpio = 32;
> > +
> > +		gpio_device[i].dev.platform_data = &gpio_pdata[i];
> > +
> > +		platform_device_register(&gpio_device[i]);
> > +	}
> > +}
> > +

Thanks,
Sekhar

