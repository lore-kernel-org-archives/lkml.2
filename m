Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2ILPmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:42:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64601 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2ILPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:42:49 -0400
Message-ID: <5050AD65.1000801@gmail.com>
Date: Wed, 12 Sep 2012 23:42:29 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/22] PCI: use a global lock to serialize PCI
 root bridge hotplug operations
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-7-git-send-email-jiang.liu@huawei.com> <CAErSpo5ixjvv3r9wzCXFrDZ790u9_K5KCuQ7GQO3fFuFuiVJZg@mail.gmail.com>
In-Reply-To: <CAErSpo5ixjvv3r9wzCXFrDZ790u9_K5KCuQ7GQO3fFuFuiVJZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 06:57 AM, Bjorn Helgaas wrote:
> On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Currently there's no mechanism to protect the global pci_root_buses list
>> from dynamic change at runtime. That means, PCI root bridge hotplug
>> operations, which dynamically change the pci_root_buses list, may cause
>> invalid memory accesses.
>>
>> So introduce a global lock to serialize accesses to the pci_root_buses
>> list and serialize PCI host bridge hotplug operations.
>>
>> Be careful, never try to acquire this global lock from PCI device drivers,
>> that may cause deadlocks.
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  drivers/acpi/pci_root.c           |    8 +++++++-
>>  drivers/edac/i7core_edac.c        |   16 +++++++---------
>>  drivers/gpu/drm/drm_fops.c        |    6 +++++-
>>  drivers/pci/host-bridge.c         |   19 +++++++++++++++++++
>>  drivers/pci/hotplug/sgi_hotplug.c |    2 ++
>>  drivers/pci/pci-sysfs.c           |    2 ++
>>  drivers/pci/probe.c               |    5 ++++-
>>  drivers/pci/search.c              |    9 ++++++++-
>>  include/linux/pci.h               |    8 ++++++++
>>  9 files changed, 62 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index 7aff631..6bd0e32 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -463,6 +463,8 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>>         if (!root)
>>                 return -ENOMEM;
>>
>> +       pci_host_bridge_hotplug_lock();
> 
> Here's where I get lost.  This is an ACPI driver's .add() routine,
> which is analogous to a PCI driver's .probe() routine.  PCI driver
> .probe() routines don't need to be concerned with PCI device hotplug.
> All the hotplug-related locking is handled by the PCI core, not by
> individual drivers.  So why do we need it here?
> 
> I'm not suggesting that the existing locking is correct.  I'm just not
> convinced this is the right way to fix it.
> 
> The commit log says we need protection for the global pci_root_buses
> list.  But even with this whole series, we still traverse the list
> without protection in places like pcibios_resource_survey() and
> pci_assign_unassigned_resources().
> 
> Maybe we can make progress on this by identifying specific failures
> that can happen in a couple of these paths, e.g., acpi_pci_root_add()
> and i7core_xeon_pci_fixup().  If we look at those paths, we might a
> way to fix this in a more general fashion than throwing in lock/unlock
> pairs.
> 
> It might also help to know what the rule is for when we need to use
> pci_host_bridge_hotplug_lock() and pci_host_bridge_hotplug_unlock().
> Apparently it is not as simple as protecting every reference to the
> pci_root_buses list.
Hi Bjorn,
	It's really a challenge work to protect the pci_root_buses list:)
All evils are caused by the pci_find_next_bus() interface, which is designed
to be called at boot time only. I have tried several other solutions but
failed.
	First I tried "pci_get_next_bus()" which holds a reference to the
returned root bus "pci_bus". But that doesn't help because pci_bus could
be removed from the pci_root_buses list even you hold a reference to
pci_bus. And it will cause trouble when you call pci_get_next_bus(pci_bus)
again because pci_bus->node.next is invalid now.
	Then I tried RCU and also failed because caller of pci_get_next_bus()
may sleep.
	And at last the global host bridge hotplug lock solution. The rules
for locking are:
	1) No need for locking when accessing the pci_root_buses list at
system initialization stages. (It's system initialization instead of driver
initialization here because driver's initialization code may be called
at runtime when loading the driver.) It's single-threaded and no hotplug
during system initialization stages.
	2) Should acquire the global lock when accessing the pci_root_buses
list at runtime.

	I have done several rounds of scanning to identify accessing to
the pci_root_buses list at runtime. But there may still be something missed:(

	I think the best solution is to get rid of the pci_find_next_bus().
but not sure whether we could achieve that.

> 
>> diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
>> index 123de28..f559b5b 100644
>> --- a/drivers/gpu/drm/drm_fops.c
>> +++ b/drivers/gpu/drm/drm_fops.c
>> @@ -344,9 +344,13 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
>>                         pci_dev_put(pci_dev);
>>                 }
>>                 if (!dev->hose) {
>> -                       struct pci_bus *b = pci_bus_b(pci_root_buses.next);
>> +                       struct pci_bus *b;
>> +
>> +                       pci_host_bridge_hotplug_lock();
>> +                       b = pci_find_next_bus(NULL);
> 
> Here's another case I don't understand.  We know already that
> pci_find_next_bus() is unsafe with respect to hotplug because it
> doesn't hold a reference on the struct pci_bus it returns.  Can't we
> replace this with some variety of pci_get_next_bus() that *does*
> acquire a reference?
> 
> Actually, I looked at the callers of pci_find_next_bus(), and most of
> them are unsafe in an even deeper way: they're doing device setup in
> initcalls, so that setup won't be done for hot-added devices.  For
> example, I can pick on sba_init() because I think I wrote it back in
> the dark ages.  sba_init() is a subsys_initcall that calls
> sba_connect_bus() for every bus we know about at boot-time, and it
> sets the host bridge's iommu pointer.  If we were to hot-add a host
> bridge, we would never set the iommu pointer.
That's a more fundamental issue, another big topic for us:(

> 
> I'm not sure why you didn't add a pci_host_bridge_hotplug_lock() in
> the sba_init() path, since it looks similar to the drm_open_helper()
> path above.  But in any case, I think that would be the wrong thing to
> do because it would fix the superficial problem while leaving the
> deeper problem of host bridge hot-add not setting the iommu pointer.
sba_init is called during system initialization stages through subsys_initcall,
so no extra protection for it.

>>                         if (b)
>>                                 dev->hose = b->sysdata;
>> +                       pci_host_bridge_hotplug_unlock();
>>                 }
>>         }
>>  #endif
> ...
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index 993d4a0..f1147a7 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -100,6 +100,13 @@ struct pci_bus * pci_find_bus(int domain, int busnr)
>>   * initiated by passing %NULL as the @from argument.  Otherwise if
>>   * @from is not %NULL, searches continue from next device on the
>>   * global list.
>> + *
>> + * Please don't call this function at rumtime if possible.
>> + * It's designed to be called at boot time only because it's unsafe
>> + * to PCI root bridge hotplug operations. But some drivers do invoke
>> + * it at runtime and it's hard to fix those drivers. In such cases,
>> + * use pci_host_bridge_hotplug()_{lock|unlock} to protect the PCI root
>> + * bus list, but you need to be really careful to avoid deadlock.
> 
> I'm not convinced that it's too hard to fix these drivers :)  There
> are only six callers, and the only ones that could possibly be at
> runtime are drm_open_helper(), sn_pci_hotplug_init(), and
> bus_rescan_store().
The same issue for i7core_xeon_pci_fixup() in i7core_edac driver too.
Will think about this solution.

--Gerry

> 
> Bjorn
> 

