Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2GLExM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:53:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2GLExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:53:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFE5816.6070102@jp.fujitsu.com>
Date: Thu, 12 Jul 2012 13:52:38 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: Re: [RFC PATCH v3 3/13] memory-hotplug : unify argument of firmware_map_add_early/hotplug
References: <4FFAB0A2.8070304@jp.fujitsu.com> <4FFAB17F.2090209@jp.fujitsu.com> <4FFD9C08.2070502@linux.vnet.ibm.com>
In-Reply-To: <4FFD9C08.2070502@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

2012/07/12 0:30, Dave Hansen wrote:
> On 07/09/2012 03:25 AM, Yasuaki Ishimatsu wrote:
>> @@ -642,7 +642,7 @@ int __ref add_memory(int nid, u64 start,
>>   	}
>>
>>   	/* create new memmap entry */
>> -	firmware_map_add_hotplug(start, start + size, "System RAM");
>> +	firmware_map_add_hotplug(start, start + size - 1, "System RAM");
> 
> I know the firmware_map_*() calls use inclusive end addresses
> internally, but do we really need to expose them?  Both of the callers
> you mentioned do:
> 
> 	firmware_map_add_hotplug(start, start + size - 1, "System RAM");
> 
> or
> 
>                  firmware_map_add_early(entry->addr,
>                          entry->addr + entry->size - 1,
>                          e820_type_to_string(entry->type));
> 
> So it seems a _bit_ silly to keep all of the callers doing this size-1
> thing.  I also noted that the new caller that you added does the same
> thing.  Could we just change the external calling convention to be
> exclusive?

Thank you for your comment.

Does the following patch include your comment? If O.K., I will separate
the patch from the series and send it for bug fix.

---
 arch/x86/kernel/e820.c    |    2 +-
 drivers/firmware/memmap.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-next/arch/x86/kernel/e820.c
===================================================================
--- linux-next.orig/arch/x86/kernel/e820.c	2012-07-02 09:50:23.000000000 +0900
+++ linux-next/arch/x86/kernel/e820.c	2012-07-12 13:30:45.942318179 +0900
@@ -944,7 +944,7 @@
 	for (i = 0; i < e820_saved.nr_map; i++) {
 		struct e820entry *entry = &e820_saved.map[i];
 		firmware_map_add_early(entry->addr,
-			entry->addr + entry->size - 1,
+			entry->addr + entry->size,
 			e820_type_to_string(entry->type));
 	}
 }
Index: linux-next/drivers/firmware/memmap.c
===================================================================
--- linux-next.orig/drivers/firmware/memmap.c	2012-07-02 09:50:26.000000000 +0900
+++ linux-next/drivers/firmware/memmap.c	2012-07-12 13:40:53.823318481 +0900
@@ -98,7 +98,7 @@
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
@@ -113,7 +113,7 @@
 	BUG_ON(start > end);

 	entry->start = start;
-	entry->end = end;
+	entry->end = end - 1;
 	entry->type = type;
 	INIT_LIST_HEAD(&entry->list);
 	kobject_init(&entry->kobj, &memmap_ktype);
@@ -148,7 +148,7 @@
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function is for memory hotplug, it is
@@ -175,7 +175,7 @@
 /**
  * firmware_map_add_early() - Adds a firmware mapping entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function uses the bootmem allocator

