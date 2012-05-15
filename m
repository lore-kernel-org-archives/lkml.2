Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966649Ab2EOT4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:56:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56727 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965427Ab2EOT4l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <1337035766.6954.74.camel@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home> <20120511225602.30496.80438.stgit@bling.home>
 <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com> <1337035766.6954.74.camel@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 15 May 2012 13:56:19 -0600
Message-ID: <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 4:49 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2012-05-14 at 16:02 -0600, Bjorn Helgaas wrote:
>> On Fri, May 11, 2012 at 4:56 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > In a PCIe environment, transactions aren't always required to
>> > reach the root bus before being re-routed.  Peer-to-peer DMA
>> > may actually not be seen by the IOMMU in these cases.  For
>> > IOMMU groups, we want to provide IOMMU drivers a way to detect
>> > these restrictions.  Provided with a PCI device, pci_acs_enabled
>> > returns the furthest downstream device with a complete PCI ACS
>> > chain.  This information can then be used in grouping to create
>> > fully isolated groups.  ACS chain logic extracted from libvirt.
>>
>> The name "pci_acs_enabled()" sounds like it returns a boolean, but it doesn't.
>
> Right, maybe this should be:
>
> struct pci_dev *pci_find_upstream_acs(struct pci_dev *pdev);
>
>> I'm not sure what "a complete PCI ACS chain" means.
>>
>> The function starts from "dev" and searches *upstream*, so I'm
>> guessing it returns the root of a subtree that must be contained in a
>> group.
>
> Any intermediate switch between an endpoint and the root bus can
> redirect a dma access without iommu translation,

Is this "redirection" just the normal PCI bridge forwarding that
allows peer-to-peer transactions, i.e., the rule (from P2P bridge
spec, rev 1.2, sec 4.1) that the bridge apertures define address
ranges that are forwarded from primary to secondary interface, and the
inverse ranges are forwarded from secondary to primary?  For example,
here:

                   ^
                   |
          +--------+-------+
          |                |
   +------+-----+    +-----++-----+
   | Downstream |    | Downstream |
   |    Port    |    |    Port    |
   |   06:05.0  |    |   06:06.0  |
   +------+-----+    +------+-----+
          |                 |
     +----v----+       +----v----+
     | Endpoint|       | Endpoint|
     | 07:00.0 |       | 08:00.0 |
     +---------+       +---------+

that rule is all that's needed for a transaction from 07:00.0 to be
forwarded from upstream to the internal switch bus 06, then claimed by
06:06.0 and forwarded downstream to 08:00.0.  This is plain old PCI,
nothing specific to PCIe.

I don't understand ACS very well, but it looks like it basically
provides ways to prevent that peer-to-peer forwarding, so transactions
would be sent upstream toward the root (and specifically, the IOMMU)
instead of being directly claimed by 06:06.0.

> so we're looking for
> the furthest upstream device for which acs is enabled all the way up to
> the root bus.

Correct me if this is wrong: To force device A's DMAs to be processed
by an IOMMU, ACS must be enabled on the root port and every downstream
port along the path to A.

If so, I think you're trying to find out the closest upstream device X
such that everything leading to X has ACS enabled.  Every device below
X can DMA freely to other devices below X, so they would all have to
be in the same isolated group.

I tried to work through some examples to develop some intuition about this:

                                |
        +------------+----------+----------------------+
        |            |                                 |
        |            |
+----------------|-------------------------------+
   +----v----+  +----v----+           |          +-----v----+
                |
   | 00:00.0 |  | 00:01.0 |           |          | 00:02.0  |
                |
   |   PCI   |  | PCIe-to |           |          | Upstream |
                |
   +---------+  |   PCI   |           |          +-----+----+
                |
                +----+----+           |                |
                |
                     |                |
+---------+------+----------------+       |
              +------+------+         |      |                |
        |       |
              |             |         | +----v-----+     +----v-----+
   +----v-----+ |
         +----v----+   +----v----+    | | 02:00.0  |     | 02:01.0  |
   | 02:02.0  | |
         | 01:00.0 |   | 01:01.0 |    | |Downstream|     |Downstream|
   |Downstream| |
         |   PCI   |   |   PCI   |    | |  w/o ACS |     |  w/ ACS  |
   |  w/ ACS  | |
         +---------+   +---------+    | +-----+----+     +----+-----+
   +----+-----+ |

+-------|---------------|----------------|-------+
                                              |               |                |
                                         +----v----+     +----v----+
   +----v----+
                                         | 03:00.0 |     | 04:00.0 |
   | 05:00.0 |
                                         |  PCIe   |     |  PCIe   |
   |  PCIe   |
                                         +---------+     | w/o ACS |
   |  w/ ACS |
                                                         +---------+
   +---------+

pci_acs_enabled(00:00.0) = 00:00.0 (on root bus (but doesn't it matter
if 00:00.0 is PCIe or if RP has ACS?))
pci_acs_enabled(00:01.0) = 00:01.0 (on root bus)
pci_acs_enabled(01:00.0) = 01:00.0 (acs_dev = 00:01.0, 01:00.0 is not
PCIe; seems wrong)
pci_acs_enabled(00:02.0) = 00:02.0 (on root bus; seems wrong if RP
doesn't have ACS)
pci_acs_enabled(02:00.0) = 00:02.0 (acs_dev = 00:02.0, 02:00.0 has no ACS cap)
pci_acs_enabled(03:00.0) = 00:02.0 (acs_dev = 00:02.0)
pci_acs_enabled(02:01.0) = 02:01.0 (acs_dev = 00:02.0, 02:01.0 has ACS enabled)
pci_acs_enabled(04:00.0) = 04:00.0 (acs_dev = 02:01.0, 04:00.0 is not
a bridge; seems wrong if 04:00 is a multi-function device)
pci_acs_enabled(02:02.0) = 02:02.0 (acs_dev = 00:02.0, 02:02.0 has ACS enabled)
pci_acs_enabled(05:00.0) = 05:00.0 (acs_dev = 02:02.0, 05:00.0 is not a bridge)

But it didn't really help.  I still can't develop a mental picture of
what this function does.

>> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> > ---
>> >
>> >  drivers/pci/pci.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
>> >  include/linux/pci.h |    1 +
>> >  2 files changed, 44 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> > index 111569c..d7f05ce 100644
>> > --- a/drivers/pci/pci.c
>> > +++ b/drivers/pci/pci.c
>> > @@ -2358,6 +2358,49 @@ void pci_enable_acs(struct pci_dev *dev)
>> >        pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
>> >  }
>> >
>> > +#define PCI_EXT_CAP_ACS_ENABLED                (PCI_ACS_SV | PCI_ACS_RR | \
>> > +                                        PCI_ACS_CR | PCI_ACS_UF)
>> > +
>> > +/**
>> > + * pci_acs_enabled - test ACS support in downstream chain
>> > + * @dev: starting PCI device
>> > + *
>> > + * Returns the furthest downstream device with an unbroken ACS chain.  If
>> > + * ACS is enabled throughout the chain, the returned device is the same as
>> > + * the one passed in.
>> > + */
>> > +struct pci_dev *pci_acs_enabled(struct pci_dev *dev)
>> > +{
>> > +       struct pci_dev *acs_dev;
>> > +       int pos;
>> > +       u16 ctrl;
>> > +
>> > +       if (!pci_is_root_bus(dev->bus))
>> > +               acs_dev = pci_acs_enabled(dev->bus->self);
>> > +       else
>> > +               return dev;
>> > +
>> > +       /* If the chain is already broken, pass on the device */
>> > +       if (acs_dev != dev->bus->self)
>> > +               return acs_dev;
>> > +
>> > +       if (!pci_is_pcie(dev) || (dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
>> > +               return dev;
>> > +
>> > +       if (dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
>> > +               return dev;
>> > +
>> > +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
>> > +       if (!pos)
>> > +               return acs_dev;
>> > +
>> > +       pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);
>> > +       if ((ctrl & PCI_EXT_CAP_ACS_ENABLED) != PCI_EXT_CAP_ACS_ENABLED)
>> > +               return acs_dev;
>> > +
>> > +       return dev;
>> > +}
>> > +
>> >  /**
>> >  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
>> >  * @dev: the PCI device
>> > diff --git a/include/linux/pci.h b/include/linux/pci.h
>> > index 9910b5c..dc25da3 100644
>> > --- a/include/linux/pci.h
>> > +++ b/include/linux/pci.h
>> > @@ -1586,6 +1586,7 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
>> >  }
>> >
>> >  void pci_request_acs(void);
>> > +struct pci_dev *pci_acs_enabled(struct pci_dev *dev);
>> >
>> >
>> >  #define PCI_VPD_LRDT                   0x80    /* Large Resource Data Type */
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
