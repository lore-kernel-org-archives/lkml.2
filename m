Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966904Ab2EOVJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:09:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966817Ab2EOVJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:09:43 -0400
Message-ID: <1337116157.6954.212.camel@bling.home>
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Tue, 15 May 2012 15:09:17 -0600
In-Reply-To: <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225602.30496.80438.stgit@bling.home>
	 <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com>
	 <1337035766.6954.74.camel@bling.home>
	 <CAErSpo48ES5iLDCh1WzmHezSEYhPjhtgD5uxoY-TCTKgUBab2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 13:56 -0600, Bjorn Helgaas wrote:
> On Mon, May 14, 2012 at 4:49 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Mon, 2012-05-14 at 16:02 -0600, Bjorn Helgaas wrote:
> >> On Fri, May 11, 2012 at 4:56 PM, Alex Williamson
> >> <alex.williamson@redhat.com> wrote:
> >> > In a PCIe environment, transactions aren't always required to
> >> > reach the root bus before being re-routed.  Peer-to-peer DMA
> >> > may actually not be seen by the IOMMU in these cases.  For
> >> > IOMMU groups, we want to provide IOMMU drivers a way to detect
> >> > these restrictions.  Provided with a PCI device, pci_acs_enabled
> >> > returns the furthest downstream device with a complete PCI ACS
> >> > chain.  This information can then be used in grouping to create
> >> > fully isolated groups.  ACS chain logic extracted from libvirt.
> >>
> >> The name "pci_acs_enabled()" sounds like it returns a boolean, but it doesn't.
> >
> > Right, maybe this should be:
> >
> > struct pci_dev *pci_find_upstream_acs(struct pci_dev *pdev);
> >
> >> I'm not sure what "a complete PCI ACS chain" means.
> >>
> >> The function starts from "dev" and searches *upstream*, so I'm
> >> guessing it returns the root of a subtree that must be contained in a
> >> group.
> >
> > Any intermediate switch between an endpoint and the root bus can
> > redirect a dma access without iommu translation,
> 
> Is this "redirection" just the normal PCI bridge forwarding that
> allows peer-to-peer transactions, i.e., the rule (from P2P bridge
> spec, rev 1.2, sec 4.1) that the bridge apertures define address
> ranges that are forwarded from primary to secondary interface, and the
> inverse ranges are forwarded from secondary to primary?  For example,
> here:
> 
>                    ^
>                    |
>           +--------+-------+
>           |                |
>    +------+-----+    +-----++-----+
>    | Downstream |    | Downstream |
>    |    Port    |    |    Port    |
>    |   06:05.0  |    |   06:06.0  |
>    +------+-----+    +------+-----+
>           |                 |
>      +----v----+       +----v----+
>      | Endpoint|       | Endpoint|
>      | 07:00.0 |       | 08:00.0 |
>      +---------+       +---------+
> 
> that rule is all that's needed for a transaction from 07:00.0 to be
> forwarded from upstream to the internal switch bus 06, then claimed by
> 06:06.0 and forwarded downstream to 08:00.0.  This is plain old PCI,
> nothing specific to PCIe.

Right, I think the main PCI difference is the point-to-point nature of
PCIe vs legacy PCI bus.  On a legacy PCI bus there's no way to prevent
devices talking to each other, but on PCIe the transaction makes a
U-turn at some point and heads out another downstream port.  ACS allows
us to prevent that from happening.

> I don't understand ACS very well, but it looks like it basically
> provides ways to prevent that peer-to-peer forwarding, so transactions
> would be sent upstream toward the root (and specifically, the IOMMU)
> instead of being directly claimed by 06:06.0.

Yep, that's my meager understanding as well.

> > so we're looking for
> > the furthest upstream device for which acs is enabled all the way up to
> > the root bus.
> 
> Correct me if this is wrong: To force device A's DMAs to be processed
> by an IOMMU, ACS must be enabled on the root port and every downstream
> port along the path to A.

Yes, modulo this comment in libvirt source:

    /* if we have no parent, and this is the root bus, ACS doesn't come
     * into play since devices on the root bus can't P2P without going
     * through the root IOMMU.
     */

So we assume that a redirect at the point of the iommu will factor in
iommu translation.

> If so, I think you're trying to find out the closest upstream device X
> such that everything leading to X has ACS enabled.  Every device below
> X can DMA freely to other devices below X, so they would all have to
> be in the same isolated group.

Yes

> I tried to work through some examples to develop some intuition about this:

(inserting fixed url)
> http://www.asciiflow.com/#3736558963405980039

> pci_acs_enabled(00:00.0) = 00:00.0 (on root bus (but doesn't it matter
> if 00:00.0 is PCIe or if RP has ACS?))

Hmm, the latter is the assumption above.  For the former, I think
libvirt was probably assuming that PCI devices must have a PCIe device
upstream from them because x86 doesn't have assignment friendly IOMMUs
except on PCIe.  I'll need to work on making that more generic.

> pci_acs_enabled(00:01.0) = 00:01.0 (on root bus)
> pci_acs_enabled(01:00.0) = 01:00.0 (acs_dev = 00:01.0, 01:00.0 is not
> PCIe; seems wrong)

Oops, I'm calling pci_find_upstream_pcie_bridge() first on any of my
input devices, so this was passing for me.  I'll need to incorporate
that generically.

> pci_acs_enabled(00:02.0) = 00:02.0 (on root bus; seems wrong if RP
> doesn't have ACS)

Yeah, let me validate the libvirt assumption.  I see ACS on my root
port, so maybe they're just assuming it's always enabled or that the
precedence favors IOMMU translation.  I'm also starting to think that we
might want "from" and "to" struct pci_dev parameters to make it more
flexible where the iommu lives in the system.

> pci_acs_enabled(02:00.0) = 00:02.0 (acs_dev = 00:02.0, 02:00.0 has no ACS cap)
> pci_acs_enabled(03:00.0) = 00:02.0 (acs_dev = 00:02.0)
> pci_acs_enabled(02:01.0) = 02:01.0 (acs_dev = 00:02.0, 02:01.0 has ACS enabled)
> pci_acs_enabled(04:00.0) = 04:00.0 (acs_dev = 02:01.0, 04:00.0 is not
> a bridge; seems wrong if 04:00 is a multi-function device)

AIUI, ACS is not an endpoint property, so this is what should happen.  I
don't think multifunction plays a role other than how much do we trust
the implementation to not allow back channels between functions (the
answer should probably be not at all).

> pci_acs_enabled(02:02.0) = 02:02.0 (acs_dev = 00:02.0, 02:02.0 has ACS enabled)
> pci_acs_enabled(05:00.0) = 05:00.0 (acs_dev = 02:02.0, 05:00.0 is not a bridge)
> 
> But it didn't really help.  I still can't develop a mental picture of
> what this function does.

It helped me :)  These are good examples, I'll work on fixing it for
them.  Thanks,

Alex


