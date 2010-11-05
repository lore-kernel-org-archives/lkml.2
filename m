Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0KEF7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:59:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38797 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0KEF7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:59:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CD39CE2.5010905@jp.fujitsu.com>
Date: Fri, 05 Nov 2010 14:57:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike DeKoker <mdekoker@signatec.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: pciehp - Problems with ExpressCard hotplug
References: <007f01cb7bc5$76c99fd0$645cdf70$@com> <201011040606.33889.rjw@sisk.pl>
In-Reply-To: <201011040606.33889.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/04 14:06), Rafael J. Wysocki wrote:
> [CCing linux-pci and Bjorn]
>
> On Thursday, November 04, 2010, Mike DeKoker wrote:
>> Hello everyone, I hope this is the correct forum.
>>
>> I'm having a problem with hotplug working for a PCIe-based ExpressCard
>> device that I'm developing a driver module for. If not hot-plugged,
>> everything works great. Further, running the exact same laptop/device
>> hardware but different OS (XP or Win7-64) hot-plugging works okay so I don't
>> think this is a simple hardware/BIOS error.
>>
>> I've tried several stock kernel versions from 2.6.18 (the version my
>> customer intends to use) up to 2.6.34.7 (version for all verbiage below) and
>> have had fairly consistent behavior.
>>
>> The driver module (sig_ec14) is using the pci_register_driver interface and
>> in the subsequent probe callback function (after a hot-plug) an error occurs
>> when calling pci_enable_device. Here's the relevant dmesg data:
>>
>> Insert device:
>> pciehp 0000:00:1c.5:pcie04: Card present on Slot(5)
>> pci 0000:07:00.0: supports D1
>> pci 0000:07:00.0: PME# supported from D0 D1 D3hot
>> pci 0000:07:00.0: PME# disabled
>> pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
>> with 'pcie_aspm=force'
>> pci 0000:08:00.0: reg 10: [mem 0x00000000-0x0000001f]
>> pci 0000:08:00.0: reg 14: [mem 0x00000000-0x0000007f]
>> pci 0000:08:00.0: reg 18: [mem 0x00000000-0x0000003f]
>> pci 0000:07:00.0: PCI bridge to [bus 08-ff]
>> pci 0000:07:00.0:   bridge window [io  0x0000-0x0000] (disabled)
>> pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
>> pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff pref]
>> (disabled)
>> pci 0000:07:00.0: BAR 14: assigned [mem 0xd9000000-0xd90fffff]
>> pci 0000:07:00.0: PCI bridge to [bus 08-08]
>> pci 0000:07:00.0:   bridge window [io  disabled]
>> pci 0000:07:00.0:   bridge window [mem 0xd9000000-0xd90fffff]
>> pci 0000:07:00.0:   bridge window [mem pref disabled]
>> pcieport 0000:00:1c.5: PCI bridge to [bus 07-09]
>> pcieport 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
>> pcieport 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffffff]
>> pcieport 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffffff 64bit
>> pref]
>> pcieport 0000:00:1c.5: setting latency timer to 64
>> pci 0000:07:00.0: enabling device (0000 ->  0002)
>> pci 0000:07:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
>> pci 0000:07:00.0: setting latency timer to 64
>> pci 0000:07:00.0: no hotplug settings from platform
>> pci 0000:08:00.0: no hotplug settings from platform
>> pci 0000:08:00.0: using default PCI settings
>> sig_ec14 : Driver module loading
>> sig_ec14 :  Verbose module output enabled (development build)
>> sig_ec14 : Dynamic major number: 248
>> sig_ec14 : PCI probe: New EC14 device
>> sig_ec14 0000:08:00.0: device not available (can't reserve [mem
>> 0x00000000-0x0000001f])
>> sig_ec14 : Failed to enable PCI device: -22
>> sig_ec14: probe of 0000:08:00.0 failed with error -22
>> .
>>
>> It looks like the requested memory spaces are not allocated properly. I'm a
>> little uncertain about the entity that's actually responsible for allocating
>> the resources. Is this a failure of the BIOS or does system software play a
>> role in PNP resource allocation for hot-plug? I'm a little out of my element
>> here.
>>
>> I've also run with pciehp_debug=1 in the event that the extra info makes
>> sense to someone:
>>
>> Insert device:
>> pciehp 0000:00:1c.5:pcie04: pcie_isr: intr_loc 8
>> pciehp 0000:00:1c.5:pcie04: Presence/Notify input change
>> pciehp 0000:00:1c.5:pcie04: Card present on Slot(5)
>> pciehp 0000:00:1c.5:pcie04: Surprise Removal
>> pciehp 0000:00:1c.5:pcie04: pciehp_check_link_status: lnk_status = 3011
>> pci 0000:07:00.0: supports D1
>> pci 0000:07:00.0: PME# supported from D0 D1 D3hot
>> pci 0000:07:00.0: PME# disabled
>> pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
>> with 'pcie_aspm=force'
>> .
>>
>> That 'Surprise Removal' immediately following the 'Card present on Slot(5)'
>> message looks like a potential culprit.

I believe this is just an message problem.

It looks like resource allocation code doesn't work for your
end device...

Could you send the following information

  - whole dmesg output after hot-plugging the device (with pciehp_debug=1)
  - lspci -vvvxxx output after boot with and without your device (no
    hotplug operation required)

Thanks,
Kenji Kaneshige


