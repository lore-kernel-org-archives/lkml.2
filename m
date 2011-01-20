Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1ATEOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:14:15 -0500
Received: from void.printf.net ([89.145.121.20]:35065 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab1ATEON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:14:13 -0500
Date: Thu, 20 Jan 2011 04:14:12 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <tardyp@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pierre Tardy <pierre.tardy@intel.com>
Subject: Re: [PATCH 3/3] mmc: remove anti clock gating quirk for wl1271
Message-ID: <20110120041412.GA5274@void.printf.net>
References: <cover.1294588491.git.tardyp@gmail.com> <cb471b35d320b96a9d143103fd9e9b76f8998470.1294588491.git.tardyp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb471b35d320b96a9d143103fd9e9b76f8998470.1294588491.git.tardyp@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Sun, Jan 09, 2011 at 05:26:20PM +0100, Pierre Tardy wrote:
> From: Pierre Tardy <pierre.tardy@intel.com>
> 
> Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
> ---
>  drivers/mmc/core/quirks.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
> index fe467c8..506e4fc 100644
> --- a/drivers/mmc/core/quirks.c
> +++ b/drivers/mmc/core/quirks.c
> @@ -33,6 +33,14 @@ static void add_quirk(struct mmc_card *card, int data)
>  }
>  
>  /*
> + * This hook just removes a quirk unconditionnally
> + */
> +static void remove_quirk_hook(struct mmc_card *card, int data)
> +{
> +	card->quirks &= ~data;
> +}

This adds a defined-but-not-used warning.  The MMC tree doesn't
currently generate any warnings, so it would be good to avoid adding new
ones, though I understand why it might make sense in this case.

drivers/mmc/core/quirks.c:30:13: warning: ‘add_quirk’ defined but not used
drivers/mmc/core/quirks.c:38:13: warning: ‘remove_quirk_hook’ defined but not used

> +
> +/*
>   * This hook just adds a quirk for all sdio devices
>   */
>  static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
> @@ -41,9 +49,19 @@ static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
>  		card->quirks |= data;
>  }
>  
> +#ifndef SDIO_VENDOR_ID_TI
> +#define SDIO_VENDOR_ID_TI		0x0097
> +#endif
> +
> +#ifndef SDIO_DEVICE_ID_TI_WL1271
> +#define SDIO_DEVICE_ID_TI_WL1271	0x4076
> +#endif
> +
>  static const struct mmc_fixup mmc_fixup_methods[] = {
>  	{ SDIO_ANY_ID, SDIO_ANY_ID,
>  		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
> +	{ SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271,
> +		remove_quirk_hook, MMC_QUIRK_BROKEN_CLK_GATING },
>  	{ 0 }
>  };
>  

This doesn't compile, missing a comma.  Was it tested?

drivers/mmc/core/quirks.c:63:2: error: expected ‘}’ before ‘{’ token

(Otherwise, looks good.)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
