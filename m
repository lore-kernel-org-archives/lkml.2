Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1DUNL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:11:29 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:49444 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1DUNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:11:26 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiBRAIQssE1V5qkTPGdsb2JhbACJGZwuCwEBAQE3Mohwu08OhWgEkjw
X-IronPort-AV: E=Sophos;i="4.64,251,1301868000"; 
   d="scan'208";a="1723415486"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 21 Apr 2011 15:13:17 +0200
To: riyer@nvidia.com
Cc: dmitry.torokhov@gmail.com, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v1] Input: tegra-kbc - add ghost key filter.
Message-ID: <20110421131317.GA8661@polaris.bitmath.org>
References: <1303248031-9633-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303248031-9633-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

> Add ghost key filtering support for the Nvidia Tegra matrix keyboard.
> 
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> ---
> v1: Do not report keypresses when matrix keyboard encounters key ghosting.
> 
>  arch/arm/mach-tegra/include/mach/kbc.h |    1 +
>  drivers/input/keyboard/tegra-kbc.c     |   40 ++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
> index 04c7798..bd99744 100644
> --- a/arch/arm/mach-tegra/include/mach/kbc.h
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -58,5 +58,6 @@ struct tegra_kbc_platform_data {
>  
>  	bool wakeup;
>  	bool use_fn_map;
> +	bool use_ghost_filter;
>  };
>  #endif
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> index 99ce903..bff8bfe 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -72,6 +72,7 @@ struct tegra_kbc {
>  	unsigned int repoll_dly;
>  	unsigned long cp_dly_jiffies;
>  	bool use_fn_map;
> +	bool use_ghost_filter;
>  	const struct tegra_kbc_platform_data *pdata;
>  	unsigned short keycode[KBC_MAX_KEY * 2];
>  	unsigned short current_keys[KBC_MAX_KPENT];
> @@ -285,6 +286,44 @@ static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
>  	}
>  
>  	/*
> +	 * Matrix keyboard designs are prone to keyboard ghosting.
> +	 * Ghosting occurs if there are 3 keys such that -
> +	 * any 2 of the 3 keys share a row, and any 2 of them share a column.
> +	 * If so ignore the keypresses for this iteration.
> +	 */
> +	if ((kbc->use_ghost_filter) && (num_down >= 3)) {
> +		for (i = 0; i < num_down; i++) {
> +			unsigned int j;
> +			u8 curr_col = scancodes[i] & 0x07;
> +			u8 curr_row = scancodes[i] >> KBC_ROW_SHIFT;
> +			bool key_in_same_row = false;
> +			bool key_in_same_col = false;

How about moving these outside the loop,

> +
> +			/*
> +			 * Find 2 keys such that one key is in the same row
> +			 * and the other is in the same column as the i-th key.
> +			 */
> +			for (j = 0; j < num_down; j++) {

using j = i + 1 here,

> +				u8 col = scancodes[j] & 0x07;
> +				u8 row = scancodes[j] >> KBC_ROW_SHIFT;
> +
> +				/* Skip checking the i-th key. */
> +				if (i == j)
> +					continue;

skipping this,

> +
> +				if (col == curr_col)
> +					key_in_same_col = true;
> +				if (row == curr_row)
> +					key_in_same_row = true;
> +			}
> +			if (key_in_same_col && key_in_same_row) {
> +				spin_unlock_irqrestore(&kbc->lock, flags);
> +				return;
> +			}

and placing this test after the irqrestore instead?

> +		}
> +	}
> +
> +	/*
>  	 * If the platform uses Fn keymaps, translate keys on a Fn keypress.
>  	 * Function keycodes are KBC_MAX_KEY apart from the plain keycodes.
>  	 */
> @@ -652,6 +691,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
>  		input_dev->keycodemax *= 2;
>  
>  	kbc->use_fn_map = pdata->use_fn_map;
> +	kbc->use_ghost_filter = pdata->use_ghost_filter;
>  	keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
>  	matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
>  				   input_dev->keycode, input_dev->keybit);
> -- 
> 1.7.0.4

Thanks,
Henrik
