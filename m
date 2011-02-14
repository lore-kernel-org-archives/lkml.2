Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1BNW7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:59:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1BNW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=prnQhXhcNv+7I1tC+VV6avjEi+XiAzAdJjFYMlY1S0ksoRny/rxs1tZ8eOCS06+gmS
         /544tQg/WiTn0HDPw91sfT1GbTK2hPLH7HepoK9/36pg9TZSGYaeJ8vgActGTM3ZQ+vn
         8dWas6m+toZf89oR4KYIIOYwkVqAMzpbYSRV4=
Message-ID: <4D59B3CE.7010408@gmail.com>
Date: Tue, 15 Feb 2011 01:59:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization
 from amd_scan_nodes() to amd_numa_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-11-git-send-email-tj@kernel.org>
In-Reply-To: <1297530663-26234-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 08:10 PM, Tejun Heo wrote:
> This brings amd initialization behavior closer to that of acpi.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: Brian Gerst<brgerst@gmail.com>
> Cc: Cyrill Gorcunov<gorcunov@gmail.com>
> Cc: Shaohui Zheng<shaohui.zheng@intel.com>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: H. Peter Anvin<hpa@linux.intel.com>
> ---
>   arch/x86/mm/amdtopology_64.c |   40 ++++++++++++++++++++++------------------
>   1 files changed, 22 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
> index c5eddfa..4056333 100644
> --- a/arch/x86/mm/amdtopology_64.c
> +++ b/arch/x86/mm/amdtopology_64.c
> @@ -74,8 +74,9 @@ int __init amd_numa_init(void)
>   	unsigned long end = PFN_PHYS(max_pfn);
>   	unsigned numnodes;
>   	unsigned long prevbase;
> -	int i, nb;
> +	int i, j, nb;
>   	u32 nodeid, reg;
> +	unsigned int bits, cores, apicid_base;
>
>   	if (!early_pci_allowed())
>   		return -EINVAL;
> @@ -176,6 +177,26 @@ int __init amd_numa_init(void)
>
>   	if (!nodes_weight(mem_nodes_parsed))
>   		return -ENOENT;
> +
> +	/*
> +	 * We seem to have valid NUMA configuration.  Map apicids to nodes
> +	 * using the coreid bits from early_identify_cpu.
> +	 */
> +	bits = boot_cpu_data.x86_coreid_bits;
> +	cores = 1<<  bits;
> +	apicid_base = 0;
> +
> +	/* get the APIC ID of the BSP early for systems with apicid lifting */
> +	early_get_boot_cpu_id();
> +	if (boot_cpu_physical_apicid>  0) {
> +		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
> +		apicid_base = boot_cpu_physical_apicid;
		^^^
> +	}
> +
> +	for_each_node_mask(i, cpu_nodes_parsed)
> +		for (j = apicid_base; j<  cores + apicid_base; j++)
> +			set_apicid_to_node((i<<  bits) + j, i);
> +
>   	return 0;
>   }
>

   Hi Tejun, while you at it, it seems apicid_base conditional assignment is
redundant here (boot_cpu_physical_apicid is unsigned int) so we might have
something like

	apicid_start	= boot_cpu_physical_apicid;
	apicid_end	= apicid_start + cores;

	for_each_node_mask(i, cpu_nodes_parsed) {
		for (j = apicid_start; j <  apicid_end; j++)
			set_apicid_to_node((i <<  bits) + j, i);
	}

  But of course it should be considered as followup update just to not
mess the things. (probably need to check if we ever may reach this point
with boot_cpu_physical_apicid = -1U). Just a thought.
-- 
     Cyrill
