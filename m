Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2IDJ4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:56:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34838 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2IDJzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:55:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5045CFD6.9040408@jp.fujitsu.com>
Date: Tue, 4 Sep 2012 18:54:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <cl@linux.com>, <minchan.kim@gmail.com>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC v8 PATCH 13/20] memory-hotplug: check page type in get_page_bootmem
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>	<1346148027-24468-14-git-send-email-wency@cn.fujitsu.com> <20120831143032.1343e99a.akpm@linux-foundation.org> <50457983.1050304@cn.fujitsu.com>
In-Reply-To: <50457983.1050304@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

2012/09/04 12:46, Wen Congyang wrote:
> Hi, isimatu-san
>
> At 09/01/2012 05:30 AM, Andrew Morton Wrote:
>> On Tue, 28 Aug 2012 18:00:20 +0800
>> wency@cn.fujitsu.com wrote:
>>
>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> There is a possibility that get_page_bootmem() is called to the same page many
>>> times. So when get_page_bootmem is called to the same page, the function only
>>> increments page->_count.
>>
>> I really don't understand this explanation, even after having looked at
>> the code.  Can you please have another attempt at the changelog?
>
> What is the problem that you want to fix? The function get_page_bootmem()
> may be called to the same page more than once, but I don't find any problem
> about current implementation.

The patch is just optimization. The patch does not fix a problems.
As you know, the function may be called many times for the same page.
I think if a page is sets to page_type and Page Private flag and page->private,
the page need not be set the same things again. So we check page_type when
get_page_bootmem() is called. And if the page has been set to them, the page
is only incremented page->_count.

Thanks,
Yasuaki Ishimatsu

>
> Thanks
> Wen Congyang
>
>>
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -95,10 +95,17 @@ static void release_memory_resource(struct resource *res)
>>>   static void get_page_bootmem(unsigned long info,  struct page *page,
>>>   			     unsigned long type)
>>>   {
>>> -	page->lru.next = (struct list_head *) type;
>>> -	SetPagePrivate(page);
>>> -	set_page_private(page, info);
>>> -	atomic_inc(&page->_count);
>>> +	unsigned long page_type;
>>> +
>>> +	page_type = (unsigned long) page->lru.next;
>>> +	if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
>>> +	    page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
>>> +		page->lru.next = (struct list_head *) type;
>>> +		SetPagePrivate(page);
>>> +		set_page_private(page, info);
>>> +		atomic_inc(&page->_count);
>>> +	} else
>>> +		atomic_inc(&page->_count);
>>>   }
>>
>> And a code comment which explains what is going on would be good.  As
>> is always the case ;)
>>
>>
>


