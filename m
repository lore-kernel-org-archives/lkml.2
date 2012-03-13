Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab2CMFya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:54:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40491 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab2CMFy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5WKLf4C_f+roqDtbvs0vU_qTKp6OZ83AXXZggPrynt2A@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-21-git-send-email-yinghai@kernel.org>
	<CAErSpo5WKLf4C_f+roqDtbvs0vU_qTKp6OZ83AXXZggPrynt2A@mail.gmail.com>
Date: Mon, 12 Mar 2012 22:54:27 -0700
X-Google-Sender-Auth: XXZ1IMV_Eo7UfIyBe0sYeC2UFHM
Message-ID: <CAE9FiQWwzS2SFvzO2BL-aoVFVEMFpwJPKPODArkKtQSeAoTYGw@mail.gmail.com>
Subject: Re: [PATCH v2 20/37] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 8:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> it supports both pci root bus and pci bus under pci bridge.
>>
>> -v2: Change to three returns way in dev_bus_remove_store.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-doc@vger.kernel.org
>> ---
>>  Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
>>  drivers/pci/pci-sysfs.c                 |   30 ++++++++++++++++++++++++++++++
>>  2 files changed, 38 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 95f0f37..22392de 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -92,6 +92,14 @@ Description:
>>                hot-remove the PCI device and any of its children.
>>                Depends on CONFIG_HOTPLUG.
>>
>> +What:          /sys/bus/pci/devices/.../pci_bus/.../remove
>> +Date:          March 2012
>> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
>> +Description:
>> +               Writing a non-zero value to this attribute will
>> +               hot-remove the PCI bus and any of its children.
>> +               Depends on CONFIG_HOTPLUG.
>
> I don't think this interface makes sense.  This stops every device on
> the bus, removes the bus, unregisters the host bridge device if we're
> removing a root bus.

it is some kind of handy. otherwise if there is several devices on the
bus, will need to
remove the devices one by one.

>
> I think we should just have a "remove *bridge*" interface.  It makes
> no sense to me to remove a bus but leave the bridge, and it makes the
> code quite complicated.

I want to remove all devices under the bridge and then rescan the
bridge. then if the bridge get removed.
then we have to rescan bridge's parent bus.

>
> The point of hotplug is to add and remove devices.  We'll get
> interrupts saying "please remove this device" or "please rescan the
> bus behind this bridge because something might have changed."
>
> If we're removing a host bridge, the platform, e.g., ACPI, will tell
> us about the bridge that is going away.  The notification is attached
> to the *bridge*, not the bus it leads to.
>
> The expected mechanism on x86 is an SCI from the platform, but if we
> need a sysfs way to start host bridge removal, I think it should be
> something like this:
>
>    echo 1 > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove

for that,  let just use
echo "\_SB.PCI0 3" > /proc/acpi/sci/notify

Yinghai
