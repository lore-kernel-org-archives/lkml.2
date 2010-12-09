Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0LIFY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 00:24:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62750 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0LIFY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 00:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WOB0Ljdt1BhjJFuGXGs8SdQuSLcRyWL00P/VayRBXzfILRz6G5NvULbt8AVRd0lPsy
         Ek9rmrhEQj/D9gNMBF+xlTP2SbVaSlUwpxMQtuKRdqR14Vq5KG54f9MuSkHJBE+jHai9
         dpgCA1KPWgfZ9Y9v+cHx5o1UljHDMin75RwY0=
MIME-Version: 1.0
In-Reply-To: <20101201124900.GB5421@intel.com>
References: <20101201124900.GB5421@intel.com>
Date: Thu, 9 Dec 2010 14:24:25 +0900
X-Google-Sender-Auth: QApmOCNVj7pgHPoTXHfGCfWofHA
Message-ID: <AANLkTimv5f43mgtubgps_rgiHXa3=NGRb4kNrps8ViJn@mail.gmail.com>
Subject: Re: [PATCH v4 1/4]enable HW reset capbility
From: Kyungmin Park <kmpark@infradead.org>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        arjan@linux.intel.com, alan@linux.intel.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 9:49 PM, Chuanxiao Dong <chuanxiao.dong@intel.com> wrote:
> From d3be0b4fe8e8a40294830dfd8d0543d1e957fd29 Mon Sep 17 00:00:00 2001
> From: Chuanxiao Dong <chuanxiao.dong@intel.com>
> Date: Wed, 1 Dec 2010 19:14:02 +0800
> Subject: [PATCH 1/4] enable HW reset caps of MMC card if card supports
>
> HW reset capbility enable bit is byte 162 in card EXT_CSD
> register, only version4.4 card or later can support to enable
> this feature.
>
> HW reset feature can be used to reset eMMC card when occures
> timeout errors during read/write/erase.
>
> Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> ---
>  drivers/mmc/core/mmc.c   |   29 +++++++++++++++++++++++++++++
>  include/linux/mmc/card.h |    1 +
>  include/linux/mmc/mmc.h  |    1 +
>  3 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 77f93c3..85cc7f6 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -310,6 +310,10 @@ static int mmc_read_ext_csd(struct mmc_card *card)
>                        ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
>                card->ext_csd.trim_timeout = 300 *
>                        ext_csd[EXT_CSD_TRIM_MULT];
> +               /*
> +                * check Hardware reset cap
Check hardware.
> +                */
> +               card->ext_csd.rst = ext_csd[EXT_CSD_RST];
>        }
>
>        if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
> @@ -484,6 +488,31 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>        }
>
>        /*
> +        * eMMC4.4 version card has HW reset capbility.
capability.
> +        * Enable this feature here:
> +        * RST_N_FUNCTION register is W/R, one time programmable
Use RST_n_FUNCTION as spec.
> +        * or readable.
> +        * So need to enable this register only once after power on
> +        */
> +       if (card->csd.mmca_vsn >= CSD_SPEC_VER_4 &&
> +                       card->ext_csd.rev >= 4 &&
it should be card->ext_csd.rev >= 5 since 4 is obsolete.

Thank you,
Kyungmin Park
> +                       card->ext_csd.rst == 0) {
> +               err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +                               EXT_CSD_RST, 1);
> +
> +               if (err && err != -EBADMSG)
> +                       goto free_card;
> +
> +               if (err) {
> +                       printk(KERN_WARNING "%s: switch to rst enable "
> +                                  "failed %d\n",
> +                                  mmc_hostname(card->host), err);
> +                       err = 0;
> +               } else
> +                       card->ext_csd.rst = 1;
> +       }
> +
> +       /*
>         * Activate high speed (if supported)
>         */
>        if ((card->ext_csd.hs_max_dtr != 0) &&
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 8ce0827..ebee676 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -54,6 +54,7 @@ struct mmc_ext_csd {
>        unsigned int            sec_trim_mult;  /* Secure trim multiplier  */
>        unsigned int            sec_erase_mult; /* Secure erase multiplier */
>        unsigned int            trim_timeout;           /* In milliseconds */
> +       unsigned int            rst; /* hardware reset enable bit */
>  };
>
>  struct sd_scr {
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 956fbd8..b7ab0da 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -251,6 +251,7 @@ struct _mmc_csd {
>  * EXT_CSD fields
>  */
>
> +#define EXT_CSD_RST            162     /* onetime programmable R/W */
>  #define EXT_CSD_ERASE_GROUP_DEF                175     /* R/W */
>  #define EXT_CSD_ERASED_MEM_CONT                181     /* RO */
>  #define EXT_CSD_BUS_WIDTH              183     /* R/W */
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
