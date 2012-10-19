Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2JSBt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:49:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2JSBty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:49:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,610,1344182400"; 
   d="scan'208";a="6026633"
Message-ID: <5080B310.50608@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 09:55:28 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 5/10] memory-hotplug : memory-hotplug: check page type
 in get_page_bootmem
References: <506E43E0.70507@jp.fujitsu.com> <506E46B6.3060502@jp.fujitsu.com> <CAHGf_=raSH5C8ye90F1PLZ8mGQUGggB=J0HYU8UhkKVDTV5JXQ@mail.gmail.com> <5080A394.2000409@jp.fujitsu.com>
In-Reply-To: <5080A394.2000409@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 09:49:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 09:49:29,
	Serialize complete at 2012/10/19 09:49:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/19/2012 08:49 AM, Yasuaki Ishimatsu Wrote:
> Hi Kosaki,
> 
> Sorry for late reply.
> 
> 2012/10/13 4:28, KOSAKI Motohiro wrote:
>> On Thu, Oct 4, 2012 at 10:32 PM, Yasuaki Ishimatsu
>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>> The function get_page_bootmem() may be called more than one time to
>>> the same
>>> page. There is no need to set page's type, private if the function is
>>> not
>>> the first time called to the page.
>>>
>>> Note: the patch is just optimization and does not fix any problem.
>>>
>>> CC: David Rientjes <rientjes@google.com>
>>> CC: Jiang Liu <liuj97@gmail.com>
>>> CC: Len Brown <len.brown@intel.com>
>>> CC: Christoph Lameter <cl@linux.com>
>>> Cc: Minchan Kim <minchan.kim@gmail.com>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> CC: Wen Congyang <wency@cn.fujitsu.com>
>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>> ---
>>>   mm/memory_hotplug.c |   15 +++++++++++----
>>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> Index: linux-3.6/mm/memory_hotplug.c
>>> ===================================================================
>>> --- linux-3.6.orig/mm/memory_hotplug.c  2012-10-04 18:29:58.284676075
>>> +0900
>>> +++ linux-3.6/mm/memory_hotplug.c       2012-10-04 18:30:03.454680542
>>> +0900
>>> @@ -95,10 +95,17 @@ static void release_memory_resource(stru
>>>   static void get_page_bootmem(unsigned long info,  struct page *page,
>>>                               unsigned long type)
>>>   {
>>> -       page->lru.next = (struct list_head *) type;
>>> -       SetPagePrivate(page);
>>> -       set_page_private(page, info);
>>> -       atomic_inc(&page->_count);
>>> +       unsigned long page_type;
>>> +
>>> +       page_type = (unsigned long)page->lru.next;
>>
>> If I understand correctly, page->lru.next might be uninitialized yet.
> 
> Ah yes. I was misunderstanding...
> 
> Hi Wen,
> 
> When you update the physical hot remove patch-set, please drop the patch.

OK

Thanks
Wen Congyang

> 
> Thanks,
> Yasuaki Ishimatsu   
>> Moreover, I have no seen any good effect in this patch. I don't
>> understand
>> why we need to increase code complexity.
>>
>>
>>
>>> +       if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
>>> +           page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
>>> +               page->lru.next = (struct list_head *)type;
>>> +               SetPagePrivate(page);
>>> +               set_page_private(page, info);
>>> +               atomic_inc(&page->_count);
>>> +       } else
>>> +               atomic_inc(&page->_count);
>>>   }
>>>
>>>   /* reference to __meminit __free_pages_bootmem is valid
>>>
>>> -- 
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

