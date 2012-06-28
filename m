Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab2F1F0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:26:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48499 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2F1F0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <4FEA9DB1.7010303@jp.fujitsu.com>
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9DB1.7010303@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 01:26:21 -0400
X-Google-Sender-Auth: Y18m_kKX9oj5-uF4wFT7hBHiGDE
Message-ID: <CAHGf_=qtt6_EWucC4B8R_jr71UTc9=QTJcDXz8Oo13C_nyu-mQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 1:44 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> When offline_pages() is called to offlined memory, the function fails since
> all memory has been offlined. In this case, the function should succeed.
> The patch adds the check function into offline_pages().

I don't understand your point. I think following misoperation should
fail. Otherwise
administrator have no way to know their fault.

$ echo offline > memoryN/state
$ echo offline > memoryN/state

In general, we don't like to ignore an error except the standard require it.

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
>  drivers/base/memory.c  |   20 ++++++++++++++++++++
>  include/linux/memory.h |    1 +
>  mm/memory_hotplug.c    |    5 +++++
>  3 files changed, 26 insertions(+)
>
> Index: linux-3.5-rc4/drivers/base/memory.c
> ===================================================================
> --- linux-3.5-rc4.orig/drivers/base/memory.c    2012-06-26 13:28:16.726211752 +0900
> +++ linux-3.5-rc4/drivers/base/memory.c 2012-06-26 13:34:22.423639904 +0900
> @@ -70,6 +70,26 @@ void unregister_memory_isolate_notifier(
>  }
>  EXPORT_SYMBOL(unregister_memory_isolate_notifier);
>
> +bool memory_is_offline(unsigned long start_pfn, unsigned long end_pfn)

I dislike this function name. 'memory' is too vague to me.


> +{
> +       struct memory_block *mem;
> +       struct mem_section *section;
> +       unsigned long pfn, section_nr;
> +
> +       for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +               section_nr = pfn_to_section_nr(pfn);
> +               section = __nr_to_section(section_nr);
> +               mem = find_memory_block(section);

This seems to have strong sparse dependency.
Hm, I wonder why memory-hotplug.c can enable when X86_64_ACPI_NUMA.

# eventually, we can have this option just 'select SPARSEMEM'
config MEMORY_HOTPLUG
	bool "Allow for memory hot-add"
	depends on SPARSEMEM || X86_64_ACPI_NUMA


> +               if (!mem)
> +                       continue;
> +               if (mem->state == MEM_OFFLINE)
> +                       continue;
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
>  /*
>  * register_memory - Setup a sysfs device for a memory block
>  */
> Index: linux-3.5-rc4/include/linux/memory.h
> ===================================================================
> --- linux-3.5-rc4.orig/include/linux/memory.h   2012-06-25 04:53:04.000000000 +0900
> +++ linux-3.5-rc4/include/linux/memory.h        2012-06-26 13:34:22.424639891 +0900
> @@ -120,6 +120,7 @@ extern int memory_isolate_notify(unsigne
>  extern struct memory_block *find_memory_block_hinted(struct mem_section *,
>                                                        struct memory_block *);
>  extern struct memory_block *find_memory_block(struct mem_section *);
> +extern bool memory_is_offline(unsigned long start_pfn, unsigned long end_pfn);
>  #define CONFIG_MEM_BLOCK_SIZE  (PAGES_PER_SECTION<<PAGE_SHIFT)
>  enum mem_add_context { BOOT, HOTPLUG };
>  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> Index: linux-3.5-rc4/mm/memory_hotplug.c
> ===================================================================
> --- linux-3.5-rc4.orig/mm/memory_hotplug.c      2012-06-26 13:28:16.743211538 +0900
> +++ linux-3.5-rc4/mm/memory_hotplug.c   2012-06-26 13:48:38.264940468 +0900
> @@ -887,6 +887,11 @@ static int __ref offline_pages(unsigned
>
>        lock_memory_hotplug();
>
> +       if (memory_is_offline(start_pfn, end_pfn)) {
> +               ret = 0;
> +               goto out;
> +       }
> +
>        zone = page_zone(pfn_to_page(start_pfn));
>        node = zone_to_nid(zone);
>        nr_pages = end_pfn - start_pfn;
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
