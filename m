Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1IGCpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:45:22 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:46187 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1IGCpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:45:14 -0400
Date: Wed, 07 Sep 2011 10:40:08 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: Re: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
In-reply-to: <CAErSpo5owGuYLP2-JR6uJsM+Pqwna+FUB--p4OhjLVAETqYpcw@mail.gmail.com>
X-Originating-IP: [10.166.80.171]
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linqiangmin@huawei.com, james.chenjiabo@huawei.com
Message-id: <4E66D988.9070505@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.1) Gecko/20110830
 Thunderbird/6.0.1
X-CFilter-Loop: Reflected
References: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
 <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
 <4E65C254.8090107@huawei.com>
 <CAErSpo5owGuYLP2-JR6uJsM+Pqwna+FUB--p4OhjLVAETqYpcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/9/7 2:38, Bjorn Helgaas wrote:
> On Mon, Sep 5, 2011 at 11:48 PM, canquan.shen<shencanquan@huawei.com>  wrote:
>> On 2011/9/6 12:19, Bjorn Helgaas wrote:
>>>>
>>>> 主题: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
>>>>
>>>> In Xen virtualization environment, When I used xen tools (xm vcpu-set
>>>> vcpu_number ) to test the vcpu add and remove, I found it is failure on vcpu
>>>> remove, I found the reason is that nothing to do when cpu remove in
>>>> acpi_processor_hotplug_notify function, so I add the code of send the
>>>> OFFLINE message to udev and add the rule of udev. it is ok on vcpu remove.
>>>> Signed-off-by: Shen canquan<shencanquan@huawei.com>
>>>> ---
>>>>   drivers/acpi/processor_driver.c |    2 ++
>>>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>>> diff --git a/drivers/acpi/processor_driver.c
>>>> b/drivers/acpi/processor_driver.c
>>>> index a4e0f1b..a1c564f 100644
>>>> --- a/drivers/acpi/processor_driver.c
>>>> +++ b/drivers/acpi/processor_driver.c
>>>> @@ -677,6 +677,8 @@ static void acpi_processor_hotplug_notify(acpi_handle
>>>> handle,
>>>>                                      "Driver data is NULL, dropping
>>>> EJECT\n");
>>>>                          return;
>>>>                  }
>>>> +
>>>> +               kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>>>>                  break;
>>>>          default:
>>>>                  ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>>>
>>> The processor driver used to generate ONLINE and OFFLINE messages.  I
>>> removed them with c1815e0740.  According to the changelog, the driver
>>> core still generates KOBJ_ADD and KOBJ_REMOVE events.
>>
>> Thanks for your answer.
>> When I used xen tools (xm vcpu-set vcpu_numer) to reduce the cpu number. I
>> don't found any event . I use the following tool to capture the event:
>> udevadm monitor --env --kernel --udev.
>>
>> If I used xen tools to add the cpu number , udev module will receive the
>> KOBJ_ADD event.
>>
>> In my patch ,It is more fine to replace KOBJ_OFFLINE to KOBJ_REMOVE event .
>
> I don't think we should emit KOBJ_REMOVE from the ACPI processor
> driver.  KOBJ_ADD is emitted by the driver model core
> (device_register() ->  device_add() path), and I think KOBJ_REMOVE
> should also be emitted from the driver model core.
>
> Is acpi_processor_remove() called when you remove a processor?  I see
> a path where it will be called via acpi_eject_store():
>
>      acpi_eject_store
>        acpi_os_hotplug_execute(acpi_bus_hot_remove_device)
>        acpi_bus_hot_remove_device
>          acpi_bus_trim
>            acpi_bus_remove
>              device_release_driver
>                dev->driver->remove (acpi_processor_remove())
>              acpi_device_unregister
>                device_unregister
>                  device_del
>                    kobject_uevent(KOBJ_REMOVE)
>
> but as far as I can tell, this path is only used when we write
> something to the "eject" sysfs file.  I would think we'd want to use
> most of this same path when we hot remove a CPU via the ACPI SCI
> mechanism.
>

Because in my patch will send the KOBJ_REMOVE event to udev module. and 
I write a udev rule like the following:
ACTION=="remove",DRIVER=="processor",SUBSYSTEM=="acpi",RUN+="/bin/bash 
-c 'echo 1 > /sys%p/eject'"
This rule will write "1" to the "eject" sysfs file. and then call 
acpi_eject_store function.

> If you change acpi_processor_hotplug_notify() to use acpi_bus_trim()
> for the removal case, you should get KOBJ_REMOVE events.  Would that
> be enough to make the xen vcpu remove work, or at least get you
> closer?
>

Xen vcpu remove will work if add the acpi_bus_trim() in the 
acpi_processor_hotplug_notify() function.

But I have two question:
1) If acpi processor driver send the KOBJ_REMOVE(or KOBJ_OFFLINE_CPU) to 
udev module. user has a chance to decide to remove or not remove the cpu 
?  The default is remove cpu if user does not write any udev rule .
2) In the acpi_bus_trim function,  the call patch is following:
      acpi_bus_trim
       acpi_bus_remove
         device_release_driver
            dev->driver->remove (acpi_processor_remove())
                acpi_processor_handle_eject
                       cpu_down
          acpi_device_unregister
             device_unregister
                device_del
                  kobject_uevent(KOBJ_REMOVE)

   I think this call patch is not clear, and I think when acpi processor 
driver receive the eject event. at first it send KOBJ_OFFLINE event to 
udev module and udev rule decide to offline or not offline the cpu. and 
if offline cpu  and then acpi processor driver remove the processor 
device(by listen CPU_DEAD event can know the cpu had offlined)
and so I think it is fine if has the following call path:
     acpi_processor_hotplug_notify
         register_hotcpu_notifier
         kobject_uevent(KOBJ_OFFLINE)


and udev rule will offline the cpu
       store_online
          cpu_down
            _cpu_down
	       cpu_notify_nofail (CPU_DEAD event)

and  in acpi processor driver receive CPU_DEAD
      acpi_cpu_soft_notify
           acpi_bus_trim
               acpi_bus_remove
                device_release_driver
                   dev->driver->remove (acpi_processor_remove())
                acpi_device_unregister
                  device_unregister
                      device_del
                         kobject_uevent(KOBJ_REMOVE)


--
canquan.shen

>> btw: how to find changelog of the c1815e0740.
>
> git show c1815e0740
>
> Bjorn
>
> .
>


