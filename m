Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2DHVks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 17:40:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53919 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755229Ab2DHVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 17:40:47 -0400
Message-ID: <1333921246.2508.8.camel@joe2Laptop>
Subject: Re: [PATCH] dma: pl330: fix a couple of compilation warnings
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 08 Apr 2012 14:40:46 -0700
In-Reply-To: <1333919920-25481-1-git-send-email-olof@lixom.net>
References: <1333919920-25481-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 14:18 -0700, Olof Johansson wrote:
> Move a couple of tests and do a minor refactor to avoid:
[]
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
[]
> @@ -2926,8 +2928,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	INIT_LIST_HEAD(&pd->channels);
>  
>  	/* Initialize channel parameters */
> -	num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
> -			(u8)pi->pcfg.num_chan);
> +	num_chan = max_t(int, pdat ? pdat->nr_valid_peri :
> +				     pi->pcfg.num_peri,
> +			      pi->pcfg.num_chan);
>  	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);

Few trivial things:

There's no error checking for a malloc failure
This should probably be kcalloc
The alignment here is not nice

Maybe:

	num_chan = max_t(size_t, pdat ? pdat->nr_valid_peri : pi->pcfg.num_peri,
			 pi->pcfg.num_chan);
	pdmac->peripherals = kcalloc(num_chan, sizeof(*pch), GFP_KERNEL);
	if (!pdmac->peripherals)
		goto some_err;


