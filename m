Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2IUC5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:57:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57261 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2IUC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWuVW6U9cE+iY0Gpua_0xhdxp6HxcWyhqqSN+L3Da_1Qg@mail.gmail.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
 <1346168638-32724-5-git-send-email-jiang.liu@huawei.com> <CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com>
 <CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com> <CAE9FiQWuVW6U9cE+iY0Gpua_0xhdxp6HxcWyhqqSN+L3Da_1Qg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Sep 2012 20:56:43 -0600
Message-ID: <CAErSpo5zeBVBowMyQS8QgAzrVbTJOb=Tuees9r1BnUZ3x13V0A@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 7:51 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Sep 20, 2012 at 4:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Sep 20, 2012 at 2:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> in that case, VFs  are stopped before PF, so they are not in device
>>> tree anymore.
>>> so pci_get_domain_bus_and_slot will not find those VFs.
>>>
>>> So the reference to PF is not released. Also vit_bus may not be released too.
>>>
>>> So you have to rework
>>>     pci_get_domain_bus_and_slot to make it work on pci devices get stopped only.
>>>
>>> or just drop this from the tree.
>>
>> pci_find_bus() is a broken interface (because there's no reference
>> counting or safety with respect to hot-plug), and if the design
>> depends on it, that means the design is broken, too.  I don't think
>> reworking pci_get_domain_bus_and_slot() is the right answer.
>>
>> It's not clear to me why we need the split between stopping and
>> removing devices.  That split leads to these zombie devices that have
>> been stopped and are no longer findable by bus_find_device() (which is
>> used by pci_get_domain_bus_and_slot()), but still "exist" in some
>> fashion until they're removed.  It's unreasonable for random PCI and
>> driver code to have to worry about that zombie state.
>
> That is not zombie state. that is driver unloaded, and not in /sys, /proc.
> that pci device only can be found under bus->devices.

It doesn't matter whether we call this a "zombie state" or just refer
to it as "devices not in /sys & /proc but still in bus->devices."  The
point is that this state is not very useful, and code outside the PCI
core should not have to know that it exists.

> just like we have pci_device_add and pci_bus_add_device
> or acpi add and acpi start.

The fact that ACPI drivers have both .add() and .start() methods is
another artifact of poor design, in my opinion.  No other subsystem
has that split, as far as I know.  The ACPI split exists because of a
messed-up ACPI hotplug implementation.  That doesn't mean we should
copy it.

>> I'm not happy about either reverting Jiang's patch or splitting
>> stop/remove again.  It complicates the design and the code.  I'll
>> apply them because they're regressions, and we don't have time for
>> redesign before 3.7.  But I encourage you to think about how to do
>> this more cleanly.
>
> That will need to redesign sriov implementation.

That's right.  If we can improve the situation by redesigning, that's
what we should do.  The present situation, where we keep adding
special cases because "that's the way the rest of the system works" is
not sustainable in the long term.

> Also that pci root bus add/start, stop/remove will need special
> sequence to make ioapic
> and dmar to be started early before normal pci device drivers and
> stopped after normal pci device drivers.

This is another thing I'm curious about.  How do you handle this
situation today (before host bridge hot-add)?

The DMAR I'm not so worried about because as far as I know, there's no
such thing as a DMAR that's discovered by PCI enumeration.  We should
discover it via ACPI, and that can happen before we enumerate anything
behind a host bridge, so I don't really see any ordering problem
between the DMAR and the PCI devices that would use it.

However, I know there *are* IOAPICs that are enumerated as PCI
devices, and I don't know whether we can deduce a relationship between
the IOAPIC and the devices that use it.  Don't we have this problem
already?  I assume that even without hot-adding a host bridge, we
might discover a PCI IOAPIC that was present at boot, and we'd have to
make sure to bind a driver to it before we use any of the PCI devices
connected to it.  How does that work?

Bjorn
