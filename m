Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1LHKvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:51:23 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:42753 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1LHKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:51:21 -0500
Date: Thu, 8 Dec 2011 11:51:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, guenter.roeck@ericsson.com
Subject: Re: [PATCH 05/10] HWMON: Convert via-cputemp to x86 cpuid
 autoprobing
Message-ID: <20111208115111.3b4a1069@endymion.delvare>
In-Reply-To: <1323304882-27953-6-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	<1323304882-27953-6-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Dec 2011 16:41:18 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Use the new x86 cpuid autoprobe interface.
> 
> Cc: khali@linux-fr.org
> Cc: guenter.roeck@ericsson.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/hwmon/via-cputemp.c |   29 +++++++++++------------------
>  1 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
> index 8eac67d..36ddb83 100644
> --- a/drivers/hwmon/via-cputemp.c
> +++ b/drivers/hwmon/via-cputemp.c
> @@ -37,6 +37,7 @@
>  #include <linux/cpu.h>
>  #include <asm/msr.h>
>  #include <asm/processor.h>
> +#include <asm/cpu_device_id.h>
>  
>  #define DRVNAME	"via_cputemp"
>  
> @@ -308,34 +309,26 @@ static struct notifier_block via_cputemp_cpu_notifier __refdata = {
>  	.notifier_call = via_cputemp_cpu_callback,
>  };
>  
> +static struct x86_cpu_id cputemp_ids[] = {

Shall be const.

> +	{ X86_VENDOR_CENTAUR, 6, 0xa, }, /* C7a */
> +	{ X86_VENDOR_CENTAUR, 6, 0xd, }, /* C7d */

Better spelt "C7 A" and "C7 D".

> +	{ X86_VENDOR_CENTAUR, 6, 0xf, }, /* Nano */
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, cputemp_ids);
> +
>  static int __init via_cputemp_init(void)
>  {
>  	int i, err;
>  
> -	if (cpu_data(0).x86_vendor != X86_VENDOR_CENTAUR) {
> -		printk(KERN_DEBUG DRVNAME ": Not a VIA CPU\n");
> -		err = -ENODEV;
> -		goto exit;
> -	}
> +	if (!x86_match_cpu(cputemp_ids))
> +		return -ENODEV;
>  
>  	err = platform_driver_register(&via_cputemp_driver);
>  	if (err)
>  		goto exit;
>  
>  	for_each_online_cpu(i) {
> -		struct cpuinfo_x86 *c = &cpu_data(i);
> -
> -		if (c->x86 != 6)
> -			continue;
> -
> -		if (c->x86_model < 0x0a)
> -			continue;
> -
> -		if (c->x86_model > 0x0f) {
> -			pr_warn("Unknown CPU model 0x%x\n", c->x86_model);
> -			continue;
> -		}

Here again, the per-cpu check was intended, and I would like to
preserve that (even though SMP systems based on VIA CPUs must be
rare...)

> -
>  		via_cputemp_device_add(i);
>  	}
>  


-- 
Jean Delvare
