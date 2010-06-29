Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0F2SCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:02:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43438 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0F2SCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:02:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 23/25] x86: Have nobootmem version setup_bootmem_allocator()
Date: Tue, 29 Jun 2010 12:02:57 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-24-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-24-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291202.58730.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:52 am Yinghai Lu wrote:
> We can reduce #ifdef number from 3 to one in init_32.c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_32.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index e3ae067..f172aa3 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -771,11 +771,9 @@ static unsigned long __init setup_node_bootmem(int nodeid,
>  
>  	return bootmap + bootmap_size;
>  }
> -#endif
>  
>  void __init setup_bootmem_allocator(void)
>  {
> -#ifndef CONFIG_NO_BOOTMEM
>  	int nodeid;
>  	unsigned long bootmap_size, bootmap;
>  	/*
> @@ -787,13 +785,11 @@ void __init setup_bootmem_allocator(void)
>  	if (bootmap == (unsigned long)LMB_ERROR)
>  		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
>  	lmb_reserve_range(bootmap, bootmap + bootmap_size, "BOOTMAP");
> -#endif
>  
>  	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
>  		 max_pfn_mapped<<PAGE_SHIFT);
>  	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
>  
> -#ifndef CONFIG_NO_BOOTMEM
>  	for_each_online_node(nodeid) {
>  		 unsigned long start_pfn, end_pfn;
>  
> @@ -811,10 +807,19 @@ void __init setup_bootmem_allocator(void)
>  		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
>  						 bootmap);
>  	}
> -#endif
>  
>  	after_bootmem = 1;
>  }
> +#else
> +void __init setup_bootmem_allocator(void)
> +{
> +	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
> +		 max_pfn_mapped<<PAGE_SHIFT);
> +	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);

Please use %pR format here and fix up the other printks above in the
other #ifdef branch.

> +
> +	after_bootmem = 1;
> +}
> +#endif
>  
>  /*
>   * paging_init() sets up the page tables - note that the first 8MB are
> 
