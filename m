Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2JDIFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:05:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51020 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2JDIE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:04:58 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Ivan Djelic <ivan.djelic@parrot.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Thread-Topic: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Thread-Index: AQHNoXbfIgW0XH8glUaeL6a0DcGNGJenkgkAgAEzgcA=
Date: Thu, 4 Oct 2012 08:03:42 +0000
Deferred-Delivery: Thu, 4 Oct 2012 08:03:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9B4902@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-4-git-send-email-avinashphilip@ti.com>
 <20121003185458.GA27502@parrot.com>
In-Reply-To: <20121003185458.GA27502@parrot.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 00:24:58, Ivan Djelic wrote:
> On Wed, Oct 03, 2012 at 03:29:48PM +0100, Philip, Avinash wrote:
> > Add support for BCH ECC scheme to gpmc driver and also enabling multi
> > sector read/write. This helps in doing single shot NAND page read and
> > write.
> > 
> > ECC engine configurations
> > BCH 4 bit support
> > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
> > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
> > 13 and ecc_size1 as 1.
> > 
> > BCH 8 bit support
> > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
> > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
> > 26 and ecc_size1 as 2.
> > 
> > Note: For BCH8 ECC bytes set to 14 to make compatible with RBL.
> > 
> 
> Hi Philip,
> 
> I have a few comments/questions below,
> 
> (...)
> > diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> > index 72428bd..c9bc3cf 100644
> > --- a/arch/arm/mach-omap2/gpmc.c
> > +++ b/arch/arm/mach-omap2/gpmc.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/io.h>
> >  #include <linux/module.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/mtd/nand.h>
> >  
> >  #include <asm/mach-types.h>
> >  #include <plat/gpmc.h>
> > @@ -83,6 +84,18 @@
> >  #define ENABLE_PREFETCH		(0x1 << 7)
> >  #define DMA_MPU_MODE		2
> >  
> > +/* GPMC ecc engine settings for read */
> > +#define BCH_WRAPMODE_1		1	/* BCH wrap mode 6 */
> 
> Comment should say "mode 1".

Ok I will correct it.

> 
> (...)
> >  /**
> > + * gpmc_calculate_ecc_bch	- Generate ecc bytes per block of 512 data bytes for entire page
> > + * @cs:  chip select number
> > + * @dat: The pointer to data on which ECC is computed
> > + * @ecc: The ECC output buffer
> > + */
> > +int gpmc_calculate_ecc_bch(int cs, const u_char *dat, u_char *ecc)
> > +{
> > +	int i, eccbchtsel;
> > +	u32 nsectors, reg, bch_val1, bch_val2, bch_val3, bch_val4;
> > +
> > +	if (gpmc_ecc_used != cs)
> > +		return -EINVAL;
> > +
> > +	/* read number of sectors for ecc to be calculated */
> > +	nsectors = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 4) & 0x7) + 1;
> > +	/*
> > +	 * find BCH scheme used
> > +	 * 0 -> BCH4
> > +	 * 1 -> BCH8
> > +	 */
> > +	eccbchtsel = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 12) & 0x3);
> > +
> > +	/* update ecc bytes for entire page */
> > +	for (i = 0; i < nsectors; i++) {
> > +
> > +		reg = GPMC_ECC_BCH_RESULT_0 + 16 * i;
> > +
> > +		/* Read hw-computed remainder */
> > +		bch_val1 = gpmc_read_reg(reg + 0);
> > +		bch_val2 = gpmc_read_reg(reg + 4);
> > +		if (eccbchtsel) {
> > +			bch_val3 = gpmc_read_reg(reg + 8);
> > +			bch_val4 = gpmc_read_reg(reg + 12);
> > +		}
> > +
> > +		if (eccbchtsel) {
> > +			/* BCH8 ecc scheme */
> > +			*ecc++ = (bch_val4 & 0xFF);
> > +			*ecc++ = ((bch_val3 >> 24) & 0xFF);
> > +			*ecc++ = ((bch_val3 >> 16) & 0xFF);
> > +			*ecc++ = ((bch_val3 >> 8) & 0xFF);
> > +			*ecc++ = (bch_val3 & 0xFF);
> > +			*ecc++ = ((bch_val2 >> 24) & 0xFF);
> > +			*ecc++ = ((bch_val2 >> 16) & 0xFF);
> > +			*ecc++ = ((bch_val2 >> 8) & 0xFF);
> > +			*ecc++ = (bch_val2 & 0xFF);
> > +			*ecc++ = ((bch_val1 >> 24) & 0xFF);
> > +			*ecc++ = ((bch_val1 >> 16) & 0xFF);
> > +			*ecc++ = ((bch_val1 >> 8) & 0xFF);
> > +			*ecc++ = (bch_val1 & 0xFF);
> > +			/* 14th byte of ecc not used */
> > +			*ecc++ = 0;
> > +		} else {
> > +			/* BCH4 ecc scheme */
> > +			*ecc++ = ((bch_val2 >> 12) & 0xFF);
> > +			*ecc++ = ((bch_val2 >> 4) & 0xFF);
> > +			*ecc++ = (((bch_val2 & 0xF) << 4) |
> > +					((bch_val1 >> 28) & 0xF));
> > +			*ecc++ = ((bch_val1 >> 20) & 0xFF);
> > +			*ecc++ = ((bch_val1 >> 12) & 0xFF);
> > +			*ecc++ = ((bch_val1 >> 4) & 0xFF);
> > +			*ecc++ = ((bch_val1 & 0xF) << 4);
> > +		}
> > +	}
> > +
> > +	gpmc_ecc_used = -EINVAL;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(gpmc_calculate_ecc_bch);
> 
> Here you introduce a function very similar to gpmc_calculate_ecc_bch4 and
> gpmc_calculate_ecc_bch8, but without the added benefit (IMHO) of the constant
> polynomial that allows to get an ecc sequence of 0xFFs for a buffer filled with
> 0xFFs. Why ?

I don't exactly understand what we benefitted/achieve. In my observation,
this API does spare area also written with 0xFF if data area is 0xFFs.
So the area looks like erased page again.

> If using the ELM prevents you from reusing gpmc_calculate_ecc_bch[48], could you explain in which way ?

When using gpmc_calculate_ecc_bch[48], calculated ecc values modified.
The read sequence we following is
Read 512 byte -> read ECC bytes from spare area
Now the calculated ECC will be zero if no error is reported. In case of error, a syndrome
Polynomial is reported. In either case modifying will corrupt the data.

This is valid if we are writing a page with 0xFF also. But this time we were filling a valid
ecc in spare area not 0xFF as in gpmc_calculate_ecc_bch[48].

Additionally to make compatible with RBL ECC layout (14 byte), we were setting ecc[13] as zero.

Thanks
Avinash  

> 
> Best regards,
> --
> Ivan
> 

