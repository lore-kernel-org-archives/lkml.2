Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2LMLwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:52:00 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:56337 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2LMLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:51:58 -0500
Message-ID: <1355399509.7498.49.camel@hal>
Subject: Re: [RFC PATCH 01/10] s390/pci: base support
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        sebott <sebott@linux.vnet.ibm.com>,
        Gerald =?ISO-8859-1?Q?Sch=E4fer?= <gerald.schaefer@de.ibm.com>
Date: Thu, 13 Dec 2012 12:51:49 +0100
In-Reply-To: <CAErSpo7h_EnqWzx7TN9yr5JnmUjLcZSv=pkc+Cz=8egF+EcyXQ@mail.gmail.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
	 <c6f38a8b22d0bf2980785a2f9a786ba4616a3284.1352719877.git.jang@linux.vnet.ibm.com>
	 <CAErSpo7h_EnqWzx7TN9yr5JnmUjLcZSv=pkc+Cz=8egF+EcyXQ@mail.gmail.com>
Organization: IBM LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 12121311-6892-0000-0000-000003CF12CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 14:14 -0700, Bjorn Helgaas wrote:
> On Wed, Nov 14, 2012 at 2:41 AM, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > Add PCI support for s390, (only 64 bit mode is supported by hardware):
> > - PCI facility tests
> > - PCI instructions: pcilg, pcistg, pcistb, stpcifc, mpcifc, rpcit
> > - map readb/w/l/q and writeb/w/l/q to pcilg and pcistg instructions
> > - pci_iomap implementation
> > - memcpy_fromio/toio
> > - pci_root_ops using special pcilg/pcistg
> > - device, bus and domain allocation
> >
> > Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
> 
> I think these patches are in -next already, so I just have some
> general comments & questions.

Yes, since the feedback was manageable we decided to give the patches
some exposure in -next and if no one complains we'll just go for the
next merge window. BTW, Sebastian & Gerald (on CC:) will continue the
work on the PCI code.

> My overall impression is that these are exceptionally well done.
> They're easy to read, well organized, and well documented.  It's a
> refreshing change from a lot of the stuff that's posted.

Thanks Björn!

> As with other arches that run on top of hypervisors, you have
> arch-specific code that enumerates PCI devices using hypervisor calls,
> and you hook into the PCI core at a lower level than
> pci_scan_root_bus().  That is, you call pci_create_root_bus(),
> pci_scan_single_device(), pci_bus_add_devices(), etc., directly from
> the arch code.  This is the typical approach, but it does make more
> dependencies between the arch code and the PCI core than I'd like.
> 
> Did you consider hiding any of the hypervisor details behind the PCI
> config accessor interface?  If that could be done, the overall
> structure might be more similar to other architectures.

You mean pci_root_ops? I'm not sure I understand how that can be used
to hide hipervisor details. One reason why we use the lower level
functions is that we need to create the root bus (and its resources)
much earlier then the pci_dev. For instance pci_hp_register wants a
pci_bus to create the PCI slot and the slot can exist without a pci_dev.

> The current config accessors only work for dev/fn 00.0 (they fail when
> "devfn != ZPCI_DEVFN").  Why is that?  It looks like it precludes
> multi-function devices and basically prevents you from building an
> arbitrary PCI hierarchy.

Our hypervisor does not support multi-function devices. In fact the
hypervisor will limit the reported PCI devices to a hand-picked
selection so we can be sure that there will be no unsupported devices.
The PCI hierarchy is hidden by the hipervisor. We only use the PCI
domain number, bus and devfn are always zero. So it looks like every
function is directly attached to a PCI root complex.

That was the reason for the sanity check, but thinking about it I could
remove it since although we don't support multi-function devices I
think the s390 code should be more agnostic to these limitations.

> zpci_map_resources() is very unusual.  The struct pci_dev resource[]
> table normally contains CPU physical addresses, but
> zpci_map_resources() fills it with virtual addresses.  I suspect this
> has something to do with the "BAR spaces are not disjunctive on s390"
> comment.  It almost sounds like that's describing host bridges where
> the PCI bus address is not equal to the CPU physical address -- in
> that case, device A and device B may have the same values in their
> BARs, but they can still be distinct if they're under host bridges
> that apply different CPU-to-bus address translations.

Yeah, you've found it... I've had 3 or 4 tries on different
implementations but all failed. If we use the resources as they are we
cannot map them to the instructions (and ioremap does not help because
there we cannot find out which device the resource belongs to). If we
change the BARs on the card MMIO stops to work. I don't know about host
bridges - if we would use a host bridge at which point in the
translation process would it kick in?

Jan

> Bjorn
> 



