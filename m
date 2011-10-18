Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1JRNGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:06:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53157 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab1JRNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:06:45 -0400
Date: Tue, 18 Oct 2011 15:06:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
 so it can be freed
In-Reply-To: <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
Message-ID: <Pine.LNX.4.64.1110181506202.17200@ask.diku.dk>
References: <1318909555-12933-1-git-send-email-julia@diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Dong Aisheng-B29396 wrote:

> > -----Original Message-----
> > From: Julia Lawall [mailto:julia@diku.dk]
> > Sent: Tuesday, October 18, 2011 11:46 AM
> > To: Liam Girdwood
> > Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi
> > Iwai; Dong Aisheng-B29396; Wolfram Sang; alsa-devel@alsa-project.org;
> > linux-kernel@vger.kernel.org
> > Subject: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
> > so it can be freed
> > 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Add a new variable for storing resources accessed subsequent to the one
> > accessed using request_mem_region, so the one accessed using
> > request_mem_region can be released if needed.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @r@
> > expression E, E1;
> > identifier f;
> > statement S1,S2,S3;
> > @@
> > 
> > if (E == NULL)
> > {
> >   ... when != if (E == NULL || ...) S1 else S2
> >       when != E = E1
> > *E->f
> >   ... when any
> >   return ...;
> > }
> > else S3
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  sound/soc/mxs/mxs-saif.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c index
> > 401944c..e12ff78 100644
> > --- a/sound/soc/mxs/mxs-saif.c
> > +++ b/sound/soc/mxs/mxs-saif.c
> > @@ -617,7 +617,7 @@ static irqreturn_t mxs_saif_irq(int irq, void *dev_id)
> > 
> >  static int mxs_saif_probe(struct platform_device *pdev)  {
> > -	struct resource *res;
> > +	struct resource *res, *res1;
> How about naming iores and dmares?

Sure. I will change that.

thanks,
julia

> 
> >  	struct mxs_saif *saif;
> >  	struct mxs_saif_platform_data *pdata;
> >  	int ret = 0;
> > @@ -676,14 +676,14 @@ static int mxs_saif_probe(struct platform_device
> > *pdev)
> >  		goto failed_ioremap;
> >  	}
> > 
> > -	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> > -	if (!res) {
> > +	res1 = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> > +	if (!res1) {
> >  		ret = -ENODEV;
> >  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
> >  			ret);
> >  		goto failed_ioremap;
> >  	}
> > -	saif->dma_param.chan_num = res->start;
> > +	saif->dma_param.chan_num = res1->start;
> > 
> >  	saif->irq = platform_get_irq(pdev, 0);
> >  	if (saif->irq < 0) {
> > 
> 
> Regards
> Dong Aisheng
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
