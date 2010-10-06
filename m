Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab0JFTl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:41:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41733 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab0JFTl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vMB62s2CVpFWz0FVlGAaoph6g2eNluA4/ZoytiNYPChz6+wzu2ZdhHQGgEVr6eD42W
         5YVc1CkBUGNG/qQPr4NN4GH8JlFVzLcthKQx670Nr342mv1KiHu7Opw056CtRlm5+2sO
         p4Fdn/AMYWMqZHafZUAlcClszDc26FjpbKXr4=
Date: Wed, 6 Oct 2010 23:41:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] apic, x86: Use BIOS settings for IBS and MCE
	threshold interrupt LVT offsets
Message-ID: <20101006194150.GA17647@lenovo>
References: <1286360874-1471-1-git-send-email-robert.richter@amd.com> <1286360874-1471-3-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286360874-1471-3-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:27:54PM +0200, Robert Richter wrote:
> We want the BIOS to setup the EILVT APIC registers. The offsets were
> hardcoded and BIOS settings were overwritten by the OS. Now, the
> subsystems for MCE threshold and IBS determine the LVT offset from the
> registers the BIOS has setup. If the BIOS setup is buggy on a family
> 10h system, a workaround enables IBS. If the OS determines an invalid
> register setup, a "[Firmware Bug]: " error message is reported.
> 
> We need this change also for upcomming cpu families.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---

Hi Robert, a few comments

...  
>  /*
>   * Program the next event, relative to now
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 5e97529..e13d4bd 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -131,7 +131,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  	u32 low = 0, high = 0, address = 0;
>  	unsigned int bank, block;
>  	struct thresh_restart tr;
> -	u8 lvt_off;
> +	int lvt_off = -1;
> +	u8 offset;
>  
>  	for (bank = 0; bank < NR_BANKS; ++bank) {
>  		for (block = 0; block < NR_BLOCKS; ++block) {
> @@ -165,8 +166,28 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  			if (shared_bank[bank] && c->cpu_core_id)
>  				break;
>  #endif
> -			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
> -						       APIC_EILVT_MSG_FIX, 0);
> +			offset = (high & MASK_LVTOFF_HI) >> 20;
> +			if (lvt_off < 0) {
> +				if (setup_APIC_eilvt(offset,
> +						     THRESHOLD_APIC_VECTOR,
> +						     APIC_EILVT_MSG_FIX, 0)) {
> +					pr_err(FW_BUG "cpu %d, failed to "
> +					       "setup threshold interrupt "
> +					       "for bank %d, block %d "
> +					       "(MSR%08X=0x%x%08x)",
> +					       smp_processor_id(), bank, block,
> +					       address, high, low);
> +					continue;
> +				}
> +				lvt_off = offset;
> +			} else if (lvt_off != offset) {

Could we put explicit type specificator here? For better readbility.
...

> +static int force_ibs_eilvt_setup(void)
> +{
> +	int i;
> +	int ret;
> +
> +	/* find the next free available EILVT entry */
> +	for (i = 1; i < 4; i++) {

APIC_EILVT_NR_MAX here, no?

> +		if (!eilvt_is_available(i))
> +			continue;
> +		ret = setup_ibs_ctl(i);
> +		if (ret)
> +			return ret;
> +		return 0;
>  	}
>  
 
  Cyrill
