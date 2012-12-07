Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2LGGos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:44:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab2LGGop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:44:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,235,1355068800"; 
   d="scan'208";a="6351360"
Message-ID: <50C19022.9000501@cn.fujitsu.com>
Date: Fri, 07 Dec 2012 14:43:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        benh@kernel.crashing.org, paulus@samba.org,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [Patch v4 09/12] memory-hotplug: remove page table of x86_64
 architecture
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <1354010422-19648-10-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1354010422-19648-10-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/07 14:44:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/07 14:44:02,
	Serialize complete at 2012/12/07 14:44:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 06:00 PM, Wen Congyang wrote:
> For hot removing memory, we sholud remove page table about the memory.
> So the patch searches a page table about the removed memory, and clear
> page table.

(snip)

> +void __meminit
> +kernel_physical_mapping_remove(unsigned long start, unsigned long end)
> +{
> +	unsigned long next;
> +	bool pgd_changed = false;
> +
> +	start = (unsigned long)__va(start);
> +	end = (unsigned long)__va(end);

Hi Wu,

Here, you expect start and end are physical addresses. But in
phys_xxx_remove() function, I think using virtual addresses is just
fine. Functions like pmd_addr_end() and pud_index() only calculate
an offset.

So, would you please tell me if we have to use physical addresses here ?

Thanks. :)

> +
> +	for (; start<  end; start = next) {
> +		pgd_t *pgd = pgd_offset_k(start);
> +		pud_t *pud;
> +
> +		next = pgd_addr_end(start, end);
> +
> +		if (!pgd_present(*pgd))
> +			continue;
> +
> +		pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
> +		phys_pud_remove(pud, __pa(start), __pa(next));
> +		if (free_pud_table(pud, pgd))
> +			pgd_changed = true;
> +		unmap_low_page(pud);
> +	}
> +
> +	if (pgd_changed)
> +		sync_global_pgds(start, end - 1);
> +
> +	flush_tlb_all();
> +}
> +
>   #ifdef CONFIG_MEMORY_HOTREMOVE
>   int __ref arch_remove_memory(u64 start, u64 size)
>   {
> @@ -692,6 +921,8 @@ int __ref arch_remove_memory(u64 start, u64 size)
>   	ret = __remove_pages(zone, start_pfn, nr_pages);
>   	WARN_ON_ONCE(ret);
>
> +	kernel_physical_mapping_remove(start, start + size);
> +
>   	return ret;
>   }
>   #endif


