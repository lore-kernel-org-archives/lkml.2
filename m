Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0KDCKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:10:42 -0400
Received: from mail14c40.carrierzone.com ([209.235.156.154]:53246 "EHLO
	mail14c40.carrierzone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0KDCKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:10:40 -0400
X-Authenticated-User: mdekoker.signatec.com
From: "Mike DeKoker" <mdekoker@signatec.com>
To: <linux-kernel@vger.kernel.org>
Subject: pciehp - Problems with ExpressCard hotplug
Date: Wed, 3 Nov 2010 19:10:31 -0700
Organization: Signatec, Inc.
Message-ID: <007f01cb7bc5$76c99fd0$645cdf70$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Act7xXU5t5zyM7FqTGWggE5ccsdFzw==
Content-Language: en-us
X-CSC: 0
X-CHA: v=1.1 cv=mjQE2xIzoTA6qQ8K6W9PLv+3oSrX8IL9Pr/Khg0ezGQ= c=1 sm=1
		a=wwB1YaP1kyIA:10 a=kj9zAlcOel0A:10 a=1FqhxYnyYMgbpOE3yW0okQ==:17
		a=RM1WpG7xdsFcxe0AG6UA:9 a=OW_-ctHDF4O063KRZvwA:7
		a=Hl1eqKtc8Xxd9DaZ0ZBt-7tXikcA:4 a=CjuIK1q_8ugA:10 a=UFTOLpBZlAIgnKFo:21
		a=PHZCZfDOwfRc5jHv:21 a=1FqhxYnyYMgbpOE3yW0okQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, I hope this is the correct forum.

I'm having a problem with hotplug working for a PCIe-based ExpressCard
device that I'm developing a driver module for. If not hot-plugged,
everything works great. Further, running the exact same laptop/device
hardware but different OS (XP or Win7-64) hot-plugging works okay so I don't
think this is a simple hardware/BIOS error.

I've tried several stock kernel versions from 2.6.18 (the version my
customer intends to use) up to 2.6.34.7 (version for all verbiage below) and
have had fairly consistent behavior.

The driver module (sig_ec14) is using the pci_register_driver interface and
in the subsequent probe callback function (after a hot-plug) an error occurs
when calling pci_enable_device. Here's the relevant dmesg data:

Insert device:
pciehp 0000:00:1c.5:pcie04: Card present on Slot(5)
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: PME# supported from D0 D1 D3hot
pci 0000:07:00.0: PME# disabled
pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
with 'pcie_aspm=force'
pci 0000:08:00.0: reg 10: [mem 0x00000000-0x0000001f]
pci 0000:08:00.0: reg 14: [mem 0x00000000-0x0000007f]
pci 0000:08:00.0: reg 18: [mem 0x00000000-0x0000003f]
pci 0000:07:00.0: PCI bridge to [bus 08-ff]
pci 0000:07:00.0:   bridge window [io  0x0000-0x0000] (disabled)
pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff pref]
(disabled)
pci 0000:07:00.0: BAR 14: assigned [mem 0xd9000000-0xd90fffff]
pci 0000:07:00.0: PCI bridge to [bus 08-08]
pci 0000:07:00.0:   bridge window [io  disabled]
pci 0000:07:00.0:   bridge window [mem 0xd9000000-0xd90fffff]
pci 0000:07:00.0:   bridge window [mem pref disabled]
pcieport 0000:00:1c.5: PCI bridge to [bus 07-09]
pcieport 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
pcieport 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffffff]
pcieport 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffffff 64bit
pref]
pcieport 0000:00:1c.5: setting latency timer to 64
pci 0000:07:00.0: enabling device (0000 -> 0002)
pci 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:07:00.0: setting latency timer to 64
pci 0000:07:00.0: no hotplug settings from platform
pci 0000:08:00.0: no hotplug settings from platform
pci 0000:08:00.0: using default PCI settings
sig_ec14 : Driver module loading
sig_ec14 :  Verbose module output enabled (development build)
sig_ec14 : Dynamic major number: 248
sig_ec14 : PCI probe: New EC14 device
sig_ec14 0000:08:00.0: device not available (can't reserve [mem
0x00000000-0x0000001f])
sig_ec14 : Failed to enable PCI device: -22
sig_ec14: probe of 0000:08:00.0 failed with error -22
.

It looks like the requested memory spaces are not allocated properly. I'm a
little uncertain about the entity that's actually responsible for allocating
the resources. Is this a failure of the BIOS or does system software play a
role in PNP resource allocation for hot-plug? I'm a little out of my element
here.

I've also run with pciehp_debug=1 in the event that the extra info makes
sense to someone:

Insert device:
pciehp 0000:00:1c.5:pcie04: pcie_isr: intr_loc 8
pciehp 0000:00:1c.5:pcie04: Presence/Notify input change
pciehp 0000:00:1c.5:pcie04: Card present on Slot(5)
pciehp 0000:00:1c.5:pcie04: Surprise Removal
pciehp 0000:00:1c.5:pcie04: pciehp_check_link_status: lnk_status = 3011
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: PME# supported from D0 D1 D3hot
pci 0000:07:00.0: PME# disabled
pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
with 'pcie_aspm=force'
.

That 'Surprise Removal' immediately following the 'Card present on Slot(5)'
message looks like a potential culprit.

When the device is connected cold and the system is powered up I have no
problems:
sig_ec14 : Driver module loading
sig_ec14 :  Verbose module output enabled (development build)
sig_ec14 : Dynamic major number: 248
sig_ec14 : PCI probe: New EC14 device
sig_ec14 0000:0a:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sig_ec14 : Memory IO region 0 -> Start: 0xD90000C0, Len: 0x0020
sig_ec14 : Memory IO region 1 -> Start: 0xD9000000, Len: 0x0080
sig_ec14 : Memory IO region 2 -> Start: 0xD9000080, Len: 0x0040
.

Any advice would be greatly appreciated; I'd like to be able to test the
module's handling of surprise removal, etc.

I am off-list, please CC me at: mdekoker at the domain of signatec dot com.

Thank you all for your time and the great work you do.

Regards,
Mike DeKoker



