Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1FVEWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 00:22:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1FVEWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 00:22:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jun 2011 13:15:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: Re: mm: Fix page_end_pfn() implementations.
Message-Id: <20110622131542.884cbbb1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110621.211141.964267743068211890.davem@davemloft.net>
References: <20110621.211141.964267743068211890.davem@davemloft.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 21:11:41 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> Commit 37573e8c718277103f61f03741bdc5606d31b07e ("memcg: fix
> init_page_cgroup nid with sparsemem") broke the build on sparc64
> because this is the first time the page_end_pfn() interface has
> actually been used in a long time, and sparc64's definition
> referes to ->node_end_pfn which doesn't even exist.
> 
> While fixing this I noticed powerpc had the same problem, and
> m32r's version had an off-by-one error.
> 
> These are all fixed here.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Sorry, a patch is now queued in mmotm, as

http://marc.info/?l=linux-mm-commits&m=130834703319994&w=2

Thanks,
-Kame

> 
> diff --git a/arch/m32r/include/asm/mmzone.h b/arch/m32r/include/asm/mmzone.h
> index 9f3b5ac..31238e0 100644
> --- a/arch/m32r/include/asm/mmzone.h
> +++ b/arch/m32r/include/asm/mmzone.h
> @@ -18,7 +18,7 @@ extern struct pglist_data *node_data[];
>  #define node_end_pfn(nid)						\
>  ({									\
>  	pg_data_t *__pgdat = NODE_DATA(nid);				\
> -	__pgdat->node_start_pfn + __pgdat->node_spanned_pages - 1;	\
> +	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
>  })
>  
>  #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
> diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
> index fd3fd58..86bf6ac 100644
> --- a/arch/powerpc/include/asm/mmzone.h
> +++ b/arch/powerpc/include/asm/mmzone.h
> @@ -43,7 +43,8 @@ u64 memory_hotplug_max(void);
>   */
>  
>  #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
> -#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
> +#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
> +				 NODE_DATA(nid)->node_spanned_pages)
>  
>  #else
>  #define memory_hotplug_max() memblock_end_of_DRAM()
> diff --git a/arch/sparc/include/asm/mmzone.h b/arch/sparc/include/asm/mmzone.h
> index e8c6487..a321b04 100644
> --- a/arch/sparc/include/asm/mmzone.h
> +++ b/arch/sparc/include/asm/mmzone.h
> @@ -9,7 +9,8 @@ extern struct pglist_data *node_data[];
>  
>  #define NODE_DATA(nid)		(node_data[nid])
>  #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
> -#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
> +#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
> +				 NODE_DATA(nid)->node_spanned_pages)
>  
>  extern int numa_cpu_lookup_table[];
>  extern cpumask_t numa_cpumask_lookup_table[];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

