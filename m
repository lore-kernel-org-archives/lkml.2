Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2K2KlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:41:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2K2KlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:41:00 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50B73BA0.4060406@jp.fujitsu.com>
Date: Thu, 29 Nov 2012 19:40:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 02/46] x86, mm: Split out split_mem_range from init_memory_mapping
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org> <1354139277-17376-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1354139277-17376-3-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/29 6:47, Yinghai Lu wrote:
> So make init_memory_mapping smaller and readable.
> 
> -v2: use 0 instead of nr_range as input parameter found by Yasuaki Ishimatsu.
> 
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

>   arch/x86/mm/init.c |   41 +++++++++++++++++++++++++----------------
>   1 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index aa5b0da..6368b86 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -146,25 +146,13 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
>   	return nr_range;
>   }
>   
> -/*
> - * Setup the direct mapping of the physical memory at PAGE_OFFSET.
> - * This runs before bootmem is initialized and gets pages directly from
> - * the physical memory. To access them they are temporarily mapped.
> - */
> -unsigned long __init_refok init_memory_mapping(unsigned long start,
> -					       unsigned long end)
> +static int __meminit split_mem_range(struct map_range *mr, int nr_range,
> +				     unsigned long start,
> +				     unsigned long end)
>   {
>   	unsigned long start_pfn, end_pfn;
> -	unsigned long ret = 0;
>   	unsigned long pos;
> -	struct map_range mr[NR_RANGE_MR];
> -	int nr_range, i;
> -
> -	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
> -	       start, end - 1);
> -
> -	memset(mr, 0, sizeof(mr));
> -	nr_range = 0;
> +	int i;
>   
>   	/* head if not big page alignment ? */
>   	start_pfn = start >> PAGE_SHIFT;
> @@ -258,6 +246,27 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>   			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
>   			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
>   
> +	return nr_range;
> +}
> +
> +/*
> + * Setup the direct mapping of the physical memory at PAGE_OFFSET.
> + * This runs before bootmem is initialized and gets pages directly from
> + * the physical memory. To access them they are temporarily mapped.
> + */
> +unsigned long __init_refok init_memory_mapping(unsigned long start,
> +					       unsigned long end)
> +{
> +	struct map_range mr[NR_RANGE_MR];
> +	unsigned long ret = 0;
> +	int nr_range, i;
> +
> +	pr_info("init_memory_mapping: [mem %#010lx-%#010lx]\n",
> +	       start, end - 1);
> +
> +	memset(mr, 0, sizeof(mr));
> +	nr_range = split_mem_range(mr, 0, start, end);
> +
>   	/*
>   	 * Find space for the kernel direct mapping tables.
>   	 *
> 


