Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1BCU5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:57:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60459 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1BCU5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:57:13 -0500
Date: Thu, 3 Feb 2011 13:57:07 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH TIP 01/14] x86/e820: remove conditional early mapping
 in parse_e820_ext
Message-ID: <20110203205707.GG6180@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:58:49AM +0530, Sebastian Andrzej Siewior wrote:
> This patch ensures that the memory passed from parse_setup_data() is
> large enough to cover the complete data structure. That means that the
> conditional mapping in parse_e820_ext() can go.
> 
> While here, I also attempt not to map two pages if the address is not
> aligned to a page boundary.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

I'm going through the dt patches now.  If I decide they are ready to
go, should I pick this one up too?  hpa, does this look like something
you can ack?

g.

> ---
>  arch/x86/include/asm/e820.h |    2 +-
>  arch/x86/kernel/e820.c      |    8 +-------
>  arch/x86/kernel/setup.c     |   18 +++++++++++++++---
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index e99d55d..908b969 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -96,7 +96,7 @@ extern void e820_setup_gap(void);
>  extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
>  			unsigned long start_addr, unsigned long long end_addr);
>  struct setup_data;
> -extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
> +extern void parse_e820_ext(struct setup_data *data);
>  
>  #if defined(CONFIG_X86_64) || \
>  	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 294f26d..5fad626 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -667,21 +667,15 @@ __init void e820_setup_gap(void)
>   * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
>   * linked list of struct setup_data, which is parsed here.
>   */
> -void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
> +void __init parse_e820_ext(struct setup_data *sdata)
>  {
> -	u32 map_len;
>  	int entries;
>  	struct e820entry *extmap;
>  
>  	entries = sdata->len / sizeof(struct e820entry);
> -	map_len = sdata->len + sizeof(struct setup_data);
> -	if (map_len > PAGE_SIZE)
> -		sdata = early_ioremap(pa_data, map_len);
>  	extmap = (struct e820entry *)(sdata->data);
>  	__append_e820_map(extmap, entries);
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
> -	if (map_len > PAGE_SIZE)
> -		early_iounmap(sdata, map_len);
>  	printk(KERN_INFO "extended physical RAM map:\n");
>  	e820_print_map("extended");
>  }
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index d3cfe26..f8e7152 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -429,16 +429,28 @@ static void __init parse_setup_data(void)
>  		return;
>  	pa_data = boot_params.hdr.setup_data;
>  	while (pa_data) {
> -		data = early_memremap(pa_data, PAGE_SIZE);
> +		u32 data_len;
> +		u32 map_len;
> +
> +		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
> +				(u64)sizeof(struct setup_data));
> +		data = early_memremap(pa_data, map_len);
> +		data_len = data->len + sizeof(struct setup_data);
> +		if (data_len > map_len) {
> +			early_iounmap(data, map_len);
> +			data = early_memremap(pa_data, data_len);
> +			map_len = data_len;
> +		}
> +
>  		switch (data->type) {
>  		case SETUP_E820_EXT:
> -			parse_e820_ext(data, pa_data);
> +			parse_e820_ext(data);
>  			break;
>  		default:
>  			break;
>  		}
>  		pa_data = data->next;
> -		early_iounmap(data, PAGE_SIZE);
> +		early_iounmap(data, map_len);
>  	}
>  }
>  
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
