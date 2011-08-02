Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1HBO5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:57:18 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:37364 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1HBO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:57:12 -0400
Message-ID: <4E381043.7080501@ge.com>
Date: Tue, 02 Aug 2011 15:57:07 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus numbers
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch> <4E36A4EA.30404@ge.com> <20110801143102.GA9705@becoht-mvanga> <4E36CB29.2030907@ge.com> <20110802115434.GA25063@becoht-mvanga>
In-Reply-To: <20110802115434.GA25063@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Aug 2011 14:54:00.0624 (UTC) FILETIME=[037F2B00:01CC5124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 12:54, Manohar Vanga wrote:
> Hey Martin,
> 
>> No I'm thinking more along the lines of how the persistent device names seem
>> to be created. For example, on my system udev is used to create a symlink
>> called "/dev/cdrom" using this udev rule:
>>
>> SUBSYSTEM=="block", ENV{ID_CDROM}=="?*",
>> ENV{ID_PATH}=="pci-0000:00:1f.2-scsi-1:0:0:0", SYMLINK+="cdrom",
>> ENV{GENERATED}="1"
>>
>> The bit that might be more useful to us is the ENV{ID_PATH}, the
>> "pci-0000:00:1f.2" bit in particular. If I'm not mistaken, this is sufficient
>> to identify a PCI device (such as a VME bridge)
> 
> We have cases where we have multiple PCI devices of the same type and we need
> a way to access each of them based on physical location. This cannot be solved
> in PCI in any way except manually testing and figuring out which slot
> corresponds to which device.
> 

I agree - you will always need to work out which PCI device corresponds to
which VME bus.

> Firmware changes and BIOS updates have a chance of changing the PCI ordering.
> We have had this problem before and we solve it by mapping the PCI bus and
> device ID's to slot numbers (these are manually entered into the database by
> looking at the lspci output and manually testing which device is which). These
> mappings are stored in a local file at the moment (with plans to move it into
> the database). This file looks something like this:
> 
> $ cat /etc/crateconfig
> 1 0 0
> 2 0 0
> 3 0 0
> 4 2 f
> 5 2 e <-- eg. This is the 1st device (02:0e.0)
> 6 2 d <--     This is the 2nd device (02:0d.0)
> 7 0 0
> 8 0 0
> 9 0 0
> 10 0 0
> 11 0 0
> 12 1 f
> 13 1 e
> 14 1 d
> 
> The database entry for the crate then uses these mapped numbers only:
> 
>     --> TEWS Technologies GmbH TPCI200, Slot 5
>     --> TEWS Technologies GmbH TPCI200, Slot 6
> 

An I right in thinking that you use IndustryPack VME bridges on TPCI200
carrier cards?

I'm not sure I follow. The above configuration seems to describe how you map
physical slot numbers to devices, not VME bridges to an reasonably arbitrary
VME bus number on a specific host. I assume that 02.0e.0 and 02.0d.0 are 2
bridges on the same host and that the host is acting as a bridge between slots
1-5 and 6-14 that are 2 separate buses in the same crate.

> For such device drivers, the loading is done as follows:
> 
> 1. Get the mapped slot number for the device from the database (eg. 5, 6)
> 2. Convert it to the bus/device combination using /etc/crateconfig
>    (eg. 5 --> 02,0e and 6 --> 02,0d)
> 3. Pass it to the driver during load time using module parameters
>      $ insmod driver.ko dev_id=0,1 buses=02,02 devices=0e, 0d
>    The driver checks this with the pci_dev structure passed to it and
>    assigns the device number based on this.
>

So 0, 1 are the bus numbers?

Where does the 5 & 6 in the part above come into play?

> This is what would be my suggestion for doing with multiple bridges of the
> same kind. This way we can control the changes from firmware through
> modparams and a config file like /etc/crateconfig. If the PCI locations
> change with BIOS/firmware updates, we can manually change the mappings to
> the new ones.
> 

If we are storing them in user space, do we need to push them into kernel
space when we load the VME bridge driver?

> The UUID's do nothing but compress the two separate params (bus, device)
> into a single param (the UUID). This has the bigger disadvantage that it
> is not human readable. This is a strong requirement since the database
> mappings need to be maintained by the admins.
> 

I'm not sure it's any more or less readable than having separate PCI bus and
PCI device numbers in a csv formatted file.

It does do more. Crucially in the udev example I gave, it identifies that the
disk is connected to a controller on PCI. It also identifies that it's on PCI
domain 0.

I'm fairly sure that a this format allows for other buses to provide parameter
strings in varying formats, should someone write a bridge driver for a USB-VME
bridge like this:

http://www.struck.de/sis3150usb.htm

We could still identify the VME bridge being used (even if two such devices
were connected to the same host).

> The point I'm trying to make is that the PCI id's cannot be used directly
> as they change with firmware and BIOS changes.
> 

But you seem to be using them directly in the example above. You pass in the
PCI bus and device number. In fact. you are *just* using the PCI bus and
device numbering, which would not work with the USB-VME bridge above.

>> I'm thinking of the topology that is used in the above example to uniquely
>> identify a specific SATA device.
> 
> SATA devices like hard disks have unique fixed identifiers that can be used
> to generate the UUID's. PCI device locations shouldn't be assumed to be
> fixed.
> 

Which part of the example udev rule I gave is a fixed identifier? It
identifies the CDROM based on system topology, using the PCI bus numbering and
SCSI bus numbering.

For example, for a device sitting on VME, in the A32 address space at 0x30000,
via a PCI-VME bridge on PCI bus 2, device 0d, we could provide something like
this:

vme-a32:30000-pci-0000:02:0d.0

>> We could either provide the above paths, or rename buses similar to how
>> network interfaces are renamed (hence why I mentioned them as well). Of course
>> renaming the buses has the disadvantage that the correct names will only be in
>> place once the board has got to user space, so the drivers would have to be
>> built as modules.
> 
> Yes, this would be another contraint.
> 
>> I assume that you replace like with like, so the bridges are found in the same
>> order (if you have more than one of the same bridge). In this case the
>> topology will be the same, so you should reliably be able to replace cards.
> 
> Yeah but if firmware/BIOS versions are differing in the cards (eg. updated
> revisions of the board), then things could get messy.
> 

I can't see how the approach you laid out above solves this.

Martyn


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
