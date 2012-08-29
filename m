Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2H2H1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 03:27:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59041 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2H2H1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 03:27:32 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-2a-503dc46276fd
Message-id: <503DC45D.7060607@samsung.com>
Date: Wed, 29 Aug 2012 16:27:25 +0900
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
References: <503DB130.8090807@samsung.com>
In-reply-to: <503DB130.8090807@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd2kI7YBBu979C0u75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBnXW5ewFrTLVsxduo+9gXGFRBcjB4eEgInEz8t2XYyc
	QKaYxIV769m6GLk4hAQWMUqc+T+bHcJ5yShxYcV9JpAqXgEtidYnn8BsFgFViWMz/zOD2GwC
	OhLbvx0Hi4sKhEhc37OBEaJeUOLH5HssILaIgJrErl23wTYwC0xnkpi07yRYg7CAs8TniSfA
	BgkBLbj34xBYM6eAtsSi3T/BmpmBFuxvncYGYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgYHwmvYNxVYPFIUYBDkYlHt4L3LYBQqyJZcWVuYcY
	JTiYlUR4n5oChXhTEiurUovy44tKc1KLDzFKc7AoifPy9xkGCAmkJ5akZqemFqQWwWSZODil
	GhinBEpJGm3W6z6+z+utS218sqXZlto7zcKn3padOnlgwvoHzxyW/DQxZDp6od88IeV/aUia
	1BTu49X9+pLyCvVczxh3Ha70y/vz7c5MxiX14pJbmFw/ZiY3v7m4STDCTW3LNz5tlmrT/LN8
	SwtOMJiv/L3z9vU5f3P3/NgiJy9/ZBrTIdWAra+VWIozEg21mIuKEwFaIpZNQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Could you merge this patch?
We want to prevent this problem at mainline kernel.

Best Regards,
Jaehoon Chung

On 08/29/2012 03:05 PM, IAN CHEN wrote:
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
> @@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
>  #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular multiblock */
>  #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512 bytes in */
>  #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
> +#define MMC_QUIRK_SEC_ERASE_TRIM_BROKEN (1<<10)	/* Skip secure for erase/trim */
>  						/* byte mode */
>  	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
>  #define MMC_NO_POWER_NOTIFICATION	0
> 

