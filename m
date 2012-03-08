Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2CHEpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:45:47 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52068 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266Ab2CHEpl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:45:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVTng2Bi4z9YY9CustC7KkTr-6+qFaaqu8F4dd0WAKGig@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
 <1331018040-30725-17-git-send-email-yinghai@kernel.org> <CAErSpo59kzBL1ApWuWWcymd9UR3m3vB3zkUoJezn66As+-97dQ@mail.gmail.com>
 <CAE9FiQVTng2Bi4z9YY9CustC7KkTr-6+qFaaqu8F4dd0WAKGig@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Mar 2012 21:45:18 -0700
Message-ID: <CAErSpo72DxcCtMedHUu=t1-bGXp3sqa+hCgP2tNT=z6EfiHTJQ@mail.gmail.com>
Subject: Re: [PATCH 16/23] PCI: add pci bus removal through /sys/.../pci_bus/.../remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Matthew Garrett, linux-acpi for ACPI hotplug]

On Wed, Mar 7, 2012 at 5:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Mar 7, 2012 at 4:03 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> it supports both pci root bus and pci bus under pci bridge.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: linux-doc@vger.kernel.org
>>> ---
>>>  Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
>>>  drivers/pci/pci-sysfs.c                 |   28 ++++++++++++++++++++++++++++
>>>  2 files changed, 36 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>>> index 95f0f37..22392de 100644
>>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>>> @@ -92,6 +92,14 @@ Description:
>>>                hot-remove the PCI device and any of its children.
>>>                Depends on CONFIG_HOTPLUG.
>>>
>>> +What:          /sys/bus/pci/devices/.../pci_bus/.../remove
>>> +Date:          March 2012
>>> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
>>> +Description:
>>> +               Writing a non-zero value to this attribute will
>>> +               hot-remove the PCI bus and any of its children.
>>
>> Is this the interface we want?  It seems like the ultimate goal is to
>> remove the *host bridge*, i.e., the PNP0A08 device on x86.  If that's
>> the case, the logical thing seems like a
>> /sys/bus/acpi/devices/PNP0A08:00/remove file.
>>
>> All the current "remove" attributes are for *devices*, e.g.,
>> /sys/devices/pci0000:00/0000:00:03.0/remove, not for *buses*.
>
> could add that later.

Of course, we can always add things later.  What I'm concerned about
is that once we add an interface like this to sysfs, it's difficult to
remove.  Therefore, I don't want to add things that are clearly not
what we really want.

> I am thinking to add some non-intrusive way to make notification work
> for root-bus hot removal/add.

The Way Things Are Supposed To Work is that ACPI notifies the OS that
a device (a PNP0A08 host bridge in this case) is being removed.  The
OS driver does its cleanup and lets go of the device.  There are
several things in the ACPI part of that path that are not implemented
yet, so I understand that we might need a sysfs knob to kick things
off.  But can't we make a knob that just calls the host bridge driver
.remove() method, i.e., acpi_pci_root_remove()?

> also in some case, cpu buses get scan during booting, could use that
> to remove those not needed
> root buses.

I don't see the value in this.  I think you're talking about removing
the devices we discovered by blindly probing, i.e., the ones the BIOS
didn't tell us about.  I do think we should stop blindly probing for
them, but I don't see what we gain by adding a sysfs knob to remove
them.

>> I'm not sure it makes sense to talk about removing a "bus" and leaving
>> the upstream bridge (either a host bridge or a P2P bridge).  I think
>> it'd make more sense to remove the bridge itself, which would of
>> course have the consequence of removing the secondary bus.
>
> for root bus, that remove pci_host_bridge and pci root bus.
>
> for pci bus under pci bridge, will remove that pci bus, but will still
> keep  that pci bridge.
> that should be ok. just like some pci bridge is there, and later can
> not create child bus for it.
>
> there is one case: during test busn_alloc, i need to remove all device
> on one bus, and
> use setpci to change bridge bus number register. then use rescan
> bridge to create new bus.
>
> with this one, I just need to remove that bus, instead of remove
> children devices one by one.

I don't think making it convenient for manual testing is an argument
for this interface.  For sysfs interfaces it is more important to make
something that fits well into the grand plan of how things Should
Work.  If you need internal helper functions for convenience, I'm OK
with that, because it's easier to change those than to change sysfs
interfaces.

Bjorn
