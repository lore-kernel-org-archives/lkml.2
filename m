Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1KCLLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:11:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54277 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1KCLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:11:50 -0400
Subject: Re: [PATCH RFC] virtio-pci: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <20111103103314.GA18296@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <1320279543.31237.14.camel@lappy>
	 <20111103103314.GA18296@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 03 Nov 2011 13:09:51 +0200
Message-ID: <1320318591.29407.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:33 +0200, Michael S. Tsirkin wrote:
> On Thu, Nov 03, 2011 at 02:19:03AM +0200, Sasha Levin wrote:
> > Hi Michael,
> > 
> > On Thu, 2011-11-03 at 01:31 +0200, Michael S. Tsirkin wrote:
> > > Add a flexible mechanism to specify virtio configuration layout, using
> > > pci vendor-specific capability.  A separate capability is used for each
> > > of common, device specific and data-path accesses.
> > > 
> > > Warning: compiled only.
> > > This patch also needs to be split up, pci_iomap changes
> > > also need arch updates for non-x86.
> > > 
> > > We also will need to update the spec.
> > > 
> > > See the first chunk for layout documentation.
> > > 
> > > Posting here for early feedback.
> > > 
> > > In particular:
> > > 
> > > Do we need to require offset to be aligned?
> > > Does iowrite16 work with unaligned accesses on all architectures?
> > > Does using ioread/write as we do add overhead as compared to
> > > plain PIO accesses?
> > > 
> > > Jesse - are you OK with the pci_iomap_range API proposed here
> > > (see last chunks)?
> > > I noticed lots of architectures duplicate the implementation
> > > of pci_iomap - makes sense to clean that up?
> > > 
> > > Thanks,
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > ---
> > > 
> > > diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
> > > index ea66f3f..b8a9de2 100644
> > > --- a/include/linux/virtio_pci.h
> > > +++ b/include/linux/virtio_pci.h
> > > @@ -92,4 +92,38 @@
> > >  /* The alignment to use between consumer and producer parts of vring.
> > >   * x86 pagesize again. */
> > >  #define VIRTIO_PCI_VRING_ALIGN		4096
> > > +
> > > +/*
> > > + * Layout for Virtio PCI vendor specific capability (little-endian):
> > > + * 5 bit virtio capability id.
> > > + * 3 bit BAR index register, specifying which BAR to use.
> > > + * 4 byte cfg offset within the BAR.
> > 
> > Why not make the 3 bits of the BIR as the lower 3 bits of the offset
> > like its done in the PCI spec?
> > 
> > This way you also get 'free' 32bit alignment and simpler masking.
> 
> 3 bit gets us 64 bit alignment, no? Seems a bit more than we need:
> we need at most 16 bit alignment.

Yup, it's actually 64 bit, but whats the problem with that? It will also
look more similar to the PCI spec.

> 
> > > + * 4 byte cfg size.
> > > + */
> > > +
> > > +/* A single virtio device has multiple vendor specific capabilities, we use the
> > > + * 5 bit ID field to distinguish between these. */
> > > +#define VIRTIO_PCI_CAP_ID		3
> > > +#define VIRTIO_PCI_CAP_ID_MASK		0x1f
> > > +#define VIRTIO_PCI_CAP_ID_SHIFT		0
> > > +
> > > +/* IDs for different capabilities. If a specific configuration
> > > + * is missing, legacy PIO path is used. */
> > > +/* Common configuration */
> > > +#define VIRTIO_PCI_CAP_COMMON_CFG	0
> > > +/* Device specific confiuration */
> > > +#define VIRTIO_PCI_CAP_DEVICE_CFG	1
> > > +/* Notifications and ISR access */
> > > +#define VIRTIO_PCI_CAP_NOTIFY_CFG	2
> > 
> > I think that separating notification here is very kvm specific.
> 
> I don't see how it's kvm specific. This just makes it possible to split data path and
> configuration. Good for security as well. I was actually debating a
> separate configuration for ISR and NOTIFICATION.

It's not really a clean split between data and config, you still have
device status stuck between notification and ISR, which isn't really in
the data path.

A split as you suggested sounds like a good idea, but we just need to
move some fields around to make it clean.

> > Maybe it
> > could be replaced by allowing virtio to signal eventfds or something
> > similar?
> 
> No idea what you mean - it's a pci device, how should it signal eventfds?

I'm not really sure what I was thinking about, ignore that :)

> 
> > > +
> > > +/* Index of the BAR including this configuration */
> > > +#define VIRTIO_PCI_CAP_CFG_BIR		3
> > > +#define VIRTIO_PCI_CAP_CFG_BIR_MASK	(0x7)
> > > +#define VIRTIO_PCI_CAP_CFG_BIR_SHIFT	5
> > > +
> > > +/* Offset within the BAR */
> > > +#define VIRTIO_PCI_CAP_CFG_OFF		4
> > > +/* Size of the configuration space */
> > > +#define VIRTIO_PCI_CAP_CFG_SIZE		8
> > > +
> > >  #endif
> > > diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > > index 4bcc8b8..d4ed130 100644
> > > --- a/drivers/virtio/virtio_pci.c
> > > +++ b/drivers/virtio/virtio_pci.c
> > > @@ -37,8 +37,12 @@ struct virtio_pci_device
> > >  	struct virtio_device vdev;
> > >  	struct pci_dev *pci_dev;
> > >  
> > > -	/* the IO mapping for the PCI config space */
> > > +	/* the IO address for the common PCI config space */
> > >  	void __iomem *ioaddr;
> > > +	/* the IO address for device specific config */
> > > +	void __iomem *ioaddr_device;
> > > +	/* the IO address to use for notifications operations */
> > > +	void __iomem *ioaddr_notify;
> > >  
> > >  	/* a list of queues so we can dispatch IRQs */
> > >  	spinlock_t lock;
> > > @@ -57,8 +61,142 @@ struct virtio_pci_device
> > >  	unsigned msix_used_vectors;
> > >  	/* Whether we have vector per vq */
> > >  	bool per_vq_vectors;
> > > +
> > > +	/* Various IO mappings: used for resource tracking only. */
> > > +
> > > +	/* Legacy BAR0: typically PIO. */
> > > +	void __iomem *legacy_map;
> > > +
> > > +	/* Mappings specified by device capabilities: typically in MMIO */
> > > +	void __iomem *notify_map;
> > > +	void __iomem *common_map;
> > > +	void __iomem *device_map;
> > >  };
> > >  
> > > +/*
> > > + * With PIO, device-specific config moves as MSI-X is enabled/disabled.
> > > + * Use this accessor to keep pointer to that config in sync.
> > > + */
> > > +static void virtio_pci_set_msix_enabled(struct virtio_pci_device *vp_dev, int enabled)
> > > +{
> > > +	vp_dev->msix_enabled = enabled;
> > > +	if (vp_dev->device_map)
> > > +		vp_dev->ioaddr_device = vp_dev->device_map;
> > > +	else
> > > +		vp_dev->ioaddr_device = vp_dev->legacy_map +
> > > +			VIRTIO_PCI_CONFIG(vp_dev);
> > > +}
> > > +
> > > +static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap_id)
> > > +{
> > > +        u32 size;
> > > +        u32 offset;
> > > +        u8 bir;
> > > +        u8 cap_len;
> > > +	int pos;
> > > +	struct pci_dev *dev = vp_dev->pci_dev;
> > > +	void __iomem *p;
> > > +
> > > +	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
> > > +	     pos > 0;
> > > +	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
> > > +		u8 id;
> > > +		pci_read_config_byte(dev, pos + PCI_VNDR_CAP_LEN, &cap_len);
> > > +		if (cap_len < VIRTIO_PCI_CAP_ID + 1)
> > > +			continue;
> > > +		pci_read_config_byte(dev, pos + VIRTIO_PCI_CAP_ID, &id);
> > > +		id >>= VIRTIO_PCI_CAP_ID_SHIFT;
> > > +		id &= VIRTIO_PCI_CAP_ID_MASK;
> > > +		if (id == cap_id)
> > > +			break;
> > > +	}
> > > +
> > > +	if (pos <= 0)
> > > +		return NULL;
> > > +
> > > +	if (cap_len < VIRTIO_PCI_CAP_CFG_BIR + 1)
> > > +		goto err;
> > > +        pci_read_config_byte(dev, pos + VIRTIO_PCI_CAP_CFG_BIR, &bir);
> > > +	if (cap_len < VIRTIO_PCI_CAP_CFG_OFF + 4)
> > > +		goto err;
> > > +        pci_read_config_dword(dev, pos + VIRTIO_PCI_CAP_CFG_OFF, &offset);
> > > +	if (cap_len < VIRTIO_PCI_CAP_CFG_SIZE + 4)
> > > +		goto err;
> > > +        pci_read_config_dword(dev, pos + VIRTIO_PCI_CAP_CFG_SIZE, &size);
> > > +        bir >>= VIRTIO_PCI_CAP_CFG_BIR_SHIFT;
> > > +        bir &= VIRTIO_PCI_CAP_CFG_BIR_MASK;
> > > +
> > > +	/* It's possible for a device to supply a huge config space,
> > > +	 * but we'll never need to map more than a page ATM. */
> > > +	p = pci_iomap_range(dev, bir, offset, size, PAGE_SIZE);
> > > +	if (!p)
> > > +		dev_err(&vp_dev->vdev.dev, "Unable to map virtio pci memory");
> > > +	return p;
> > > +err:
> > > +	dev_err(&vp_dev->vdev.dev, "Unable to parse virtio pci capability");
> > > +	return NULL;
> > > +}
> > > +
> > > +static void virtio_pci_iounmap(struct virtio_pci_device *vp_dev)
> > > +{
> > > +	if (vp_dev->legacy_map)
> > > +		pci_iounmap(vp_dev->pci_dev, vp_dev->legacy_map);
> > > +	if (vp_dev->notify_map)
> > > +		pci_iounmap(vp_dev->pci_dev, vp_dev->notify_map);
> > > +	if (vp_dev->common_map)
> > > +		pci_iounmap(vp_dev->pci_dev, vp_dev->common_map);
> > > +	if (vp_dev->device_map)
> > > +		pci_iounmap(vp_dev->pci_dev, vp_dev->device_map);
> > > +}
> > > +
> > > +static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
> > > +{
> > > +	vp_dev->notify_map = virtio_pci_map_cfg(vp_dev,
> > > +						     VIRTIO_PCI_CAP_NOTIFY_CFG);
> > > +	vp_dev->common_map = virtio_pci_map_cfg(vp_dev,
> > > +						     VIRTIO_PCI_CAP_COMMON_CFG);
> > > +	vp_dev->device_map = virtio_pci_map_cfg(vp_dev,
> > > +						     VIRTIO_PCI_CAP_DEVICE_CFG);
> > > +
> > > +	if (!vp_dev->notify_map || !vp_dev->common_map ||
> > > +	    !vp_dev->device_map) {
> > > +		/*
> > > +		 * If not all capabilities present, map legacy PIO.
> > > +		 * Legacy access is at BAR 0. We never need to map
> > > +		 * more than 256 bytes there, since legacy config space
> > > +		 * used PIO which has this size limit.
> > > +		 * */
> > 
> > Whats the point of putting each of those new configs into a separate cap
> > structure if you must have all 3 of them for the new config layout to
> > work anyway?
> 
> Pls look closer, we don't require all 3 of them. For example, we can have BAR0
> DEVICE and COMMON, and notifications will use BAR0.
> 
> By using an identical structure we make is much easier to reuse
> and extend it. For example we might add a separate structure for ISR.

Right.

> > Also, why not use this change to simplify the config space? The attempts
> > to squeeze it into the limited PIO space made it quite messy, and this
> > can be a good chance to fix some things like the MSI-X and offsets
> > issue.
> 
> For MSI-X this is exactly what this change does, by splitting
> device-specific parts out. So if DEVICE capability is present,
> this tells us where the device specific data starts and
> enabling MSI-X does not relocate it.

You still have relocations within the shared config space, once 64bit
features or other future extensions are implemented.

> Are there other fields we want to move?

We can do several things:

1. Since we're no longer limited in space - remove queue selector and
just have a full queue table.

2. Move device specific features into the device specific region.
Currently the features field is a mix between virtio-pci and device
specific features.

I did more similar things in the spec suggestion I've sent, could you
look at the second part for more ideas please?

-- 

Sasha.

