Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1LHCla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 21:41:30 -0500
Received: from imr4.ericy.com ([198.24.6.9]:55296 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1LHCl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 21:41:29 -0500
Date: Wed, 7 Dec 2011 18:40:01 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "trenn@suse.de" <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>
Subject: Re: [PATCH 06/10] HWMON: Convert coretemp to x86 cpuid autoprobing
Message-ID: <20111208024001.GA4912@ericsson.com>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
 <1323304882-27953-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323304882-27953-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Dec 07, 2011 at 07:41:19PM -0500, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Use the new x86 cpuid autoprobe interface for the Intel coretemp
> driver.
> 
> Cc: fenghua.yu@intel.com
> Cc: khali@linux-fr.org
> Cc: guenter.roeck@ericsson.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/hwmon/coretemp.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 104b376..5de1579 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -39,6 +39,7 @@
>  #include <linux/moduleparam.h>
>  #include <asm/msr.h>
>  #include <asm/processor.h>
> +#include <asm/cpu_device_id.h>
>  
>  #define DRVNAME	"coretemp"
>  
> @@ -756,13 +757,23 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
>  	.notifier_call = coretemp_cpu_callback,
>  };
>  
> +static struct x86_cpu_id coretemp_ids[] = {
> +	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);
> +
>  static int __init coretemp_init(void)
>  {
>  	int i, err = -ENODEV;
>  
> -	/* quick check if we run Intel */
> -	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
> -		goto exit;
> +	/*
> +	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
> +	 * sensors. We check this bit only, all the early CPUs
> +	 * without thermal sensors will be filtered out.
> +	 */
> +	if (!x86_match_cpu(coretemp_ids))
> +		return -ENODEV;
>  

X86_FEATURE_DTS is checked elsewhere in the driver, in function get_core_online().
Can that check be removed ?

Guenter

>  	err = platform_driver_register(&coretemp_driver);
>  	if (err)
> -- 
> 1.7.4.4
> 
