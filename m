Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478Ab2ILQvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:51:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64466 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab2ILQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <5050AD65.1000801@gmail.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
 <1344355862-2726-7-git-send-email-jiang.liu@huawei.com> <CAErSpo5ixjvv3r9wzCXFrDZ790u9_K5KCuQ7GQO3fFuFuiVJZg@mail.gmail.com>
 <5050AD65.1000801@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Sep 2012 10:51:05 -0600
Message-ID: <CAErSpo4=cakjCQ_Z_nUa2xZQr9KV72kxtsgrW0cjeFN=ktb8zQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 06/22] PCI: use a global lock to serialize PCI root
 bridge hotplug operations
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 9:42 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 09/12/2012 06:57 AM, Bjorn Helgaas wrote:
>> On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> Currently there's no mechanism to protect the global pci_root_buses list
>>> from dynamic change at runtime. That means, PCI root bridge hotplug
>>> operations, which dynamically change the pci_root_buses list, may cause
>>> invalid memory accesses.
>>>
>>> So introduce a global lock to serialize accesses to the pci_root_buses
>>> list and serialize PCI host bridge hotplug operations.

>>> @@ -463,6 +463,8 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>>>         if (!root)
>>>                 return -ENOMEM;
>>>
>>> +       pci_host_bridge_hotplug_lock();
>>
>> Here's where I get lost.  This is an ACPI driver's .add() routine,
>> which is analogous to a PCI driver's .probe() routine.  PCI driver
>> .probe() routines don't need to be concerned with PCI device hotplug.
>> All the hotplug-related locking is handled by the PCI core, not by
>> individual drivers.  So why do we need it here?
>>
>> I'm not suggesting that the existing locking is correct.  I'm just not
>> convinced this is the right way to fix it.
>>
>> The commit log says we need protection for the global pci_root_buses
>> list.  But even with this whole series, we still traverse the list
>> without protection in places like pcibios_resource_survey() and
>> pci_assign_unassigned_resources().
>>
>> Maybe we can make progress on this by identifying specific failures
>> that can happen in a couple of these paths, e.g., acpi_pci_root_add()
>> and i7core_xeon_pci_fixup().  If we look at those paths, we might a
>> way to fix this in a more general fashion than throwing in lock/unlock
>> pairs.
>>
>> It might also help to know what the rule is for when we need to use
>> pci_host_bridge_hotplug_lock() and pci_host_bridge_hotplug_unlock().
>> Apparently it is not as simple as protecting every reference to the
>> pci_root_buses list.
> Hi Bjorn,
>         It's really a challenge work to protect the pci_root_buses list:)

Yes.  IIRC, your last patch was to unexport pci_root_buses, which I
think is a great idea.

> All evils are caused by the pci_find_next_bus() interface, which is designed
> to be called at boot time only. I have tried several other solutions but
> failed.
>         First I tried "pci_get_next_bus()" which holds a reference to the
> returned root bus "pci_bus". But that doesn't help because pci_bus could
> be removed from the pci_root_buses list even you hold a reference to
> pci_bus. And it will cause trouble when you call pci_get_next_bus(pci_bus)
> again because pci_bus->node.next is invalid now.

That sounds like a bug.  If an interface returns a structure after
acquiring a reference, the caller should be able to rely on the
structure remaining valid.  Adding extra locks doesn't feel like the
right solution for that problem.

In the big picture, I'm not sure how much sense all the
pci_find_bus(), pci_find_next_bus(), pci_get_bus(),
pci_get_next_bus(), etc., interfaces really make.  There really aren't
very many callers, and most of them look a bit hacky to me.  Usually
they're quirks trying to locate a device or drivers for device A
trying to locate companion device B or something similar.  I wonder if
we could figure out some entirely new interface that wouldn't involve
traversing so much of the hierarchy and therefore could be safer.

>         Then I tried RCU and also failed because caller of pci_get_next_bus()
> may sleep.
>         And at last the global host bridge hotplug lock solution. The rules
> for locking are:
>         1) No need for locking when accessing the pci_root_buses list at
> system initialization stages. (It's system initialization instead of driver
> initialization here because driver's initialization code may be called
> at runtime when loading the driver.) It's single-threaded and no hotplug
> during system initialization stages.
>         2) Should acquire the global lock when accessing the pci_root_buses
> list at runtime.
>
>         I have done several rounds of scanning to identify accessing to
> the pci_root_buses list at runtime. But there may still be something missed:(

That's part of what makes me uneasy.  We have to look at a lot of code
outside drivers/pci to analyze correctness, which is difficult.  It
would be much better if we could do something in the core, where we
only have to analyze drivers/pci.  I know this is probably much harder
and probably involves replacing or removing some of these interfaces
that cause problems.

>         I think the best solution is to get rid of the pci_find_next_bus().
> but not sure whether we could achieve that.

>> Actually, I looked at the callers of pci_find_next_bus(), and most of
>> them are unsafe in an even deeper way: they're doing device setup in
>> initcalls, so that setup won't be done for hot-added devices.  For
>> example, I can pick on sba_init() because I think I wrote it back in
>> the dark ages.  sba_init() is a subsys_initcall that calls
>> sba_connect_bus() for every bus we know about at boot-time, and it
>> sets the host bridge's iommu pointer.  If we were to hot-add a host
>> bridge, we would never set the iommu pointer.

> That's a more fundamental issue, another big topic for us:(

>> I'm not sure why you didn't add a pci_host_bridge_hotplug_lock() in
>> the sba_init() path, since it looks similar to the drm_open_helper()
>> path above.  But in any case, I think that would be the wrong thing to
>> do because it would fix the superficial problem while leaving the
>> deeper problem of host bridge hot-add not setting the iommu pointer.

> sba_init is called during system initialization stages through subsys_initcall,
> so no extra protection for it.

OK, I see your reasoning.  But I don't agree :)  All the users of an
interface should use the same locking scheme, even if they're at
boot-time where we "know" we don't need it.  It's too hard to analyze
differences, and code gets copied from one place to somewhere else
where it might not be appropriate.

Bjorn
