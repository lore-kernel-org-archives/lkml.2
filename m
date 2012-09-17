Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2IQObh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:31:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43335 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2IQObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:31:35 -0400
Message-ID: <5057343C.2010201@gmail.com>
Date: Mon, 17 Sep 2012 22:31:24 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 5/9] ACPI/pci-bind: remove bind/unbind callbacks from
 acpi_device_ops
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com> <1347678312-11124-6-git-send-email-jiang.liu@huawei.com> <CAE9FiQWk_2gPyVUiLgvRQ=qrFNby_R7Qh-QNruobQnhVFTn21w@mail.gmail.com>
In-Reply-To: <CAE9FiQWk_2gPyVUiLgvRQ=qrFNby_R7Qh-QNruobQnhVFTn21w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 07:27 AM, Yinghai Lu wrote:
> On Fri, Sep 14, 2012 at 8:05 PM, Jiang Liu <liuj97@gmail.com> wrote:
>>  From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Now ACPI devices are created before/destroyed after corresponding PCI
>> devices, and acpi_platform_notify/acpi_platform_notify_remove will
>> update PCI<->ACPI binding relationship when creating/destroying PCI
>> devices, there's no need to invoke bind/unbind callbacks from ACPI
>> device probe/destroy routines anymore. So remove bind/unbind callbacks
>> from acpi_device_ops.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/acpi/pci_bind.c     |  100 +++++++++----------------------------------
>>  drivers/acpi/pci_root.c     |    9 ----
>>  drivers/acpi/scan.c         |   21 +--------
>>  include/acpi/acpi_bus.h     |    4 --
>>  include/acpi/acpi_drivers.h |    1 -
>>  5 files changed, 23 insertions(+), 112 deletions(-)
>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> index d1ecca2..f31cb2f 100644
>> --- a/drivers/acpi/scan.c
>> +++ b/drivers/acpi/scan.c
>> @@ -1232,17 +1232,8 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>>         dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
>>         device_release_driver(&dev->dev);
>>
>> -       if (!rmdevice)
>> -               return 0;
>> -
>> -       /*
>> -        * unbind _ADR-Based Devices when hot removal
>> -        */
>> -       if (dev->flags.bus_address) {
>> -               if ((dev->parent) && (dev->parent->ops.unbind))
>> -                       dev->parent->ops.unbind(dev);
>> -       }
>> -       acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
>> +       if (rmdevice)
>> +               acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
>>
>>         return 0;
>>  }
> 
> for pci root bus, acpi_bus_trim() is used to remove acpi_device.
> 
> and later in acpi_pci_root_remove to stop pci drivers/ioapic driver,
> iommu driver then remove pci devices.
> 
> if call back is removed there, then could some functions in
> acpi_pci_unbind() will be skipped.
> 
> I really do not want to add pci_stop_bus_devices() in
> pci_root_hp.c::handle_root_bridge_removal before
> calling acpi_bus_trim...
Hi Yinghai,
	We are working on a ACPI based hotplug framework for CPU, memory and IOH.
With our framework, the sequence to remove a IOH is:
1) unbind all PCI device drivers for affected PCI devices.
2) stop and remove all affected PCI devices.
3) stop ACPI ioapic drivers(a new driver like PCI version).
4) destroy all ACPI devices.

--Gerry
> 
> Thanks
> 
> Yinghai
> 

