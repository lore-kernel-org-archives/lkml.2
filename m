Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2JQGmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:42:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2JQGmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:42:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,598,1344182400"; 
   d="scan'208";a="6014354"
Message-ID: <507E54AA.2080806@cn.fujitsu.com>
Date: Wed, 17 Oct 2012 14:48:10 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to
 acpi_memory_device_remove()
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com> <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com> <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
In-Reply-To: <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 14:42:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 14:42:10,
	Serialize complete at 2012/10/17 14:42:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/13/2012 03:10 AM, KOSAKI Motohiro Wrote:
>>>> -static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>>>> +static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>>>>  {
>>>>         int result;
>>>>         struct acpi_memory_info *info, *n;
>>>>
>>>> +       list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>>>
>>> Which lock protect this loop?
>>
>> There is no any lock to protect it now...
> 
> When iterate an item removal list, you should use lock for protecting from
> memory corruption.
> 
> 
> 
> 
>>>> +static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>>>> +{
>>>> +       int result;
>>>>
>>>>         /*
>>>>          * Ask the VM to offline this memory range.
>>>>          * Note: Assume that this function returns zero on success
>>>>          */
>>>
>>> Write function comment instead of this silly comment.
>>>
>>>> -       list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>>>> -               if (info->enabled) {
>>>> -                       result = remove_memory(info->start_addr, info->length);
>>>> -                       if (result)
>>>> -                               return result;
>>>> -               }
>>>> -               kfree(info);
>>>> -       }
>>>> +       result = acpi_memory_remove_memory(mem_device);
>>>> +       if (result)
>>>> +               return result;
>>>>
>>>>         /* Power-off and eject the device */
>>>>         result = acpi_memory_powerdown_device(mem_device);
>>>
>>> This patch move acpi_memory_powerdown_device() from ACPI_NOTIFY_EJECT_REQUEST
>>> to release callback, but don't explain why.
>>
>> Hmm, it doesn't move the code. It just reuse the code in acpi_memory_powerdown_device().
> 
> Even if reuse or not reuse, you changed the behavior. If any changes
> has no good rational, you cannot get an ack.

I don't understand this? IIRC, the behavior isn't changed.

Thanks
Wen Congyang

> 
> 
> 
> 
>>>> @@ -473,12 +486,23 @@ static int acpi_memory_device_add(struct
>>>>  static int acpi_memory_device_remove(struct acpi_device *device, int type)
>>>>  {
>>>>         struct acpi_memory_device *mem_device = NULL;
>>>> -
>>>> +       int result;
>>>>
>>>>         if (!device || !acpi_driver_data(device))
>>>>                 return -EINVAL;
>>>>
>>>>         mem_device = acpi_driver_data(device);
>>>> +
>>>> +       if (type == ACPI_BUS_REMOVAL_EJECT) {
>>>> +               /*
>>>> +                * offline and remove memory only when the memory device is
>>>> +                * ejected.
>>>> +                */
>>>
>>> This comment explain nothing. A comment should describe _why_ should we do.
>>> e.g. Why REMOVAL_NORMAL and REMOVEL_EJECT should be ignored. Why
>>> we need remove memory here instead of ACPI_NOTIFY_EJECT_REQUEST.
>>
>> Hmm, we have 2 ways to remove a memory:
>> 1. SCI
>> 2. echo 1 >/sys/bus/acpi/devices/PNP0C80:XX/eject
>>
>> In the 2nd case, there is no ACPI_NOTIFY_EJECT_REQUEST. We should offline
>> the memory and remove it from kernel in the release callback. We will poweroff
>> the memory device in acpi_bus_hot_remove_device(), so we must offline
>> and remove it if the type is ACPI_BUS_REMOVAL_EJECT.
>>
>> I guess we should not poweroff the memory device when we fail to offline it.
>> But device_release_driver() doesn't returns any error...
> 
> 1) I think /sys/bus/acpi/devices/PNP0C80:XX/eject should emulate acpi
> eject. Can't
> you make a pseudo acpi eject event and detach device by acpi regular path?
> 
> 2) Your explanation didn't explain why we should ignore REMOVAL_NORMAL
> and REMOVEL_EJECT. As far as reviewers can't track your intention, we
> can't maintain
> the code and can't ack them.
> 

