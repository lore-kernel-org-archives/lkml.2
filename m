Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2JSJDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:03:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab2JSJDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:03:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6030382"
Message-ID: <508118A6.80804@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 17:08:54 +0800
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
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com> <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com> <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com> <507E77D1.3030709@cn.fujitsu.com> <CAHGf_=rxGeb0RsgEFF2FRRfdX0wiE9cDyVaftsG3E8AgyzYi1g@mail.gmail.com>
In-Reply-To: <CAHGf_=rxGeb0RsgEFF2FRRfdX0wiE9cDyVaftsG3E8AgyzYi1g@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 17:02:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 17:02:54,
	Serialize complete at 2012/10/19 17:02:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/19/2012 03:44 AM, KOSAKI Motohiro Wrote:
>>>>>> +       if (type == ACPI_BUS_REMOVAL_EJECT) {
>>>>>> +               /*
>>>>>> +                * offline and remove memory only when the memory device is
>>>>>> +                * ejected.
>>>>>> +                */
>>>>>
>>>>> This comment explain nothing. A comment should describe _why_ should we do.
>>>>> e.g. Why REMOVAL_NORMAL and REMOVEL_EJECT should be ignored. Why
>>>>> we need remove memory here instead of ACPI_NOTIFY_EJECT_REQUEST.
>>>>
>>>> Hmm, we have 2 ways to remove a memory:
>>>> 1. SCI
>>>> 2. echo 1 >/sys/bus/acpi/devices/PNP0C80:XX/eject
>>>>
>>>> In the 2nd case, there is no ACPI_NOTIFY_EJECT_REQUEST. We should offline
>>>> the memory and remove it from kernel in the release callback. We will poweroff
>>>> the memory device in acpi_bus_hot_remove_device(), so we must offline
>>>> and remove it if the type is ACPI_BUS_REMOVAL_EJECT.
>>>>
>>>> I guess we should not poweroff the memory device when we fail to offline it.
>>>> But device_release_driver() doesn't returns any error...
>>>
>>> 1) I think /sys/bus/acpi/devices/PNP0C80:XX/eject should emulate acpi
>>> eject. Can't
>>> you make a pseudo acpi eject event and detach device by acpi regular path?
>>
>> It is another issue. And we only can implement it here with current acpi
>> implemention. Some other acpi devices(for example: cpu) do it like this.
> 
> Hint: only cpu take like this.
> 
> 
>>> 2) Your explanation didn't explain why we should ignore REMOVAL_NORMAL
>>> and REMOVEL_EJECT. As far as reviewers can't track your intention, we
>>> can't maintain
>>> the code and can't ack them.
>>>
>>
>> REMOVAL_NORMAL means the user want to unbind the memory device from this driver.
>> It is no need to eject the device, and we can still use this device after unbinding.
>> So it can be ignored.
>>
>> REMOVAL_EJECT means the user want to eject and remove the device, and we should
>> not use the device. So we should offline and remove the memory here.
> 
> This is not exactly correct, IMHO. Usually, we must not touch unbinded
> device because
> they are out of OS control. If I understand is correct, the main
> reason is to distinguish a
> rollback of driver initialization failure and true ejection.
> 
> REMOVAL_NORMAL is usually used for rollback and REMOVAL_EJECT is used for
> removal device eject. Typical device don't need to distinguish them
> because we should
> deallocate every resource even when driver initialization failure.
> 
> However, cpu and memory are exceptions. They are recognized from kernel before
> driver initialization. Then even if machine have crappy acpi table and
> make failure acpi
> initialization, disabling memory make no sense.

Hmm, IIRC, if the memory is recognized from kerenl before driver initialization,
the memory device is not managed by the driver acpi_memhotplug.

I think we should also deal with REMOVAL_NORMAL here now. Otherwise it will cause
some critical problem: we unbind the device from the driver but we still use
it. If we eject it, we have no chance to offline and remove it. It is very dangerous.

Thanks
Wen Congyang

> 
> And, when you make _exceptional_ rule, you should comment verbosely in the code
> the detail.  likes 1) why we need.  2) which
> device/machine/environment suffer such exception. 2)  what affect
> other subsys.
> 
> Even though cpu hotplug has crappy poor comment and document, please
> don't follow
> them.
> 

