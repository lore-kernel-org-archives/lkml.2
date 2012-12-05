Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2LEMpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:45:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51712 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2LEMpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:45:30 -0500
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
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: RE: [PATCH v3 1/3] mtd: nand: omap2: Update nerrors using
 ecc.strength
Thread-Topic: [PATCH v3 1/3] mtd: nand: omap2: Update nerrors using
 ecc.strength
Thread-Index: AQHNzic/oyygUlc/tEivdk+KDbZRxpgJyJuAgABfSOA=
Date: Wed, 5 Dec 2012 12:43:59 +0000
Deferred-Delivery: Wed, 5 Dec 2012 12:43:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA1139B@DBDE01.ent.ti.com>
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com>
 <1354189595-12784-2-git-send-email-avinashphilip@ti.com>
 <50BF3819.9010200@ti.com>
In-Reply-To: <50BF3819.9010200@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB5Cjnba014148

On Wed, Dec 05, 2012 at 17:33:37, Nori, Sekhar wrote:
> Hi Avinash,
> 
> On 11/29/2012 5:16 PM, Philip, Avinash wrote:
> > Update number of errors using nand ecc strength.
> > Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX
> 
> Can you please describe why the original method of setting nerrors was
> incorrect? Was it causing any issues in any particular configuration?

It affects the reusability of the code. For example BCH8 with AM335x RBL 
compatibility requires  14 bytes instead of 13 byte. So setting nerrors
with
	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
will break am335x RBL compatibility.

> Mentioning this will help maintainers assign priority to your patch. If
> this is a real bug affecting existing platforms, then there is a chance
> this patch can get into v3.7 (or at least into v3.8-rc1).
> 
> Like Peter who commented on this before, I am not a fan of using macros
> for self-describing constants - especially when you end up using the
> same numbers inside the macro name itself. No need to resend any thing
> just for this, you can wait to see if the maintainers are okay with it.

Yes I agree. But the same constants are used in multiple places here.
So usage of macro helps in readability & code debugging.

Thanks
Avinash
 
> 
> Thanks,
> Sekhar
> 
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > ---
> > :100644 100644 359293e... 7e61dac... M	drivers/mtd/nand/omap2.c
> >  drivers/mtd/nand/omap2.c |   12 ++++++++----
> >  1 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> > index 359293e..7e61dac 100644
> > --- a/drivers/mtd/nand/omap2.c
> > +++ b/drivers/mtd/nand/omap2.c
> > @@ -118,6 +118,9 @@
> >  
> >  #define OMAP24XX_DMA_GPMC		4
> >  
> > +#define BCH8_MAX_ERROR		8	/* upto 8 bit correctable */
> > +#define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
> > +
> >  /* oob info generated runtime depending on ecc algorithm and layout selected */
> >  static struct nand_ecclayout omap_oobinfo;
> >  /* Define some generic bad / good block scan pattern which are used
> > @@ -1042,7 +1045,7 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
> >  	struct nand_chip *chip = mtd->priv;
> >  	u32 val;
> >  
> > -	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
> > +	nerrors = info->nand.ecc.strength;
> >  	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
> >  	nsectors = 1;
> >  	/*
> > @@ -1219,13 +1222,14 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
> >  	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> >  						   mtd);
> >  #ifdef CONFIG_MTD_NAND_OMAP_BCH8
> > -	const int hw_errors = 8;
> > +	const int hw_errors = BCH8_MAX_ERROR;
> >  #else
> > -	const int hw_errors = 4;
> > +	const int hw_errors = BCH4_MAX_ERROR;
> >  #endif
> >  	info->bch = NULL;
> >  
> > -	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ? 8 : 4;
> > +	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ?
> > +		BCH8_MAX_ERROR : BCH4_MAX_ERROR;
> >  	if (max_errors != hw_errors) {
> >  		pr_err("cannot configure %d-bit BCH ecc, only %d-bit supported",
> >  		       max_errors, hw_errors);
> > 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
