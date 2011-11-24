Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1KXC3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:29:43 -0500
Received: from ozlabs.org ([203.10.76.45]:56526 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1KXC3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:29:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
In-Reply-To: <20111123084640.GE22734@redhat.com>
References: <20111122183621.GA5235@redhat.com> <87hb1v1scp.fsf@rustcorp.com.au> <20111123084640.GE22734@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 24 Nov 2011 11:06:44 +1030
Message-ID: <87ty5uxso3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 10:46:41 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Nov 23, 2011 at 01:02:22PM +1030, Rusty Russell wrote:
> > On Tue, 22 Nov 2011 20:36:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > Here's an updated vesion.
> > > I'm alternating between updating the spec and the driver,
> > > spec update to follow.
> > 
> > Don't touch the spec yet, we have a long way to go :(
> > 
> > I want the ability for driver to set the ring size, and the device to
> > set the alignment.
> 
> Did you mean driver to be able to set the alignment? This
> is what BIOS guys want - after BIOS completes, guest driver gets handed
> control and sets its own alignment to save memory.

Yep, sorry.

But we really do want the guest to set the ring size.  Because it has to
be guest-physical-contiguous, the host currently sets a very small ring,
because the guest is useless if it can't allocate.

Either way, it's now the driver's responsibility to write those fields.

> > That's a bigger change than you have here.
> 
> Why can't we just add the new registers at the end?
> With the new capability, we have as much space as we like for that.

We could, for sure.

> > I imagine it almost rips the driver into two completely different drivers.
> 
> If you insist on moving all the rest of registers around, certainly. But
> why do this?

Because I suspect we'll be different enough anyway, once we change the
way we allocate the ring, and write the alignment.  It'll be *clearer*
to have two completely separate paths than to fill with if() statements.
And a rewrite won't hurt the driver.

But to be honest I don't really care about the Linux driver: we're
steeped in this stuff and we'll get it right.  But I'm *terrified* of
making the spec more complex; implementations will get it wrong.  I
*really* want to banish the legacy stuff to an appendix where noone will
ever know it's there :)

> Renaming constants in exported headers will break userspace builds.
> Do we care? Why not?

As the patch shows, I decided not to do that.  It's a nice heads-up, but
breaking older versions of the code is just mean.  Hence this:

> > +#ifndef __KERNEL__
> > +/* Don't break compile of old userspace code.  These will go away. */
> > +#define VIRTIO_PCI_HOST_FEATURES VIRTIO_PCI_LEGACY_HOST_FEATURES
> > +#define VIRTIO_PCI_GUEST_FEATURES VIRTIO_PCI_LEGACY_GUEST_FEATURES
> > +#define VIRTIO_PCI_LEGACY_QUEUE_PFN VIRTIO_PCI_QUEUE_PFN
> > +#define VIRTIO_PCI_LEGACY_QUEUE_NUM VIRTIO_PCI_QUEUE_NUM
> > +#define VIRTIO_PCI_LEGACY_QUEUE_SEL VIRTIO_PCI_QUEUE_SEL
> > +#define VIRTIO_PCI_LEGACY_QUEUE_NOTIFY VIRTIO_PCI_QUEUE_NOTIFY
> > +#define VIRTIO_PCI_LEGACY_STATUS VIRTIO_PCI_STATUS
> > +#define VIRTIO_PCI_LEGACY_ISR VIRTIO_PCI_ISR
> > +#define VIRTIO_MSI_LEGACY_CONFIG_VECTOR VIRTIO_MSI_CONFIG_VECTOR
> > +#define VIRTIO_MSI_LEGACY_QUEUE_VECTOR VIRTIO_MSI_QUEUE_VECTOR
> > +#define VIRTIO_PCI_LEGACY_CONFIG(dev) VIRTIO_PCI_CONFIG(dev)
> > +#define VIRTIO_PCI_LEGACY_QUEUE_ADDR_SHIFT VIRTIO_PCI_QUEUE_ADDR_SHIFT
> > +#define VIRTIO_PCI_LEGACY_VRING_ALIGN VIRTIO_PCI_VRING_ALIGN
> > +#endif /* ...!KERNEL */

...
> > +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> > +struct virtio_pci_common_cfg {
> > +	/* About the whole device. */
> > +	__u64 device_features;	/* read-only */
> > +	__u64 guest_features;	/* read-write */
> > +	__u64 queue_address;	/* read-write */
> > +	__u16 msix_config;	/* read-write */
> > +	__u8 device_status;	/* read-write */
> > +	__u8 unused;
> > +
> > +	/* About a specific virtqueue. */
> > +	__u16 queue_select;	/* read-write */
> > +	__u16 queue_align;	/* read-write, power of 2. */
> > +	__u16 queue_size;	/* read-write, power of 2. */
> > +	__u16 queue_msix_vector;/* read-write */
> > +};
> 
> Slightly confusing as the registers are in fact little endian ...

Good point, should mark them appropriately with __le16.  That makes it
even clearer.

Thanks,
Rusty.
