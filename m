Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2FPV4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 17:56:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56115 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab2FPV4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 17:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 16 Jun 2012 15:56:28 -0600
Message-ID: <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 9:03 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jun 15, 2012 at 6:57 PM, Ulrich Drepper <drepper@gmail.com> wrote:
>> The PCI roots in multi-socket SNB are part of specific sockets.  This
>> means optimization will need to know which socket the root is part of
>> and therefore which cores have direct access as opposed to over one or
>> more QPI links.
>>
>> I tried to find this information in the /sys filesystem in kernels up
>> to the current upstream kernel.  It seems there is actually nothing
>> like this.
>>
>> There are the files /sys/devices/pci*/*/local_cpus which should
>> contain this information.  For each device we would be able to get the
>> information about the local CPUs.
>>
>> The SPARC OF handling seems to set the field, some Intel drivers seem
>> to try to do it in a different way.
>>
>> The problem I have seen (at least on a Dell R620) is that the
>> dev_to_code() function returns -1 which indicates that no node
>> information is stored.
>>
>> If I understand the code correctly, the numa_node field can be set
>> explicitly but is mostly inherited from the underlying device (bus
>> etc).  Does this mean that the locality information should come from
>> the same place where the PCI root data structure is initialized?
>>
>> This happens, if I'm not mistaken, in the ACPI table parsing.  I've
>> disassembled the DSDT table and didn't find anything like this type of
>> information.  At least I didn't see it.  I also couldn't find anything
>> in the ACPI 5.0 spec.
>
> yes, you should have _PXM for root bus in DSDT.
>
>>
>>
>> The questions are:
>> a) am I missing something?
>> b) do BIOSes (perhaps from other manufacturers) provide the information?
>> c) can we get this fixed?
>
> get updated BIOS.
>
>> d) can we interpolate the information for platforms where the BIOSes
>> don't have the information?
>
> in arch/x86/pci/acpi.c::pci_acpi_scan_root(), we have
>
>        node = -1;
> #ifdef CONFIG_ACPI_NUMA
>        pxm = acpi_get_pxm(device->handle);
>        if (pxm >= 0)
>                node = pxm_to_node(pxm);
>        if (node != -1)
>                set_mp_bus_to_node(busnum, node);
>        else
> #endif
>                node = get_mp_bus_to_node(busnum);
>
>        if (node != -1 && !node_online(node))
>                node = -1;
>
>        info = kzalloc(sizeof(*info), GFP_KERNEL);
>        if (!info) {
>                printk(KERN_WARNING "pci_bus %04x:%02x: "
>                       "ignored (out of memory)\n", domain, busnum);
>                return NULL;
>        }
>
>        sd = &info->sd;
>        sd->domain = domain;
>        sd->node = node;
>
> So kernel will check _PXM at first, or will use pre-probe host bridge info.
> Now we only have that for amd k8 cpu.
>
> We used to have same for intel IOH nehalem,  and get bless from intel.
> but that get removed at some point.
> I have one local internal similar patch for SNB iio for crossing check
> if BIOS set correctly.
> but I don't think i will try to get blessing from intel to publish it.
>
> So please get one updated bios from your vendor.

If ACPI provides a perfectly usable generic way to describe this
topology and the vendor BIOS doesn't bother to use it, I'm not very
interested in trying to compensate for that BIOS deficiency by adding
a bunch of non-portable CPU-specific gunk to Linux.
