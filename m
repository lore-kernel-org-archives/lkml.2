Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1HSMWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:22:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:58330 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1HSMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:22:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.91
Message-ID: <4E4E5596.9070001@tudelft.nl>
Date: Fri, 19 Aug 2011 14:22:46 +0200
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
Subject: Re: [PATCH 3/6] Input: elantech - packet checking for v2 hardware
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 18-08-11 03:57, JJ Ding schreef:
> For v2 hardware, there is no real parity check, but we can still check
> some constant bits for data integrity.
>
> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
If you add some comments, as suggest by Dmitry, it looks perfect :-)

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

Éric

> ---
>   drivers/input/mouse/elantech.c |   26 +++++++++++++++++++++++---
>   1 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index cf41f23..032181c 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -376,6 +376,25 @@ static int elantech_check_parity_v1(struct psmouse *psmouse)
>   	       etd->parity[packet[3]] == p3;
>   }
>
> +static int packet_simple_check_v2(struct psmouse *psmouse)
> +{
> +	struct elantech_data *etd = psmouse->private;
> +	unsigned char *packet = psmouse->packet;
> +
> +	if (etd->reports_pressure)
> +		return (packet[0]&  0x0c) == 0x04&&
> +		       (packet[3]&  0x0f) == 0x02;
> +
> +	if ((packet[0]&  0xc0) == 0x80)
> +		return (packet[0]&  0x0c) == 0x0c&&
> +		       (packet[3]&  0x0e) == 0x08;
> +
> +	return (packet[0]&  0x3c) == 0x3c&&
> +	       (packet[1]&  0xf0) == 0x00&&
> +	       (packet[3]&  0x3e) == 0x38&&
> +	       (packet[4]&  0xf0) == 0x00;
> +}
> +
>   /*
>    * Process byte stream from mouse and handle complete packets
>    */
> @@ -398,7 +417,9 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>   		break;
>
>   	case 2:
> -		/* We don't know how to check parity in protocol v2 */
> +		if (etd->paritycheck&&  !packet_simple_check_v2(psmouse))
> +			return PSMOUSE_BAD_DATA;
> +
>   		elantech_report_absolute_v2(psmouse);
>   		break;
>   	}
> @@ -799,8 +820,7 @@ int elantech_init(struct psmouse *psmouse)
>   		etd->hw_version = 2;
>   		/* For now show extra debug information */
>   		etd->debug = 1;
> -		/* Don't know how to do parity checking for version 2 */
> -		etd->paritycheck = 0;
> +		etd->paritycheck = 1;
>
>   		if (etd->fw_version>= 0x020800)
>   			etd->reports_pressure = true;

