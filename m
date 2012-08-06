Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2HFFzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2HFFzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:55:52 -0400
Message-ID: <1344232549.3441.7.camel@ul30vt.home>
Subject: Re: [PATCH] pci: Account for virtual buses in pci_acs_path_enabled
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com
Date: Sun, 05 Aug 2012 23:55:49 -0600
In-Reply-To: <CAErSpo42VMnfzDP6t5eCFfE-5=yPNmNGLs6a2D0KwGMhe71DbQ@mail.gmail.com>
References: <20120804181445.6598.6505.stgit@bling.home>
	 <CAErSpo42VMnfzDP6t5eCFfE-5=yPNmNGLs6a2D0KwGMhe71DbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-05 at 23:30 -0600, Bjorn Helgaas wrote:
> On Sat, Aug 4, 2012 at 12:19 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > It's possible to have buses without an associated bridge
> > (bus->self == NULL).  SR-IOV can generate such buses.  When
> > we find these, skip to the parent bus to look for the next
> > ACS test.
> 
> To make sure I understand the problem here, I think you're referring
> to the situation where an SR-IOV device can span several bus numbers,
> e.g., the "VFs Spanning Multiple Bus Numbers" implementation note in
> the SR-IOV 1.1 spec, sec. 2.1.2.
> 
> It says "All PFs must be located on the Device's captured Bus Number"
> -- I think that means every PF will be directly on a bridge's
> secondary bus and hence will have a valid dev->bus->self pointer.
> 
> However, VFs need not be on the same bus number.  If a VF is on
> (captured Bus Number plus 1), I think we allocate a new struct pci_bus
> for it, but there's no P2P bridge that leads to that bus, so the
> bus->self pointer is probably NULL.

Yes, exactly.  virtfn_add_bus() is where we're creating this new bus.

> This makes me quite nervous, because I bet there are many places that
> assume every non-root bus has a valid bus->self pointer  -- I know I
> certainly had that assumption.
> 
> I looked at callers of pci_is_root_bus(), and at first glance, it seems like
> iommu_init_device(), intel_iommu_add_device(), pci_acs_path_enabled(),


These 3 are handled by this patch, plus the intel and amd iommu patches
I sent.

> pci_get_interrupt_pin(), pci_common_swizzle(),

If sr-iov is the only source of these virtual buses, these are probably
ok since VFs don't support INTx.

> pci_find_upstream_pcie_bridge(), and

Here the pci_is_root_bus() is after a pci_is_pcie() check, so again if
sr-iov only (and assuming VFs properly report PCIe capability), we
shouldn't stumble on it.

> pci_bus_release_bridge_resources() all might have similar problems.

This one might deserve further investigation.  Thanks,

Alex

> 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >
> > David Ahern reported an oops from iommu drivers passing NULL into
> > this function for the same mistake.  Harden this function against
> > assuming bus->self is valid as well.  David, please include this
> > patch as well as the iommu patches in your testing.
> >
> >  drivers/pci/pci.c |   22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index f3ea977..e11a49c 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2486,18 +2486,30 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
> >  bool pci_acs_path_enabled(struct pci_dev *start,
> >                           struct pci_dev *end, u16 acs_flags)
> >  {
> > -       struct pci_dev *pdev, *parent = start;
> > +       struct pci_dev *pdev = start;
> > +       struct pci_bus *bus;
> >
> >         do {
> > -               pdev = parent;
> > -
> >                 if (!pci_acs_enabled(pdev, acs_flags))
> >                         return false;
> >
> > -               if (pci_is_root_bus(pdev->bus))
> > +               bus = pdev->bus;
> > +
> > +               if (pci_is_root_bus(bus))
> >                         return (end == NULL);
> >
> > -               parent = pdev->bus->self;
> > +               /*
> > +                * Skip buses without an associated bridge.  In this
> > +                * case move to the parent and continue.
> > +                */
> > +               while (!bus->self) {
> > +                       if (!pci_is_root_bus(bus))
> > +                               bus = bus->parent;
> > +                       else
> > +                               return (end == NULL);
> > +               }
> > +
> > +               pdev = bus->self;
> >         } while (pdev != end);
> >
> >         return true;
> >



