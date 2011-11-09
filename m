Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab1KIV0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:26:36 -0500
Received: from mother.ludd.ltu.se ([130.240.16.3]:53743 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1KIV0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:26:35 -0500
X-Greylist: delayed 2086 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 16:26:34 EST
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=iso-8859-1
From: Nils Carlson <nils.carlson@ludd.ltu.se>
In-Reply-To: <20111109203546.GI14181@aftab>
Date: Wed, 9 Nov 2011 21:51:18 +0100
Cc: =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ericsson.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BDAE4D65-0E5E-4F35-B651-5332D17BDADC@ludd.ltu.se>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com> <20111109144258.GD30472@aftab> <4EBA98A1.90902@ericsson.com> <20111109203546.GI14181@aftab>
To: Borislav Petkov <bp@amd64.org>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Nov 9, 2011, at 9:35 PM, Borislav Petkov wrote:

> Hi Niklas,
> 
> On Wed, Nov 09, 2011 at 04:13:37PM +0100, Niklas Söderlund wrote:
>> The decoding table from the documentation:
>> 

>> <snip>

>> - It do not consider the out of order values of cs_mode values 4-7:
>> 256, 512, 256, 512.
> 
> Agreed, thanks for reporting this. However, I removed the static tables
> at the time because I didn't want to carry unnecessary weight around for
> no reason (tables were static back then). And I know, they're small but
> dead weight like that tends to accumulate.
> 
> Your approach is ok with creating the lookup table on the stack but how
> about the following instead - it is much smaller and it is only code,
> no need for stack memory at all. It should give you the proper mapping,
> IINM.
> 

I have to say that I much prefer Niklas approach, the code below is difficult
to understand compared to the table, and seeing as the data sheet contains
the table it's much easier for a reader to understand the correspondance.

Cheers,
Nils Carlson

> --
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index c9eee6d33e9a..3702f20d784e 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1132,12 +1132,12 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
> 		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
> 	}
> 	else if (pvt->ext_model >= K8_REV_D) {
> +		unsigned diff;
> 		WARN_ON(cs_mode > 10);
> 
> -		if (cs_mode == 3 || cs_mode == 8)
> -			return 32 << (cs_mode - 1);
> -		else
> -			return 32 << cs_mode;
> +		diff = cs_mode / 3 + (unsigned)(cs_mode > 5);
> +
> +		return 32 << (cs_mode - diff);
> 	}
> 	else {
> 		WARN_ON(cs_mode > 6);
> --
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

