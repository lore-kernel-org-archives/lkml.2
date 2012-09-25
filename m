Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2IYPQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:16:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab2IYPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:16:20 -0400
Message-ID: <5061CAB6.306@gmail.com>
Date: Tue, 25 Sep 2012 23:16:06 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH v2] PCI: allow acpiphp to handle PCIe ports w/o native
 PCIe hotplug capability
References: <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com> <1345648605-7636-1-git-send-email-jiang.liu@huawei.com> <CAErSpo5gyZgxWxwTgXRMyZzDDbEBeXHtmhisPN2FqvvUarmTeg@mail.gmail.com>
In-Reply-To: <CAErSpo5gyZgxWxwTgXRMyZzDDbEBeXHtmhisPN2FqvvUarmTeg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 06:10 AM, Bjorn Helgaas wrote:
> On Wed, Aug 22, 2012 at 9:16 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make acpiphp
>> ignore root bridges using PCIe native hotplug) added code that made the
>> acpiphp driver completely ignore PCIe root complexes for which the kernel
>> had been granted control of the native PCIe hotplug feature by the BIOS
>> through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
>> "PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
>> the constraints to allow acpiphp driver handle non-PCIe bridges under
>> such a complex. The constraint needs to be relaxed further to allow
>> acpiphp driver to hanlde PCIe ports without native PCIe hotplug capability.
>>
>> Some MR-IOV switch chipsets, such PLX8696, support multiple virtual PCIe
>> switches and may migrate downstream ports among virtual switches.
>> To migrate a downstream port from the source virtual switch to the target,
>> the port needs to be hot-removed from the source and hot-added into the
>> target. pciehp driver can't be used here because there's no slots within
>> the virtual PCIe switch. So acpiphp driver is used to support downstream
>> port migration. A typical configuration is as below:
>> [Root w/o native PCIe HP]
>>         [Upstream port of vswitch w/o native PCIe HP]
>>                 [Downstream port of vswitch w/ native PCIe HP]
>>                         [PCIe enpoint]
>>
>> Here acpiphp driver will be used to handle root ports and upstream port
>> in the virtual switch, and pciehp driver will be used to handle downstream
>> ports in the virtual switch.
>>
>> v1->v2: use PCIe capability accessors to read PCI_EXP_SLTCAP register
>>
>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> 
> I tweaked the changelog (typos, indentation) and applied this to my
> "pci/jiang-acpiphp" branch.  Kenji acked a previous version, but I
> didn't add it here because this is slightly updated.
> 
> If the PLX8696 supports moving downstream ports between upstream
> ports, it seems like a deficiency if the upstream port doesn't support
> native hotplug.  If I understand correctly, this patch allows the use
> of acpiphp for "hotplug" of the downstream ports, but that is only an
> option if the PLX8696 is in the ACPI namespace.
> 
> It seems like the lack of PLX8696 native hotplug for upstream ports
> mean this virtual switch migration can only be done if the PLX8696 is
> soldered into the system -- for instance, we don't have any way to
> deal with an 8696 on a plug-in card because ACPI won't know anything
> about that device.
Hi Bjorn,
	That's true, we can't deal with 8696 on add-in cards yet. The platform
we are working with is:
	The motherboard has a specially designed slot for a root port, which
could only be used to connect an IO-extension box with 8696. So the BIOS could
build ACPI objects for the 8696 chipset.
	Thanks!
	Gerry

