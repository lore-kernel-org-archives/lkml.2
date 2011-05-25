Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1EYUzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:55:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10242 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1EYUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:55:36 -0400
Date: Wed, 25 May 2011 22:53:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, jbeulich@novell.com,
        fenghua.yu@intel.com
Subject: Re: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v2
Message-ID: <20110525225359.60d819d5@endymion.delvare>
In-Reply-To: <1306351948-23382-3-git-send-email-andi@firstfloor.org>
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
	<1306351948-23382-3-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, 25 May 2011 12:32:28 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the ucode revision is available in cpu_data remove
> the existing code in coretemp.c to query it manually. Read the ucode
> revision from cpu_data instead

Where is this available? Not upstream yet, apparently. I get a build
failure here.

> 
> v2: Fix misplaced variable init. Remove unused variables.
> Cc: jbeulich@novell.com
> Cc: fenghua.yu@intel.com
> Cc: khali@linux-fr.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/hwmon/coretemp.c |   31 +++++--------------------------
>  1 files changed, 5 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 9577c43..eec29d6 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -324,15 +324,6 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
>  	}
>  }
>  
> -static void __devinit get_ucode_rev_on_cpu(void *edx)
> -{
> -	u32 eax;
> -
> -	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> -	sync_core();
> -	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
> -}
> -
>  static int get_pkg_tjmax(unsigned int cpu, struct device *dev)
>  {
>  	int err;
> @@ -425,29 +416,17 @@ static void update_ttarget(__u8 cpu_model, struct temp_data *tdata,
>  static int chk_ucode_version(struct platform_device *pdev)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(pdev->id);
> -	int err;
> -	u32 edx;
>  
>  	/*
>  	 * Check if we have problem with errata AE18 of Core processors:
>  	 * Readings might stop update when processor visited too deep sleep,
>  	 * fixed for stepping D0 (6EC).
>  	 */
> -	if (c->x86_model == 0xe && c->x86_mask < 0xc) {
> -		/* check for microcode update */
> -		err = smp_call_function_single(pdev->id, get_ucode_rev_on_cpu,
> -					       &edx, 1);

As a side note, this is fixing a section mismatch, as
get_ucode_rev_on_cpu() was declared __devinit but chk_ucode_version()
isn't. Thankfully this doesn't affect previous kernels. As far as I can
see, chk_ucode_version could be made __devinit. I'll send a patch.

> -		if (err) {
> -			dev_err(&pdev->dev,
> -				"Cannot determine microcode revision of "
> -				"CPU#%u (%d)!\n", pdev->id, err);
> -			return -ENODEV;
> -		} else if (edx < 0x39) {
> -			dev_err(&pdev->dev,
> -				"Errata AE18 not fixed, update BIOS or "
> -				"microcode of the CPU!\n");
> -			return -ENODEV;
> -		}
> +	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->cpu_update < 0x39) {
> +		dev_err(&pdev->dev,
> +			"Errata AE18 not fixed, update BIOS or "
> +			"microcode of the CPU!\n");
> +		return -ENODEV;
>  	}
>  	return 0;
>  }

This all looks reasonable, but I am not able to test it.

-- 
Jean Delvare
