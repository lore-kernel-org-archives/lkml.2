Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2H2FhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 01:37:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31967 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2H2FhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 01:37:01 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-2b-503daa7b7a8e
Message-id: <503DAA76.40509@samsung.com>
Date: Wed, 29 Aug 2012 14:36:54 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        d.j.shin@samsung.com, jongtae22.kim@samsung.com,
        kyungmin.park@samsung.com, jh80.chung@samsung.com
Subject: Re: [PATCH v6] mmc: card: Skip secure option for MoviNAND.
References: <503DA2F1.70601@samsung.com>
In-reply-to: <503DA2F1.70601@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAd2aVbYBBus/sFlc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLmX1jHXHBfpuL09H1MDYxtEl2MnBwSAiYSr/a9Z4Sw
	xSQu3FvP1sXIxSEksIhRonveJHYI5yWjxMbTC8GqeAU0JK7OfQZmswioSjS9XMgMYrMJ6Ehs
	/3acCcQWFQiRuL5nA1S9oMSPyfdYQGwRATWJXbtug21gFpjOJDFp30mwBmEBZ4nPE0+ADRIC
	WvDwfRsbiM0poClx+s9OdhCbGWjB/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA7HZ1I7GFc2WBxiFOBgVOLhvcBtGyDEmlhWXJl7iFGC
	g1lJhPepKVCINyWxsiq1KD++qDQntfgQozQHi5I4L3+fYYCQQHpiSWp2ampBahFMlomDU6qB
	kfWQ7K/klbnCjzJ2Mv/tXf1A9M4pheyMX9OagxjWdnn49tRPd0q5VnTu1ixfaxvD2FcCdWbS
	nFk59yZNfvpiFgs73560SXJXXj6z5U5tr5O7yX3YPu1O75L5J02dXLPDY2uEaywvJhq37Nwc
	qKJqcXBzuej+PaIzygv58sSq+c8Z3/E0ULilxFKckWioxVxUnAgAGRtS60MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to check your mail setting.

On 08/29/2012 02:04 PM, IAN CHEN wrote:
> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.
> 
> You could refer this discussion in XDA developers.
> http://forum.xda-developers.com/showthread.php?t=1644364
> https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB
> 
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
>  include/linux/mmc/card.h |    1 +
>  2 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index f1c84de..0377885 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
> struct request *req)
Line wrap.?
>  		/* complete ongoing async transfer before issuing discard */
>  		if (card->host->areq)
>  			mmc_blk_issue_rw_rq(mq, NULL);
> -		if (req->cmd_flags & REQ_SECURE)
> +		if (req->cmd_flags & REQ_SECURE &&
> +			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
>  			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>  		else
>  			ret = mmc_blk_issue_discard_rq(mq, req);
> @@ -1716,6 +1717,7 @@ force_ro_fail:
>  #define CID_MANFID_SANDISK	0x2
>  #define CID_MANFID_TOSHIBA	0x11
>  #define CID_MANFID_MICRON	0x13
> +#define CID_MANFID_SAMSUNG	0x15
> 
>  static const struct mmc_fixup blk_fixups[] =
>  {
> @@ -1752,6 +1754,26 @@ static const struct mmc_fixup blk_fixups[] =
>  	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_MICRON, 0x200, add_quirk_mmc,
>  		  MMC_QUIRK_LONG_READ_TIME),
> 
> +	/*
> +	 * Some issue about secure erase/secure trim for Samsung MoviNAND
> +	 */
> +	MMC_FIXUP("M8G2FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
> +
>  	END_FIXUP
>  };
> 
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 111aca5..4b27f9f 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -239,6 +239,7 @@ struct mmc_card {
>  #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular
> multiblock */
here..
>  #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512
> bytes in */
Also
>  #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
> +#define MMC_QUIRK_SEC_ERASE_TRIM_BROKEN (1<<10)	/* Skip secure for
> erase/trim */
Also line wrap?
>  						/* byte mode */
>  	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
>  #define MMC_NO_POWER_NOTIFICATION	0
> 

