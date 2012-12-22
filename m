Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2LVWb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 17:31:58 -0500
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:46922 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab2LVWb5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 17:31:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 22 Dec 2012 14:29:57 -0800
Subject: RE: [PATCH 07/25] mwifiex: don't use [delayed_]work_pending()
Thread-Topic: [PATCH 07/25] mwifiex: don't use [delayed_]work_pending()
Thread-Index: Ac3f58skdyNE5zJWTWet1KNdvJtrRwAqtujQ
Message-ID: <477F20668A386D41ADCC57781B1F70430D13D8099B@SC-VEXCH1.marvell.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-8-git-send-email-tj@kernel.org>
In-Reply-To: <1356141435-17340-8-git-send-email-tj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thanks for the patch.

> Drop work_pending() test from mwifiex_sdio_card_reset().  As
> work_pending() becomes %false before sdio_card_reset_worker() starts
> executing, it doesn't really protect anything.  reset_host may change
> between mmc_remove_host() and mmc_add_host().  Make
> sdio_card_reset_worker() cache the target mmc_host so that it isn't
> affected by mwifiex_sdio_card_reset() racing with it.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: linux-wireless@vger.kernel.org

Acked-by: Bing Zhao <bzhao@marvell.com>

> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

If you are taking other patches in this series through your tree, please take this one too.

Thanks,
Bing

> 
> Thanks.
> 
>  drivers/net/wireless/mwifiex/sdio.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 5a1c1d0..f2874c3 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -1752,6 +1752,8 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
>  static struct mmc_host *reset_host;
>  static void sdio_card_reset_worker(struct work_struct *work)
>  {
> +	struct mmc_host *target = reset_host;
> +
>  	/* The actual reset operation must be run outside of driver thread.
>  	 * This is because mmc_remove_host() will cause the device to be
>  	 * instantly destroyed, and the driver then needs to end its thread,
> @@ -1761,10 +1763,10 @@ static void sdio_card_reset_worker(struct work_struct *work)
>  	 */
> 
>  	pr_err("Resetting card...\n");
> -	mmc_remove_host(reset_host);
> +	mmc_remove_host(target);
>  	/* 20ms delay is based on experiment with sdhci controller */
>  	mdelay(20);
> -	mmc_add_host(reset_host);
> +	mmc_add_host(target);
>  }
>  static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
> 
> @@ -1773,9 +1775,6 @@ static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
>  {
>  	struct sdio_mmc_card *card = adapter->card;
> 
> -	if (work_pending(&card_reset_work))
> -		return;
> -
>  	reset_host = card->func->card->host;
>  	schedule_work(&card_reset_work);
>  }
> --
> 1.8.0.2

