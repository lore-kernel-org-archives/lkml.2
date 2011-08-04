Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1HDJhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:37:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:5346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1HDJgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:36:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="35306855"
Subject: Re: [PATCH V3 08/20] dmaengine/amba-pl08x: support runtime PM
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linux@arm.linux.org.uk, linus.walleij@linaro.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com
In-Reply-To: <cbf7119fa968fa54077729aabf1ecca5d21db629.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
	 <cbf7119fa968fa54077729aabf1ecca5d21db629.1312190881.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 14:22:53 +0530
Message-ID: <1312447973.1539.24.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 17:26 +0530, Viresh Kumar wrote:
> Insert notifiers for the runtime PM API. With this the runtime PM layer kicks in
> to action where used. This will also handle enabling/disabling of interface
> clock (Code will be added in amba/bus.c by Russell King).
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/amba-pl08x.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 3fbaf0e..a829f0e 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -84,6 +84,7 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <asm/hardware/pl080.h>
> @@ -879,11 +880,19 @@ static void pl08x_free_txd_list(struct pl08x_driver_data *pl08x,
>   */
>  static int pl08x_alloc_chan_resources(struct dma_chan *chan)
>  {
> +	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
> +	struct pl08x_driver_data *pl08x = plchan->host;
> +
> +	pm_runtime_get_sync(&pl08x->adev->dev);
>  	return 0;
>  }
>  
>  static void pl08x_free_chan_resources(struct dma_chan *chan)
>  {
> +	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
> +	struct pl08x_driver_data *pl08x = plchan->host;
> +
> +	pm_runtime_put_sync(&pl08x->adev->dev);
>  }
>  
>  /*
> @@ -1855,6 +1864,9 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  		goto out_no_pl08x;
>  	}
>  
> +	pm_runtime_set_active(&adev->dev);
> +	pm_runtime_enable(&adev->dev);
> +
>  	/* Initialize memcpy engine */
>  	dma_cap_set(DMA_MEMCPY, pl08x->memcpy.cap_mask);
>  	pl08x->memcpy.dev = &adev->dev;
> @@ -1993,6 +2005,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
>  		 amba_part(adev), amba_rev(adev),
>  		 (unsigned long long)adev->res.start, adev->irq[0]);
> +
> +	pm_runtime_put_sync(&adev->dev);
i dont think pm_runtime_put_sync() is the right thing to do here. This
will call your suspend and return after suspend has been called. This
will delay your probe completion and have impact on system boot time,
this is a very wrong approach.
Please move this to _put, so that suspend will be called asynchronously

Also while at it why should you require all the _put calls to be _sync
type?
>  	return 0;
>  
>  out_no_slave_reg:
> @@ -2011,6 +2025,9 @@ out_no_ioremap:
>  	dma_pool_destroy(pl08x->pool);
>  out_no_lli_pool:
>  out_no_platdata:
> +	pm_runtime_put_sync(&adev->dev);
> +	pm_runtime_disable(&adev->dev);
> +
>  	kfree(pl08x);
>  out_no_pl08x:
>  	amba_release_regions(adev);


-- 
~Vinod

