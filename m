Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0DBNvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 09:51:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:30807 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895Ab0DBNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,353,1267430400"; 
   d="scan'208";a="786042705"
Date: Fri, 2 Apr 2010 15:51:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34] mfd: Clean up after WM83xx AUXADC interrupt if
 it arrives late
Message-ID: <20100402135152.GH8010@sortiz.org>
References: <1270210119-16746-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270210119-16746-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 02, 2010 at 01:08:39PM +0100, Mark Brown wrote:
> In certain circumstances, especially under heavy load, the AUXADC
> completion interrupt may be detected after we've timed out waiting for
> it.  That conversion would still succeed but the next conversion will
> see the completion that was signalled by the interrupt for the previous
> conversion and therefore not wait for the AUXADC conversion to run,
> causing it to report failure.
> 
> Provide a simple, non-invasive cleanup by using try_wait_for_completion()
> to ensure that the completion is not signalled before we wait.  Since
> the AUXADC is run within a mutex we know there can only have been at
> most one AUXADC interrupt outstanding.  A more involved change should
> follow for the next merge window.
Patch applied to my for-linus branch, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-core.c |    3 +++
>  drivers/mfd/wm8350-core.c |    4 ++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
> index a3d5728..f2ab025 100644
> --- a/drivers/mfd/wm831x-core.c
> +++ b/drivers/mfd/wm831x-core.c
> @@ -349,6 +349,9 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
>  		goto disable;
>  	}
>  
> +	/* If an interrupt arrived late clean up after it */
> +	try_wait_for_completion(&wm831x->auxadc_done);
> +
>  	/* Ignore the result to allow us to soldier on without IRQ hookup */
>  	wait_for_completion_timeout(&wm831x->auxadc_done, msecs_to_jiffies(5));
>  
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index e400a3b..b580748 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -363,6 +363,10 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
>  	reg |= 1 << channel | WM8350_AUXADC_POLL;
>  	wm8350_reg_write(wm8350, WM8350_DIGITISER_CONTROL_1, reg);
>  
> +	/* If a late IRQ left the completion signalled then consume
> +	 * the completion. */
> +	try_wait_for_completion(&wm8350->auxadc_done);
> +
>  	/* We ignore the result of the completion and just check for a
>  	 * conversion result, allowing us to soldier on if the IRQ
>  	 * infrastructure is not set up for the chip. */
> -- 
> 1.7.0.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
