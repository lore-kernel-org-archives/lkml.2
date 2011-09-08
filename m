Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1IHAVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:21:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61728 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1IHAVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:21:21 -0400
Date: Thu, 08 Sep 2011 08:21:09 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: Re: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
In-reply-to: <CAErSpo7Rf+X3MVgmdYvbEXw-UAU7sEEMq5upBkhEn9Eu0zD-zw@mail.gmail.com>
X-Originating-IP: [10.166.80.171]
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linqiangmin@huawei.com, james.chenjiabo@huawei.com
Message-id: <4E680A75.3000600@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.1) Gecko/20110830
 Thunderbird/6.0.1
X-CFilter-Loop: Reflected
References: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
 <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
 <4E65C254.8090107@huawei.com>
 <CAErSpo5owGuYLP2-JR6uJsM+Pqwna+FUB--p4OhjLVAETqYpcw@mail.gmail.com>
 <4E66D988.9070505@huawei.com>
 <CAErSpo7Rf+X3MVgmdYvbEXw-UAU7sEEMq5upBkhEn9Eu0zD-zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/9/7 14:57, Bjorn Helgaas wrote:
> On Tue, Sep 6, 2011 at 7:40 PM, canquan.shen<shencanquan@huawei.com>  wrote:
>> On 2011/9/7 2:38, Bjorn Helgaas wrote:
>
>>> Is acpi_processor_remove() called when you remove a processor?  I see
>>> a path where it will be called via acpi_eject_store():
>>>
>>>      acpi_eject_store
>>>        acpi_os_hotplug_execute(acpi_bus_hot_remove_device)
>>>        acpi_bus_hot_remove_device
>>>          acpi_bus_trim
>>>            acpi_bus_remove
>>>              device_release_driver
>>>                dev->driver->remove (acpi_processor_remove())
>>>              acpi_device_unregister
>>>                device_unregister
>>>                  device_del
>>>                    kobject_uevent(KOBJ_REMOVE)
>>>
>>> but as far as I can tell, this path is only used when we write
>>> something to the "eject" sysfs file.  I would think we'd want to use
>>> most of this same path when we hot remove a CPU via the ACPI SCI
>>> mechanism.
>>>
>>
>> Because in my patch will send the KOBJ_REMOVE event to udev module. and I
>> write a udev rule like the following:
>> ACTION=="remove",DRIVER=="processor",SUBSYSTEM=="acpi",RUN+="/bin/bash -c
>> 'echo 1>  /sys%p/eject'"
>> This rule will write "1" to the "eject" sysfs file. and then call
>> acpi_eject_store function.
>
> Hmmm.  I think I understand your proposal, but it seems like a
> convoluted path to me.
>
> I guess the real question is whether we must give userspace a chance
> to decide whether to actually do the remove or not.  Is there a
> requirement to do that?  Neither the dynamic device removal flow (ACPI
> spec 4.0a, sec 6.3) nor the ejection flow example (fig 6-5) mentions
> doing that.
>
    I think we should give userspace a chance to decide whether do  the 
remove or not. About the cpu remove, it has two part, one in the linux 
kernel which mainly online/offline cpu, another is acpi core driver, 
which mainly add and remove the device of processor.
    giving userspace a chance is not acpi spec requirement. but it is 
flexible for linux kernel. many driver use the udev mechanism to has a 
chance for user to decide how to handle the event of kernel.

> I mentioned before that I think the ACPI hotplug code should be ripped
> out of the drivers and consolidated in the ACPI core.  I think it's
> pretty clear from the spec that the 0-0x7f notifications (Bus Check,
> Device Check, Eject Request, etc.) are designed to be handled by the
> core, not by individual drivers.  We handle hotplug in the drivers
> today, but I think that's mainly because we never implemented support
> in the Linux ACPI core.  There are comments in acpi_bus_check_device()
> and acpi_bus_check_scope() about what we *should* be doing there.
>
> I am opposed to adding more hotplug support to individual drivers
> because I still hope that someday we'll support it in the ACPI core.
> Many ACPI drivers don't support hotplug at all, and the ones that do
> support hotplug do it in a variety of ways.  It's all quite a mess.
>
> Bjorn
>
> .
>

I admit it is convoluted path for hot cpu remove. and the acpi processor 
driver will be consolidated in the acip core. but how to do in the acpi 
core ? I think it maybe directly call acpi_bus_hot_remove_device or send 
KOBJ_OFFLINE event to linux kernel.

I will modify the processor driver by add the acpi_bus_trim function in 
acpi_processor_hotplug_notify. and create the patch for fix this problem.
Could you help me to merge to latest linux kernel? Thanks for your 
answer again.

---
canquan.shen





