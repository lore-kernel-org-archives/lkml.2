Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2ILJ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:57:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39245 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab2ILJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:57:37 -0400
Message-ID: <50505C44.1040003@huawei.com>
Date: Wed, 12 Sep 2012 17:56:20 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH v1 19/22] PCI/x86: enable PCI bus lock mechanism for
 x86 platforms
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-20-git-send-email-jiang.liu@huawei.com> <CAErSpo7CYY0AucKj1_e=a8FDP6beQ6LKKaAEFbKxJp_ViwGhsA@mail.gmail.com>
In-Reply-To: <CAErSpo7CYY0AucKj1_e=a8FDP6beQ6LKKaAEFbKxJp_ViwGhsA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-9-12 7:22, Bjorn Helgaas wrote:
> On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> This patch turns on PCI bus lock mechanism for x86 platforms. It also
>> enhances x86 specific PCI implementation to support PCI bus lock.
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/x86/pci/acpi.c   |    6 +++++-
>>  arch/x86/pci/common.c |   12 ++++++++++++
>>  drivers/pci/Kconfig   |    3 +--
>>  3 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
>> index 2bb885a..c68dbdf 100644
>> --- a/arch/x86/pci/acpi.c
>> +++ b/arch/x86/pci/acpi.c
>> @@ -414,7 +414,8 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>>          * Maybe the desired pci bus has been already scanned. In such case
>>          * it is unnecessary to scan the pci bus with the given domain,busnum.
>>          */
>> -       bus = pci_find_bus(domain, busnum);
>> +       bus = __pci_get_and_lock_bus(domain, busnum,
>> +                                    PCI_BUS_STATE_STOPPING - 1);
>>         if (bus) {
>>                 /*
>>                  * If the desired bus exits, the content of bus->sysdata will
>> @@ -449,6 +450,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>>                         pci_free_resource_list(&resources);
>>                         __release_pci_root_info(info);
>>                 }
>> +               pci_bus_get(bus);
>>         }
>>
>>         /* After the PCI-E bus has been walked and all devices discovered,
>> @@ -475,6 +477,8 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>>  #endif
>>         }
>>
>> +       pci_unlock_and_put_bus(bus);
>> +
>>         return bus;
>>  }
>>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 0ad990a..8b7ae63 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -667,6 +667,18 @@ struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
>>         return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
>>  }
>>
>> +static DEFINE_MUTEX(pci_root_bus_mutex);
>> +
>> +void arch_pci_lock_host_bridge_hotplug(void)
>> +{
>> +       mutex_lock(&pci_root_bus_mutex);
>> +}
>> +
>> +void arch_pci_unlock_host_bridge_hotplug(void)
>> +{
>> +       mutex_unlock(&pci_root_bus_mutex);
>> +}
> 
> Are these left over from previous work?  I don't see any reference to
> them elsewhere in your patch series.
Hi Bjorn
	Eagle eyes! Yes, it's left from previous work and I have changed to
other mechanism for root bus locks.
	--Gerry

> 
>>  /*
>>   * NUMA info for PCI busses
>>   *
>> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> index a6df8b1..1bbe924 100644
>> --- a/drivers/pci/Kconfig
>> +++ b/drivers/pci/Kconfig
>> @@ -122,5 +122,4 @@ config PCI_LABEL
>>         select NLS
>>
>>  config PCI_BUS_LOCK
>> -       bool
>> -       default n
>> +       def_bool y if X86
>> --
>> 1.7.9.5
>>
> 
> .
> 


