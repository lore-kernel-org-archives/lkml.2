Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0KIISP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:18:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38145 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0KIISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:18:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CD9039E.6000103@jp.fujitsu.com>
Date: Tue, 09 Nov 2010 17:17:34 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike DeKoker <mdekoker@signatec.com>
CC: "'Rafael J. Wysocki'" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, "'Bjorn Helgaas'" <bjorn.helgaas@hp.com>
Subject: Re: pciehp - Problems with ExpressCard hotplug
References: <007f01cb7bc5$76c99fd0$645cdf70$@com> <201011040606.33889.rjw@sisk.pl> <4CD39CE2.5010905@jp.fujitsu.com> <003a01cb7d1d$3adbad70$b0930850$@com>
In-Reply-To: <003a01cb7d1d$3adbad70$b0930850$@com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/06 4:11), Mike DeKoker wrote:
>> (2010/11/04 14:06), Rafael J. Wysocki wrote:
>>> [CCing linux-pci and Bjorn]
>>>
>>> On Thursday, November 04, 2010, Mike DeKoker wrote:
>>>> Hello everyone, I hope this is the correct forum.
>>>>
>>>> I'm having a problem with hotplug working for a PCIe-based ExpressCard
>>>> device that I'm developing a driver module for. If not hot-plugged,
>>>> everything works great. Further, running the exact same laptop/device
>>>> hardware but different OS (XP or Win7-64) hot-plugging works okay so I
> don't
>>>> think this is a simple hardware/BIOS error.
>>>>
>>>> I've tried several stock kernel versions from 2.6.18 (the version my
>>>> customer intends to use) up to 2.6.34.7 (version for all verbiage below)
> and
>>>> have had fairly consistent behavior.
>>>>
>>>> The driver module (sig_ec14) is using the pci_register_driver interface
> and
>>>> in the subsequent probe callback function (after a hot-plug) an error
> occurs
>>>> when calling pci_enable_device. Here's the relevant dmesg data:
>>>>
>>>> Insert device:
> SNIP
>>>>
>>>> It looks like the requested memory spaces are not allocated properly.
> I'm a
>>>> little uncertain about the entity that's actually responsible for
> allocating
>>>> the resources. Is this a failure of the BIOS or does system software
> play a
>>>> role in PNP resource allocation for hot-plug? I'm a little out of my
> element
>>>> here.
>>>>
>>>> I've also run with pciehp_debug=1 in the event that the extra info makes
>>>> sense to someone:
>>>>
> SNIP
>>>>
>>>> That 'Surprise Removal' immediately following the 'Card present on
> Slot(5)'
>>>> message looks like a potential culprit.
>>
>> I believe this is just an message problem.
>>
>> It looks like resource allocation code doesn't work for your
>> end device...
>>
>> Could you send the following information
>>
>>   - whole dmesg output after hot-plugging the device (with pciehp_debug=1)
>>   - lspci -vvvxxx output after boot with and without your device (no
>>     hotplug operation required)
>
> ------- lspci -vvvxxx (Pre device insertion):
>

(snip.)

> 08:00.0 Non-VGA unclassified device: Device 1b94:ec14
> 	Subsystem: Device 1b94:ec14
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-
> <TAbort-<MAbort->SERR-<PERR- INTx-
> 	Interrupt: pin A routed to IRQ 255
> 	Kernel modules: sig_ec14
> 00: 94 1b 14 ec 00 00 20 02 00 00 00 00 00 40 00 00


I guess the following code in setup-bus.c skips your device
whose class code is undefined.

static void __dev_sort_resources(struct pci_dev *dev,
                                  struct resource_list *head)
{
         u16 class = dev->class >> 8;

         /* Don't touch classless devices or host bridges or ioapics.  */
         if (class == PCI_CLASS_NOT_DEFINED || class == PCI_CLASS_BRIDGE_HOST)
                 return;

Can you try with the above two lines commented out?

Regards,
Kenji Kaneshige

