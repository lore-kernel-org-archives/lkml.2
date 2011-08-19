Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1HSM3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:29:12 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:44788 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1HSM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:29:10 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.91
Message-ID: <4E4E5714.2040802@tudelft.nl>
Date: Fri, 19 Aug 2011 14:29:08 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110814 Thunderbird/5.0
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 5/6] Input: elantech - clean up elantech_init
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 18-08-11 03:57, JJ Ding schreef:
> Group property setting code into elantech_set_properties.
>
> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
Looks good.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

Éric
> ---
>   drivers/input/mouse/elantech.c |   69 ++++++++++++++++++++++-----------------
>   1 files changed, 39 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 7b9b6e5..ddd40eb 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -791,6 +791,42 @@ static int elantech_reconnect(struct psmouse *psmouse)
>   }
>
>   /*
> + * determine hardware version and set some properties according to it.
> + */
> +static void elantech_set_properties(struct elantech_data *etd)
> +{
> +	/*
> +	 * Assume every version greater than 0x020030 is new EeePC style
> +	 * hardware with 6 byte packets, except 0x020600
> +	 */
> +	if (etd->fw_version<  0x020030 || etd->fw_version == 0x020600)
> +		etd->hw_version = 1;
> +	else
> +		etd->hw_version = 2;
> +
> +	/*
> +	 * Turn on packet checking by default.
> +	 */
> +	etd->paritycheck = 1;
> +
> +	/*
> +	 * This firmware suffers from misreporting coordinates when
> +	 * a touch action starts causing the mouse cursor or scrolled page
> +	 * to jump. Enable a workaround.
> +	 */
> +	etd->jumpy_cursor =
> +		(etd->fw_version == 0x020022 || etd->fw_version == 0x020600);
> +
> +	if (etd->hw_version == 2) {
> +		/* For now show extra debug information */
> +		etd->debug = 1;
> +
> +		if (etd->fw_version>= 0x020800)
> +			etd->reports_pressure = true;
> +	}
> +}
> +
> +/*
>    * Initialize the touchpad and create sysfs entries
>    */
>   int elantech_init(struct psmouse *psmouse)
> @@ -816,26 +852,9 @@ int elantech_init(struct psmouse *psmouse)
>   	}
>
>   	etd->fw_version = (param[0]<<  16) | (param[1]<<  8) | param[2];
> -
> -	/*
> -	 * Assume every version greater than this is new EeePC style
> -	 * hardware with 6 byte packets
> -	 */
> -	if (etd->fw_version>= 0x020030) {
> -		etd->hw_version = 2;
> -		/* For now show extra debug information */
> -		etd->debug = 1;
> -		etd->paritycheck = 1;
> -
> -		if (etd->fw_version>= 0x020800)
> -			etd->reports_pressure = true;
> -
> -	} else {
> -		etd->hw_version = 1;
> -		etd->paritycheck = 1;
> -	}
> -
> -	pr_info("assuming hardware version %d, firmware version %d.%d.%d\n",
> +	elantech_set_properties(etd);
> +	pr_info("assuming hardware version %d "
> +		"(with firmware version 0x%02x%02x%02x)\n",
>   		etd->hw_version, param[0], param[1], param[2]);
>
>   	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY,
> @@ -847,16 +866,6 @@ int elantech_init(struct psmouse *psmouse)
>   		etd->capabilities[0], etd->capabilities[1],
>   		etd->capabilities[2]);
>
> -	/*
> -	 * This firmware suffers from misreporting coordinates when
> -	 * a touch action starts causing the mouse cursor or scrolled page
> -	 * to jump. Enable a workaround.
> -	 */
> -	if (etd->fw_version == 0x020022 || etd->fw_version == 0x020600) {
> -		pr_info("firmware version 2.0.34/2.6.0 detected, enabling jumpy cursor workaround\n");
> -		etd->jumpy_cursor = true;
> -	}
> -
>   	if (elantech_set_absolute_mode(psmouse)) {
>   		pr_err("failed to put touchpad into absolute mode.\n");
>   		goto init_fail;

