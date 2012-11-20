Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KTGtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:49:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19623 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2KTGtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:49:20 -0500
X-IronPort-AV: E=Sophos;i="4.83,284,1352044800"; 
   d="scan'208";a="6236720"
Message-ID: <50AB2967.5010302@cn.fujitsu.com>
Date: Tue, 20 Nov 2012 14:55:35 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        benh@kernel.crashing.org, paulus@samba.org,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: Re: [PATCH v3 06/12] memory-hotplug: unregister memory section on
 SPARSEMEM_VMEMMAP
References: <1351763083-7905-1-git-send-email-wency@cn.fujitsu.com> <1351763083-7905-7-git-send-email-wency@cn.fujitsu.com> <50AB21A4.8050709@gmail.com>
In-Reply-To: <50AB21A4.8050709@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 14:49:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/20 14:49:02,
	Serialize complete at 2012/11/20 14:49:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/20/2012 02:22 PM, Jaegeuk Hanse Wrote:
> On 11/01/2012 05:44 PM, Wen Congyang wrote:
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> Currently __remove_section for SPARSEMEM_VMEMMAP does nothing. But
>> even if
>> we use SPARSEMEM_VMEMMAP, we can unregister the memory_section.
>>
>> So the patch add unregister_memory_section() into __remove_section().
> 
> Hi Yasuaki,
> 
> In order to review this patch, I should dig sparse memory codes in
> advance. But I have some confuse of codes. Why need encode/decode mem
> map instead of set mem_map to ms->section_mem_map directly?

The memmap is aligned, and the low bits are zero. We store some information
in these bits. So we need to encode/decode memmap here.

Thanks
Wen Congyang

> 
> Regards,
> Jaegeuk
> 
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
>>   mm/memory_hotplug.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index ca07433..66a79a7 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -286,11 +286,14 @@ static int __meminit __add_section(int nid,
>> struct zone *zone,
>>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>   static int __remove_section(struct zone *zone, struct mem_section *ms)
>>   {
>> -    /*
>> -     * XXX: Freeing memmap with vmemmap is not implement yet.
>> -     *      This should be removed later.
>> -     */
>> -    return -EBUSY;
>> +    int ret = -EINVAL;
>> +
>> +    if (!valid_section(ms))
>> +        return ret;
>> +
>> +    ret = unregister_memory_section(ms);
>> +
>> +    return ret;
>>   }
>>   #else
>>   static int __remove_section(struct zone *zone, struct mem_section *ms)
> 
> 

