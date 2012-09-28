Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2I1AZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:25:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53787 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2I1AY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:24:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5064EE3F.3080606@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 09:24:31 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ni zhan Chen <nizhan.chen@gmail.com>
CC: <wency@cn.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <minchan.kim@gmail.com>,
        <akpm@linux-foundation.org>, <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] memory-hotplug: add memory_block_release
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-2-git-send-email-wency@cn.fujitsu.com> <CAEkdkmVW5wwG4_cy0yHFNVmk2bzAqzo2adRsMn1yHOW9Ex98_g@mail.gmail.com>
In-Reply-To: <CAEkdkmVW5wwG4_cy0yHFNVmk2bzAqzo2adRsMn1yHOW9Ex98_g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

2012/09/27 19:20, Ni zhan Chen wrote:
> Hi Congyang,
>
> 2012/9/27 <wency@cn.fujitsu.com>
>
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> When calling remove_memory_block(), the function shows following message at
>> device_release().
>>
>> Device 'memory528' does not have a release() function, it is broken and
>> must
>> be fixed.
>>
>
> What's the difference between the patch and original implemetation?

The implementation is for removing a memory_block. So the purpose is
same as original one. But original code is bad manner. kobject_cleanup()
is called by remove_memory_block() at last. But release function for
releasing memory_block is not registered. As a result, the kernel message
is shown. IMHO, memory_block should be release by the releae function.

Thanks,
Yasuaki Ishimatsu

>
>
>> remove_memory_block() calls kfree(mem). I think it shouled be called from
>> device_release(). So the patch implements memory_block_release()
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Paul Mackerras <paulus@samba.org>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> CC: Wen Congyang <wency@cn.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>>   drivers/base/memory.c |    9 ++++++++-
>>   1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index 7dda4f7..da457e5 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -70,6 +70,13 @@ void unregister_memory_isolate_notifier(struct
>> notifier_block *nb)
>>   }
>>   EXPORT_SYMBOL(unregister_memory_isolate_notifier);
>>
>> +static void release_memory_block(struct device *dev)
>> +{
>> +       struct memory_block *mem = container_of(dev, struct memory_block,
>> dev);
>> +
>> +       kfree(mem);
>> +}
>> +
>>   /*
>>    * register_memory - Setup a sysfs device for a memory block
>>    */
>> @@ -80,6 +87,7 @@ int register_memory(struct memory_block *memory)
>>
>>          memory->dev.bus = &memory_subsys;
>>          memory->dev.id = memory->start_section_nr / sections_per_block;
>> +       memory->dev.release = release_memory_block;
>>
>>          error = device_register(&memory->dev);
>>          return error;
>> @@ -630,7 +638,6 @@ int remove_memory_block(unsigned long node_id, struct
>> mem_section *section,
>>                  mem_remove_simple_file(mem, phys_device);
>>                  mem_remove_simple_file(mem, removable);
>>                  unregister_memory(mem);
>> -               kfree(mem);
>>          } else
>>                  kobject_put(&mem->dev.kobj);
>>
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>


