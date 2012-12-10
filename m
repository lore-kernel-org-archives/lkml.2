Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2LJGoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:44:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53853 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2LJGox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:44:53 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v3 2/3] mtd: devices: elm: Add support for ELM error
 correction
Thread-Topic: [PATCH v3 2/3] mtd: devices: elm: Add support for ELM error
 correction
Thread-Index: AQHNzidHymKJQMxCykm8lU2YmG5mH5gM1SyAgATFekA=
Date: Mon, 10 Dec 2012 06:43:17 +0000
Deferred-Delivery: Mon, 10 Dec 2012 06:43:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA1FA14@DBDE01.ent.ti.com>
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com>
 <1354189595-12784-3-git-send-email-avinashphilip@ti.com>
 <50C1C6E3.5020300@ti.com>
In-Reply-To: <50C1C6E3.5020300@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBA6j0Aj003554

On Fri, Dec 07, 2012 at 16:07:23, Nori, Sekhar wrote:
> On 11/29/2012 5:16 PM, Philip, Avinash wrote:
> > The ELM hardware module can be used to speedup BCH 4/8/16 ECC scheme
> > error correction.
> > For now only 4 & 8 bit support is added
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Rob Landley <rob@landley.net>

[...]
/**
> > + * elm_config - Configure ELM module
> > + * @info:	elm info
> > + */
> > +static void elm_config(struct elm_info *info)
> 
> This is called "config", but there is no configuration information
> passed which looks odd..

The config information is bch_type, encapsulated in struct elm_info.

> 
> > +{
> > +	u32 reg_val;
> > +
> > +	reg_val = (info->bch_type & ECC_BCH_LEVEL_MASK) | (ELM_ECC_SIZE << 16);
> > +	elm_write_reg(info, ELM_LOCATION_CONFIG, reg_val);
> > +}
> 
> Is there a use case where BCH type needs to be changed after NAND has
> been probed?

No, I think kernel handles the entire NAND part with a single ecc layout.
Hence there is no run time BCH switching. But ELM driver should support BCH
4 & 8. Selection of BCH information comes from DT of NAND driver.

As NAND driver supporting BCH4 & 8 ecc scheme ELM module support
configuration of both.  Configuration of ELM module should done as part
of NAND driver probing.


> You will have to erase any existing data written to NAND if
> you change the ECC type. That sounds destructive enough to avoid such a
> thing.

There is no support for BCH switching after NAND driver probing.

[...]
> > +struct device *elm_request(enum bch_ecc bch_type)
> > +{
> > +	struct elm_info *info;
> > +
> > +	list_for_each_entry(info, &elm_devices, list) {
> > +		if (info && info->dev) {
> > +				info->bch_type = bch_type;
> > +				elm_config(info);
> > +				return info->dev;
> > +		}
> > +	}
> 
> This will always return the first ELM device probed since you never
> remove the allocated device from the list.

But now I realized that, there is no mechanism of freeing the requested
resource.

So I will add mechanism to request ELM module successfully only if ELM
module is not requested already and add mechanism to free it, on NAND
driver module unload (loadable module support). This way ELM driver
can achieve multi instance support.

> I wonder why you really need a list?

The prime motivation for the list is the driver should support multi
instances of ELM by removing global symbols.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
