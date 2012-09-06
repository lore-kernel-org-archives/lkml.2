Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2IFH2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:28:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2IFH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346837155-534-21-git-send-email-wency@cn.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
	<1346837155-534-21-git-send-email-wency@cn.fujitsu.com>
Date: Thu, 6 Sep 2012 15:27:55 +0800
Message-ID: <CA+quRcZtQCmFa4=1fq1iainQROy3NgtAXjLFF9cixs6KVXoMDA@mail.gmail.com>
Subject: Re: [RFC v9 PATCH 20/21] memory-hotplug: clear hwpoisoned flag when
 onlining pages
From: =?GB2312?B?YW5keXd1MTA2vai5+g==?= <wujianguo106@gmail.com>
To: wency@cn.fujitsu.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5 <wency@cn.fujitsu.com>
>
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> hwpoisoned may set when we offline a page by the sysfs interface
> /sys/devices/system/memory/soft_offline_page or
> /sys/devices/system/memory/hard_offline_page. If we don't clear
> this flag when onlining pages, this page can't be freed, and will
> not in free list. So we can't offline these pages again. So we
> should clear this flag when onlining pages.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  mm/memory_hotplug.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 270c249..140c080 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -661,6 +661,11 @@ EXPORT_SYMBOL_GPL(__online_page_increment_counters);
>
>  void __online_page_free(struct page *page)
>  {
> +#ifdef CONFIG_MEMORY_FAILURE
> +       /* The page may be marked HWPoisoned by soft/hard offline page */
> +       ClearPageHWPoison(page);

Hi Congyang,
I think you should decrease mce_bad_pages counter her
atomic_long_sub(1, &mce_bad_pages);

>
> +#endif
> +
>         ClearPageReserved(page);
>         init_page_count(page);
>         __free_page(page);
> --
> 1.7.1
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
