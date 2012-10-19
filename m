Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2JSAud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:50:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60824 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2JSAub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:50:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5080A394.2000409@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 09:49:24 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
CC: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/10] memory-hotplug : memory-hotplug: check page type
 in get_page_bootmem
References: <506E43E0.70507@jp.fujitsu.com> <506E46B6.3060502@jp.fujitsu.com> <CAHGf_=raSH5C8ye90F1PLZ8mGQUGggB=J0HYU8UhkKVDTV5JXQ@mail.gmail.com>
In-Reply-To: <CAHGf_=raSH5C8ye90F1PLZ8mGQUGggB=J0HYU8UhkKVDTV5JXQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

Sorry for late reply.

2012/10/13 4:28, KOSAKI Motohiro wrote:
> On Thu, Oct 4, 2012 at 10:32 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> The function get_page_bootmem() may be called more than one time to the same
>> page. There is no need to set page's type, private if the function is not
>> the first time called to the page.
>>
>> Note: the patch is just optimization and does not fix any problem.
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Christoph Lameter <cl@linux.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> CC: Wen Congyang <wency@cn.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>>   mm/memory_hotplug.c |   15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> Index: linux-3.6/mm/memory_hotplug.c
>> ===================================================================
>> --- linux-3.6.orig/mm/memory_hotplug.c  2012-10-04 18:29:58.284676075 +0900
>> +++ linux-3.6/mm/memory_hotplug.c       2012-10-04 18:30:03.454680542 +0900
>> @@ -95,10 +95,17 @@ static void release_memory_resource(stru
>>   static void get_page_bootmem(unsigned long info,  struct page *page,
>>                               unsigned long type)
>>   {
>> -       page->lru.next = (struct list_head *) type;
>> -       SetPagePrivate(page);
>> -       set_page_private(page, info);
>> -       atomic_inc(&page->_count);
>> +       unsigned long page_type;
>> +
>> +       page_type = (unsigned long)page->lru.next;
>
> If I understand correctly, page->lru.next might be uninitialized yet.

Ah yes. I was misunderstanding...

Hi Wen,

When you update the physical hot remove patch-set, please drop the patch.

Thanks,
Yasuaki Ishimatsu  
  
> Moreover, I have no seen any good effect in this patch. I don't understand
> why we need to increase code complexity.
>
>
>
>> +       if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
>> +           page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
>> +               page->lru.next = (struct list_head *)type;
>> +               SetPagePrivate(page);
>> +               set_page_private(page, info);
>> +               atomic_inc(&page->_count);
>> +       } else
>> +               atomic_inc(&page->_count);
>>   }
>>
>>   /* reference to __meminit __free_pages_bootmem is valid
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


