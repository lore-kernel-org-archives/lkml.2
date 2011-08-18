Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1HRCtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:49:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1HRCtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:49:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=FFLcf2360aYxlXmCfI2rCcve4FMUlbKw5J0A+6H02ac0koySdMnpcMJQiOUGDYj67
	EZhcgihSu7b70C8joLRLA==
MIME-Version: 1.0
In-Reply-To: <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 10:49:29 +0800
X-Google-Sender-Auth: 2fg-TshmTUiTcytcwOKbOjC0KLk
Message-ID: <CAGS+omA0=Ypm0vRbBkSiGYc_NBf4adCBhPhpbrhineXe1+hcrw@mail.gmail.com>
Subject: Re: [PATCH 3/6] Input: elantech - packet checking for v2 hardware
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 9:57 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> For v2 hardware, there is no real parity check, but we can still check
> some constant bits for data integrity.
>
> Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
> ---
>  drivers/input/mouse/elantech.c |   26 +++++++++++++++++++++++---
>  1 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index cf41f23..032181c 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -376,6 +376,25 @@ static int elantech_check_parity_v1(struct psmouse *psmouse)
>               etd->parity[packet[3]] == p3;
>  }
>
> +static int packet_simple_check_v2(struct psmouse *psmouse)
> +{
> +       struct elantech_data *etd = psmouse->private;
> +       unsigned char *packet = psmouse->packet;
> +
> +       if (etd->reports_pressure)
> +               return (packet[0] & 0x0c) == 0x04 &&
> +                      (packet[3] & 0x0f) == 0x02;
> +
> +       if ((packet[0] & 0xc0) == 0x80)
> +               return (packet[0] & 0x0c) == 0x0c &&
> +                      (packet[3] & 0x0e) == 0x08;
> +
> +       return (packet[0] & 0x3c) == 0x3c &&
> +              (packet[1] & 0xf0) == 0x00 &&
> +              (packet[3] & 0x3e) == 0x38 &&
> +              (packet[4] & 0xf0) == 0x00;
> +}
> +
>  /*
>  * Process byte stream from mouse and handle complete packets
>  */
> @@ -398,7 +417,9 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>                break;
>
>        case 2:
> -               /* We don't know how to check parity in protocol v2 */
> +               if (etd->paritycheck && !packet_simple_check_v2(psmouse))
> +                       return PSMOUSE_BAD_DATA;
> +
>                elantech_report_absolute_v2(psmouse);
>                break;
>        }
> @@ -799,8 +820,7 @@ int elantech_init(struct psmouse *psmouse)
>                etd->hw_version = 2;
>                /* For now show extra debug information */
>                etd->debug = 1;
> -               /* Don't know how to do parity checking for version 2 */
> -               etd->paritycheck = 0;
> +               etd->paritycheck = 1;

If we always do some sort of check, can we just remove etd->paritycheck now?

>
>                if (etd->fw_version >= 0x020800)
>                        etd->reports_pressure = true;
> --
> 1.7.4.1
>
>
