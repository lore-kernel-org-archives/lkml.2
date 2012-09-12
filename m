Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2ILIjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:39:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18932 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2ILIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:39:18 -0400
Message-ID: <505049B5.6030905@huawei.com>
Date: Wed, 12 Sep 2012 16:37:09 +0800
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
Subject: Re: [RFC PATCH v1 01/22] PCI: use pci_get_domain_bus_and_slot() to
 avoid race conditions
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-2-git-send-email-jiang.liu@huawei.com> <CAErSpo5nOJBCags9=e1y9ZcSDK9y69mZy=_+x0m_9bK78yVUJg@mail.gmail.com>
In-Reply-To: <CAErSpo5nOJBCags9=e1y9ZcSDK9y69mZy=_+x0m_9bK78yVUJg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-9-12 6:00, Bjorn Helgaas wrote:
> On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> There's a typical usage pattern to search a PCI device under a specific
>> PCI bus (domian, busno) as below:
>> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
>> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
>>
>> The above code has a race window between pci_find_bus() and pci_get_slot()
>> if PCI hotplug operations happen between them which removes the pci_bus.
>> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
>> which also reduces code complexity.
> 
> This makes sense to me.  If we support hotplug, it's fundamentally
> unsafe to keep a struct pci_bus * without having a reference or some
> way to make sure it doesn't go away.  I think we should try to
> eradicate all uses of pci_find_bus() and pci_find_next_bus().
Hi Bjorn
	I have split out these into a separate patch set at
http://www.spinics.net/lists/linux-pci/msg17227.html.
	In my latest PCI bus lock patch set, I have introduced a new
interface pci_get_bus() to replace pci_find_bus(). But pci_find_next_bus()
is a little harder to deal with, still need more work here.
	Thanks!

> 
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/ia64/sn/kernel/io_common.c      |    4 +---
>>  drivers/gpu/vga/vgaarb.c             |   15 +++------------
>>  drivers/pci/hotplug/cpcihp_generic.c |    8 ++------
>>  drivers/pci/iov.c                    |    8 ++------
>>  drivers/pci/xen-pcifront.c           |   10 ++--------
>>  5 files changed, 10 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
>> index fbb5f2f..8630875 100644
>> --- a/arch/ia64/sn/kernel/io_common.c
>> +++ b/arch/ia64/sn/kernel/io_common.c
>> @@ -229,7 +229,6 @@ void sn_pci_fixup_slot(struct pci_dev *dev, struct pcidev_info *pcidev_info,
>>  {
>>         int segment = pci_domain_nr(dev->bus);
>>         struct pcibus_bussoft *bs;
>> -       struct pci_bus *host_pci_bus;
>>         struct pci_dev *host_pci_dev;
>>         unsigned int bus_no, devfn;
>>
>> @@ -245,8 +244,7 @@ void sn_pci_fixup_slot(struct pci_dev *dev, struct pcidev_info *pcidev_info,
>>
>>         bus_no = (pcidev_info->pdi_slot_host_handle >> 32) & 0xff;
>>         devfn = pcidev_info->pdi_slot_host_handle & 0xffffffff;
>> -       host_pci_bus = pci_find_bus(segment, bus_no);
>> -       host_pci_dev = pci_get_slot(host_pci_bus, devfn);
>> +       host_pci_dev = pci_get_domain_bus_and_slot(segment, bus_no, devfn);
>>
>>         pcidev_info->host_pci_dev = host_pci_dev;
>>         pcidev_info->pdi_linux_pcidev = dev;
>> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
>> index 3df8fc0..b6852b7 100644
>> --- a/drivers/gpu/vga/vgaarb.c
>> +++ b/drivers/gpu/vga/vgaarb.c
>> @@ -1066,7 +1066,6 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>>                 }
>>
>>         } else if (strncmp(curr_pos, "target ", 7) == 0) {
>> -               struct pci_bus *pbus;
>>                 unsigned int domain, bus, devfn;
>>                 struct vga_device *vgadev;
>>
>> @@ -1085,19 +1084,11 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>>                         pr_debug("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
>>                                 domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
>>
>> -                       pbus = pci_find_bus(domain, bus);
>> -                       pr_debug("vgaarb: pbus %p\n", pbus);
>> -                       if (pbus == NULL) {
>> -                               pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
>> -                                       domain, bus);
>> -                               ret_val = -ENODEV;
>> -                               goto done;
>> -                       }
>> -                       pdev = pci_get_slot(pbus, devfn);
>> +                       pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
>>                         pr_debug("vgaarb: pdev %p\n", pdev);
>>                         if (!pdev) {
>> -                               pr_err("vgaarb: invalid PCI address %x:%x\n",
>> -                                       bus, devfn);
>> +                               pr_err("vgaarb: invalid PCI address %x:%x:%x\n",
>> +                                       domain, bus, devfn);
>>                                 ret_val = -ENODEV;
>>                                 goto done;
>>                         }
>> diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
>> index 81af764..a6a71c4 100644
>> --- a/drivers/pci/hotplug/cpcihp_generic.c
>> +++ b/drivers/pci/hotplug/cpcihp_generic.c
>> @@ -154,12 +154,8 @@ static int __init cpcihp_generic_init(void)
>>         if(!r)
>>                 return -EBUSY;
>>
>> -       bus = pci_find_bus(0, bridge_busnr);
>> -       if (!bus) {
>> -               err("Invalid bus number %d", bridge_busnr);
>> -               return -EINVAL;
>> -       }
>> -       dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
>> +       dev = pci_get_domain_bus_and_slot(0, bridge_busnr,
>> +                                         PCI_DEVFN(bridge_slot, 0));
>>         if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
>>                 err("Invalid bridge device %s", bridge);
>>                 pci_dev_put(dev);
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index 74bbaf8..c7d2969 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -152,15 +152,11 @@ failed1:
>>  static void virtfn_remove(struct pci_dev *dev, int id, int reset)
>>  {
>>         char buf[VIRTFN_ID_LEN];
>> -       struct pci_bus *bus;
>>         struct pci_dev *virtfn;
>>         struct pci_sriov *iov = dev->sriov;
>>
>> -       bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
>> -       if (!bus)
>> -               return;
>> -
>> -       virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
>> +       virtfn = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus),
>> +                       virtfn_bus(dev, id), virtfn_devfn(dev, id));
>>         if (!virtfn)
>>                 return;
>>
>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>> index d6cc62c..def8d0b 100644
>> --- a/drivers/pci/xen-pcifront.c
>> +++ b/drivers/pci/xen-pcifront.c
>> @@ -982,7 +982,6 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>>         int err = 0;
>>         int i, num_devs;
>>         unsigned int domain, bus, slot, func;
>> -       struct pci_bus *pci_bus;
>>         struct pci_dev *pci_dev;
>>         char str[64];
>>
>> @@ -1032,13 +1031,8 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>>                         goto out;
>>                 }
>>
>> -               pci_bus = pci_find_bus(domain, bus);
>> -               if (!pci_bus) {
>> -                       dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
>> -                               domain, bus);
>> -                       continue;
>> -               }
>> -               pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
>> +               pci_dev = pci_get_domain_bus_and_slot(domain, bus,
>> +                               PCI_DEVFN(slot, func));
>>                 if (!pci_dev) {
>>                         dev_dbg(&pdev->xdev->dev,
>>                                 "Cannot get PCI device %04x:%02x:%02x.%d\n",
>> --
>> 1.7.9.5
>>
> 
> .
> 


