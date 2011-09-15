Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1IOBgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:36:11 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:50519 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1IOBgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:36:09 -0400
Date: Thu, 15 Sep 2011 09:35:34 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: Re: [PATCH v3] acpi: Fix CPU hot removal problem
In-reply-to: <CAErSpo4F1oH6uBcbYRf9M49=kk49H==r=Cuh2Mrx2Wq4rmUeVg@mail.gmail.com>
X-Originating-IP: [10.166.80.130]
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Message-id: <4E715666.8090600@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.2) Gecko/20110902
 Thunderbird/6.0.2
X-CFilter-Loop: Reflected
References: <4E700EDA.7090505@huawei.com>
 <CAErSpo4F1oH6uBcbYRf9M49=kk49H==r=Cuh2Mrx2Wq4rmUeVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/9/14 22:14, Bjorn Helgaas wrote:
> On Tue, Sep 13, 2011 at 8:18 PM, canquan.shen<shencanquan@huawei.com>  wrote:
>> We run linux as a guest in Xen environment. When we used the xen tools
>> (xm vcpu-set<n>) to hot add and remove vcpu to and from the guest, we
>> encountered the failure on vcpu removal. We found the reason is that it
>> didn't go to really remove cpu in the cpu removal code path.
>>
>> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix this
>> issue. With this patch, it works fine for us.
>>
>> Signed-off-by: Shen canquan<shencanquan@huawei.com>
>> ---
>>   drivers/acpi/processor_driver.c |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c
>> b/drivers/acpi/processor_driver.c
>> index a4e0f1b..0856ef8 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -677,6 +677,13 @@ static void acpi_processor_hotplug_notify(acpi_handle
>> handle,
>>                                     "Driver data is NULL, dropping EJECT\n");
>>                         return;
>>                 }
>> +               ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>> +                       "Hot-removing processor device %s\n",
>> +                       dev_name(&device->dev)));
>> +               if (acpi_bus_trim(device, 1)) {
>> +                       printk(KERN_ERR "ACPI: Removing device failed!\n");
>
> We can do better than that.  Nobody ever looks at ACPI_DEBUG_PRINT info.
>
>      u32 id;
>      ...
>      id = pr->id;
>      if (acpi_bus_trim(device, 1))
>          printk(KERN_ERR PREFIX "Failed to remove CPU %d\n", id);
>
> (No "return" needed here.  In fact, the "return" at the bottom of
> acpi_processor_hotplug_notify() is also superfluous.  You could remove
> it at the same time.)
>
> .
>

Thanks for your suggestion. I will modify it and resend the patch.

--
Canquan.shen


