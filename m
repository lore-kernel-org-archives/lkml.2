Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2JQPMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:12:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46065 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab2JQPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:12:08 -0400
Message-ID: <507ECA43.3070402@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 08:09:55 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/5] memory-hotplug: update mce_bad_pages when removing
 the memory
References: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com> <1350475735-26136-3-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1350475735-26136-3-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101715-2876-0000-0000-0000011D3EB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

> +#ifdef CONFIG_MEMORY_FAILURE
> +static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
> +{
> +	int i;
> +
> +	if (!memmap)
> +		return;

I guess free_section_usemap() does the same thing.

> +	for (i = 0; i < PAGES_PER_SECTION; i++) {
> +		if (PageHWPoison(&memmap[i])) {
> +			atomic_long_sub(1, &mce_bad_pages);
> +			ClearPageHWPoison(&memmap[i]);
> +		}
> +	}
> +}
> +#endif
> +
>  void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
>  {
>  	struct page *memmap = NULL;
> @@ -786,6 +803,10 @@ void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
>  		ms->pageblock_flags = NULL;
>  	}
> 
> +#ifdef CONFIG_MEMORY_FAILURE
> +	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
> +#endif
> +
>  	free_section_usemap(memmap, usemap);
>  }
>  #endif

But why put the call outside the  "if (ms->section_mem_map)" block?  If
you put it inside, then you don't have to check for !memmap in
clear_hwpoisoned_pages().

Also, we really frown on #ifdefs scattered throughout code.  I'd suggest
either:

+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+#ifdef CONFIG_MEMORY_FAILURE
... existing code
+#endif /* CONFIG_MEMORY_FAILURE */
+}

or

+#ifdef CONFIG_MEMORY_FAILURE
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
... existing code
+}
+#else
+static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{}
+#endif /* CONFIG_MEMORY_FAILURE */

and keep the #ifdef out of sparse_remove_one_section().

