Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2LRSH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:07:28 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:59458 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2LRSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:07:26 -0500
Date: Tue, 18 Dec 2012 19:07:18 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com,
        =?ISO-8859-15?Q?Gerald_Sch=E4fer?= <gerald.schaefer@de.ibm.com>
Subject: Re: [RFC PATCH 01/10] s390/pci: base support
In-Reply-To: <CAErSpo6pFLiPtQuBGzAo1B4cQOWzJEur_2THT=xJo9c5otp5hQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1212181905400.3320@c4eb>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com> <c6f38a8b22d0bf2980785a2f9a786ba4616a3284.1352719877.git.jang@linux.vnet.ibm.com> <CAErSpo7h_EnqWzx7TN9yr5JnmUjLcZSv=pkc+Cz=8egF+EcyXQ@mail.gmail.com> <1355399509.7498.49.camel@hal> 
 <CAErSpo6pFLiPtQuBGzAo1B4cQOWzJEur_2THT=xJo9c5otp5hQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463805262-1886667569-1355854041=:3320"
x-cbid: 12121818-6892-0000-0000-000003DA9F94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463805262-1886667569-1355854041=:3320
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 13 Dec 2012, Bjorn Helgaas wrote:

> On Thu, Dec 13, 2012 at 4:51 AM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > On Mon, 2012-12-10 at 14:14 -0700, Bjorn Helgaas wrote:
> >> On Wed, Nov 14, 2012 at 2:41 AM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> >> > Add PCI support for s390, (only 64 bit mode is supported by hardware):
> >> > - PCI facility tests
> >> > - PCI instructions: pcilg, pcistg, pcistb, stpcifc, mpcifc, rpcit
> >> > - map readb/w/l/q and writeb/w/l/q to pcilg and pcistg instructions
> >> > - pci_iomap implementation
> >> > - memcpy_fromio/toio
> >> > - pci_root_ops using special pcilg/pcistg
> >> > - device, bus and domain allocation
> >> >
> >> > Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
> >>
> >> I think these patches are in -next already, so I just have some
> >> general comments & questions.
> >
> > Yes, since the feedback was manageable we decided to give the patches
> > some exposure in -next and if no one complains we'll just go for the
> > next merge window. BTW, Sebastian & Gerald (on CC:) will continue the
> > work on the PCI code.
> >
> >> My overall impression is that these are exceptionally well done.
> >> They're easy to read, well organized, and well documented.  It's a
> >> refreshing change from a lot of the stuff that's posted.
> >
> > Thanks Björn!
> >
> >> As with other arches that run on top of hypervisors, you have
> >> arch-specific code that enumerates PCI devices using hypervisor calls,
> >> and you hook into the PCI core at a lower level than
> >> pci_scan_root_bus().  That is, you call pci_create_root_bus(),
> >> pci_scan_single_device(), pci_bus_add_devices(), etc., directly from
> >> the arch code.  This is the typical approach, but it does make more
> >> dependencies between the arch code and the PCI core than I'd like.
> >>
> >> Did you consider hiding any of the hypervisor details behind the PCI
> >> config accessor interface?  If that could be done, the overall
> >> structure might be more similar to other architectures.
> >
> > You mean pci_root_ops? I'm not sure I understand how that can be used
> > to hide hipervisor details.
> 
> The object of doing this would be to let you use pci_scan_root_bus(),
> so you wouldn't have to call pci_scan_single_device() and
> pci_bus_add_resources() directly.  The idea is to make pci_read() and
> pci_write() smart enough that the PCI core can use them as though you
> have a normal PCI implementation.  When pci_scan_root_bus() enumerates
> devices on the root bus using pci_scan_child_bus(), it does config
> reads on the VENDOR_ID of bb:00.0, bb:01.0, ..., bb:1f.0.  Your
> pci_read() would return error or 0xffffffff data for everything except
> bb:00.0 (I guess it actually already does that).
> 
> Then some of the other init, e.g., zpci_enable_device(), could be done
> by the standard pcibios hooks such as pcibios_add_device() and
> pcibios_enable_device(), which would remove some of the PCI grunge
> from zpci_scan_devices() and the s390 hotplug driver.
> 
> > One reason why we use the lower level
> > functions is that we need to create the root bus (and its resources)
> > much earlier then the pci_dev. For instance pci_hp_register wants a
> > pci_bus to create the PCI slot and the slot can exist without a pci_dev.
> 
> There must be something else going on here; a bus is *always* created
> before any of the pci_devs on the bus.
> 
> One thing that looks a little strange is that zpci_list seems to be
> sort of a cross between a list of PCI host bridges and a list of PCI
> devices.  Understandable, since you usually have a one-to-one
> correspondence between them, but for your hotplug stuff, you can have
> the host bridge and slot without the pci_dev.
> 
> The hotplug slot support is really a function of the host bridge
> support, so it doesn't seem quite right to me to split it into a
> separate module (although that is the way most PCI hotplug drivers are
> currently structured).  One reason is that it makes hot-add of a host
> bridge awkward: you have to have the "if (hotplug_ops.create_slot)"
> test in zpci_create_device().
> 
> >> The current config accessors only work for dev/fn 00.0 (they fail when
> >> "devfn != ZPCI_DEVFN").  Why is that?  It looks like it precludes
> >> multi-function devices and basically prevents you from building an
> >> arbitrary PCI hierarchy.
> >
> > Our hypervisor does not support multi-function devices. In fact the
> > hypervisor will limit the reported PCI devices to a hand-picked
> > selection so we can be sure that there will be no unsupported devices.
> > The PCI hierarchy is hidden by the hipervisor. We only use the PCI
> > domain number, bus and devfn are always zero. So it looks like every
> > function is directly attached to a PCI root complex.
> >
> > That was the reason for the sanity check, but thinking about it I could
> > remove it since although we don't support multi-function devices I
> > think the s390 code should be more agnostic to these limitations.
> 
> The config accessor interface should be defined so it works for all
> PCI devices that exist, and fails for devices that do not exist.  The
> approach you've taken so far is to prevent the PCI core from even
> attempting access to non-existent devices, which requires you to use
> some lower-level PCI interfaces.  The alternative I'm raising as a
> possibility is to allow the PCI core to attempt accesses to
> non-existent devices, but have the accessor be smart enough to use the
> hypervisor or other arch-specific data to determine whether the device
> exists or not, and act accordingly.
> 
> Basically the idea is that if we put more smarts in the config
> accessors, we can make the interface between the PCI core and the
> architecture thinner.
> 
> >> zpci_map_resources() is very unusual.  The struct pci_dev resource[]
> >> table normally contains CPU physical addresses, but
> >> zpci_map_resources() fills it with virtual addresses.  I suspect this
> >> has something to do with the "BAR spaces are not disjunctive on s390"
> >> comment.  It almost sounds like that's describing host bridges where
> >> the PCI bus address is not equal to the CPU physical address -- in
> >> that case, device A and device B may have the same values in their
> >> BARs, but they can still be distinct if they're under host bridges
> >> that apply different CPU-to-bus address translations.
> >
> > Yeah, you've found it... I've had 3 or 4 tries on different
> > implementations but all failed. If we use the resources as they are we
> > cannot map them to the instructions (and ioremap does not help because
> > there we cannot find out which device the resource belongs to). If we
> > change the BARs on the card MMIO stops to work. I don't know about host
> > bridges - if we would use a host bridge at which point in the
> > translation process would it kick in?
> 
> Here's how it works.  The PCI host bridge claims regions of the CPU
> physical address space and forwards transactions in those regions to
> the PCI root bus.  Some host bridges can apply an offset when
> forwarding, so the address on the bus may be different from the
> address from the CPU.  The bus address is what matches a PCI BAR.
> 
> You can tell the PCI core about this translation by using
> pci_add_resource_offset() instead of pci_add_resource().  When the PCI
> core reads a BAR, it applies the offset to convert the BAR value into
> a CPU physical address.
> 
> For example, let's say you have two host bridges:
> 
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [mem 0x100000000-0x1ffffffff] (bus
> address [0x00000000-0xffffffff])
> PCI host bridge to bus 0001:00
> pci_bus 0001:00: root bus resource [mem 0x200000000-0x2ffffffff] (bus
> address [0x00000000-0xffffffff])
> 
> Both bridges use the same bus address range, and BARs of devices on
> bus 0000:00 can have the same values as those of devices on bus
> 0001:00.  But there's no ambiguity because a CPU access to
> 0x1_0000_0000 will be claimed by the first bridge and translated to
> bus address 0x0 on bus 0000:00, while a CPU access to 0x2_0000_0000
> will be claimed by the second bridge and translated to bus address 0x0
> on bus 0001:00.
> 
> The pci_dev resources will contain CPU physical addresses, not the BAR
> values themselves.  These addresses implicitly identify the host
> bridge (and, in your case, the pci_dev, since you have at most one
> pci_dev per host bridge).

Hi Bjorn,

thanks for the explanation. I'll look into it.

Regards,
Sebastian
---1463805262-1886667569-1355854041=:3320--

