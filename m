Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2F3PrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 11:47:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48423 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2F3PrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 11:47:08 -0400
Message-ID: <4FEF1F6A.6090705@gmail.com>
Date: Sat, 30 Jun 2012 23:46:50 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9DB1.7010303@jp.fujitsu.com>
In-Reply-To: <4FEA9DB1.7010303@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 01:44 PM, Yasuaki Ishimatsu wrote:
> When offline_pages() is called to offlined memory, the function fails since
> all memory has been offlined. In this case, the function should succeed.
> The patch adds the check function into offline_pages().
> 
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  drivers/base/memory.c  |   20 ++++++++++++++++++++
>  include/linux/memory.h |    1 +
>  mm/memory_hotplug.c    |    5 +++++
>  3 files changed, 26 insertions(+)
> 
> Index: linux-3.5-rc4/drivers/base/memory.c
> ===================================================================
> --- linux-3.5-rc4.orig/drivers/base/memory.c	2012-06-26 13:28:16.726211752 +0900
> +++ linux-3.5-rc4/drivers/base/memory.c	2012-06-26 13:34:22.423639904 +0900
> @@ -70,6 +70,26 @@ void unregister_memory_isolate_notifier(
>  }
>  EXPORT_SYMBOL(unregister_memory_isolate_notifier);
> 
> +bool memory_is_offline(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	struct memory_block *mem;
> +	struct mem_section *section;
> +	unsigned long pfn, section_nr;
> +
> +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		section_nr = pfn_to_section_nr(pfn);
> +		section = __nr_to_section(section_nr);
Is it possible for __nr_to_section return NULL here?

> +		mem = find_memory_block(section);
> +		if (!mem)
> +			continue;
> +		if (mem->state == MEM_OFFLINE)
> +			continue;
> +		return false;
> +	}
> +
> +	return true;
> +}
Need a put_dev(&mem->dev) for the last memory block device handled before return.

> +
>  /*
>   * register_memory - Setup a sysfs device for a memory block
>   */
> Index: linux-3.5-rc4/include/linux/memory.h
> ===================================================================
> --- linux-3.5-rc4.orig/include/linux/memory.h	2012-06-25 04:53:04.000000000 +0900
> +++ linux-3.5-rc4/include/linux/memory.h	2012-06-26 13:34:22.424639891 +0900
> @@ -120,6 +120,7 @@ extern int memory_isolate_notify(unsigne
>  extern struct memory_block *find_memory_block_hinted(struct mem_section *,
>  							struct memory_block *);
>  extern struct memory_block *find_memory_block(struct mem_section *);
> +extern bool memory_is_offline(unsigned long start_pfn, unsigned long end_pfn);
>  #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
>  enum mem_add_context { BOOT, HOTPLUG };
>  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> Index: linux-3.5-rc4/mm/memory_hotplug.c
> ===================================================================
> --- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-06-26 13:28:16.743211538 +0900
> +++ linux-3.5-rc4/mm/memory_hotplug.c	2012-06-26 13:48:38.264940468 +0900
> @@ -887,6 +887,11 @@ static int __ref offline_pages(unsigned
> 
>  	lock_memory_hotplug();
> 
> +	if (memory_is_offline(start_pfn, end_pfn)) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	zone = page_zone(pfn_to_page(start_pfn));
>  	node = zone_to_nid(zone);
>  	nr_pages = end_pfn - start_pfn;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


