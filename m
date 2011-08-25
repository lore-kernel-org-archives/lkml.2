Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1HYO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:28:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:43086 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1HYO2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:28:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,281,1312182000"; 
   d="scan'208";a="10998278"
Subject: Re: [PATCH] dmatest: make dmatest threads freezable
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1108181648370.5245@axis700.grange>
References: <Pine.LNX.4.64.1108181648370.5245@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 19:57:30 +0530
Message-ID: <1314282450.1606.43.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 16:50 +0200, Guennadi Liakhovetski wrote:
> Making dmatest threads freezable allows its use for system PM testing.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Looks good to me, Dan if you give me your ack, I will carry this in my
tree

-- 
~Vinod
> ---
>  drivers/dma/dmatest.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 765f5ff..fc0ea6c 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -10,6 +10,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
> +#include <linux/freezer.h>
>  #include <linux/init.h>
>  #include <linux/kthread.h>
>  #include <linux/module.h>
> @@ -251,6 +252,7 @@ static int dmatest_func(void *data)
>  	int			i;
>  
>  	thread_name = current->comm;
> +	set_freezable_with_signal();
>  
>  	ret = -ENOMEM;
>  
> @@ -305,7 +307,8 @@ static int dmatest_func(void *data)
>  		dma_addr_t dma_srcs[src_cnt];
>  		dma_addr_t dma_dsts[dst_cnt];
>  		struct completion cmp;
> -		unsigned long tmo = msecs_to_jiffies(timeout);
> +		unsigned long start, tmo, end = 0 /* compiler... */;
> +		bool reload = true;
>  		u8 align = 0;
>  
>  		total_tests++;
> @@ -404,7 +407,17 @@ static int dmatest_func(void *data)
>  		}
>  		dma_async_issue_pending(chan);
>  
> -		tmo = wait_for_completion_timeout(&cmp, tmo);
> +		do {
> +			start = jiffies;
> +			if (reload)
> +				end = start + msecs_to_jiffies(timeout);
> +			else if (end <= start)
> +				end = start + 1;
> +			tmo = wait_for_completion_interruptible_timeout(&cmp,
> +								end - start);
> +			reload = try_to_freeze();
> +		} while (tmo == -ERESTARTSYS);
> +
>  		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
>  
>  		if (tmo == 0) {


