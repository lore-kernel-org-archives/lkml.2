Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab0I0U6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759971Ab0I0U6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:58:09 -0400
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level
 PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org
In-Reply-To: <20100927115420.GA7427@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
	 <20100927115420.GA7427@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 14:57:49 -0600
Message-ID: <1285621069.4951.61.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 13:54 +0200, Michael S. Tsirkin wrote:
> On Wed, Sep 22, 2010 at 02:18:24PM -0700, Tom Lyon wrote:
> > 
> > Signed-off-by: Tom Lyon <pugs@cisco.com>
> 
> Some comments on the pci bits:
> 
> After going over them for the Nth time - something needs to be done
> with the rvirt/write tables. I doubt anyone besides me and you
> has gone over them: 

/me bites tongue...

> > +static void vfio_bar_fixup(struct vfio_dev *vdev)
> > +{
> 
> So you do this on each read?
> Why don't you mask the appropriate bits on write?
> This is what real hardware does, after all.
> Then you won't need the bardirty field.
> 
> 
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int bar;
> > +	u32 *lp;
> > +	u64 mask;
> > +
> > +	for (bar = 0; bar <= 5; bar++) {
> > +		if (pci_resource_start(pdev, bar))
> > +			mask = ~(pci_resource_len(pdev, bar) - 1);
> > +		else
> > +			mask = 0;
> > +		lp = (u32 *)vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar;
> > +		*lp &= (u32)mask;
> > +
> > +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
> > +			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> > +		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> > +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> > +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> > +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> > +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> > +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> > +				lp++;
> > +				*lp &= (u32)(mask >> 32);
> > +				bar++;
> > +			}
> > +		}
> > +	}
> > +
> > +	if (pci_resource_start(pdev, PCI_ROM_RESOURCE))
> 
> Not if (pci_resource_len)?

Using this test covers both zero length/unimplemented BARs and BARs that
aren't mapped by the host.  Unmapped BARs on the host are exposed as
unimplemented BARs to the vfio user.  I wonder if this is still
necessary if we do the iomap/rom_map on open as I propose.

> > +		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
> > +	else
> > +		mask = 0;
> > +	lp = (u32 *)vdev->vconfig + PCI_ROM_ADDRESS;
> > +	*lp &= (u32)mask;
> > +
> > +	vdev->bardirty = 0;
> 
> Aren't the pci values in little endian format?
> If so doing operations on them in native endianness is wrong.
> sparse generally is good at catching these, but you will
> have to avoid so many type casts and annotate endian-ness
> for it to be of any use.

Yep, I expect there are a number of endian issues here, good call
pointing them out.

Alex

