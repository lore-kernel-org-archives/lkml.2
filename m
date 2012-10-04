Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2JDKYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:24:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44627 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2JDKYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:24:05 -0400
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
Subject: RE: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Topic: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Thread-Index: AQHNoXboDgXHKDcq00CaQ0Yo4e+M+penmT6AgAFWaxA=
Date: Thu, 4 Oct 2012 10:22:43 +0000
Deferred-Delivery: Thu, 4 Oct 2012 10:22:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9B7FDF@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
 <20121003192044.GB27502@parrot.com>
In-Reply-To: <20121003192044.GB27502@parrot.com>
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

On Thu, Oct 04, 2012 at 00:50:45, Ivan Djelic wrote:
> On Wed, Oct 03, 2012 at 03:29:49PM +0100, Philip, Avinash wrote:
> > ELM module can be used for error correction of BCH 4 & 8 bit. Also
> > support read & write page in one shot by adding custom read_page &
> > write_page methods. This helps in optimizing code.
> > 
> > New structure member "is_elm_used" is added to know the status of
> > whether the ELM module is used for error correction or not.
> > 
> > Note:
> > ECC layout of BCH8 uses 14 bytes for 512 byte of data to make compatible
> > with RBL ECC layout, even though the requirement was only 13 byte. This
> > results a common ecc layout across RBL, U-boot & Linux.
> > 
> 
> See a few comments below,
> 
> (...)
> > +static int omap_elm_correct_data(struct mtd_info *mtd, u_char *dat,
> > +                               u_char *read_ecc, u_char *calc_ecc)
> > +{
> > +       struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> > +                       mtd);
> > +       int eccsteps = info->nand.ecc.steps;
> > +       int i , j, stat = 0;
> > +       int eccsize, eccflag, size;
> > +       struct elm_errorvec err_vec[ERROR_VECTOR_MAX];
> > +       u_char *ecc_vec = calc_ecc;
> > +       enum bch_ecc type;
> > +       bool is_error_reported = false;
> > +
> > +       /* initialize elm error vector to zero */
> > +       memset(err_vec, 0, sizeof(err_vec));
> > +       if (info->nand.ecc.strength == BCH8_MAX_ERROR) {
> > +               size = BCH8_SIZE;
> > +               eccsize = BCH8_ECC_OOB_BYTES;
> > +               type = BCH8_ECC;
> > +       } else {
> > +               size = BCH4_SIZE;
> > +               eccsize = BCH4_SIZE;
> > +               type = BCH4_ECC;
> > +       }
> > +
> > +       for (i = 0; i < eccsteps ; i++) {
> > +               eccflag = 0;    /* initialize eccflag */
> > +
> > +               for (j = 0; (j < eccsize); j++) {
> > +                       if (read_ecc[j] != 0xFF) {
> > +                               eccflag = 1;    /* data area is flashed */
> 
> Just a reminder: this way of checking if a page has been programmed is not robust to bitflips,
> so you may get into trouble with UBIFS on a fairly recent device.
> 
> (...)
> > @@ -1039,14 +1180,45 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
> > 
> >         nerrors = info->nand.ecc.strength;
> >         dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
> > +#ifdef CONFIG_MTD_NAND_OMAP_BCH
> > +       if (info->is_elm_used) {
> > +               /*
> > +                * Program GPMC to perform correction on (steps * 512) byte
> > +                * sector at a time.
> > +                */
> > +               gpmc_enable_hwecc_bch(info->gpmc_cs, mode, dev_width,
> > +                               info->nand.ecc.steps, nerrors);
> > +               return;
> > +       }
> > +#endif
> >         /*
> > -        * Program GPMC to perform correction on one 512-byte sector at a time.
> > -        * Using 4 sectors at a time (i.e. ecc.size = 2048) is also possible and
> > -        * gives a slight (5%) performance gain (but requires additional code).
> > +        * Program GPMC to perform correction on one 512-byte sector at
> > +        * a time.
> 
> Why removing the comment about 4-sector perf gain ? :-)

With this patch, support for reading 4 sectors (max 8) is available.
Hence I am removing it.

> 
> (...)
> > @@ -1146,35 +1402,62 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
> >                 goto fail;
> >         }
> > 
> > -       /* initialize GPMC BCH engine */
> > -       ret = gpmc_init_hwecc_bch(info->gpmc_cs, 1, max_errors);
> > -       if (ret)
> > -               goto fail;
> > -
> > -       /* software bch library is only used to detect and locate errors */
> > -       info->bch = init_bch(13, max_errors, 0x201b /* hw polynomial */);
> > -       if (!info->bch)
> > -               goto fail;
> > +       info->nand.ecc.size = 512;
> > +       info->nand.ecc.hwctl = omap3_enable_hwecc_bch;
> > +       info->nand.ecc.mode = NAND_ECC_HW;
> > +       info->nand.ecc.strength = hw_errors;
> > 
> > -       info->nand.ecc.size    = 512;
> > -       info->nand.ecc.hwctl   = omap3_enable_hwecc_bch;
> > -       info->nand.ecc.correct = omap3_correct_data_bch;
> > -       info->nand.ecc.mode    = NAND_ECC_HW;
> > +       if (info->is_elm_used && (mtd->writesize <= 4096)) {
> > +               enum bch_ecc bch_type;
> > 
> > -       /*
> > -        * The number of corrected errors in an ecc block that will trigger
> > -        * block scrubbing defaults to the ecc strength (4 or 8).
> > -        * Set mtd->bitflip_threshold here to define a custom threshold.
> > -        */
> > +               if (hw_errors == BCH8_MAX_ERROR) {
> > +                       bch_type = BCH8_ECC;
> > +                       info->nand.ecc.bytes = BCH8_SIZE;
> > +               } else {
> > +                       bch_type = BCH4_ECC;
> > +                       info->nand.ecc.bytes = BCH4_SIZE;
> > +               }
> > 
> > -       if (max_errors == 8) {
> > -               info->nand.ecc.strength  = 8;
> > -               info->nand.ecc.bytes     = 13;
> > -               info->nand.ecc.calculate = omap3_calculate_ecc_bch8;
> > +               info->nand.ecc.correct = omap_elm_correct_data;
> > +               info->nand.ecc.calculate = omap3_calculate_ecc_bch;
> > +               info->nand.ecc.read_page = omap_read_page_bch;
> > +               info->nand.ecc.write_page = omap_write_page_bch;
> > +               info->elm_dev = elm_request(bch_type);
> > +               if (!info->elm_dev) {
> > +                       pr_err("Request to elm module failed\n");
> > +                       goto fail;
> > +               }
> >         } else {
> > -               info->nand.ecc.strength  = 4;
> > -               info->nand.ecc.bytes     = 7;
> > -               info->nand.ecc.calculate = omap3_calculate_ecc_bch4;
> > +
> > +               /* initialize GPMC BCH engine */
> > +               ret = gpmc_init_hwecc_bch(info->gpmc_cs, 1, max_errors);
> > +               if (ret)
> > +                       goto fail;
> > +
> > +               /*
> > +                * software bch library is only used to detect and
> > +                * locateerrors
> 
> s/locateerrors/locate errors/

Ok I will correct it.

> 
> BTW, did you check that your patch does not break the software BCH case (i.e. no ELM) ?

I had checked in AM335x-evm software BCH without ELM. So this patch set is not breaking
software BCH functionality.

Thanks
Avinash


> 
> BR,
> --
> Ivan
> 

