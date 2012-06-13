Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2FMId5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:33:57 -0400
Received: from linux-sh.org ([111.68.239.195]:35253 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab2FMIdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:33:54 -0400
Date: Wed, 13 Jun 2012 17:33:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arve Hj??nnev??g <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 01/15] ARM: etm: Don't require clock control
Message-ID: <20120613083330.GB27673@linux-sh.org>
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
 <1339552887-17204-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339552887-17204-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:01:19PM -0700, John Stultz wrote:
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index 36d20bd..bd295e8 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -362,13 +362,12 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
>  	if (ret)
>  		goto out_unmap;
>  
> +	/* Get optional clock. Currently used to select clock source on omap3 */
>  	t->emu_clk = clk_get(&dev->dev, "emu_src_ck");
> -	if (IS_ERR(t->emu_clk)) {
> +	if (IS_ERR(t->emu_clk))
>  		dev_dbg(&dev->dev, "Failed to obtain emu_src_ck.\n");
> -		return -EFAULT;
> -	}
> -
> -	clk_enable(t->emu_clk);
> +	else
> +		clk_enable(t->emu_clk);
>  
Optionally you could just:

	if (IS_ERR(t->emu_clk))
		t->emu_clk = NULL;

and use the clk API as you were, as it does handle NULL being passed in.

In this case you don't have too many callsites to worry about, but it's
reasonably convenient to be able to pass a NULL clk pointer around
without constant special-casing when those start to balloon up.
