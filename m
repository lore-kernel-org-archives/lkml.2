Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1BXMeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:34:22 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:37077 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1BXMeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:34:20 -0500
Date: Thu, 24 Feb 2011 13:34:14 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase
 time
Message-ID: <20110224123352.GA26516@marc.osknowledge.org>
References: <20110224111801.GA7169@intel.com>
 <20110224113756.GB7260@marc.osknowledge.org>
 <5D8008F58939784290FAB48F5497519835CE59FE52@shsmsx502.ccr.corp.intel.com>
 <20110224122235.GC7260@marc.osknowledge.org>
 <5D8008F58939784290FAB48F5497519835CE59FE57@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D8008F58939784290FAB48F5497519835CE59FE57@shsmsx502.ccr.corp.intel.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck2-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dong, Chuanxiao <chuanxiao.dong@intel.com> [2011-02-24 20:25:21 +0800]:

> > -----Original Message-----
> > From: Marc Koschewski [mailto:marc@osknowledge.org]
> > Sent: Thursday, February 24, 2011 8:23 PM
> > To: Dong, Chuanxiao
> > Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; adrian.hunter@nokia.com;
> > linus.walleij@linaro.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase time
> > 
> > * Dong, Chuanxiao <chuanxiao.dong@intel.com> [2011-02-24 20:09:59 +0800]:
> > 
> > >
> > >
> > > > -----Original Message-----
> > > > From: Marc Koschewski [mailto:marc@osknowledge.org]
> > > > Sent: Thursday, February 24, 2011 7:38 PM
> > > > To: Dong, Chuanxiao
> > > > Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; adrian.hunter@nokia.com;
> > > > linus.walleij@linaro.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH 1/1]mmc: fix division by zero when calculate mmc erase
> > time
> > > >
> > > > Hi,
> > > >
> > > > * Chuanxiao Dong <chuanxiao.dong@intel.com> [2011-02-24 19:18:01 +0800]:
> > > >
> > > > > Since if clock gating feature is enabled, the clock frequency may be zero when
> > > > > host clock is gated. In such scenario, mmc_set_mmc_erase_timeout() may
> > have a
> > > > > division by zero bug.
> > > > >
> > > > > So this patch used mmc_host_clk_rate() to fix this.
> > > > >
> > > > > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> > > > > ---
> > > > >  drivers/mmc/core/core.c |   10 ++++++++--
> > > > >  1 files changed, 8 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > > > > index 34a7e8c..12d0eb8 100644
> > > > > --- a/drivers/mmc/core/core.c
> > > > > +++ b/drivers/mmc/core/core.c
> > > > > @@ -1201,8 +1201,14 @@ static void mmc_set_mmc_erase_timeout(struct
> > > > mmc_card *card,
> > > > >  		 * less but not that much less, so fudge it by multiplying by 2.
> > > > >  		 */
> > > > >  		timeout_clks <<= 1;
> > > > > -		timeout_us += (timeout_clks * 1000) /
> > > > > -			      (card->host->ios.clock / 1000);
> > > > > +
> > > > > +		/*
> > > > > +		 * at this moment, host controller maybe clock gated, so make
> > > > > +		 * sure we can get a correct host clock freq.
> > > > > +		 */
> > > > > +		if (mmc_host_clk_rate(card->host))
> > > > > +			timeout_us += (timeout_clks * 1000) /
> > > > > +				      (mmc_host_clk_rate(card->host) / 1000);
> > > >
> > > > Why don't you just reuse mmc_host_clk_rate()'s result instead of calling it
> > twice?
> > > This is a incline function and just return host->ios.clock. Reuse
> > mmc_host_clk_rate()'s result need to add a new variable to save the value.
> > 
> > It's not inline on trunk and it spinlocks.
> > 
> > drivers/mmc/core/host.c:195
> > 
> >     194  */
> >     195 unsigned int mmc_host_clk_rate(struct mmc_host *host)
> >     196 {
> OK. With the clock gating framework enabled... I agree. So, what do you think? Add a new variable is better?

I personally would prefer the variable over the spinlock and function call, yes.

And calling the same method with the same parameters on a line and another
time on the next line is generally a bad idea I think. But maybe that's kind
of a 'taste', moreover. It just hit my eye when I saw it...

Cheers,
Marc

> 
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
