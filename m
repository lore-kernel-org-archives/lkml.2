Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2IFIg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:36:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2IFIgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:36:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,379,1344182400"; 
   d="scan'208";a="5795915"
Message-ID: <504861D5.201@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 16:41:57 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?YW5keXd1MTA25bu65Zu9?= <wujianguo106@gmail.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v9 PATCH 20/21] memory-hotplug: clear hwpoisoned flag when
 onlining pages
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>	<1346837155-534-21-git-send-email-wency@cn.fujitsu.com> <CA+quRcZtQCmFa4=1fq1iainQROy3NgtAXjLFF9cixs6KVXoMDA@mail.gmail.com>
In-Reply-To: <CA+quRcZtQCmFa4=1fq1iainQROy3NgtAXjLFF9cixs6KVXoMDA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 16:35:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 16:35:57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/06/2012 03:27 PM, andywu106建国 Wrote:
> 2012/9/5 <wency@cn.fujitsu.com>
>>
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> hwpoisoned may set when we offline a page by the sysfs interface
>> /sys/devices/system/memory/soft_offline_page or
>> /sys/devices/system/memory/hard_offline_page. If we don't clear
>> this flag when onlining pages, this page can't be freed, and will
>> not in free list. So we can't offline these pages again. So we
>> should clear this flag when onlining pages.
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Paul Mackerras <paulus@samba.org>
>> CC: Christoph Lameter <cl@linux.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  mm/memory_hotplug.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 270c249..140c080 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -661,6 +661,11 @@ EXPORT_SYMBOL_GPL(__online_page_increment_counters);
>>
>>  void __online_page_free(struct page *page)
>>  {
>> +#ifdef CONFIG_MEMORY_FAILURE
>> +       /* The page may be marked HWPoisoned by soft/hard offline page */
>> +       ClearPageHWPoison(page);
> 
> Hi Congyang,
> I think you should decrease mce_bad_pages counter her
> atomic_long_sub(1, &mce_bad_pages);

Yes, thanks for pointing it out.

Thanks
Wen Congyang

> 
>>
>> +#endif
>> +
>>         ClearPageReserved(page);
>>         init_page_count(page);
>>         __free_page(page);
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

