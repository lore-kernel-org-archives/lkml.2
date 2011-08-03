Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1HCMkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:40:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1HCMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:40:18 -0400
Date: Wed, 3 Aug 2011 13:39:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
Message-ID: <20110803123953.GB23953@n2100.arm.linux.org.uk>
References: <cover.1312190881.git.viresh.kumar@st.com> <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 03:07:18PM +0530, Viresh Kumar wrote:
> Insert notifiers for the runtime PM API. With this the runtime PM layer kicks in
> to action where used. This will also handle enabling/disabling of interface
> clock (Code will be added in amba/bus.c by Russell King).

I don't think this is correct...

> @@ -879,11 +880,19 @@ static void pl08x_free_txd_list(struct pl08x_driver_data *pl08x,
>   */
>  static int pl08x_alloc_chan_resources(struct dma_chan *chan)
>  {
> +	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
> +	struct pl08x_driver_data *pl08x = plchan->host;
> +
> +	pm_runtime_resume(&pl08x->adev->dev);

Shouldn't this be pm_runtime_get_sync() ?

>  	return 0;
>  }
>  
>  static void pl08x_free_chan_resources(struct dma_chan *chan)
>  {
> +	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
> +	struct pl08x_driver_data *pl08x = plchan->host;
> +
> +	pm_runtime_suspend(&pl08x->adev->dev);

And pm_runtime_put() ?

>  }
>  
>  /*
> @@ -1993,6 +2002,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
>  		 amba_part(adev), amba_rev(adev),
>  		 (unsigned long long)adev->res.start, adev->irq[0]);
> +
> +	pm_runtime_suspend(&adev->dev);

And pm_runtime_put() ?

We don't want to call pm_runtime_suspend/resume directly because that
could have bad consequences if more than one channel is in use.

The enabling and disabling of runtime PM for AMBA devices will be handled
in the core code...

Lastly, we may want to make this even tighter to the actual period that
the DMA is being used, rather than just the period that a driver has
been allocated a channel.  I'd rather have it done that way now (and
tested) so that we achieve maximal effect from runtime PM, rather than
having something which needs to be revisited again.

IOW, if this is worth doing, then its worth doing properly first time.
