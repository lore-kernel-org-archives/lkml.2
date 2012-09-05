Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab2IEJWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:22:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758379Ab2IEJW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:22:27 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789107"
Message-ID: <50471B23.4010308@cn.fujitsu.com>
Date: Wed, 05 Sep 2012 17:28:03 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: rob@landley.net, tglx@linutronix.de, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH v2 2/2] x86: reimplement mem boot option
References: <4FD99C88.2010002@cn.fujitsu.com> <4FD99CFA.6060801@cn.fujitsu.com> <503342A3.3060902@cn.fujitsu.com>
In-Reply-To: <503342A3.3060902@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:22:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:22:03,
	Serialize complete at 2012/09/05 17:22:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, H. Peter Anvin

Do you have time to review this patch?

Thanks
Wen Congyang

At 08/21/2012 04:11 PM, Wen Congyang Wrote:
> Current mem boot option only can work for non efi environment. If the user
> specifies add_efi_memmap, it cannot work for efi environment. In
> the efi environment, we call e820_add_region() to add the memory map. So
> we can modify __e820_add_region() and the mem boot option can work for
> efi environment.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  arch/x86/kernel/e820.c |   29 +++++++++++++++++++++++++----
>  1 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 4185797..20bc467 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
>  #ifdef CONFIG_PCI
>  EXPORT_SYMBOL(pci_mem_start);
>  #endif
> +static u64 mem_limit = ~0ULL;
>  
>  /*
>   * This function checks if any part of the range <start,end> is mapped
> @@ -119,6 +120,20 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
>  		return;
>  	}
>  
> +	if (start >= mem_limit) {
> +		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
> +		       (unsigned long long)start,
> +		       (unsigned long long)(start + size - 1));
> +		return;
> +	}
> +
> +	if (mem_limit - start < size) {
> +		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
> +		       (unsigned long long)mem_limit,
> +		       (unsigned long long)(start + size - 1));
> +		size = mem_limit - start;
> +	}
> +
>  	e820x->map[x].addr = start;
>  	e820x->map[x].size = size;
>  	e820x->map[x].type = type;
> @@ -809,7 +824,7 @@ static int userdef __initdata;
>  /* "mem=nopentium" disables the 4MB page tables. */
>  static int __init parse_memopt(char *p)
>  {
> -	u64 mem_size;
> +	char *oldp;
>  
>  	if (!p)
>  		return -EINVAL;
> @@ -825,11 +840,11 @@ static int __init parse_memopt(char *p)
>  	}
>  
>  	userdef = 1;
> -	mem_size = memparse(p, &p);
> +	oldp = p;
> +	mem_limit = memparse(p, &p);
>  	/* don't remove all of memory when handling "mem={invalid}" param */
> -	if (mem_size == 0)
> +	if (mem_limit == 0 || p == oldp)
>  		return -EINVAL;
> -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
>  
>  	return 0;
>  }
> @@ -881,6 +896,12 @@ early_param("memmap", parse_memmap_opt);
>  
>  void __init finish_e820_parsing(void)
>  {
> +	if (mem_limit != ~0ULL) {
> +		userdef = 1;
> +		e820_remove_range(mem_limit, ULLONG_MAX - mem_limit,
> +				  E820_RAM, 1);
> +	}
> +
>  	if (userdef) {
>  		u32 nr = e820.nr_map;
>  

