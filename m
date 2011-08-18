Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1HRDIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:08:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1HRDI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:08:29 -0400
Message-ID: <4E4C81EB.7040303@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 11:07:23 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 4/6] Input: elantech - work around EC buffer
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:07:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:07:13,
	Serialize complete at 2011-08-18 11:07:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 09:57 AM, JJ Ding wrote:
> With some EC chips, when we resync due to bad packets, those bad bytes would
> still remain in EC's buffer area. That makes us always get bad data back,
> no matter what.
>
> So shift packet for 1 byte when encounter bad packet, until we get rid of those
> bytes.
>
> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
> ---
>   drivers/input/mouse/elantech.c |    9 +++++++--
>   1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 032181c..7b9b6e5 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -411,20 +411,25 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>   	switch (etd->hw_version) {
>   	case 1:
>   		if (etd->paritycheck&&  !elantech_check_parity_v1(psmouse))
> -			return PSMOUSE_BAD_DATA;
> +			goto bad_packet;
>
>   		elantech_report_absolute_v1(psmouse);
>   		break;
>
>   	case 2:
>   		if (etd->paritycheck&&  !packet_simple_check_v2(psmouse))
> -			return PSMOUSE_BAD_DATA;
> +			goto bad_packet;
>
>   		elantech_report_absolute_v2(psmouse);
>   		break;
>   	}
>
>   	return PSMOUSE_FULL_PACKET;
> +
> + bad_packet:
You may introduce space here.
> +	memmove(psmouse->packet, psmouse->packet + 1, psmouse->pktsize - 1);
> +	psmouse->pktcnt--;
> +	return PSMOUSE_GOOD_DATA;
>   }
>
>   /*


-- 
Thanks
Wanlong Gao
