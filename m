Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2EJDkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:40:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:26953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab2EJDkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164256674"
Subject: Re: [PATCH V2 2/2] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4FAA4EA3.70001@nvidia.com>
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
	 <1336030889-32269-3-git-send-email-ldewangan@nvidia.com>
	 <1336558444.1540.243.camel@vkoul-udesk3>  <4FAA4EA3.70001@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 09:04:04 +0530
Message-ID: <1336620844.1540.269.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 16:31 +0530, Laxman Dewangan wrote:
> Thanks Vinod for reviewing code.
> I am removing the code from this thread which  is not require. Only 
> keeping code surrounding our discussion.
> 
> On Wednesday 09 May 2012 03:44 PM, Vinod Koul wrote:
> > On Thu, 2012-05-03 at 13:11 +0530, Laxman Dewangan wrote:
> >> + * Initial number of descriptors to allocate for each channel during
> >> + * allocation. More descriptors will be allocated dynamically if
> >> + * client needs it.
> >> + */
> >> +#define DMA_NR_DESCS_PER_CHANNEL     4
> >> +#define DMA_NR_REQ_PER_DESC          8
> > all of these should be namespaced.
> > APB and AHB are fairly generic names.
> Fine, then I will go as APB_DMA_NR_DESC_xxx and APB_DMA_NR_REQ_xxx
NO. Many ppl use APB/AHB, so pls don't use or namespace them properly
> 
> >> +
> >> +enum dma_transfer_mode {
> >> +     DMA_MODE_NONE,
> >> +     DMA_MODE_ONCE,
> >> +     DMA_MODE_CYCLE,
> >> +     DMA_MODE_CYCLE_HALF_NOTIFY,
> >> +};
> > I dont understand why you would need to keep track of these?
> > You get a request for DMA. You have properties of transfer. You prepare
> > you descriptors and then submit.
> > Why would you need to create above modes and remember them?
> I am allowing multiple desc requests in dma through prep_slave and 
> prep_cyclic. So when dma channel does not have any request then it can 
> set its mode as NONE.
Again NO.

This is not how dmaengine API is supposed to work.
Correct behavior would be:
You prepare descriptors, as many as you want.
You submit them. Dmaengine driver takes them and pushes them to pending
list. Submit does not start.
When .issue_pending is called, you start DMA by using first descriptor
in pending list. One completed you start next one untill you exhaust the
complete list.
So use your pending list for this.
> Once the desc is requested the mode is set based on request. 
Again NO
> This mode 
> will not get change until all dma request done and if new request come 
> to dma channel, it checks that it should not conflict with older mode. 
> The engine is configured in these mode and will change only when all 
> transfer completed.
See above you absolutely dont need to track *modes*

> We are allocating memory also and that's why it is there.
> But I can make it because I am callocating memory as GFP_ATOMIC.
> However if the function call dma_async_tx_descriptor_init() can happen 
> in atomic context i.e. calling spin_lock_init() call.
> 
> >> +                     }
> >> +                     dma_cookie_complete(&dma_desc->txd);
> > does this make sense. You are marking an aborted descriptor as complete.
> If I dont call the the complete cookie of that channel will not get 
> updated and on query, it will return as PROGRESS.
> I need to update the dma channel completed cookie.
No the transaction failed as it was aborted. So mark it as DMA_ERROR.

> >> +     /* Call callbacks if was pending before aborting requests */
> >> +     while (!list_empty(&cb_dma_desc_list)) {
> >> +             dma_desc  = list_first_entry(&cb_dma_desc_list,
> >> +                             typeof(*dma_desc), cb_node);
> >> +             list_del(&dma_desc->cb_node);
> >> +             callback = dma_desc->txd.callback;
> >> +             callback_param = dma_desc->txd.callback_param;
> > again, callback would be called from tasklet, so why would it need to be
> > called from here , and why would this be pending.
> What happen if some callbacks are pending as tasklet does not get 
> scheduled and meantime, the dma terminated (specially in multi-core system)?
> Should we ignore all callbacks in this case?
In termination case, client has already terminated and possibly in
process of cleanup.
So makes no sense in those cases to call the callback.
-- 
~Vinod

