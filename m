Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1KBViO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:38:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49904 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1KBViM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:38:12 -0400
MIME-Version: 1.0
In-Reply-To: <20111102141410.4d44a4eb@jbarnes-desktop>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
 <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
 <CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8D8973@exchdb03.mips.com>
 <1318319295.29415.452.camel@pasglop> <CAErSpo5rU8aa=-joApUTYbsQrbrRz9x-7VA3V3H9gDg7k7nj+w@mail.gmail.com>
 <20111102141410.4d44a4eb@jbarnes-desktop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 Nov 2011 15:37:51 -0600
Message-ID: <CAErSpo5_sAPb90JB62JJQFA+Sa8TyzDmQbsYdLra8Z8d0dqJHQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and fix
 MIPS PCI resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Zhu, DengCheng" <dczhu@mips.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 3:14 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 11 Oct 2011 10:15:34 -0600
> Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> On Tue, Oct 11, 2011 at 1:48 AM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>>
>> > I must admit I don't completely understand what this patch is about,
>> > other than it will most probably break the way we do resource management
>> > on powerpc :-)
>> >
>> > I don't understand the point about conflicts in scan_slot and I don't
>> > see what you win by "settling down early". Also keep in mind that the
>> > resources read from the device need to be remapped on some archs like
>> > powerpc which we do from a header quirk at the moment.
>>
>> These patches only deal with root bus resources, i.e., the
>> non-architected PCI host bridge windows.  They don't have anything to
>> do with normal PCI BARs.
>>
>> MIPS sets up root buses differently than powerpc, so it has a problem
>> that powerpc doesn't have.  Here's the original MIPS flow (before this
>> series):
>>
>>               pci_scan_bus
>>                 pci_scan_bus_parented
>>                   pci_create_bus        <-- A create root bus
>>                   pci_scan_child_bus
>>                     pci_scan_slot
>>                       pci_scan_single_device
>>                         pci_scan_device
>>                           pci_setup_device
>>                             pci_fixup_device (pci_fixup_early)  <-- B
>>                         pci_device_add
>>                           pci_fixup_device (pci_fixup_header)   <-- C
>>                     pcibios_fixup_bus   <-- D fill in root bus resources
>>
>> At point A, we allocate a struct pci_bus for the root bus.
>> pci_create_bus() fills in defaults for the resources available on that
>> bus: ioport_resource and iomem_resource, which cover all possible
>> address space.  Later at point D, we replace those defaults with the
>> correct resources (hose->io_resource and hose->mem_resource in this
>> MIPS case).
>>
>> The problem is that the root bus resources are wrong during the
>> interval between A and D.  Anything that looks at them may break.  In
>> the case Deng-Cheng found, the quirk_piix4_acpi() fixup at point C
>> claimed a region, which incorrectly became the child of
>> ioport_resource instead of host->io_resource.
>>
>> Deng-Cheng's patches close this window by basically combining the
>> fixup at D with the root bus creation at A.
>>
>> Powerpc doesn't have the same problem because it calls
>> pci_create_bus() directly so it can fix the root bus resources with
>> pcibios_setup_phb_resources() *before* it scans the bus.
>>
>> Even though powerpc and many other architectures don't have the MIPS
>> problem, I think it's worth changing the code because the existing
>> pattern is poor.  In almost all cases, we know what the host bridge
>> apertures are before we create the root bus.  It's error-prone to have
>> pci_create_bus() fill in default resources, then rely on the
>> architecture to fix that up later.  I think it's better to supply the
>> resources up front.
>
> Ben, with the above explained are you ok with this change?

Note that this thread is for an old version of these patches.  The
current version of this series (coincidentally also labelled "v3") is
here:

http://marc.info/?l=linux-pci&m=131984075431810&w=2
