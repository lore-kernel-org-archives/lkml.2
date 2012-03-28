Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2C1FZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:25:25 -0400
Received: from linux-sh.org ([111.68.239.195]:48254 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2C1FZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:25:24 -0400
Date: Wed, 28 Mar 2012 14:25:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/2] dma: shdma: fix runtime PM: clear channel buffers on reset
Message-ID: <20120328052503.GP26543@linux-sh.org>
References: <Pine.LNX.4.64.1201041528570.30506@axis700.grange> <Pine.LNX.4.64.1201041532290.30506@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1201041532290.30506@axis700.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 03:34:17PM +0100, Guennadi Liakhovetski wrote:
> On platforms, supporting power domains, if the domain, containing a DMAC
> instance is powered down, the driver fails to resume correctly. On those
> platforms DMAC channels have an additional CHCLR register for clearing
> channel buffers. Using this register during runtime resume fixes the
> problem.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

..

> @@ -139,6 +157,10 @@ static int sh_dmae_rst(struct sh_dmae_device *shdev)
>  		dev_warn(shdev->common.dev, "Can't initialize DMAOR.\n");
>  		return -EIO;
>  	}
> +	if (shdev->pdata->dmaor_init & ~dmaor)
> +		dev_warn(shdev->common.dev,
> +			 "DMAOR=0x%x hasn't latched the initial value 0x%x.\n",
> +			 dmaor, shdev->pdata->dmaor_init);
>  	return 0;
>  }
>  
I've just hit this on SH7786, which I suspect means that I've got it
wired up incorrectly somehow. This hunk also appears completely unrelated
to the changelog, so I'm wondering what exactly it's for. If this is a
probe attempt then presumably we should be handing down an error and
-ENODEV'ing in the init path? Is it expected that this is non-fatal in
the other reset cases?
