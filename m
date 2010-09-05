Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0IEUoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 16:44:05 -0400
Received: from void.printf.net ([89.145.121.20]:47079 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0IEUoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 16:44:04 -0400
Date: Sun, 5 Sep 2010 21:43:36 +0100
From: Chris Ball <cjb@laptop.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hein_Tibosch <hein_tibosch@yahoo.es>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pierre Ossman <pierre@ossman.eu>, Chris Ball <cjb@laptop.org>,
        Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mmc: Make ID freq configurable
Message-ID: <20100905204336.GA23574@void.printf.net>
References: <4C80187D.9000304@yahoo.es> <20100905201448.GA22819@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905201448.GA22819@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Sun, Sep 05, 2010 at 09:14:48PM +0100, Matt Fleming wrote:
> On Fri, Sep 03, 2010 at 05:34:53AM +0800, Hein_Tibosch wrote:
> > In the latest releases of the mmc driver, the freq during initialization
> > is set to a fixed 400 Khz. This was reportedly too fast for several
> > users. As there doesn't seem to be an ideal frequency which-works-for-all,
> > Pierre suggested to let the driver try several frequencies.
> > 
> > This patch implements that idea. It will try mmc-initialization using
> > several frequencies from an array 400, 300, 200 and 100.
> > I submitted it earlier but it's now adapted to and tested with kernel
> > 2.6.36-rc3.
> > 
> > In case SDIO is broken, it'll still try to detect SDMEM, also at different
> > freqs.
> > 
> > Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> > 
> > ---
> > diff -Nurp a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > --- a/drivers/mmc/core/core.c	2010-08-29 23:36:04.000000000 +0800
> > +++ b/drivers/mmc/core/core.c	2010-09-03 04:28:52.000000000 +0800
> > @@ -907,12 +907,7 @@ static void mmc_power_up(struct mmc_host
> >  	 */
> >  	mmc_delay(10);
> > 
> > -	if (host->f_min > 400000) {
> > -		pr_warning("%s: Minimum clock frequency too high for "
> > -				"identification mode\n", mmc_hostname(host));
> > -		host->ios.clock = host->f_min;
> > -	} else
> > -		host->ios.clock = 400000;
> > +	host->ios.clock = host->f_init;
> > 
> >  	host->ios.power_mode = MMC_POWER_ON;
> >  	mmc_set_ios(host);
> > @@ -1404,6 +1399,8 @@ void mmc_rescan(struct work_struct *work
> >  	u32 ocr;
> >  	int err;
> >  	unsigned long flags;
> > +	int i;
> > +	unsigned freqs[] = { 400000, 300000, 200000, 100000 };
> > 
> >  	spin_lock_irqsave(&host->lock, flags);
> > 
> > @@ -1443,55 +1440,64 @@ void mmc_rescan(struct work_struct *work
> >  	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
> >  		goto out;
> > 
> > -	mmc_claim_host(host);
> > +	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
> > +		mmc_claim_host(host);
> > 
> > -	mmc_power_up(host);
> > -	sdio_reset(host);
> > -	mmc_go_idle(host);
> > +		if (freqs[i] >= host->f_min)
> > +			host->f_init = freqs[i];
> > +		else if (i && freqs[i-1] <= host->f_min)
> > +			goto out;
> 
> The label 'out' does not release the claim on the host.

Thanks for catching that.

> > +		else
> > +			host->f_init = host->f_min;
> > 
> > -	mmc_send_if_cond(host, host->ocr_avail);
> > +		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
> > +		mmc_power_up(host);
> > +		sdio_reset(host);
> > +		mmc_go_idle(host);
> > 
> > -	/*
> > -	 * First we search for SDIO...
> > -	 */
> > -	err = mmc_send_io_op_cond(host, 0, &ocr);
> > -	if (!err) {
> > -		if (mmc_attach_sdio(host, ocr)) {
> > -			mmc_claim_host(host);
> > -			/* try SDMEM (but not MMC) even if SDIO is broken */
> > -			if (mmc_send_app_op_cond(host, 0, &ocr))
> > -				goto out_fail;
> > +		mmc_send_if_cond(host, host->ocr_avail);
> > +
> > +		/*
> > +		 * First we search for SDIO...
> > +		 */
> > +		err = mmc_send_io_op_cond(host, 0, &ocr);
> > +		if (!err) {
> > +			if (mmc_attach_sdio(host, ocr)) {
> > +				mmc_claim_host(host);
> > +				/* try SDMEM (but not MMC) even if SDIO is broken */
> > +				if (mmc_send_app_op_cond(host, 0, &ocr))
> > +					goto out_fail;
> > +
> > +				if (mmc_attach_sd(host, ocr))
> > +					mmc_power_off(host);
> > +			}
> > +			goto out;
> > +		}
> > 
> > +		/*
> > +		 * ...then normal SD...
> > +		 */
> > +		err = mmc_send_app_op_cond(host, 0, &ocr);
> > +		if (!err) {
> >  			if (mmc_attach_sd(host, ocr))
> >  				mmc_power_off(host);
> > +			goto out;
> 
> Same problem here.
> 
> >  		}
> > -		goto out;
> > -	}
> > 
> > -	/*
> > -	 * ...then normal SD...
> > -	 */
> > -	err = mmc_send_app_op_cond(host, 0, &ocr);
> > -	if (!err) {
> > -		if (mmc_attach_sd(host, ocr))
> > -			mmc_power_off(host);
> > -		goto out;
> > -	}
> > -
> > -	/*
> > -	 * ...and finally MMC.
> > -	 */
> > -	err = mmc_send_op_cond(host, 0, &ocr);
> > -	if (!err) {
> > -		if (mmc_attach_mmc(host, ocr))
> > -			mmc_power_off(host);
> > -		goto out;
> > -	}
> > +		/*
> > +		 * ...and finally MMC.
> > +		 */
> > +		err = mmc_send_op_cond(host, 0, &ocr);
> > +		if (!err) {
> > +			if (mmc_attach_mmc(host, ocr))
> > +				mmc_power_off(host);
> > +			goto out;
> > +		}
> 
> And here.

Actually, mmc_attach_{sd,mmc}() both do release the host as part of
their failure case, so I don't think there's a problem with these two.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
