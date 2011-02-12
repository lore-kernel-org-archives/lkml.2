Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1BLRyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:54:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48401 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1BLRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:54:28 -0500
Message-ID: <4D56C8EA.5000000@kernel.org>
Date: Sat, 12 Feb 2011 09:52:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 01/26] x86-64, NUMA: Make dummy node initialization path
 similar to non-dummy ones
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-2-git-send-email-tj@kernel.org>
In-Reply-To: <1297530663-26234-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D56C945.00BA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 09:10 AM, Tejun Heo wrote:
> Dummy node initialization in initmem_init() didn't initialize apicid
> to node mapping and set cpu to node mapping directly by caling
> numa_set_node(), which is different from non-dummy init paths.
> 
> Update it such that they behave similarly.  Initialize apicid to node
> mapping and call numa_init_array().  The actual cpu to node mapping is
> handled by init_cpu_to_node() later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/mm/numa_64.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index f548fbf..ea5dd48 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -623,10 +623,11 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
>  	memnodemap[0] = 0;
>  	node_set_online(0);
>  	node_set(0, node_possible_map);
> -	for (i = 0; i < nr_cpu_ids; i++)
> -		numa_set_node(i, 0);
> +	for (i = 0; i < MAX_LOCAL_APIC; i++)
> +		set_apicid_to_node(i, NUMA_NO_NODE);
>  	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
>  	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
> +	numa_init_array();
>  }
>  
>  unsigned long __init numa_free_all_bootmem(void)

Acked-by: Yinghai Lu <yinghai@kernel.org>
