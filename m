Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1HYO1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:27:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:35185 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1HYO1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,281,1312182000"; 
   d="scan'208";a="44451554"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 19:56:26 +0530
Message-ID: <1314282386.1606.42.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 16:55 +0200, Guennadi Liakhovetski wrote:
> Currently the shdma dmaengine driver uses runtime PM to save power, when
> no channel on the specific controller is requested by a user. This patch
> switches the driver to count individual DMA transfers. That way the
> controller can be powered down between transfers, even if some of its
> channels are in use.
No, I don't agree with the approach here, you don't need to count the
transfers, the runtime_pm framework does that very well for you.

What you need to do is to call pm_runtime_get() in your .issue_pending
callback (NOT in tx_submit anyway, this needs to be fixed in driver, see
the Documentation/dmaengine.txt
And once the transfer has completed you need to call pm_rumtime_put()

Runtime PM framework actually counts the device usage count and whenever
your device usage count goes to 0 it will call .runtime_suspend
callback, thus enable you to save power.

-- 
~Vinod
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> tested on mackerel (sh7372) with dmatest, sh_mobile_sdhi and sh_mmcif with 
> runtime PM and STR.
> 
>  drivers/dma/shdma.c |   94 +++++++++++++++++++++++++++++++++++++--------------
>  drivers/dma/shdma.h |    7 ++++
>  2 files changed, 75 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> index e7bb747..81809c2 100644
> --- a/drivers/dma/shdma.c
> +++ b/drivers/dma/shdma.c
> @@ -259,15 +259,23 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
>  	return 0;
>  }
>  
> +static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan);
> +
>  static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
>  {
>  	struct sh_desc *desc = tx_to_sh_desc(tx), *chunk, *last = desc, *c;
>  	struct sh_dmae_chan *sh_chan = to_sh_chan(tx->chan);
> +	struct sh_dmae_slave *param = tx->chan->private;
>  	dma_async_tx_callback callback = tx->callback;
>  	dma_cookie_t cookie;
> -	unsigned long flags;
> +	bool power_up;
>  
> -	spin_lock_irqsave(&sh_chan->desc_lock, flags);
> +	spin_lock_irq(&sh_chan->desc_lock);
> +
> +	if (list_empty(&sh_chan->ld_queue))
> +		power_up = true;
> +	else
> +		power_up = false;
>  
>  	cookie = sh_chan->common.cookie;
>  	cookie++;
> @@ -303,7 +311,38 @@ static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
>  		tx->cookie, &last->async_tx, sh_chan->id,
>  		desc->hw.sar, desc->hw.tcr, desc->hw.dar);
>  
> -	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
> +	if (power_up) {
> +		sh_chan->pm_state = DMAE_PM_BUSY;
> +
> +		pm_runtime_get(sh_chan->dev);
> +
> +		spin_unlock_irq(&sh_chan->desc_lock);
> +
> +		pm_runtime_barrier(sh_chan->dev);
> +
> +		spin_lock_irq(&sh_chan->desc_lock);
> +
> +		/* Have we been reset, while waiting? */
> +		if (sh_chan->pm_state != DMAE_PM_ESTABLISHED) {
> +			dev_dbg(sh_chan->dev, "Bring up channel %d\n",
> +				sh_chan->id);
> +			if (param) {
> +				const struct sh_dmae_slave_config *cfg =
> +					param->config;
> +
> +				dmae_set_dmars(sh_chan, cfg->mid_rid);
> +				dmae_set_chcr(sh_chan, cfg->chcr);
> +			} else {
> +				dmae_init(sh_chan);
> +			}
> +
> +			if (sh_chan->pm_state == DMAE_PM_PENDING)
> +				sh_chan_xfer_ld_queue(sh_chan);
> +			sh_chan->pm_state = DMAE_PM_ESTABLISHED;
> +		}
> +	}
> +
> +	spin_unlock_irq(&sh_chan->desc_lock);
>  
>  	return cookie;
>  }
> @@ -347,8 +386,6 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
>  	struct sh_dmae_slave *param = chan->private;
>  	int ret;
>  
> -	pm_runtime_get_sync(sh_chan->dev);
> -
>  	/*
>  	 * This relies on the guarantee from dmaengine that alloc_chan_resources
>  	 * never runs concurrently with itself or free_chan_resources.
> @@ -368,11 +405,6 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
>  		}
>  
>  		param->config = cfg;
> -
> -		dmae_set_dmars(sh_chan, cfg->mid_rid);
> -		dmae_set_chcr(sh_chan, cfg->chcr);
> -	} else {
> -		dmae_init(sh_chan);
>  	}
>  
>  	while (sh_chan->descs_allocated < NR_DESCS_PER_CHANNEL) {
> @@ -401,7 +433,6 @@ edescalloc:
>  etestused:
>  efindslave:
>  	chan->private = NULL;
> -	pm_runtime_put(sh_chan->dev);
>  	return ret;
>  }
>  
> @@ -413,7 +444,6 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
>  	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
>  	struct sh_desc *desc, *_desc;
>  	LIST_HEAD(list);
> -	int descs = sh_chan->descs_allocated;
>  
>  	/* Protect against ISR */
>  	spin_lock_irq(&sh_chan->desc_lock);
> @@ -440,9 +470,6 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
>  
>  	spin_unlock_irq(&sh_chan->desc_lock);
>  
> -	if (descs > 0)
> -		pm_runtime_put(sh_chan->dev);
> -
>  	list_for_each_entry_safe(desc, _desc, &list, node)
>  		kfree(desc);
>  }
> @@ -676,7 +703,6 @@ static int sh_dmae_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  						  struct sh_desc, node);
>  		desc->partial = (desc->hw.tcr - sh_dmae_readl(sh_chan, TCR)) <<
>  			sh_chan->xmit_shift;
> -
>  	}
>  	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
>  
> @@ -761,7 +787,13 @@ static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all
>  		     async_tx_test_ack(&desc->async_tx)) || all) {
>  			/* Remove from ld_queue list */
>  			desc->mark = DESC_IDLE;
> +
>  			list_move(&desc->node, &sh_chan->ld_free);
> +
> +			if (list_empty(&sh_chan->ld_queue)) {
> +				dev_dbg(sh_chan->dev, "Bring down channel %d\n", sh_chan->id);
> +				pm_runtime_put(sh_chan->dev);
> +			}
>  		}
>  	}
>  
> @@ -791,16 +823,14 @@ static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
>  		;
>  }
>  
> +/* Called under spin_lock_irq(&sh_chan->desc_lock) */
>  static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
>  {
>  	struct sh_desc *desc;
>  
> -	spin_lock_irq(&sh_chan->desc_lock);
>  	/* DMA work check */
> -	if (dmae_is_busy(sh_chan)) {
> -		spin_unlock_irq(&sh_chan->desc_lock);
> +	if (dmae_is_busy(sh_chan))
>  		return;
> -	}
>  
>  	/* Find the first not transferred descriptor */
>  	list_for_each_entry(desc, &sh_chan->ld_queue, node)
> @@ -813,14 +843,18 @@ static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
>  			dmae_start(sh_chan);
>  			break;
>  		}
> -
> -	spin_unlock_irq(&sh_chan->desc_lock);
>  }
>  
>  static void sh_dmae_memcpy_issue_pending(struct dma_chan *chan)
>  {
>  	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
> -	sh_chan_xfer_ld_queue(sh_chan);
> +
> +	spin_lock_irq(&sh_chan->desc_lock);
> +	if (sh_chan->pm_state == DMAE_PM_ESTABLISHED)
> +		sh_chan_xfer_ld_queue(sh_chan);
> +	else
> +		sh_chan->pm_state = DMAE_PM_PENDING;
> +	spin_unlock_irq(&sh_chan->desc_lock);
>  }
>  
>  static enum dma_status sh_dmae_tx_status(struct dma_chan *chan,
> @@ -913,6 +947,12 @@ static bool sh_dmae_reset(struct sh_dmae_device *shdev)
>  
>  		list_splice_init(&sh_chan->ld_queue, &dl);
>  
> +		if (!list_empty(&dl)) {
> +			dev_dbg(sh_chan->dev, "Bring down channel %d\n", sh_chan->id);
> +			pm_runtime_put(sh_chan->dev);
> +		}
> +		sh_chan->pm_state = DMAE_PM_ESTABLISHED;
> +
>  		spin_unlock(&sh_chan->desc_lock);
>  
>  		/* Complete all  */
> @@ -966,10 +1006,10 @@ static void dmae_do_tasklet(unsigned long data)
>  			break;
>  		}
>  	}
> -	spin_unlock_irq(&sh_chan->desc_lock);
> -
>  	/* Next desc */
>  	sh_chan_xfer_ld_queue(sh_chan);
> +	spin_unlock_irq(&sh_chan->desc_lock);
> +
>  	sh_dmae_chan_ld_cleanup(sh_chan, false);
>  }
>  
> @@ -1037,7 +1077,9 @@ static int __devinit sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
>  		return -ENOMEM;
>  	}
>  
> -	/* copy struct dma_device */
> +	new_sh_chan->pm_state = DMAE_PM_ESTABLISHED;
> +
> +	/* reference struct dma_device */
>  	new_sh_chan->common.device = &shdev->common;
>  
>  	new_sh_chan->dev = shdev->common.dev;
> diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
> index dc56576..2b55a27 100644
> --- a/drivers/dma/shdma.h
> +++ b/drivers/dma/shdma.h
> @@ -23,6 +23,12 @@
>  
>  struct device;
>  
> +enum dmae_pm_state {
> +	DMAE_PM_ESTABLISHED,
> +	DMAE_PM_BUSY,
> +	DMAE_PM_PENDING,
> +};
> +
>  struct sh_dmae_chan {
>  	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
>  	spinlock_t desc_lock;		/* Descriptor operation lock */
> @@ -38,6 +44,7 @@ struct sh_dmae_chan {
>  	u32 __iomem *base;
>  	char dev_id[16];		/* unique name per DMAC of channel */
>  	int pm_error;
> +	enum dmae_pm_state pm_state;
>  };
>  
>  struct sh_dmae_device {




