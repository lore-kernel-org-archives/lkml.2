Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1EBIfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:35:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:40576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1EBIfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:35:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,301,1301900400"; 
   d="scan'208";a="741028091"
Subject: Re: [PATCH 2/2] dmaengine: shdma: add runtime- and system-level
 power management
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
In-Reply-To: <Pine.LNX.4.64.1104291908090.17813@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
	 <Pine.LNX.4.64.1104291908090.17813@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 13:33:11 +0530
Message-ID: <1304323391.1589.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 19:09 +0200, Guennadi Liakhovetski wrote:
> This patch extends and fixes runtime power management in the shdma
> driver to support powering down the DMA controller and adds support
> for system-level suspend and resume.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/dma/shdma.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/shdma.h |    1 +
>  2 files changed, 69 insertions(+), 0 deletions(-)
> 

>  
> +static int sh_dmae_runtime_suspend(struct device *dev)
> +{
> +	return 0;
> +}
Don't you need to initialize you device on resume...????


> +
> +static int sh_dmae_runtime_resume(struct device *dev)
> +{
> +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> +
> +	return sh_dmae_rst(shdev);
> +}
> +
> +#ifdef CONFIG_PM
This should be removed...
> +static int sh_dmae_suspend(struct device *dev)
> +{
> +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> +	int i;
> +
> +	for (i = 0; i < shdev->pdata->channel_num; i++) {
> +		struct sh_dmae_chan *sh_chan = shdev->chan[i];
> +		if (sh_chan->descs_allocated)
> +			sh_chan->pm_error = pm_runtime_put_sync(dev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int sh_dmae_resume(struct device *dev)
> +{
> +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> +	int i;
> +
> +	for (i = 0; i < shdev->pdata->channel_num; i++) {
> +		struct sh_dmae_chan *sh_chan = shdev->chan[i];
> +		struct sh_dmae_slave *param = sh_chan->common.private;
> +
> +		if (!sh_chan->descs_allocated)
> +			continue;
> +
> +		if (!sh_chan->pm_error)
> +			pm_runtime_get_sync(dev);
> +
> +		if (param) {
> +			const struct sh_dmae_slave_config *cfg = param->config;
> +			dmae_set_dmars(sh_chan, cfg->mid_rid);
> +			dmae_set_chcr(sh_chan, cfg->chcr);
> +		} else {
> +			dmae_init(sh_chan);
> +		}
> +	}
> +
> +	return 0;
> +}
> +#else
> +#define sh_dmae_suspend NULL
> +#define sh_dmae_resume NULL
> +#endif
> +
> +const struct dev_pm_ops sh_dmae_pm = {
> +	.suspend		= sh_dmae_suspend,
> +	.resume			= sh_dmae_resume,
> +	.runtime_suspend	= sh_dmae_runtime_suspend,
> +	.runtime_resume		= sh_dmae_runtime_resume,
> +};
> +
>  static struct platform_driver sh_dmae_driver = {
>  	.remove		= __exit_p(sh_dmae_remove),
>  	.shutdown	= sh_dmae_shutdown,
>  	.driver = {
>  		.owner	= THIS_MODULE,
>  		.name	= "sh-dma-engine",
> +		.pm	= &sh_dmae_pm,
>  	},
>  };
>  
> diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
> index 52e4fb1..3f9d3cd 100644
> --- a/drivers/dma/shdma.h
> +++ b/drivers/dma/shdma.h
> @@ -37,6 +37,7 @@ struct sh_dmae_chan {
>  	int id;				/* Raw id of this channel */
>  	u32 __iomem *base;
>  	char dev_id[16];		/* unique name per DMAC of channel */
> +	int pm_error;
>  };
>  
>  struct sh_dmae_device {

And please remember to CC maintainers...


-- 
~Vinod

