Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1GGNmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:42:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:44034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab1GGNmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,493,1304319600"; 
   d="scan'208";a="24922472"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Jul 2011 19:11:56 +0530
Subject: RE: [PATCH/RFC] dma: shdma: transfer based runtime PM
Thread-Topic: [PATCH/RFC] dma: shdma: transfer based runtime PM
Thread-Index: Acw8qT6pfgECNZO9SXCeazSPCQGTEwAAgHMg
Message-ID: <438BB0150E931F4B9CE701519A4463010871C08C60@bgsmsx502.gar.corp.intel.com>
References: <Pine.LNX.4.64.1106010909570.22716@axis700.grange>
 <1306915370.10976.11.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1107071518140.4348@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107071518140.4348@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, 2011-06-01 at 12:50 +0530, Guennadi Liakhovetski wrote:
> > > Currently the shdma dmaengine driver uses runtime PM to save power, when
> > > no channel on the specific controller is requested by a user. This patch
> > > switches the driver to count individual DMA transfers. That way the
> > > controller can be powered down between transfers, even if some of its
> > > channels are in use.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >
> > > I marked this an RFC, because it might make sense to first test it with
> > > Rafael's upcoming power-domain code for sh-mobile, before committing.
> > >
> > >  drivers/dma/shdma.c |   28 ++++++++++++++++------------
> > >  1 files changed, 16 insertions(+), 12 deletions(-)
> > You should be sending this to LKML as well...
> 
> added
> 
> > > diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> > > index 6eb8454..94d78f2 100644
> > > --- a/drivers/dma/shdma.c
> > > +++ b/drivers/dma/shdma.c
> > > @@ -235,10 +235,22 @@ static dma_cookie_t sh_dmae_tx_submit(struct
> dma_async_tx_descriptor *tx)
> > >  	struct sh_desc *desc = tx_to_sh_desc(tx), *chunk, *last = desc, *c;
> > >  	struct sh_dmae_chan *sh_chan = to_sh_chan(tx->chan);
> > >  	dma_async_tx_callback callback = tx->callback;
> > > +	struct sh_dmae_slave *param = tx->chan->private;
> > >  	dma_cookie_t cookie;
> > >
> > > +	pm_runtime_get_sync(sh_chan->dev);
> > This should be done in issue_pending where the descriptor is supposed to
> > be submitted. See Documentation/dmaengine.txt
> 
> So, you're saying, that drivers' .device_issue_pending() method is allowed
> to sleep? But in dma_issue_pending_all() it is called under a
> rcu_read_(un)lock(), so, sleeping there doesn't seem like a good idea to
> me?
Yes agreed, if you are issuing from the non sleeping context, it makes sense 
to have it here. I was only concerned that typically h/w should be woken up 
when we want it to start, which is issue_pending.
 
> 
> Thanks
> Guennadi
> 
> > > +
> > >  	spin_lock_bh(&sh_chan->desc_lock);
> > >
> > > +	if (param) {
> > > +		const struct sh_dmae_slave_config *cfg = param->config;
> > > +
> > > +		dmae_set_dmars(sh_chan, cfg->mid_rid);
> > > +		dmae_set_chcr(sh_chan, cfg->chcr);
> > > +	} else {
> > > +		dmae_init(sh_chan);
> > > +	}
> > > +
> > >  	cookie = sh_chan->common.cookie;
> > >  	cookie++;
> > >  	if (cookie < 0)
> > > @@ -319,8 +331,6 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan
> *chan)
> > >  	struct sh_dmae_slave *param = chan->private;
> > >  	int ret;
> > >
> > > -	pm_runtime_get_sync(sh_chan->dev);
> > > -
> > >  	/*
> > >  	 * This relies on the guarantee from dmaengine that alloc_chan_resources
> > >  	 * never runs concurrently with itself or free_chan_resources.
> > > @@ -340,11 +350,6 @@ static int sh_dmae_alloc_chan_resources(struct
> dma_chan *chan)
> > >  		}
> > >
> > >  		param->config = cfg;
> > > -
> > > -		dmae_set_dmars(sh_chan, cfg->mid_rid);
> > > -		dmae_set_chcr(sh_chan, cfg->chcr);
> > > -	} else {
> > > -		dmae_init(sh_chan);
> > >  	}
> > >
> > >  	spin_lock_bh(&sh_chan->desc_lock);
> > > @@ -378,7 +383,6 @@ edescalloc:
> > >  		clear_bit(param->slave_id, sh_dmae_slave_used);
> > >  etestused:
> > >  efindslave:
> > > -	pm_runtime_put(sh_chan->dev);
> > >  	return ret;
> > >  }
> > >
> > > @@ -390,7 +394,6 @@ static void sh_dmae_free_chan_resources(struct dma_chan
> *chan)
> > >  	struct sh_dmae_chan *sh_chan = to_sh_chan(chan);
> > >  	struct sh_desc *desc, *_desc;
> > >  	LIST_HEAD(list);
> > > -	int descs = sh_chan->descs_allocated;
> > >
> > >  	/* Protect against ISR */
> > >  	spin_lock_irq(&sh_chan->desc_lock);
> > > @@ -417,9 +420,6 @@ static void sh_dmae_free_chan_resources(struct dma_chan
> *chan)
> > >
> > >  	spin_unlock_bh(&sh_chan->desc_lock);
> > >
> > > -	if (descs > 0)
> > > -		pm_runtime_put(sh_chan->dev);
> > > -
> > >  	list_for_each_entry_safe(desc, _desc, &list, node)
> > >  		kfree(desc);
> > >  }
> > > @@ -735,6 +735,9 @@ static dma_async_tx_callback __ld_cleanup(struct
> sh_dmae_chan *sh_chan, bool all
> > >  		     async_tx_test_ack(&desc->async_tx)) || all) {
> > >  			/* Remove from ld_queue list */
> > >  			desc->mark = DESC_IDLE;
> > > +
> > > +			if (tx->cookie > 0)
> > > +				pm_runtime_put(sh_chan->dev);
> > >  			list_move(&desc->node, &sh_chan->ld_free);
> > >  		}
> > >  	}
> > > @@ -894,6 +897,7 @@ static bool sh_dmae_reset(struct sh_dmae_device *shdev)
> > >  			desc->mark = DESC_IDLE;
> > >  			if (tx->callback)
> > >  				tx->callback(tx->callback_param);
> > > +			pm_runtime_put(sh_chan->dev);
> > >  		}
> > >
> > >  		spin_lock(&sh_chan->desc_lock);
> >
> >
> > --
> > ~Vinod
> >
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
