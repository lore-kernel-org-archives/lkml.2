Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2LSPLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:11:08 -0500
Received: from ra.se.axis.com ([195.60.68.13]:33638 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2LSPK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:10:58 -0500
Date: Wed, 19 Dec 2012 16:10:54 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219151054.GB14217@axis.com>
References: <20121219140456.GA14217@axis.com>
 <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:42:26PM +0100, Thierry Reding wrote:
> On Wed, Dec 19, 2012 at 03:04:56PM +0100, Jesper Nilsson wrote:
> > This patch implements reading of the battery voltage low signal for
> > rtc-pcf8523.
> > 
> > The bit is read-only and cannot be cleared by software, so no
> > clear-function is implemented.
> > 
> > Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> > ---
> > diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
> > index be05a64..82a9895 100644
> > --- a/drivers/rtc/rtc-pcf8523.c
> > +++ b/drivers/rtc/rtc-pcf8523.c
> > @@ -23,6 +23,7 @@
> >  #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
> >  #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
> >  #define REG_CONTROL3_PM_MASK 0xe0
> > +#define REG_CONTROL3_BLF (1 << 2) /* Battery low bit, read-only */
> 
> Nit: "battery" since you don't have a full sentence.

Right.

> >  #define REG_SECONDS  0x03
> >  #define REG_SECONDS_OS (1 << 7)
> > @@ -250,9 +252,29 @@ static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
> >  	return pcf8523_start_rtc(client);
> >  }
> >  
> > +static int pcf8523_rtc_read_vl(struct device *dev, int *vl)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	u8 value;
> > +	int err;
> > +
> > +	err = pcf8523_read(client, REG_CONTROL3, &value);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	if (value & REG_CONTROL3_BLF)
> > +		*vl = 1;
> > +	else
> > +		*vl = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +
> 
> That's one blank line too much.

Will fix.

> >  static const struct rtc_class_ops pcf8523_rtc_ops = {
> > -	.read_time = pcf8523_rtc_read_time,
> > -	.set_time = pcf8523_rtc_set_time,
> > +	.read_time	= pcf8523_rtc_read_time,
> > +	.set_time	= pcf8523_rtc_set_time,
> 
> Maybe you shouldn't reindent these, but rather adopt the existing style
> instead.

Ok. :-)

> > +	.read_vl	= pcf8523_rtc_read_vl,
> 
> What tree is this based on? None of the trees I have contains .read_vl
> in rtc_class_ops.

Hm, I've tested this against a local 3.4 kernel since that is what my
device had, I didn't realize that we already had some local changes for
the voltage low stuff.

I'm guessing the right way is to do it as the pcf8563 in the mainline kernel,
I'll respin my patch and resend.

> Thierry

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
