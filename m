Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2FKBzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 21:55:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51573 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2FKBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 21:55:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4FD5500F.40404@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 10:55:27 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Kani, Toshimitsu" <toshi.kani@hp.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] ACPI: Add _OST support for ACPI container hotplug
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com> <1337826324-16802-6-git-send-email-toshi.kani@hp.com>,<4FCD8D95.1060700@jp.fujitsu.com> <45D38E03-0465-42A1-AEB3-4D120FFF66DC@hp.com>
In-Reply-To: <45D38E03-0465-42A1-AEB3-4D120FFF66DC@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

Sorry for late reply.

2012/06/06 0:36, Kani, Toshimitsu wrote:
> On Jun 4, 2012, at 9:40 PM, "Yasuaki Ishimatsu"<isimatu.yasuaki@jp.fujitsu.com>  wrote:
>
>> Hi Toshi,
>>
>> 2012/05/24 11:25, Toshi Kani wrote:
>>> Changed container_notify_cb() to call ACPI _OST method when ACPI
>>> container hotplug operation has completed. Slightly restructured
>>> the code with the same logic. The function sets eject_pending bit
>>> for an eject request since it does not initiate hot-remove operation.
>>> This bit is checked by the sysfs eject handler to determine if the
>>> request is originated from an ACPI eject notification.
>>>
>>> Signed-off-by: Toshi Kani<toshi.kani@hp.com>
>>> ---
>>>   drivers/acpi/container.c |   43 ++++++++++++++++++++++++++++---------------
>>>   1 files changed, 28 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
>>> index 45cd03b..1f9f7d7 100644
>>> --- a/drivers/acpi/container.c
>>> +++ b/drivers/acpi/container.c
>>> @@ -158,9 +158,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>>>       int result;
>>>       int present;
>>>       acpi_status status;
>>> -
>>> -
>>> -    present = is_device_present(handle);
>>> +    u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>>>
>>>       switch (type) {
>>>       case ACPI_NOTIFY_BUS_CHECK:
>>> @@ -169,32 +167,47 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>>>           printk(KERN_WARNING "Container driver received %s event\n",
>>>                  (type == ACPI_NOTIFY_BUS_CHECK) ?
>>>                  "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
>>> +
>>> +        present = is_device_present(handle);
>>>           status = acpi_bus_get_device(handle,&device);
>>> -        if (present) {
>>> -            if (ACPI_FAILURE(status) || !device) {
>>> -                result = container_device_add(&device, handle);
>>> -                if (!result)
>>> -                    kobject_uevent(&device->dev.kobj,
>>> -                               KOBJ_ONLINE);
>>> -                else
>>> -                    printk(KERN_WARNING
>>> -                           "Failed to add container\n");
>>> -            }
>>> -        } else {
>>> +        if (!present) {
>>>               if (ACPI_SUCCESS(status)) {
>>>                   /* device exist and this is a remove request */
>>> +                device->flags.eject_pending = 1;
>>>                   kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>>> +                return;
>>>               }
>>> +            break;
>>> +        }
>>> +
>>
>>> +        if (!ACPI_FAILURE(status) || device)
>>> +            break;
>>
>> The logic is not same as previous logic.
>> I think the following logic is correct.
>>
>>         if (!ACPI_FAILURE(status)&&  device)
>>             break;
>
> Hi Yasuaki,
>
> Great catch! You are right about that. Now the question is what this code should do when the call failed but the device gets set. This is rather hypothetical case, but I think it is safer to fail a hot add request whenever the device is set. What do you think?
>

I think so, too.
So there is no comment on your patch.

Thanks,
Yasuaki Ishimatsu

> Thanks,
> -Toshi
>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>>> +
>>> +        result = container_device_add(&device, handle);
>>> +        if (result) {
>>> +            printk(KERN_WARNING "Failed to add container\n");
>>> +            break;
>>>           }
>>> +
>>> +        kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
>>> +        ost_code = ACPI_OST_SC_SUCCESS;
>>>           break;
>>> +
>>>       case ACPI_NOTIFY_EJECT_REQUEST:
>>>           if (!acpi_bus_get_device(handle,&device)&&   device) {
>>> +            device->flags.eject_pending = 1;
>>>               kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>>> +            return;
>>>           }
>>>           break;
>>> +
>>>       default:
>>> -        break;
>>> +        /* non-hotplug event; possibly handled by other handler */
>>> +        return;
>>>       }
>>> +
>>> +    /* Inform firmware that the hotplug operation has completed */
>>> +    (void) acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
>>>       return;
>>>   }
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


