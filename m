Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2DJDox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:44:53 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:48754 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab2DJDow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:44:52 -0400
Message-ID: <4F83AC55.3070900@st.com>
Date: Tue, 10 Apr 2012 09:13:17 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH 2/2] dma/amba-pl08x: add support for the Nomadik variant
References: <1334004816-20219-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1334004816-20219-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2012 2:23 AM, Linus Walleij wrote:

> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c

> @@ -1934,6 +1943,24 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  		spin_lock_init(&ch->lock);
>  		ch->serving = NULL;
>  		ch->signal = -1;
> +
> +		/*
> +		 * Nomadik variants can have channels that are locked
> +		 * down for the secure world only. Lock up these channels
> +		 * by perpetually serving a dummy virtual channel.
> +		 */
> +		if (vd->nomadik) {
> +			u32 val;
> +
> +			val = readl(ch->base + PL080_CH_CONFIG);
> +			if (val & (PL080N_CONFIG_ITPROT | PL080N_CONFIG_SECPROT)) {
> +				dev_info(&adev->dev, "physical channel %d reserved "
> +					 "for secure access only\n", i);

Better not to break the print string. Go beyond 80 columns.

> +				ch->locked = true;
> +			} else
> +				ch->locked = false;
> +		}
> +

Memory for ch is allocated with kmalloc and so its default value is garbage.
So we must set locked to false in else part here.

>  		dev_dbg(&adev->dev, "physical channel %d is %s\n",
>  			i, pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
>  	}
> @@ -2016,6 +2043,12 @@ static struct vendor_data vendor_pl080 = {
>  	.dualmaster = true,
>  };
>  
> +static struct vendor_data vendor_nomadik = {
> +	.channels = 8,
> +	.dualmaster = true,
> +	.nomadik = true,
> +};
> +
>  static struct vendor_data vendor_pl081 = {
>  	.channels = 2,
>  	.dualmaster = false,
> @@ -2036,9 +2069,9 @@ static struct amba_id pl08x_ids[] = {
>  	},
>  	/* Nomadik 8815 PL080 variant */
>  	{
> -		.id	= 0x00280880,
> +		.id	= 0x00280080,

Has this changed? How it worked earlier?

>  		.mask	= 0x00ffffff,
> -		.data	= &vendor_pl080,
> +		.data	= &vendor_nomadik,
>  	},
>  	{ 0, 0 },
>  };
> diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
> index e64ce2c..0254901 100644
> --- a/include/linux/amba/pl08x.h
> +++ b/include/linux/amba/pl08x.h
> @@ -92,6 +92,8 @@ struct pl08x_bus_data {
>   * right now
>   * @serving: the virtual channel currently being served by this physical
>   * channel
> + * @locked: channel unavailable for the system, e.g. dedicated to secure
> + * world
>   */
>  struct pl08x_phy_chan {
>  	unsigned int id;
> @@ -99,6 +101,7 @@ struct pl08x_phy_chan {
>  	spinlock_t lock;
>  	int signal;
>  	struct pl08x_dma_chan *serving;
> +	bool locked;
>  };
>  
>  /**


-- 
viresh
