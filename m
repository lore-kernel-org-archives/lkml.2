Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2IQPlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:41:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56647 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2IQPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <5057343C.2010201@gmail.com>
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
	<1347678312-11124-6-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQWk_2gPyVUiLgvRQ=qrFNby_R7Qh-QNruobQnhVFTn21w@mail.gmail.com>
	<5057343C.2010201@gmail.com>
Date: Mon, 17 Sep 2012 08:41:07 -0700
X-Google-Sender-Auth: wfN-X5VG33YT4RhWyiH0BEoqz_g
Message-ID: <CAE9FiQWt2sPFRGTropM=oiiKv0qh2s__-MsMs=OFYx3OQkL2Tg@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 7:31 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 09/16/2012 07:27 AM, Yinghai Lu wrote:
>>> --- a/drivers/acpi/scan.c
>>> +++ b/drivers/acpi/scan.c
>>> @@ -1232,17 +1232,8 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>>>         dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
>>>         device_release_driver(&dev->dev);
>>>
>>> -       if (!rmdevice)
>>> -               return 0;
>>> -
>>> -       /*
>>> -        * unbind _ADR-Based Devices when hot removal
>>> -        */
>>> -       if (dev->flags.bus_address) {
>>> -               if ((dev->parent) && (dev->parent->ops.unbind))
>>> -                       dev->parent->ops.unbind(dev);
>>> -       }
>>> -       acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
>>> +       if (rmdevice)
>>> +               acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
>>>
>>>         return 0;
>>>  }
>>
>> for pci root bus, acpi_bus_trim() is used to remove acpi_device.
>>
>> and later in acpi_pci_root_remove to stop pci drivers/ioapic driver,
>> iommu driver then remove pci devices.
>>
>> if call back is removed there, then could some functions in
>> acpi_pci_unbind() will be skipped.
>>
>> I really do not want to add pci_stop_bus_devices() in
>> pci_root_hp.c::handle_root_bridge_removal before
>> calling acpi_bus_trim...
> Hi Yinghai,
>         We are working on a ACPI based hotplug framework for CPU, memory and IOH.
> With our framework, the sequence to remove a IOH is:
> 1) unbind all PCI device drivers for affected PCI devices.
> 2) stop and remove all affected PCI devices.
> 3) stop ACPI ioapic drivers(a new driver like PCI version).
> 4) destroy all ACPI devices.

i solved the problem...

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=15967ed108f9543c160422a7aaec18de30a53373

+       if (!acpi_bus_get_device(handle, &device)) {
+               int ret_val;
+
+               /* remove pci devices at first */
+               ret_val = acpi_bus_trim(device, 0);
+               printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
+
+               /* remove acpi devices */
+               ret_val = acpi_bus_trim(device, 1);
+               printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
+       }

...

also need to update acpi_bus_trim

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=c8805fe6ec46c46f352cdbffb13191116ea794ba

BTW, memory hot-remove may need some work.

Thanks

Yinghai
