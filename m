Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0LFBMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:12:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0LFBMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kBFMOWWCbtmiU0BC/r40hT/QMzJm/MKTWQhZI3v4a+rpOh75TzLafTpNFy2/GkxIwz
         J54C93I8nac9ymIPLd4rwR4KLr/pXttRsYvxXx81sTvKqNcwzs2UpX4xFdukLG5FAcLo
         3LnKfdkTba7DSgEM77KNoGY6jCSSawTbErTik=
MIME-Version: 1.0
In-Reply-To: <20101203121338.GB18655@intel.com>
References: <20101203121338.GB18655@intel.com>
Date: Mon, 6 Dec 2010 10:12:10 +0900
X-Google-Sender-Auth: iOgvpePKdyJH58ldQ-TNV0OiefQ
Message-ID: <AANLkTikPAmpJq7Q7riDPGq5UkhAa9cuXRW7kjuNGv6oB@mail.gmail.com>
Subject: Re: [PATCH v2 1/4]enable background operations for supported eMMC card
From: Kyungmin Park <kmpark@infradead.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        akpm@linux-foundation.org, arjan@linux.intel.com, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Tested-by: Kyungmin Park <kyungmin.park@samsung.com>

Note that I'm not yet see any performance improvements :)

On Fri, Dec 3, 2010 at 9:13 PM, Chuanxiao Dong <chuanxiao.dong@intel.com> wrote:
> From 984adc755cf2f7966a89e510a50f085e314fe347 Mon Sep 17 00:00:00 2001
> From: Chuanxiao Dong <chuanxiao.dong@intel.com>
> Date: Mon, 22 Nov 2010 16:31:12 +0800
> Subject: [PATCH 1/4] mmc: Enabled background operations feature if eMMC card supports
>
> Background operations is a new feature defined in eMMC4.41 standard.
> Since this feature is opertional for eMMC card, so driver only enable
> for those eMMC card which supports this feature
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/core/mmc.c   |   26 ++++++++++++++++++++++++++
>  include/linux/mmc/card.h |    2 ++
>  include/linux/mmc/mmc.h  |    3 +++
>  3 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 77f93c3..471ed82 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -310,6 +310,14 @@ static int mmc_read_ext_csd(struct mmc_card *card)
>                        ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
>                card->ext_csd.trim_timeout = 300 *
>                        ext_csd[EXT_CSD_TRIM_MULT];
> +
> +               /* detect whether the eMMC card support BKOPS */
> +               if (ext_csd[EXT_CSD_BKOPS_SUPPORT] & 0x1) {
> +                       card->ext_csd.bkops = 1;
> +                       card->ext_csd.bkops_en =
> +                               ext_csd[EXT_CSD_BKOPS_EN];
> +               }
> +
>        }
>
>        if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
> @@ -484,6 +492,24 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>        }
>
>        /*
> +        * enable BKOPS if eMMC card supports.
> +        */
> +       if (card->ext_csd.bkops) {
> +               if (!card->ext_csd.bkops_en) {
> +                       err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +                                       EXT_CSD_BKOPS_EN, 1);
> +                       if (err && err != -EBADMSG)
> +                               goto free_card;
> +
> +                       if (err) {
> +                               card->ext_csd.bkops_en = 0;
> +                               err = 0;
> +                       } else
> +                               card->ext_csd.bkops_en = 1;
> +               }
> +       }
> +
> +       /*
>         * Activate high speed (if supported)
>         */
>        if ((card->ext_csd.hs_max_dtr != 0) &&
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 8ce0827..9b755cb 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -54,6 +54,8 @@ struct mmc_ext_csd {
>        unsigned int            sec_trim_mult;  /* Secure trim multiplier  */
>        unsigned int            sec_erase_mult; /* Secure erase multiplier */
>        unsigned int            trim_timeout;           /* In milliseconds */
> +       unsigned int            bkops:1; /* background support bit */
> +       unsigned int            bkops_en:1; /* background enable bit */
>  };
>
>  struct sd_scr {
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 956fbd8..14f7813 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -251,6 +251,8 @@ struct _mmc_csd {
>  * EXT_CSD fields
>  */
>
> +#define EXT_CSD_BKOPS_EN               163     /* R/W */
> +#define EXT_CSD_BKOPS_START            164     /* W */
>  #define EXT_CSD_ERASE_GROUP_DEF                175     /* R/W */
>  #define EXT_CSD_ERASED_MEM_CONT                181     /* RO */
>  #define EXT_CSD_BUS_WIDTH              183     /* R/W */
> @@ -266,6 +268,7 @@ struct _mmc_csd {
>  #define EXT_CSD_SEC_ERASE_MULT         230     /* RO */
>  #define EXT_CSD_SEC_FEATURE_SUPPORT    231     /* RO */
>  #define EXT_CSD_TRIM_MULT              232     /* RO */
> +#define EXT_CSD_BKOPS_SUPPORT  502     /* RO */
>
>  /*
>  * EXT_CSD field definitions
> --
> 1.6.6.1
>
>
