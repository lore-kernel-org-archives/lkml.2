Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2JDHus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:50:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39291 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab2JDHuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:50:46 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
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
	<devicetree-discuss@lists.ozlabs.org>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH 2/4] mtd: devices: elm: Add support for ELM error
 correction
Thread-Topic: [PATCH 2/4] mtd: devices: elm: Add support for ELM error
 correction
Thread-Index: AQHNoXZIJO5M+tejI0OdjKXrVMye75enU2cAgAFvsJA=
Date: Thu, 4 Oct 2012 07:49:14 +0000
Deferred-Delivery: Thu, 4 Oct 2012 07:49:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9B48A7@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-3-git-send-email-avinashphilip@ti.com>
 <alpine.DEB.2.01.1210031701440.32543@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1210031701440.32543@pmeerw.net>
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

On Wed, Oct 03, 2012 at 20:40:46, Peter Meerwald wrote:
> 
> some minor nitpicks below
> 
> > + *
> > + * On completion of processing by elm module, error location status
> > + * register updated with correctable/uncorrectable error information.
> > + * In case of correctable errors, number of errors located from
> > + * elm location status register & read the these many positions from
> 
> should probably be: "... & read the positions from ..."?

Ok I will correct it.

> 
> > + * elm error location register.
> > + */
> > +static void elm_error_correction(struct elm_info *info,
> > +		struct elm_errorvec *err_vec)
> > +{
> > +	int i, j, errors = 0;
> > +	void *err_loc_base = info->elm_base + ELM_ERROR_LOCATION_0;
> > +	elm_error_t *err_loc;
> > +	void *offset;
> > +	u32 reg_val;
> > +
> > +	for (i = 0; i < ERROR_VECTOR_MAX; i++) {
> > +		/* check error reported */
> > +		if (err_vec[i].error_reported) {
> > +			offset = info->elm_base + ELM_LOCATION_STATUS +
> > +				i * ERROR_LOCATION_SIZE;
> > +			reg_val = elm_read_reg(offset);
> > +			/* check correctable error or not */
> > +			if (reg_val & ECC_CORRECTABLE_MASK) {
> > +				err_loc = err_loc_base +
> > +					i * ERROR_LOCATION_SIZE;
> > +				/* read count of correctable errors */
> > +				err_vec[i].error_count = reg_val &
> > +					ECC_NB_ERRORS_MASK;
> > +
> > +				/* update the error locations in error vector */
> > +				for (j = 0; j < err_vec[i].error_count; j++) {
> > +
> > +					reg_val = elm_read_reg(*err_loc + j);
> > +					err_vec[i].error_loc[j] = reg_val &
> > +						ECC_ERROR_LOCATION_MASK;
> > +				}
> > +
> > +				errors += err_vec[i].error_count;
> > +			} else {
> > +				err_vec[i].error_uncorrectable++;
> > +			}
> 
> extra braces above

As per coding style
This does not apply if only one branch of a conditional statement is a single
statement; in the latter case use braces in both branches:

> 
> > +
> > +			/* clearing interrupts for processed error vectors */
> > +			elm_write_reg(info->elm_base + ELM_IRQSTATUS, BIT(i));
> > +
> > +			/* disable page mode */
> > +			elm_configure_page_mode(info, i, false);
> > +		}
> > +	}
> > +
> > +	return;
> > +}
> > +
> > +/**
> > + * elm_decode_bch_error_page - Locate error position
> > + * @info:	elm info
> 
> should be dev, not info

Ok I will correct it.

> 
> > + * @ecc_calc:	calculated ECC bytes from GPMC
> > + * @err_vec:	elm error vectors
> > + *
> > + * Called with one or greater reported and is vectors with error reported
> > + * is updated in err_vec[].error_reported
> > + */
> 
> I do not understand the statement "Called with one ..."

elm_decode_bch_error_page() API will called from nand driver if and only if
errors are present while reading page. Errors can be reported in one or
multiple error vectors.

I will reword it as.

Called with one or more error reported vectors & vectors with error reported
is updated in err_vec[].error_reported

> 
[snip]
> > +
> > +#define BCH8_ECC_OOB_BYTES		13
> > +/* RBL requires 14 byte even though BCH8 uses only 13 byte */
> 
> not sure what RBL is?

RBL stands for Rom boot Loader

> 
> > +#define BCH8_SIZE			(BCH8_ECC_OOB_BYTES + 1)
> > +#define BCH4_SIZE			7
> > +
> > +#define	BCH8_SYNDROME_SIZE		4	/* 13 bytes of ecc */
> > +#define	BCH4_SYNDROME_SIZE		2	/* 7 bytes of ecc */
> > +
> > +/**
> > + * struct elm_errorvec - error vector for elm
> > + * @error_reported:		set true for vectors error is reported
> > + *
> > + * @error_count:		number of correctable errors in the sector
> > + * @error_uncorrectable:	number of uncorrectable errors
> > + * @error_loc:			buffer for error location
> > + *
> > + */
> > +struct elm_errorvec {
> > +	bool error_reported;
> > +	int error_count;
> > +	int error_uncorrectable;
> > +	int error_loc[ERROR_VECTOR_MAX];
> > +};
> > +
> > +void elm_decode_bch_error_page(struct device *dev, u8 *ecc_calc,
> > +		struct elm_errorvec *err_vec);
> > +struct device *elm_request(enum bch_ecc bch_type);
> > +#endif /* __ELM_H */
> > 
> 
> -- 
> 
> Peter Meerwald
> +43-664-2444418 (mobile)
> 

