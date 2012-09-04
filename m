Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2IDDoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:44:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab2IDDon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:44:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,364,1344182400"; 
   d="scan'208";a="5777133"
Message-ID: <50457983.1050304@cn.fujitsu.com>
Date: Tue, 04 Sep 2012 11:46:11 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, isimatu.yasuaki@jp.fujitsu.com
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC v8 PATCH 13/20] memory-hotplug: check page type in get_page_bootmem
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>	<1346148027-24468-14-git-send-email-wency@cn.fujitsu.com> <20120831143032.1343e99a.akpm@linux-foundation.org>
In-Reply-To: <20120831143032.1343e99a.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/04 11:40:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/04 11:40:39,
	Serialize complete at 2012/09/04 11:40:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, isimatu-san

At 09/01/2012 05:30 AM, Andrew Morton Wrote:
> On Tue, 28 Aug 2012 18:00:20 +0800
> wency@cn.fujitsu.com wrote:
> 
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> There is a possibility that get_page_bootmem() is called to the same page many
>> times. So when get_page_bootmem is called to the same page, the function only
>> increments page->_count.
> 
> I really don't understand this explanation, even after having looked at
> the code.  Can you please have another attempt at the changelog?

What is the problem that you want to fix? The function get_page_bootmem()
may be called to the same page more than once, but I don't find any problem
about current implementation.

Thanks
Wen Congyang

> 
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -95,10 +95,17 @@ static void release_memory_resource(struct resource *res)
>>  static void get_page_bootmem(unsigned long info,  struct page *page,
>>  			     unsigned long type)
>>  {
>> -	page->lru.next = (struct list_head *) type;
>> -	SetPagePrivate(page);
>> -	set_page_private(page, info);
>> -	atomic_inc(&page->_count);
>> +	unsigned long page_type;
>> +
>> +	page_type = (unsigned long) page->lru.next;
>> +	if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
>> +	    page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
>> +		page->lru.next = (struct list_head *) type;
>> +		SetPagePrivate(page);
>> +		set_page_private(page, info);
>> +		atomic_inc(&page->_count);
>> +	} else
>> +		atomic_inc(&page->_count);
>>  }
> 
> And a code comment which explains what is going on would be good.  As
> is always the case ;)
> 
> 

