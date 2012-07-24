Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2GXE7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 00:59:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45269 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2GXE7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 00:59:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <500E2BA1.9010502@jp.fujitsu.com>
Date: Tue, 24 Jul 2012 13:59:13 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@kernel.org>, <hpa@zytor.com>, <tj@kernel.org>,
        <akpm@linux-foundation.org>, <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] firmware_map : unify argument of firmware_map_add_early/hotplug
References: <5004CB4C.6080700@jp.fujitsu.com>
In-Reply-To: <5004CB4C.6080700@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is bugfix. So I want you to review it and merge into linux-3.6.

2012/07/17 11:17, Yasuaki Ishimatsu wrote:
> There are two ways to create /sys/firmware/memmap/X sysfs:
> 
>    - firmware_map_add_early
>      When the system starts, it is calledd from e820_reserve_resources()
>    - firmware_map_add_hotplug
>      When the memory is hot plugged, it is called from add_memory()
> 
> But these functions are called without unifying value of end argument as below:
> 
>    - end argument of firmware_map_add_early()   : start + size - 1
>    - end argument of firmware_map_add_hogplug() : start + size
> 
> The patch unifies them to "start + size". Even if applying the patch,
> /sys/firmware/memmap/X/end file content does not change.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>   arch/x86/kernel/e820.c    |    2 +-
>   drivers/firmware/memmap.c |    8 ++++----
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-next/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-next.orig/arch/x86/kernel/e820.c	2012-07-02 09:50:23.000000000 +0900
> +++ linux-next/arch/x86/kernel/e820.c	2012-07-12 13:30:45.942318179 +0900
> @@ -944,7 +944,7 @@
>   	for (i = 0; i < e820_saved.nr_map; i++) {
>   		struct e820entry *entry = &e820_saved.map[i];
>   		firmware_map_add_early(entry->addr,
> -			entry->addr + entry->size - 1,
> +			entry->addr + entry->size,
>   			e820_type_to_string(entry->type));
>   	}
>   }
> Index: linux-next/drivers/firmware/memmap.c
> ===================================================================
> --- linux-next.orig/drivers/firmware/memmap.c	2012-07-02 09:50:26.000000000 +0900
> +++ linux-next/drivers/firmware/memmap.c	2012-07-12 13:40:53.823318481 +0900
> @@ -98,7 +98,7 @@
>   /**
>    * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
>    * @start: Start of the memory range.
> - * @end:   End of the memory range (inclusive).
> + * @end:   End of the memory range.
>    * @type:  Type of the memory range.
>    * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
>    *         entry.
> @@ -113,7 +113,7 @@
>   	BUG_ON(start > end);
>   
>   	entry->start = start;
> -	entry->end = end;
> +	entry->end = end - 1;
>   	entry->type = type;
>   	INIT_LIST_HEAD(&entry->list);
>   	kobject_init(&entry->kobj, &memmap_ktype);
> @@ -148,7 +148,7 @@
>    * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
>    * memory hotplug.
>    * @start: Start of the memory range.
> - * @end:   End of the memory range (inclusive).
> + * @end:   End of the memory range.
>    * @type:  Type of the memory range.
>    *
>    * Adds a firmware mapping entry. This function is for memory hotplug, it is
> @@ -175,7 +175,7 @@
>   /**
>    * firmware_map_add_early() - Adds a firmware mapping entry.
>    * @start: Start of the memory range.
> - * @end:   End of the memory range (inclusive).
> + * @end:   End of the memory range.
>    * @type:  Type of the memory range.
>    *
>    * Adds a firmware mapping entry. This function uses the bootmem allocator
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


