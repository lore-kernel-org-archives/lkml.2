Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2JWKTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:19:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50671 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2JWKTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:19:38 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Rob Landley <rob@landley.net>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/4] mtd: devices: elm: Add support for ELM error
 correction
Thread-Topic: [PATCH 2/4] mtd: devices: elm: Add support for ELM error
 correction
Thread-Index: AQHNqw3zJstUoBASxkW32ofAwayOX5fGsshg
Date: Tue, 23 Oct 2012 10:17:58 +0000
Deferred-Delivery: Tue, 23 Oct 2012 10:17:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9D29C3@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
	<1349274589-11389-3-git-send-email-avinashphilip@ti.com>
 <87hapvv800.fsf@macbook.be.48ers.dk>
In-Reply-To: <87hapvv800.fsf@macbook.be.48ers.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 01:10:47, Peter Korsgaard wrote:
> >>>>> Philip, Avinash <avinashphilip@ti.com> writes:
> 
>  > Platforms containing the ELM module can be used to correct errors
>  > reported by BCH 4, 8 & 16 bit ECC scheme. For now only 4 & 8 bit
>  > support is added.
> 
> This sounds odd to me. What about something like:
> 
> The ELM hardware module can be used to speedup BCH 4/8/16 ECC scheme
> error correction.
> 
> For now only 4 & 8 bit support is added.

Ok I will correct it.

> 
> 
>  > +++ b/drivers/mtd/devices/Makefile
>  > @@ -17,8 +17,10 @@ obj-$(CONFIG_MTD_LART)		+= lart.o
>  >  obj-$(CONFIG_MTD_BLOCK2MTD)	+= block2mtd.o
>  >  obj-$(CONFIG_MTD_DATAFLASH)	+= mtd_dataflash.o
>  >  obj-$(CONFIG_MTD_M25P80)	+= m25p80.o
>  > +obj-$(CONFIG_MTD_NAND_OMAP2)	+= elm.o
> 
> You seem to only use it in 4/4 if CONFIG_MTD_NAND_OMAP_BCH is set, so it
> probably makes more sense to use that symbol to not needlessly include
> it if it won't be used.

Ok. This been good.

> 
> 
>  > +static void elm_write_reg(void *offset, u32 val)
>  > +{
>  > +	writel(val, offset);
>  > +}
>  > +
>  > +static u32 elm_read_reg(void *offset)
>  > +{
>  > +	return readl(offset);
>  > +}
> 
> As written these read/write wrappers don't add anything. How about
> passing struct elm_info and offset as an integer so you can drop
> elm_base from all call sites, E.G.:
> 
> static void elm_write_reg(struct elm_info *info, int offset, u32 val)
> {
>         writel(val, info->elm_base + offset);
> }
>

Ok, this helps to reduce some indentation levels also.
 
> 
>  > +void elm_decode_bch_error_page(struct device *dev, u8 *ecc_calc,
>  > +		struct elm_errorvec *err_vec)
>  > +{
>  > +	int i;
>  > +	u8 syndrome[BCH_MAX_ECC_BYTES_PER_SECTOR] = {0}, *syn_p;
> 
> 
> Why do you need to keep the entire syndrome around? You seem to only use
> it between elm_reverse_eccdata() and elm_load_syndrome(), so it could as
> well be BCH8_ECC_OOB_BYTES long (or rather a multiple of sizeof(u32).
> 
> It would also be good to do the shuffeling directly in elm_load_syndrome
> so you don't need the extra copy.

I will check.

> 
> 
>  > + */
>  > +
>  > +#ifndef __ELM_H
>  > +#define __ELM_H
>  > +
>  > +enum bch_ecc {
>  > +	BCH4_ECC = 0,
>  > +	BCH8_ECC,
>  > +	BCH16_ECC,
> 
> It probably makes more sense to not provide the enum value for BCH16 as
> you don't support it.
> 

Ok I will remove.

> 
>  > +};
>  > +

Thanks
Avinash


