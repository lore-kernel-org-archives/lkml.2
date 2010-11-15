Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0KOGek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:34:40 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39326 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab0KOGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:34:38 -0500
Date: Mon, 15 Nov 2010 15:34:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [v2,1/8] NUMA Hotplug emulator
Message-ID: <20101115063406.GE8489@linux-sh.org>
References: <20101113061416.GK32501@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113061416.GK32501@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:14:16PM +0800, Shaohui Zheng wrote:
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 7bca3c6..1993275 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -971,6 +971,7 @@ static void early_panic(char *msg)
>  }
>  
>  static int userdef __initdata;
> +static u64 max_mem_size __initdata = ULLONG_MAX;
>  
>  /* "mem=nopentium" disables the 4MB page tables. */
>  static int __init parse_memopt(char *p)
> @@ -989,12 +990,28 @@ static int __init parse_memopt(char *p)
>  
>  	userdef = 1;
>  	mem_size = memparse(p, &p);
> -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
> +	max_mem_size = mem_size;
>  
>  	return 0;
>  }
>  early_param("mem", parse_memopt);
>  
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +u64 __init e820_hide_mem(u64 mem_size)
> +{
> +	u64 start, end_pfn;
> +
> +	userdef = 1;
> +	end_pfn = e820_end_of_ram_pfn();
> +	start = (end_pfn << PAGE_SHIFT) - mem_size;
> +	e820_remove_range(start, max_mem_size - start, E820_RAM, 1);
> +	max_mem_size = start;
> +
> +	return start;
> +}
> +#endif
> +

All of this could be done with the memblock API, it would be nice if
people would start building on top of that rather than constantly adding
pointless e820 wrappers.

As I also noted in my review of the first iteration of this patch series,
almost everything you have here is completely generic, please do not go
out of your way to create architectural dependence where none exists.
