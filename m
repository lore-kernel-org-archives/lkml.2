Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2JaFvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:51:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33273 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2JaFvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:51:36 -0400
Date: Tue, 30 Oct 2012 22:51:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ti_tscadc: Match mfd sub devices to regmap interface
Message-ID: <20121031055131.GB31983@core.coreip.homeip.net>
References: <1351698945-3881-1-git-send-email-panto@antoniou-consulting.com>
 <CA+Bv8XbCweGxKg-VsM2=g5KJEbLZhUA8F=iAG2st7c0JRLH58g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Bv8XbCweGxKg-VsM2=g5KJEbLZhUA8F=iAG2st7c0JRLH58g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 09:41:00PM -0700, Russ Dill wrote:
> On Wed, Oct 31, 2012 at 8:55 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
> > The MFD parent device now uses a regmap, instead of direct
> > memory access. Use the same method in the sub devices to avoid
> > nasty surprises.
> >
> > Also rework the channel initialization of tiadc a bit.
> >
> > Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> > ---
> >  drivers/iio/adc/ti_am335x_adc.c           | 27 +++++++++++++++++++--------
> >  drivers/input/touchscreen/ti_am335x_tsc.c | 16 +++++++++++++---
> >  drivers/mfd/ti_am335x_tscadc.c            |  7 +++++--
> >  3 files changed, 37 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> > index d48fd79..5f325c1 100644
> > --- a/drivers/iio/adc/ti_am335x_adc.c
> > +++ b/drivers/iio/adc/ti_am335x_adc.c
> > @@ -23,7 +23,9 @@
> >  #include <linux/iio/iio.h>
> >  #include <linux/iio/machine.h>
> >  #include <linux/iio/driver.h>
> > +#include <linux/regmap.h>
> >
> > +#include <linux/io.h>
> >  #include <linux/mfd/ti_am335x_tscadc.h>
> >  #include <linux/platform_data/ti_am335x_adc.h>
> >
> > @@ -36,13 +38,17 @@ struct tiadc_device {
> >
> >  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> >  {
> > -       return readl(adc->mfd_tscadc->tscadc_base + reg);
> > +       unsigned int val;
> > +
> > +       val = (unsigned int)-1;
> > +       regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val);
> > +       return val;
> >  }
> 
> Would it be cleaner to instead do:
> 
> static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> {
>        unsigned int val;
> 
>        return regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val) ? : val;
> }
> 
> or
>        int ret;
> 
>        ret = regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val);
>        return ret < 0 ret ? : val;

Also the function should not be returning unsigned int if it returns
errors.

Thanks.

-- 
Dmitry
