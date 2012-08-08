Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2HHPoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:44:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2HHPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:44:53 -0400
Message-ID: <50228968.3070904@gmail.com>
Date: Wed, 08 Aug 2012 23:44:40 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/16] ACPI based system device hotplug framework
References: <1344082443-4608-1-git-send-email-jiang.liu@huawei.com> <1344382695.3010.770.camel@misato.fc.hp.com>
In-Reply-To: <1344382695.3010.770.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 07:38 AM, Toshi Kani wrote:
> On Sat, 2012-08-04 at 20:13 +0800, Jiang Liu wrote:
>> From: Jiang Liu <liuj97@gmail.com>
>>
>> The patchset is based on v3.5-rc6 and you may pull them from:
>> git://github.com/jiangliu/linux.git acpihp
>>
>> Modern high-end server may support advanced hotplug features for system
>> devices, including physical processor, memory board, IO extension board
>> and/or computer node. The ACPI specifications have provided standard
>> interfaces between firmware and OS to support device hotplug at runtime.
>> This patch series provide an ACPI based hotplug framework to support system
>> device hotplug at runtime, which will replace current existing ACPI device
>> driver based CPU/memory/CONTAINER hotplug mechanism.
>>
>> The new ACPI based hotplug framework is modelled after PCI hotplug
>> architecture and target to achieve following goals:
> 
> Hi Jiang,
> 
> It is nice to see such infrastructure work!  I have some high-level
> questions / comments below.  So far, I have only looked at part of the
> changes briefly, so please correct me if I missed something.

Hi Toshi,
	Thanks for your time to review these patches!

> 
>> 1) Provide a mechanism to detect hotplug slots by checking ACPI _EJ0 method,
>> ACPI PRCT (platform RAS capabilities table) and other platform specific
>> mechanisms.
> 
> Does this mean that hot-plug device must support both hot-add &
> hot-delete operations?  Some platforms may choose to only support
> hot-add operations to increase the resource on-line (since it requires
> less effort and Windows does not support hot-remove, either).
This is a good question. By default, the framework detects hotplug slot
by checking _EJ0 method. If a system does support hot-add only components,
some static ACPI tables, like PRCT, may be used to describe hotplug slots
available in the system. 

Basically ACPI PRCT table contains tuples of (device type, uid, RAS capabilities).

>> 2) Unify the way to enumerate ACPI based hotplug slots. All hotplug slots
>> will be enumerated by the enumeration driver, instead of by ACPI device
>> drivers.
> 
> It is nice to see redundant ACPI namespace walks removed from the ACPI
> drivers.  But why do you need to add a new enumerator to create the
> acpihp_slot tree, in addition to the current acpi_device tree?  I'd
> prefer hotplug features to be generally integrated into the current ACPI
> core code and data structures, instead of adding a new layer on top of
> it.
The idea comes from PCI hotplug framework, which has an concepts of PCI
hotplug slot and PCI device. For system device hotplug, we could follow
the same model as PCI by abstracting control points as slots. By introducing
of hotplug slot, we could:

1) Report all hotplug slots and slot's capabilities to user, no matter whether
there are devices connecting to a slot. If we integrate hotplug functionality
into current ACPI device tree, the slot (or device) is only visible when the
connected devices are enabled.

2) Provide interfaces for software to control hotplug slots. With current ACPI
definition, we could only trigger ACPI hotplug events by pressing hotplug button
or through some OOB device management system. To support RAS features like
memory power management, memory migration, dynamic resource management etc, we
need to trigger hotplug events through in-band interfaces. 

> 
> Also, acpihp_dev_get_type() in core.c relies on PNP IDs that is embedded
> in the file.  This does not seem very flexible / extendable.  One should
> be able to add a handler for a new or vendor-specific PNP ID without
> changing the core code.  struct acpi_driver allows such extension today.
Good catch. That's a design limitation currently. If the need arise, we could
extend the core to support platform specific extensions. But that may be a
little hard because all devices connecting to a slot will be configured/unconfigured
in order of device types. If we introduce a platform specific device type,
we need to change that logic too.

> 
>> 3) Dynamically create/destroy ACPI hotplug slots. For example, new ACPI
>> hotplug slots may be created when hot-adding a computer node if the node
>> contains some memory hotplug slots.
> 
> This is good, but it is necessary because you added the slots...
Currently all ACPI hotplug drivers has an assumption that the ACPI namespace is
constructed from static ACPI tables, or in other words, the ACPI namespace is
static. Dynamically create/destroy ACPI hotplug slot is to get rid of such an
assumption. If it's unnecessary, we may not support dynamic creating/destroying
of ACPI hotplug slots.

> 
>> 4) Unify the way to handle ACPI hotplug events. All ACPI hotplug events
>> for system devices will be handled by a generic ACPI hotplug driver,
>> instead of handled by ACPI device drivers.
> 
> It seems that acpihp_drv_slot_add() registers an ACPI notify handler
> through .add_dev interface.  Does it mean that a device must be marked
> as present prior to hot-add operation..?
acpihp_drv_slot_add() is called to bind the hotplug driver to a hotplug slot.
So the ACPI hotplug event handler will be installed once the hotplug driver
has been bound to a slot, no matter whether there are devices connecting to
the slot.

>> 5) Solve dependencies among hotplug slots. You need first to remove the
>> memory device before removing a physical processor if a hotpluggable memory
>> device is connected to a hotpluggable physical processor.
> 
> This is nice, but in your example, I'd expect that a container object
> (as a node or socket) is used to generally represent such dependency
> with topology.  Such container object contains processor and memory
> devices.  When user needs to eject the whole, i.e. both processor and
> memory, an eject request can be sent to the container object.
There are two ways to get dependency relationships among hotplug slots. One is
by analyzing ACPI namespace topology, as you have described. The other is by
evaluating ACPI _EDL method. Some dependency relationships must be reported by
ACPI _EDL method because the ACPI namespace topology can't reflect those dependencies.
For examples:
1) To be compatible with Windows, the PCI host bridge (IIO) embedded in a physical
processor may be present under _SB instead under the module device for the physical
processor.

2) For NHM-EX/Boxboro chipset based platform, a Boxboro chipset is connected to
two physical processors. So the Boxboro chipset must be removed first if you want
to remove those two processor together. The ACPI namespace may be something like:
\SB\
    |- SCK0
    |- SCK1
    |- PCI0

3) For a big system with partially connected topology, you may need to use ACPI _EDL
to report dependencies among nodes. An possible topology as below:
Node A <--->Node B
 ^            ^
 |            |
 v            v
Node C <--->Node D

	Regards!
	Gerry
