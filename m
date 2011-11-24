Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1KXQhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:37:10 -0500
Received: from portal.weinmann.de ([62.8.140.122]:37462 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1KXQhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:37:08 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>
Date: Thu, 24 Nov 2011 17:36:50 +0100
Subject: RE: [PATCH v7 3/5] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v7 3/5] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: Acyqv0FSxZrsf6u0TYC6s40Fe6s5OgABendw
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B45007C@wm021.weinmann.com>
References: <cover.1322062555.git.n.voss@weinmann.de>
 <201111231618.45951.arnd@arndb.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B44FEAF@wm021.weinmann.com>
 <201111241539.06990.arnd@arndb.de>
In-Reply-To: <201111241539.06990.arnd@arndb.de>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnd Bergmann wrote on 2011-11-24:
> On Thursday 24 November 2011, Voss, Nikolaus wrote:
> > >
> > > > +/*
> > > > + * Calculate and set symmetric clock as stated in datasheet:
> > > > + * twi_clk = F_MAIN / (2 * cdiv * (1 << ckdiv) + 4)
> > > > + */
> > > > +static void __devinit at91_set_twi_clock(struct at91_twi_dev *dev, int
> > > twi_clk)
> > > > +{
> > > > +   const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) -
> 2;
> > > > +   int ckdiv = fls(div >> 8);
> > > > +   const int cdiv = div >> ckdiv;
> > > > +
> > > > +   if (cpu_is_at91rm9200() && (ckdiv > 5)) {
> > > > +           dev_warn(dev->dev, "AT91RM9200 erratum 22: using ckdiv =
> 5.\n");
> > > > +           ckdiv = 5;
> > > > +   }
> > >
> > > Don't check a global property like this locally in the driver. Instead,
> > > make it a property of the device that you check here and set it based on
> > > the the device name set by the platform, or by a device tree property.
> >
> > Yes, this is a known problem and was discussed in
> > https://lkml.org/lkml/2011/11/8/217 . The main problem is that there a no
> > revisions for specific at91 IP devices but the revision is implicitly
> > defined by the cpu type and version. Changing this would need to add some
> > arch infrastructure which I think is beyond the scope of this driver.
> 
> Aside from the flamewar in that thread, my impression is that in general
> people (me certainly) prefer to have driver-local workarounds be expressed
> in a driver specific way, not in a platform or architecture specific way
> because that makes the driver less portable.

I guess I see your point now. So you want something like pdev.has_bugX to be
set by mach setup and later check this flag in the driver?

> > > > diff --git a/drivers/i2c/busses/i2c-at91.h b/drivers/i2c/busses/i2c-
> at91.h
> > > > new file mode 100644
> > > > index 0000000..a898159
> > > > --- /dev/null
> > > > +++ b/drivers/i2c/busses/i2c-at91.h
> > > > @@ -0,0 +1,80 @@
> > > > +
> > > > +#ifndef AT91_TWI_H
> > > > +#define AT91_TWI_H
> > > > +
> > >
> > > No need for a header file if all the values in it are used in only one
> > > source file. Just move everything to i2c_at91.c
> > >
> > > > +#define    AT91_TWI_MMR            0x04            /* Master Mode
> Register */
> > > > +#define    AT91_TWI_IADRSZ         (3    <<  8)    /* Internal Device
> Address
> > > > +                                            *  Size */
> > > > +#define    AT91_TWI_IADRSZ_NO      (0 << 8)
> > > > +#define    AT91_TWI_IADRSZ_1       (1 << 8)
> > > > +#define    AT91_TWI_IADRSZ_2       (2 << 8)
> > > > +#define    AT91_TWI_IADRSZ_3       (3 << 8)
> > > > +#define    AT91_TWI_MREAD          (1    << 12)    /* Master Read
> Direction
> > > */
> > > > +#define    AT91_TWI_DADR           (0x7f << 16)    /* Device Address */
> > >
> > > These are harder to read than just using hexadecimal bitmasks:
> > >
> > > #define       AT91_TWI_MMR            0x00000004
> > > #define       AT91_TWI_IADRSZ         0x00000300
> > > #define       AT91_TWI_IADRSZ_NO      0x00000000
> > > #define       AT91_TWI_IADRSZ_1       0x00000100
> > > ...
> >
> > I agree, but this header file was already used by the old driver and
> > converting would add possible errors to register definitions which are
> > not (yet) used. That's why I've left it as is and just made it a local
> > include.
> 
> But you are presenting the driver as a new one, so you should be
> prepared to get review comments like any other new code.
> 
> Please at least move the data into the main driver file to get rid of
> the header file.

I didn't want to appear ignorant about this, I actually appreciate your
comment. I just wanted to point out that there might be a reason to keep
the old file which you weren't aware of (because I presented this as a new
driver). So, I will move the register definitions to the main driver.

Thanks,
Niko

