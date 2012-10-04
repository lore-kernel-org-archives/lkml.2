Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2JDMEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:04:12 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:42559 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab2JDMEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:04:09 -0400
Date: Thu, 4 Oct 2012 14:04:05 +0200
From: Ivan Djelic <ivan.djelic@parrot.com>
To: "Philip, Avinash" <avinashphilip@ti.com>
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
Subject: Re: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Message-ID: <20121004120405.GA28840@parrot.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-4-git-send-email-avinashphilip@ti.com>
 <20121003185458.GA27502@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9B4902@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9B4902@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:03:42AM +0100, Philip, Avinash wrote:
(...)
> > > +int gpmc_calculate_ecc_bch(int cs, const u_char *dat, u_char *ecc)
> > > +{
> > > +	int i, eccbchtsel;
> > > +	u32 nsectors, reg, bch_val1, bch_val2, bch_val3, bch_val4;
> > > +
> > > +	if (gpmc_ecc_used != cs)
> > > +		return -EINVAL;
> > > +
> > > +	/* read number of sectors for ecc to be calculated */
> > > +	nsectors = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 4) & 0x7) + 1;
> > > +	/*
> > > +	 * find BCH scheme used
> > > +	 * 0 -> BCH4
> > > +	 * 1 -> BCH8
> > > +	 */
> > > +	eccbchtsel = ((gpmc_read_reg(GPMC_ECC_CONFIG) >> 12) & 0x3);
> > > +
> > > +	/* update ecc bytes for entire page */
> > > +	for (i = 0; i < nsectors; i++) {
> > > +
> > > +		reg = GPMC_ECC_BCH_RESULT_0 + 16 * i;
> > > +
> > > +		/* Read hw-computed remainder */
> > > +		bch_val1 = gpmc_read_reg(reg + 0);
> > > +		bch_val2 = gpmc_read_reg(reg + 4);
> > > +		if (eccbchtsel) {
> > > +			bch_val3 = gpmc_read_reg(reg + 8);
> > > +			bch_val4 = gpmc_read_reg(reg + 12);
> > > +		}
> > > +
> > > +		if (eccbchtsel) {
> > > +			/* BCH8 ecc scheme */
> > > +			*ecc++ = (bch_val4 & 0xFF);
> > > +			*ecc++ = ((bch_val3 >> 24) & 0xFF);
> > > +			*ecc++ = ((bch_val3 >> 16) & 0xFF);
> > > +			*ecc++ = ((bch_val3 >> 8) & 0xFF);
> > > +			*ecc++ = (bch_val3 & 0xFF);
> > > +			*ecc++ = ((bch_val2 >> 24) & 0xFF);
> > > +			*ecc++ = ((bch_val2 >> 16) & 0xFF);
> > > +			*ecc++ = ((bch_val2 >> 8) & 0xFF);
> > > +			*ecc++ = (bch_val2 & 0xFF);
> > > +			*ecc++ = ((bch_val1 >> 24) & 0xFF);
> > > +			*ecc++ = ((bch_val1 >> 16) & 0xFF);
> > > +			*ecc++ = ((bch_val1 >> 8) & 0xFF);
> > > +			*ecc++ = (bch_val1 & 0xFF);
> > > +			/* 14th byte of ecc not used */
> > > +			*ecc++ = 0;
> > > +		} else {
> > > +			/* BCH4 ecc scheme */
> > > +			*ecc++ = ((bch_val2 >> 12) & 0xFF);
> > > +			*ecc++ = ((bch_val2 >> 4) & 0xFF);
> > > +			*ecc++ = (((bch_val2 & 0xF) << 4) |
> > > +					((bch_val1 >> 28) & 0xF));
> > > +			*ecc++ = ((bch_val1 >> 20) & 0xFF);
> > > +			*ecc++ = ((bch_val1 >> 12) & 0xFF);
> > > +			*ecc++ = ((bch_val1 >> 4) & 0xFF);
> > > +			*ecc++ = ((bch_val1 & 0xF) << 4);
> > > +		}
> > > +	}
> > > +
> > > +	gpmc_ecc_used = -EINVAL;
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(gpmc_calculate_ecc_bch);
> > 
> > Here you introduce a function very similar to gpmc_calculate_ecc_bch4 and
> > gpmc_calculate_ecc_bch8, but without the added benefit (IMHO) of the constant
> > polynomial that allows to get an ecc sequence of 0xFFs for a buffer filled with
> > 0xFFs. Why ?
> 
> I don't exactly understand what we benefitted/achieve. In my observation,
> this API does spare area also written with 0xFF if data area is 0xFFs.
> So the area looks like erased page again.

Precisely. It means you can read the page with ECC enabled without having to check if
the page has been programmed; it also enables bitflip correction on erased pages.

> > If using the ELM prevents you from reusing gpmc_calculate_ecc_bch[48], could you explain in which way ?
> 
> When using gpmc_calculate_ecc_bch[48], calculated ecc values modified.
> The read sequence we following is
> Read 512 byte -> read ECC bytes from spare area
> Now the calculated ECC will be zero if no error is reported. In case of error, a syndrome
> Polynomial is reported. In either case modifying will corrupt the data.

It is still possible to retrieve your original error syndrome, even using the technique transforming ECC on erased pages into 0xFFs.
But I guess you're not interested if you need RBL compatibility.

BR,
--
Ivan
