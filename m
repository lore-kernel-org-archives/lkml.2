Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0JRXZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:25:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:57475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab0JRXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,347,1283756400"; 
   d="scan'208";a="848443504"
Date: Tue, 19 Oct 2010 01:25:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Brian Harring <ferringb@gmail.com>
Cc: linux-kernel@vger.kernel.org, richard.rojfors@pelagicore.com
Subject: Re: [PATCH] add platform_data only if non NULL
Message-ID: <20101018232501.GA16761@sortiz-mobl>
References: <20101004015056.GA22095@hrair>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004015056.GA22095@hrair>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Sun, Oct 03, 2010 at 06:50:56PM -0700, Brian Harring wrote:
> If a NULL or 0 size platform_data is added, the underlying dup results in a pointer into nullspace- meaning drivers can't do null checks for platform_data.
> 
> This fixes an oops during probing for drivers/net/ks8842, and drivers/mmc/host/sdhci-pltform when the mfd is timberdale
> 
Patch applied, without the paranoid setting :) Many thanks.

Cheers,
Samuel.


> Signed-off-by: Brian Harring <ferringb@gmail.com>
> ---
>  drivers/mfd/mfd-core.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 1823a57..eee73a8 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -38,10 +38,15 @@ static int mfd_add_device(struct device *parent, int id,
>  	pdev->dev.parent = parent;
>  	platform_set_drvdata(pdev, cell->driver_data);
>  
> -	ret = platform_device_add_data(pdev,
> -			cell->platform_data, cell->data_size);
> -	if (ret)
> -		goto fail_res;
> +	if (cell->data_size) {
> +		ret = platform_device_add_data(pdev,
> +				cell->platform_data, cell->data_size);
> +		if (ret)
> +			goto fail_res;
> +	} else {
> +		/* potentially nulled already, just being paranoid. */
> +		pdev->dev.platform_data = NULL;
> +	}
>  
>  	for (r = 0; r < cell->num_resources; r++) {
>  		res[r].name = cell->resources[r].name;
> -- 
> 1.7.2
> 



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
