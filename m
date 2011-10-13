Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1JMQLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:11:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:11719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab1JMQLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,341,1315206000"; 
   d="scan'208";a="73286423"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andi Kleen <andi@firstfloor.org>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "jbeulich@novell.com" <jbeulich@novell.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Date: Thu, 13 Oct 2011 09:11:38 -0700
Subject: RE: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v3
Thread-Topic: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v3
Thread-Index: AcyJQZcvWLzIV0ULQHClg0W3e9R5GQAgOIfg
Message-ID: <493994B35A117E4F832F97C4719C4C0401370C23C9@orsmsx505.amr.corp.intel.com>
References: <1318466795-7393-1-git-send-email-andi@firstfloor.org>
 <1318466795-7393-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1318466795-7393-3-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Wednesday, October 12, 2011 5:47 PM
> To: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org; Andi Kleen; jbeulich@novell.com; Yu,
> Fenghua; khali@linux-fr.org
> Subject: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v3
> 
> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the ucode revision is available in cpu_data remove
> the existing code in coretemp.c to query it manually. Read the ucode
> revision from cpu_data instead
> 
> v2: Fix misplaced variable init. Remove unused variables.
> v3: Port to latest tree
> Cc: jbeulich@novell.com
> Cc: fenghua.yu@intel.com
> Cc: khali@linux-fr.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/hwmon/coretemp.c |   28 ++++------------------------
>  1 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 9323837..ce18c04 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -325,15 +325,6 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id,
> struct device *dev)
>  	return adjust_tjmax(c, id, dev);
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
>  static int create_name_attr(struct platform_data *pdata, struct device
> *dev)
>  {
>  	sysfs_attr_init(&pdata->name_attr.attr);
> @@ -380,27 +371,16 @@ exit_free:
>  static int __cpuinit chk_ucode_version(unsigned int cpu)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -	int err;
> -	u32 edx;
> 
>  	/*
>  	 * Check if we have problem with errata AE18 of Core processors:
>  	 * Readings might stop update when processor visited too deep
> sleep,
>  	 * fixed for stepping D0 (6EC).
>  	 */
> -	if (c->x86_model == 0xe && c->x86_mask < 0xc) {
> -		/* check for microcode update */
> -		err = smp_call_function_single(cpu, get_ucode_rev_on_cpu,
> -					       &edx, 1);
> -		if (err) {
> -			pr_err("Cannot determine microcode revision of "
> -			       "CPU#%u (%d)!\n", cpu, err);
> -			return -ENODEV;
> -		} else if (edx < 0x39) {
> -			pr_err("Errata AE18 not fixed, update BIOS or "
> -			       "microcode of the CPU!\n");
> -			return -ENODEV;
> -		}
> +	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->microcode <
> 0x39) {
> +		pr_err("Errata AE18 not fixed, update BIOS or "
> +		       "microcode of the CPU!\n");
> +		return -ENODEV;
>  	}
>  	return 0;
>  }
> --
> 1.7.4.4

Acked-by: Fenghua Yu <fenghua.yu@intel.com>

