Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1ANIO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:14:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1ANIOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:14:51 -0500
Date: Fri, 14 Jan 2011 01:14:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in
 parse_e820_ext
Message-ID: <20110114081446.GC21832@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-2-git-send-email-bigeasy@linutronix.de>
 <20101230083745.GC11721@angua.secretlab.ca>
 <20110104130839.GA21359@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104130839.GA21359@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Sebastian,

Can you please repost this series after the merge window closes?  Some
of the patches have been reworked and reposted, but I've kind of lost
track of which ones need my attention.  Also, some of the patches have
gone in via the tip tree, so it would be useful to regroup and figure
out which ones are no longer needed.

I'll be able to take a fresh look and pick up the ones that are ready
after the merge window closes.

Thanks,
g.


On Tue, Jan 04, 2011 at 02:08:39PM +0100, Sebastian Andrzej Siewior wrote:
> This patch ensures that the memory passed from parse_setup_data() is
> large enough to cover the complete data structure. That means that the
> conditional mapping in parse_e820_ext() can go.
> 
> While here, I also attempt not to map two pages if the address is not
> aligned to a page boundary.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/x86/include/asm/e820.h |    2 +-
>  arch/x86/kernel/e820.c      |    8 +-------
>  arch/x86/kernel/setup.c     |   18 +++++++++++++++---
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 5be1542..e956492 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -93,7 +93,7 @@ extern void e820_setup_gap(void);
>  extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
>  			unsigned long start_addr, unsigned long long end_addr);
>  struct setup_data;
> -extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
> +extern void parse_e820_ext(struct setup_data *data);
>  
>  #if defined(CONFIG_X86_64) || \
>  	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 0c2b7ef..33f6361 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -666,21 +666,15 @@ __init void e820_setup_gap(void)
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
> index 0afb8c7..48e240e 100644
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
