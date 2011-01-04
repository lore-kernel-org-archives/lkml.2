Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab1ADITp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:19:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:21277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1ADITo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:19:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,271,1291622400"; 
   d="scan'208";a="589651004"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Pierre Tardy <tardyp@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Date: Tue, 4 Jan 2011 16:19:01 +0800
Subject: RE: [RFC] sdhci: use ios->clock to know when sdhci is idle
Thread-Topic: [RFC] sdhci: use ios->clock to know when sdhci is idle
Thread-Index: Acuh2w7+D7VvZG3FRIG8ynhbOhhBcwKBxuDw
Message-ID: <5D8008F58939784290FAB48F549751983510982D32@shsmsx502.ccr.corp.intel.com>
References: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
In-Reply-To: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,
I have some concerns about this RFC.
I agree with you that even if the Wifi interface is up, user might not use the network and host controller should be power gated. That also is the purport of runtime PM framework! But I think Wifi card driver can know whether user is using the network after ifconfig up, right? So that Wifi driver can tell host controller when should be power gated as well. That means you can use runtime PM framework to control Wifi card's parent to do power gating. Then why not use the it?

Another thing is, does the clock gating framework work well when use power gating? Let's consider the scenario there are two slots in one host controller. Clock gating framework can only effect the slot it wants to gate since it only set the register of this slot, not touch the other one. That is reasonable. But power gating is not just effect the slot it wants. It will influence both of the slots since it will set the host controller's power. Host controller never knows how many children are alive since his children never use runtime_put/get to notify their parent. I think this is not reasonable.


> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Pierre Tardy
> Sent: Wednesday, December 22, 2010 9:14 PM
> To: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Pierre Tardy; Chris Ball; Andrew Morton; Alan Cox; Takashi Iwai; Maxim
> Levitsky; Linus Walleij; Ohad Ben-Cohen; Gao, Yunpeng
> Subject: [RFC] sdhci: use ios->clock to know when sdhci is idle
> 
> This allows sdhci to detect its own activity and to autosuspend
> when not used
> 
> inspired from  mmci: handle clock frequency 0 properly
> From Linus Walleij <linus.walleij@stericsson.com>
> author of mmc aggressive clock gating fw.
> 
> The idea of using mmc clock gating fw in order to power gate the
> sdhci is simple (hope no too simplistic):
> Whenever the mmc fw tells we dont need the MMC clock, we dont need
> the sdhci power as well.
> 
> This does not mean that the child (card) is
> suspended. In case of a Wifi SDIO card, the card will be suspended
> and resumed according to the ifconfig up/down status.
> Even if the Wifi interface is up, user might not use the network.
> Sdhci can be powered off during those period. It is up to the HW
> implementation to implement smart enough power gating to still
> support enough always-on circuitry allowing to detect sdio
> interrupts.
> 
> This patch goes on top of Yunpeng's patch available on patchwork:
> 378052 [v2,2/3] mmc: enable runtime PM support of sdhci host controller
> 
> CC: Chris Ball <cjb@laptop.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alan Cox <alan@linux.intel.com>
> CC: Takashi Iwai <tiwai@suse.de>
> CC: Maxim Levitsky <maximlevitsky@gmail.com>
> CC: Linus Walleij <linus.walleij@stericsson.com>
> CC: Ohad Ben-Cohen <ohad@wizery.com>
> CC: Yunpeng Gao <yunpeng.gao@intel.com>
> 
> Signed-off-by: Pierre Tardy <tardyp@gmail.com>
> ---
>  drivers/mmc/host/sdhci.c  |   20 ++++++++++++++++++++
>  include/linux/mmc/sdhci.h |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a298fb0..a648330 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1161,6 +1161,7 @@ static void sdhci_set_ios(struct mmc_host *mmc,
> struct mmc_ios *ios)
>  {
>  	struct sdhci_host *host;
>  	unsigned long flags;
> +        unsigned int lastclock;
>  	u8 ctrl;
> 
>  	host = mmc_priv(mmc);
> @@ -1171,6 +1172,24 @@ static void sdhci_set_ios(struct mmc_host *mmc,
> struct mmc_ios *ios)
>  		goto out;
> 
>  	/*
> +	 * get/put runtime_pm usage counter at ios->clock transitions
> +         * We need to do it before any other chip access, as sdhci could
> +         * be power gated
> +	 */
> +        lastclock = host->iosclock;
> +        host->iosclock = ios->clock;
> +	if (lastclock == 0 && ios->clock != 0) {
> +		spin_unlock_irqrestore(&host->lock, flags);
> +		pm_runtime_get_sync(&host->parent.dev);
> +		spin_lock_irqsave(&host->lock, flags);
> +	} else if (lastclock != 0 && ios->clock == 0) {
> +		spin_unlock_irqrestore(&host->lock, flags);
> +		pm_runtime_put_autosuspend(&host->parent.dev);
> +		spin_lock_irqsave(&host->lock, flags);
> +		/* no need to configure the rest.. */
> +		goto out;
> +	}
> +	/*
>  	 * Reset the chip on each power off.
>  	 * Should clear out any weird states.
>  	 */
> @@ -1779,6 +1798,7 @@ struct sdhci_host *sdhci_alloc_host(struct device
> *dev,
> 
>  	host = mmc_priv(mmc);
>  	host->mmc = mmc;
> +	host->iosclock = 0;
> 
>  	return host;
>  }
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 0d953f5..78c1528 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -114,6 +114,7 @@ struct sdhci_host {
>  	unsigned int timeout_clk;	/* Timeout freq (KHz) */
> 
>  	unsigned int clock;	/* Current clock (MHz) */
> +	unsigned int iosclock;	/* Last clock asked via set_ios  */
>  	u8 pwr;			/* Current voltage */
> 
>  	struct mmc_request *mrq;	/* Current request */
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
