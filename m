Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1IFGuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:50:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46179 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1IFGuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:50:15 -0400
Date: Tue, 06 Sep 2011 14:48:52 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: Re: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
In-reply-to: <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
X-Originating-IP: [10.166.80.171]
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhao@intel.com" <rui.zhao@intel.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Message-id: <4E65C254.8090107@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.1) Gecko/20110830
 Thunderbird/6.0.1
X-CFilter-Loop: Reflected
References: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
 <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/9/6 12:19, Bjorn Helgaas wrote:
>> 主题: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
>>
>> In Xen virtualization environment, When I used xen tools (xm vcpu-set vcpu_number ) to test the vcpu add and remove, I found it is failure on vcpu remove, I found the reason is that nothing to do when cpu remove in acpi_processor_hotplug_notify function, so I add the code of send the OFFLINE message to udev and add the rule of udev. it is ok on vcpu remove.
>> Signed-off-by: Shen canquan<shencanquan@huawei.com>
>> ---
>>   drivers/acpi/processor_driver.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index a4e0f1b..a1c564f 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -677,6 +677,8 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>>                                      "Driver data is NULL, dropping EJECT\n");
>>                          return;
>>                  }
>> +
>> +               kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>>                  break;
>>          default:
>>                  ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>
> The processor driver used to generate ONLINE and OFFLINE messages.  I
> removed them with c1815e0740.  According to the changelog, the driver
> core still generates KOBJ_ADD and KOBJ_REMOVE events.
>

Thanks for your answer.
When I used xen tools (xm vcpu-set vcpu_numer) to reduce the cpu number. 
I don't found any event . I use the following tool to capture the event: 
udevadm monitor --env --kernel --udev.

If I used xen tools to add the cpu number , udev module will receive the 
KOBJ_ADD event.

In my patch ,It is more fine to replace KOBJ_OFFLINE to KOBJ_REMOVE event .

btw: how to find changelog of the c1815e0740.

> Could you fix the Xen vcpu add/remove problem by looking for
> ADD/REMOVE events rather than ONLINE/OFFLINE?
>

Xen vcpu add/remove module has send the sci interrupt to linux ACPI Core 
module. the sci interrupt handler function (acpi_ev_gpe_xrupt_handler) 
has hanled it and called to AML code of processor to add and remove cpu. 
and then call back acpi_processor_hotplug_notify function to notify 
linux acpi processor driver .



> I removed ONLINE/OFFLINE because I think hotplug should be handled in
> the ACPI core, not in the drivers.  Removing ONLINE/OFFLINE got rid of
> one small piece of driver-specific hotplug handling.  Obviously,
> there's still a lot to do.
>
> If using ADD/REMOVE is not sufficient, what is the justification for
> needing both REMOVE and OFFLINE, and how would they be different?
>

I think the device of processor add and remove should be handle in 
processor driver . The ONLINE/OFFLINE function of CPU should be handle 
in linux kernel. so when removing cpu by Xen. at first it should be 
notify linux kernel to offline the cpu and then remove the device of 
processor.

btw: I found acpi_eject_store function in driver/acpi/scan.c will deal 
the offline cpu and remove the device of processor.


> Bjorn
>
>




