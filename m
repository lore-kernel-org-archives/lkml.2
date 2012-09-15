Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2IOHCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 03:02:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2IOHCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 03:02:20 -0400
Message-ID: <505427F2.7080709@gmail.com>
Date: Sat, 15 Sep 2012 15:02:10 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH v2 3/9] PCI: preserve dev->subordinate until pci_stop_dev()
 has been called
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com> <1347678312-11124-4-git-send-email-jiang.liu@huawei.com> <CAE9FiQU66sW4HsDuqh69evvcT0cfx61=6JtgrU7FTJjMo-_Njw@mail.gmail.com>
In-Reply-To: <CAE9FiQU66sW4HsDuqh69evvcT0cfx61=6JtgrU7FTJjMo-_Njw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 01:09 PM, Yinghai Lu wrote:
> On Fri, Sep 14, 2012 at 8:05 PM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Yijing Wang <wangyijing@huawei.com>
>>
>> Changeset 2ed168eeb3edec029aa0eca5cb981d6376f931f9 "PCI: Fold stop and
>> remove helpers into their callers" has changed the behavior when
>> removing a PCI device.
>>
>> Previously, for a PCI bridge device with secondary bus, dev->subordinate
>> is valid when calling PCI bus notification callbacks for
>> BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events. Now dev->subordinate
>> has been reset to NULL when calling callbacks for BUS_NOTIFY_DEL_DEVICE
>> events, which may break some PCI bus notification callbacks.
>>
>> So revert to the original behavior to keep dev->subordinate valid for
>> both BUS_NOTIFY_ADD_DEVICE events and BUS_NOTIFY_DEL_DEVICE events.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  drivers/pci/remove.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
>> index 86a4636..6244956 100644
>> --- a/drivers/pci/remove.c
>> +++ b/drivers/pci/remove.c
>> @@ -79,16 +79,16 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>>          * iterator.  Therefore, iterate in reverse so we remove the VFs
>>          * first, then the PF.
>>          */
>> -       if (bus) {
>> +       if (bus)
>>                 list_for_each_entry_safe_reverse(child, tmp,
>>                                                  &bus->devices, bus_list)
>>                         pci_stop_and_remove_bus_device(child);
>> +       pci_stop_dev(dev);
>>
>> +       if (bus) {
>>                 pci_remove_bus(bus);
>>                 dev->subordinate = NULL;
>>         }
>> -
>> -       pci_stop_dev(dev);
>>         pci_destroy_dev(dev);
>>  }
>>  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
> 
> for support root bus support with acpi_pci_root (ioapic/iommu) will
> need pci_stop_bus_devices()
> 
> so I just put those function back...
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=247a40206cf44488f21bc6074cf0ba2805d4d840
Hi Yinghai,
	I will just drop this patch when merging with your pci root bus hotplug work.
	--Gerry


