Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2BHR0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:26:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34211 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2BHR0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:26:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4cd2TR4207RUk53B+jDK_DONduo8pU8EWWOgdGeg7CeQ@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-7-git-send-email-yinghai@kernel.org>
	<CAErSpo4cd2TR4207RUk53B+jDK_DONduo8pU8EWWOgdGeg7CeQ@mail.gmail.com>
Date: Wed, 8 Feb 2012 09:26:52 -0800
X-Google-Sender-Auth: V6iCiSBlU6heLMJKtdQS3w1QnWQ
Message-ID: <CAE9FiQWBLpK-Tzmvf1dHeub4Yy2ziRBpnzYuEdBvdJASnbDqYw@mail.gmail.com>
Subject: Re: [PATCH 06/24] PCI: Add busn_res tracking in core
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 8:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> update pci_scan_root_bus, and pci_scan_bus to insert root bus busn into
>> iobusn_resource tree.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/probe.c  |   30 ++++++++++++++++++++++++++----
>>  drivers/pci/remove.c |    1 +
>>  include/linux/pci.h  |    4 ++++
>>  3 files changed, 31 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index fabf9d0..cdd6e83 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1667,8 +1667,9 @@ void pci_bus_release_busn_res(struct pci_bus *b)
>>                        res, ret ? "can not be" : "is");
>>  }
>>
>> -struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>> -               struct pci_ops *ops, void *sysdata, struct list_head *resources)
>> +struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
>> +               int bus_max, struct pci_ops *ops, void *sysdata,
>> +               struct list_head *resources)
>>  {
>>        struct pci_bus *b;
>>
>> @@ -1676,10 +1677,26 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>>        if (!b)
>>                return NULL;
>>
>> +       pci_bus_insert_busn_res(b, bus, bus_max);
>>        b->subordinate = pci_scan_child_bus(b);
>>        pci_bus_add_devices(b);
>>        return b;
>>  }
>> +EXPORT_SYMBOL(pci_scan_root_bus_max);
>> +
>> +struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>> +               struct pci_ops *ops, void *sysdata,
>> +               struct list_head *resources)
>> +{
>> +       struct pci_bus *b;
>> +
>> +       b = pci_scan_root_bus_max(parent, bus, 255, ops, sysdata, resources);
>> +
>> +       if (b)
>> +               pci_bus_update_busn_res_end(b, b->subordinate);
>> +
>> +       return b;
>> +}
>>  EXPORT_SYMBOL(pci_scan_root_bus);
>>
>>  /* Deprecated; use pci_scan_root_bus() instead */
>> @@ -1692,9 +1709,11 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
>>        pci_add_resource(&resources, &ioport_resource);
>>        pci_add_resource(&resources, &iomem_resource);
>>        b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
>> -       if (b)
>> +       if (b) {
>> +               pci_bus_insert_busn_res(b, bus, 255);
>>                b->subordinate = pci_scan_child_bus(b);
>> -       else
>> +               pci_bus_update_busn_res_end(b, b->subordinate);
>> +       } else
>>                pci_free_resource_list(&resources);
>>        return b;
>>  }
>> @@ -1710,7 +1729,10 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
>>        pci_add_resource(&resources, &iomem_resource);
>>        b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
>>        if (b) {
>> +               pci_bus_insert_busn_res(b, bus, 255);
>>                b->subordinate = pci_scan_child_bus(b);
>> +               pci_bus_update_busn_res_end(b, b->subordinate);
>> +
>>                pci_bus_add_devices(b);
>>        } else {
>>                pci_free_resource_list(&resources);
>> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
>> index 82f8ae5..5b679d2 100644
>> --- a/drivers/pci/remove.c
>> +++ b/drivers/pci/remove.c
>> @@ -68,6 +68,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
>>
>>        down_write(&pci_bus_sem);
>>        list_del(&pci_bus->node);
>> +       pci_bus_release_busn_res(pci_bus);
>>        up_write(&pci_bus_sem);
>>        if (!pci_bus->is_added)
>>                return;
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 3da935c..d5b6786 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -668,6 +668,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>  void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
>>  void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
>>  void pci_bus_release_busn_res(struct pci_bus *b);
>> +struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
>> +                                            int busmax, struct pci_ops *ops,
>> +                                            void *sysdata,
>> +                                            struct list_head *resources);
>>  struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>>                                             struct pci_ops *ops, void *sysdata,
>>                                             struct list_head *resources);
>
> Now we have both pci_bus_insert_busn_res() and
> pci_scan_root_bus_max().  Why do we need both?  I think it's too much
> of a burden on architectures to expect them to understand both.
>
> Maybe some sample pseudo-code using both interfaces would help me
> understand what you expect a typical architecture to do.

We need to call pci_bus_insert_busn_res for root bus:
1. after that bus is allocated (...) : that busn_res is in the bus struct.
2. before pci_scan_child_bus

Yinghai
