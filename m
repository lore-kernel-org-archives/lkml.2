Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1CJCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:30:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48665 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1CJCaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:30:16 -0500
Date: Thu, 10 Mar 2011 11:29:57 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH]mmc: set timeout for SDHCI host before sending busy cmds
In-reply-to: <20110309080609.GA23207@intel.com>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org,
        Kyungmin Park <kyungmin.park@samsung.com>, prakity@marvell.com,
        jh80.chung@samsung.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Message-id: <4D7837A5.3010603@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
References: <20110309080609.GA23207@intel.com>
X-OriginalArrivalTime: 10 Mar 2011 02:30:14.0194 (UTC)
 FILETIME=[162C9920:01CBDECB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuanxiao Dong wrote:
> Hi all,
>    From the previous discussion, I do not think we have got a clear conclusion
>    about using maximum timeout value. At least we know from Jae hoon Chung
>    using 0xE for every case is not a good. So I want to suggest only use 0xE for
>    busy command. I personally preferred below implementation, which is similar
>    with a RFC patch submitted by Jae hoon Chung, but only without adding a new
>    quirk.

thanks for remind. 
Yes, i tested without quirks, i think that is not problem.
(Just sent RFC patch with quirks, because i want to ask how think about adding quirks or not).

> 
>    I think sdhci_calc_timeout should be left for data transfer since at least we
>    can get a warning if 0xE is not enough for host to use. And if the host
>    controller and the card have no bugs, then the calculated timeout should be
>    safe. Left the old implementation unchanged is also compatible with all
>    existed host controllers and cards.
> 
>    But for busy command, we are not clear about how long is safe enough for
>    waiting and there is also no function to do the calculation for them. So
>    preferred just using 0xE. Below the patch and comment:
> 
> Set the timeout control register for SDHCI host when send some commands which
> need busy signal. Use the maximum timeout value 0xE will be safe.
> 
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/host/sdhci.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 99c372e..8306323 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -659,8 +659,15 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
>  
>  	WARN_ON(host->data);
>  
> -	if (data == NULL)
> +	if (data == NULL) {
> +		/*
> +		 * set the timeout to be maximum value for commands those with
> +		 * busy signal
> +		 */
> +		if (host->cmd->flags & MMC_RSP_BUSY)
> +			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
>  		return;
> +	}
>  
>  	/* Sanity checks */
>  	BUG_ON(data->blksz * data->blocks > 524288);

