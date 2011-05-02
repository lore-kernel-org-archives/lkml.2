Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1EBJEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:04:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1EBJEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:04:43 -0400
Date: Mon, 2 May 2011 11:04:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 2/2] dmaengine: shdma: add runtime- and system-level
 power management
In-Reply-To: <1304323391.1589.9.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1105021056231.13244@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange> 
 <Pine.LNX.4.64.1104291908090.17813@axis700.grange> <1304323391.1589.9.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:W0g7AQyum49Dp3ymVgFN9zI5qZID7NrHHwg5kPLWf2W
 j4vcQJS3maBPubueDV7oMwDzMgTX05SwvN4PELGQ9Q+U9/tN5R
 zPEHpa4XIHmryduJASlofVuAZLnPA4n571v0g80OU1cfXsPGRA
 zrlgF18C+7Yr25Tt2A8Ynwk93PbVkrgeM9KztS9O/tXYW4p5tA
 nESx1GeDDSOXRhuuYTnvmGWqwKAbd9UhbYNG3lxZIU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Koul, Vinod wrote:

> On Fri, 2011-04-29 at 19:09 +0200, Guennadi Liakhovetski wrote:
> > This patch extends and fixes runtime power management in the shdma
> > driver to support powering down the DMA controller and adds support
> > for system-level suspend and resume.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/dma/shdma.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/dma/shdma.h |    1 +
> >  2 files changed, 69 insertions(+), 0 deletions(-)
> > 
> 
> >  
> > +static int sh_dmae_runtime_suspend(struct device *dev)
> > +{
> > +	return 0;
> > +}
> Don't you need to initialize you device on resume...????

Hm, yes, but this is suspend... Resume is below. Sorry, I probably don't 
understand your question.

> > +
> > +static int sh_dmae_runtime_resume(struct device *dev)
> > +{
> > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > +
> > +	return sh_dmae_rst(shdev);
> > +}
> > +
> > +#ifdef CONFIG_PM
> This should be removed...

You mean, these functions just won't be called, but this way we save a 
couple of bytes if PM is not set, don't we?

> > +static int sh_dmae_suspend(struct device *dev)
> > +{
> > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > +	int i;
> > +
> > +	for (i = 0; i < shdev->pdata->channel_num; i++) {
> > +		struct sh_dmae_chan *sh_chan = shdev->chan[i];
> > +		if (sh_chan->descs_allocated)
> > +			sh_chan->pm_error = pm_runtime_put_sync(dev);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sh_dmae_resume(struct device *dev)
> > +{
> > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > +	int i;
> > +
> > +	for (i = 0; i < shdev->pdata->channel_num; i++) {
> > +		struct sh_dmae_chan *sh_chan = shdev->chan[i];
> > +		struct sh_dmae_slave *param = sh_chan->common.private;
> > +
> > +		if (!sh_chan->descs_allocated)
> > +			continue;
> > +
> > +		if (!sh_chan->pm_error)
> > +			pm_runtime_get_sync(dev);
> > +
> > +		if (param) {
> > +			const struct sh_dmae_slave_config *cfg = param->config;
> > +			dmae_set_dmars(sh_chan, cfg->mid_rid);
> > +			dmae_set_chcr(sh_chan, cfg->chcr);
> > +		} else {
> > +			dmae_init(sh_chan);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +#else
> > +#define sh_dmae_suspend NULL
> > +#define sh_dmae_resume NULL
> > +#endif
> > +
> > +const struct dev_pm_ops sh_dmae_pm = {
> > +	.suspend		= sh_dmae_suspend,
> > +	.resume			= sh_dmae_resume,
> > +	.runtime_suspend	= sh_dmae_runtime_suspend,
> > +	.runtime_resume		= sh_dmae_runtime_resume,
> > +};
> > +
> >  static struct platform_driver sh_dmae_driver = {
> >  	.remove		= __exit_p(sh_dmae_remove),
> >  	.shutdown	= sh_dmae_shutdown,
> >  	.driver = {
> >  		.owner	= THIS_MODULE,
> >  		.name	= "sh-dma-engine",
> > +		.pm	= &sh_dmae_pm,
> >  	},
> >  };
> >  
> > diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
> > index 52e4fb1..3f9d3cd 100644
> > --- a/drivers/dma/shdma.h
> > +++ b/drivers/dma/shdma.h
> > @@ -37,6 +37,7 @@ struct sh_dmae_chan {
> >  	int id;				/* Raw id of this channel */
> >  	u32 __iomem *base;
> >  	char dev_id[16];		/* unique name per DMAC of channel */
> > +	int pm_error;
> >  };
> >  
> >  struct sh_dmae_device {
> 
> And please remember to CC maintainers...

Sorry, will try to remember.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
