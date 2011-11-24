Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KXPjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:39:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1KXPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:39:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Subject: Re: [PATCH v7 3/5] drivers/i2c/busses/i2c-at91.c: add new driver
Date: Thu, 24 Nov 2011 15:39:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'carsten.behling@garz-fricke.com'" <carsten.behling@garz-fricke.com>
References: <cover.1322062555.git.n.voss@weinmann.de> <201111231618.45951.arnd@arndb.de> <EF2E73589CA71846A15D0B2CDF79505D087B44FEAF@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B44FEAF@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241539.06990.arnd@arndb.de>
X-Provags-ID: V02:K0:V+ccowF8SvmlEIIF20aMp75GLcwJKc7rYVNDZgoJW88
 zAM5hhPySeKjEHk96XEBtgb5SG59a7RwRcpM1x0+Kwve/qfAfr
 eOA+ZhAcJqI/Yev3Z7jrMQ2Tc2NS92rQeUy1M+t/jSIsm3MAvd
 m2wrpHU6Z+22TUPzUoyVOO01o7W/ltZsATtb0EBYpU43xY3EHl
 lUvcaAFaCx1JC+ybvNwCXQz3Nzk4CtXEyE1ohtK3c8v5E5Rt1H
 I1CEBk5vAKzfHKwPA1jA1Svl03sayWfXEqcKlM4nQkLAKAB9Y6
 psT0WFfxmWhyBRB96jR7qZrVYKZgDQKVf+wlEd7wW8X2zO93Yo
 dj6er6Ovq4lXyXl/tPEw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 November 2011, Voss, Nikolaus wrote:
> > 
> > > +/*
> > > + * Calculate and set symmetric clock as stated in datasheet:
> > > + * twi_clk = F_MAIN / (2 * cdiv * (1 << ckdiv) + 4)
> > > + */
> > > +static void __devinit at91_set_twi_clock(struct at91_twi_dev *dev, int
> > twi_clk)
> > > +{
> > > +   const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) - 2;
> > > +   int ckdiv = fls(div >> 8);
> > > +   const int cdiv = div >> ckdiv;
> > > +
> > > +   if (cpu_is_at91rm9200() && (ckdiv > 5)) {
> > > +           dev_warn(dev->dev, "AT91RM9200 erratum 22: using ckdiv = 5.\n");
> > > +           ckdiv = 5;
> > > +   }
> > 
> > Don't check a global property like this locally in the driver. Instead,
> > make it a property of the device that you check here and set it based on
> > the the device name set by the platform, or by a device tree property.
> 
> Yes, this is a known problem and was discussed in
> https://lkml.org/lkml/2011/11/8/217 . The main problem is that there a no
> revisions for specific at91 IP devices but the revision is implicitly
> defined by the cpu type and version. Changing this would need to add some
> arch infrastructure which I think is beyond the scope of this driver.

Aside from the flamewar in that thread, my impression is that in general
people (me certainly) prefer to have driver-local workarounds be expressed
in a driver specific way, not in a platform or architecture specific way
because that makes the driver less portable.

Anyway, I don't see this point as a show-stopper since the driver is already
platform specific, but it's generally a good idea to write code like this
defensively, if only to avoid getting comments about it.

> > > diff --git a/drivers/i2c/busses/i2c-at91.h b/drivers/i2c/busses/i2c-at91.h
> > > new file mode 100644
> > > index 0000000..a898159
> > > --- /dev/null
> > > +++ b/drivers/i2c/busses/i2c-at91.h
> > > @@ -0,0 +1,80 @@
> > > +
> > > +#ifndef AT91_TWI_H
> > > +#define AT91_TWI_H
> > > +
> > 
> > No need for a header file if all the values in it are used in only one
> > source file. Just move everything to i2c_at91.c
> > 
> > > +#define    AT91_TWI_MMR            0x04            /* Master Mode Register */
> > > +#define    AT91_TWI_IADRSZ         (3    <<  8)    /* Internal Device Address
> > > +                                            *  Size */
> > > +#define    AT91_TWI_IADRSZ_NO      (0 << 8)
> > > +#define    AT91_TWI_IADRSZ_1       (1 << 8)
> > > +#define    AT91_TWI_IADRSZ_2       (2 << 8)
> > > +#define    AT91_TWI_IADRSZ_3       (3 << 8)
> > > +#define    AT91_TWI_MREAD          (1    << 12)    /* Master Read Direction
> > */
> > > +#define    AT91_TWI_DADR           (0x7f << 16)    /* Device Address */
> > 
> > These are harder to read than just using hexadecimal bitmasks:
> > 
> > #define       AT91_TWI_MMR            0x00000004
> > #define       AT91_TWI_IADRSZ         0x00000300
> > #define       AT91_TWI_IADRSZ_NO      0x00000000
> > #define       AT91_TWI_IADRSZ_1       0x00000100
> > ...
> 
> I agree, but this header file was already used by the old driver and
> converting would add possible errors to register definitions which are
> not (yet) used. That's why I've left it as is and just made it a local
> include.

But you are presenting the driver as a new one, so you should be
prepared to get review comments like any other new code.

Please at least move the data into the main driver file to get rid of
the header file.

	Arnd
