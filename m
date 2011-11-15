Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1KOIK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:10:58 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:48688 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1KOIK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:10:56 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-61-4ec21e8eda37
Message-ID: <4EC21E8E.5050003@ericsson.com>
Date: Tue, 15 Nov 2011 09:10:54 +0100
From: =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@gmail.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Fix K8 revD and later chip select sizes
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com> <20111109144258.GD30472@aftab> <4EBA98A1.90902@ericsson.com> <20111109203546.GI14181@aftab> <CA+8MBbLuhhTZW9vB7GvLCd8Uu7bgfUqkO7wu4=Pt7EWyQx0LrQ@mail.gmail.com> <20111109210052.GJ14181@aftab> <20111114165459.GA29762@aftab>
In-Reply-To: <20111114165459.GA29762@aftab>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14 Nov 2011 05:54:59 PM CET, Borislav Petkov wrote:
>
> Fix DRAM chip select sizes calculation for K8, revisions D and E.
>
> Reported-by: Niklas Söderlund<niklas.soderlund@ericsson.com
> Link: http://lkml.kernel.org/r/1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com
> Signed-off-by: Borislav Petkov<borislav.petkov@amd.com>
> ---
>
> @Niklas: would you please verify this patch fixes your issue?
>
> Thanks.
>
>   drivers/edac/amd64_edac.c |   32 ++++++++++++++++++++++++++++----
>   1 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index c9eee6d..6a83d49 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1132,12 +1132,36 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>   		return ddr2_cs_size(cs_mode, dclr&  WIDTH_128);
>   	}
>   	else if (pvt->ext_model>= K8_REV_D) {
> +		unsigned diff;
>   		WARN_ON(cs_mode>  10);
>
> -		if (cs_mode == 3 || cs_mode == 8)
> -			return 32<<  (cs_mode - 1);
> -		else
> -			return 32<<  cs_mode;
> +		/*
> +		 * the below calculation, besides trying to win an obfuscated C
> +		 * contest, maps cs_mode values to DIMM chip select sizes. The
> +		 * mappings are:
> +		 *
> +		 * cs_mode	CS size (mb)
> +		 * =======	============
> +		 * 0		32
> +		 * 1		64
> +		 * 2		128
> +		 * 3		128
> +		 * 4		256
> +		 * 5		512
> +		 * 6		256
> +		 * 7		512
> +		 * 8		1024
> +		 * 9		1024
> +		 * 10		2048
> +		 *
> +		 * Basically, it calculates a value with which to shift the
> +		 * smallest CS size of 32MB.
> +		 *
> +		 * ddr[23]_cs_size have a similar purpose.
> +		 */
> +		diff = cs_mode/3 + (unsigned)(cs_mode>  5);
> +
> +		return 32<<  (cs_mode - diff);
>   	}
>   	else {
>   		WARN_ON(cs_mode>  6);

Hi Borislav,

Yes the patch fixes my problem, but it truly is obfuscated C.

Thanks
// Niklas
