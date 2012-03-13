Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab2CMFsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:48:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab2CMFs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6uBpEYrZPBxwrg_B8j7F9XAyDUvKTS4=++xze5KVmx1g@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-11-git-send-email-yinghai@kernel.org>
	<CAErSpo6uBpEYrZPBxwrg_B8j7F9XAyDUvKTS4=++xze5KVmx1g@mail.gmail.com>
Date: Mon, 12 Mar 2012 22:48:27 -0700
X-Google-Sender-Auth: R9Qf-64Lv9q3vcMmCtjaCau02jU
Message-ID: <CAE9FiQXaDgBRrZ5dCxz9mjrzCAwH_rHrUSQGYQnHc5k7aXnU8Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/37] PCI, sysfs: create rescan_bridge under
 /sys/.../pci/devices/... for pci bridges
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 7:55 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Current code will create rescan for every pci device under parent bus.
>> that is not right. the device is already there, there is no reason to rescan it.
>
> "The device" (not "the device").

ok

>
>> We could have rescan for pci bridges. less confusing.
>>
>> Need to move rescan attr to pci dev bridge attribute group.
>> And We should rescan bridge's secondary bus instead of primary bus.
>
> "And we" (not "And We").

ok

>
> I think the idea of this patch makes sense.
>
> You might want to consider having this actually read the bridge config
> again.  That way, if the user manually changed the secondary bus
> number or the bridge windows using setpci or something, this rescan
> could use that new config if possible.

yes, in the following patches, change that to
pci_rescan_bus_bridge_resize()

and

will be
unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
{
        unsigned int max = 0;
        int pass;
        struct pci_bus *bus = bridge->bus;

        for (pass = 0; pass < 2; pass++)
                max = pci_scan_bridge(bus, bridge, max, pass);

        pci_assign_unassigned_bridge_resources(bridge);

        pci_bus_add_single_device(bridge);

at last pci_scan_bridge will check the bus register in the bridge.

>
> I still hate the fact that we will have three different rescan files
> (four if you count /sys/bus/pci/rescan), but I don't have a solution
> to offer:
>    device/rescan
>    device/rescan_bridge
>    bus/rescan

looks like we only need
/sys/devices/pci.../device/rescan_bridge
/sys/bus/pci/bus/rescan

device rescan and bus rescan should be removed.

Yinghai
