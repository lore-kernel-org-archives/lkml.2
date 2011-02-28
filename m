Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1B1Qj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:39:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:9058 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab1B1Qj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:39:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="395138228"
Date: Mon, 28 Feb 2011 17:39:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/29] mfd-core: add refcounting support to mfd_cells
 (v2)
Message-ID: <20110228163950.GB5263@sortiz-mobl>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
 <1297998456-7615-28-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297998456-7615-28-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Feb 17, 2011 at 07:07:34PM -0800, Andres Salomon wrote:
> This provides convenience functions for sharing of cells across
> multiple mfd clients.  Mfd drivers can provide enable/disable hooks
> to actually tweak the hardware, and clients can call
> mfd_shared_cell_{en,dis}able without having to worry about whether
> or not another client happens to have enabled or disabled the
> cell/hardware.
> 
> Note that this is purely optional; drivers can continue to use
> the mfd_cell's enable/disable hooks for their own purposes, if
> desired.
> 
> v2: modify mfd_shared_cell_enable/disable to only modify refcount
> if the hook call succeeds.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/mfd/mfd-core.c   |   64 +++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/mfd/core.h |   14 +++++++++-
>  2 files changed, 73 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 01115f6..ca789f8 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -18,6 +18,43 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  
> +int mfd_shared_cell_enable(struct platform_device *pdev)
> +{
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	int err = 0;
> +
> +	/* only call enable hook if the cell wasn't previously enabled */
> +	if (atomic_inc_return(cell->usage_count) == 1)
> +		err = cell->enable(pdev);
> +
> +	/* if the enable hook failed, decrement counter to allow retries */
> +	if (err)
> +		atomic_dec(cell->usage_count);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(mfd_shared_cell_enable);
> +
> +int mfd_shared_cell_disable(struct platform_device *pdev)
> +{
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	int err = 0;
> +
> +	/* only disable if no other clients are using it */
> +	if (atomic_dec_return(cell->usage_count) == 0)
> +		err = cell->disable(pdev);
> +
> +	/* if the disable hook failed, increment to allow retries */
> +	if (err)
> +		atomic_inc(cell->usage_count);
> +
> +	/* sanity check; did someone call disable too many times? */
> +	WARN_ON(atomic_read(cell->usage_count) < 0);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(mfd_shared_cell_disable);
It would probably make sense to rename both of these routines by simply
removing the shared part: mfd_cell_enable/disable().

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
