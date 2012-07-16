Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2GPGbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:31:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2GPGbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:31:06 -0400
Date: Mon, 16 Jul 2012 08:31:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7 v2] dma: sh: provide a migration path for slave
 drivers to stop using .private
In-Reply-To: <1342419560.1726.41.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207160823150.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-7-git-send-email-g.liakhovetski@gmx.de>
 <1342419560.1726.41.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:swLe2Pby5YBjcV7WImHfuLic52/tqFyIolgiFHtiWxp
 hgKu0iyvLCjoH1DtUHm6Bd706HFkSE43kjiQnzTUkdUXrJXsxW
 8WT6IVGJDCp1m6eBcQgpz/MXiAJpf5GUJk9fjrumvwu6+YneEx
 f+DNIVWZH5Tc8hWP5gcayUOyd3s+6zQewoRImItrsZZhOzHq1u
 3S+cLhOwElCRiJOBFmv5Rldjx4pwiikWM7bR9YIm22SCMEvuEg
 4bXdfRVIj6PiKZWvknOhAK61ELkbzro/5MCoq9lDp964gNuWw3
 NfmQ5eQYywmfgcqX3zhuu8psx2/nD+HXebRlOmDRSzha2erOqx
 LHSmcOXqLqtaEQVMtuF/gPUiz1GNgDdOIfV2VaG/SkOnl7eFtw
 xeEYmWQeTb3AQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> > This patch extends the sh dmaengine driver to support the preferred channel
> > selection and configuration method, instead of using the "private" field
> > from struct dma_chan. We add a standard filter function to be used by
> > slave drivers instead of implementing their own ones, and add support for
> > the DMA_SLAVE_CONFIG control operation, which must accompany the new
> > channel selection method. We still support the legacy .private channel
> > allocation method to cater for a smooth driver migration.
> There seem to be two things done in this patch, one is to provide a
> filter function for people to use for channel filtering, and second the
> removal of .private. It would be good to split these two.

No, please, see the patch description. This patch only provides a filter 
function. It does _not_ remove the use of .private yet. First all client 
drivers have to be ported over to use the new filter + slave-config 
scheme, only then will the driver be able to drop support for .private.

> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/dma/sh/shdma-base.c |  114 +++++++++++++++++++++++++++++++++---------
> >  drivers/dma/sh/shdma.c      |    5 +-
> >  include/linux/sh_dma.h      |    2 +
> >  include/linux/shdma-base.h  |    2 +-
> >  4 files changed, 95 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
> > index 73db282..0c34c73 100644
> > --- a/drivers/dma/sh/shdma-base.c
> > +++ b/drivers/dma/sh/shdma-base.c
> > @@ -171,6 +171,65 @@ static struct shdma_desc *shdma_get_desc(struct shdma_chan *schan)
> >  	return NULL;
> >  }
> >  
> > +static int shdma_setup_slave(struct shdma_chan *schan, int slave_id)
> > +{
> > +	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
> > +	const struct shdma_ops *ops = sdev->ops;
> > +	int ret;
> > +
> > +	if (slave_id < 0 || slave_id >= slave_num)
> > +		return -EINVAL;
> > +
> > +	if (test_and_set_bit(slave_id, shdma_slave_used))
> > +		return -EBUSY;
> > +
> > +	ret = ops->set_slave(schan, slave_id, false);
> > +	if (ret < 0) {
> > +		clear_bit(slave_id, shdma_slave_used);
> > +		return ret;
> > +	}
> > +
> > +	schan->slave_id = slave_id;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * This is the standard shdma filter function to be used as a replacement to the
> > + * "old" method, using the .private pointer. If for some reason you allocate a
> > + * channel without slave data, use something like ERR_PTR(-EINVAL) as a filter
> > + * parameter. If this filter is used, the slave driver, after calling
> > + * dma_request_channel(), will also have to call dmaengine_slave_config() with
> > + * .slave_id, .direction, and either .src_addr or .dst_addr set.
> > + * NOTE: this filter doesn't support multiple DMAC drivers with the DMA_SLAVE
> > + * capability! If this becomes a requirement, hardware glue drivers, using this
> > + * services would have to provide their own filters, which first would check
> > + * the device driver, similar to how other DMAC drivers, e.g., sa11x0-dma.c, do
> > + * this, and only then, in case of a match, call this common filter.
> > + */
> > +bool shdma_chan_filter(struct dma_chan *chan, void *arg)
> > +{
> > +	struct shdma_chan *schan = to_shdma_chan(chan);
> > +	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
> > +	const struct shdma_ops *ops = sdev->ops;
> > +	int slave_id = (int)arg;
> > +	int ret;
> > +
> > +	if (slave_id < 0)
> > +		/* No slave requested - arbitrary channel */
> > +		return true;
> > +
> > +	if (slave_id >= slave_num)
> > +		return false;
> > +
> > +	ret = ops->set_slave(schan, slave_id, true);
> > +	if (ret < 0)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +EXPORT_SYMBOL(shdma_chan_filter);
> > +
> >  static int shdma_alloc_chan_resources(struct dma_chan *chan)
> >  {
> >  	struct shdma_chan *schan = to_shdma_chan(chan);
> > @@ -185,21 +244,10 @@ static int shdma_alloc_chan_resources(struct dma_chan *chan)
> >  	 * never runs concurrently with itself or free_chan_resources.
> >  	 */
> >  	if (slave) {
> > -		if (slave->slave_id < 0 || slave->slave_id >= slave_num) {
> > -			ret = -EINVAL;
> > -			goto evalid;
> > -		}
> > -
> > -		if (test_and_set_bit(slave->slave_id, shdma_slave_used)) {
> > -			ret = -EBUSY;
> > -			goto etestused;
> > -		}
> > -
> > -		ret = ops->set_slave(schan, slave->slave_id);
> > +		/* Legacy mode: .private is set in filter */
> > +		ret = shdma_setup_slave(schan, slave->slave_id);
> >  		if (ret < 0)
> >  			goto esetslave;
> > -
> > -		schan->slave_id = slave->slave_id;
> >  	} else {
> >  		schan->slave_id = -EINVAL;
> >  	}
> > @@ -228,8 +276,6 @@ edescalloc:
> >  	if (slave)
> >  esetslave:
> >  		clear_bit(slave->slave_id, shdma_slave_used);
> > -etestused:
> > -evalid:
> >  	chan->private = NULL;
> you missed this one

Please, see above.

Thanks
Guennadi

> >  	return ret;
> >  }
> > @@ -587,22 +633,40 @@ static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> >  	struct shdma_chan *schan = to_shdma_chan(chan);
> >  	struct shdma_dev *sdev = to_shdma_dev(chan->device);
> >  	const struct shdma_ops *ops = sdev->ops;
> > +	struct dma_slave_config *config;
> >  	unsigned long flags;
> > -
> > -	/* Only supports DMA_TERMINATE_ALL */
> > -	if (cmd != DMA_TERMINATE_ALL)
> > -		return -ENXIO;
> > +	int ret;
> >  
> >  	if (!chan)
> >  		return -EINVAL;
> >  
> > -	spin_lock_irqsave(&schan->chan_lock, flags);
> > -
> > -	ops->halt_channel(schan);
> > -
> > -	spin_unlock_irqrestore(&schan->chan_lock, flags);
> > +	switch (cmd) {
> > +	case DMA_TERMINATE_ALL:
> > +		spin_lock_irqsave(&schan->chan_lock, flags);
> > +		ops->halt_channel(schan);
> > +		spin_unlock_irqrestore(&schan->chan_lock, flags);
> >  
> > -	shdma_chan_ld_cleanup(schan, true);
> > +		shdma_chan_ld_cleanup(schan, true);
> > +		break;
> > +	case DMA_SLAVE_CONFIG:
> > +		/*
> > +		 * So far only .slave_id is used, but the slave drivers are
> > +		 * encouraged to also set a transfer direction and an address.
> > +		 */
> > +		if (!arg)
> > +			return -EINVAL;
> > +		/*
> > +		 * We could lock this, but you shouldn't be configuring the
> > +		 * channel, while using it...
> > +		 */
> > +		config = (struct dma_slave_config*)arg;
> > +		ret = shdma_setup_slave(schan, config->slave_id);
> > +		if (ret < 0)
> > +			return ret;
> > +		break;
> > +	default:
> > +		return -ENXIO;
> > +	}
> >  
> >  	return 0;
> >  }
> > diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
> > index 9a10d8b..027c9be 100644
> > --- a/drivers/dma/sh/shdma.c
> > +++ b/drivers/dma/sh/shdma.c
> > @@ -320,7 +320,7 @@ static const struct sh_dmae_slave_config *dmae_find_slave(
> >  }
> >  
> >  static int sh_dmae_set_slave(struct shdma_chan *schan,
> > -			     int slave_id)
> > +			     int slave_id, bool try)
> >  {
> >  	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
> >  						    shdma_chan);
> > @@ -328,7 +328,8 @@ static int sh_dmae_set_slave(struct shdma_chan *schan,
> >  	if (!cfg)
> >  		return -ENODEV;
> >  
> > -	sh_chan->config = cfg;
> > +	if (!try)
> > +		sh_chan->config = cfg;
> >  
> >  	return 0;
> >  }
> > diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> > index 4e83f3e..b64d6be 100644
> > --- a/include/linux/sh_dma.h
> > +++ b/include/linux/sh_dma.h
> > @@ -99,4 +99,6 @@ struct sh_dmae_pdata {
> >  #define CHCR_TE	0x00000002
> >  #define CHCR_IE	0x00000004
> >  
> > +bool shdma_chan_filter(struct dma_chan *chan, void *arg);
> > +
> >  #endif
> > diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
> > index 6263ad2..93f9821 100644
> > --- a/include/linux/shdma-base.h
> > +++ b/include/linux/shdma-base.h
> > @@ -93,7 +93,7 @@ struct shdma_ops {
> >  	dma_addr_t (*slave_addr)(struct shdma_chan *);
> >  	int (*desc_setup)(struct shdma_chan *, struct shdma_desc *,
> >  			  dma_addr_t, dma_addr_t, size_t *);
> > -	int (*set_slave)(struct shdma_chan *, int);
> > +	int (*set_slave)(struct shdma_chan *, int, bool);
> >  	void (*setup_xfer)(struct shdma_chan *, int);
> >  	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
> >  	struct shdma_desc *(*embedded_desc)(void *, int);
> 
> 
> -- 
> ~Vinod
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
