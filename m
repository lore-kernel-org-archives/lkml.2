Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1KPJJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:09:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab1KPJI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:08:58 -0500
Date: Wed, 16 Nov 2011 11:09:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111116090938.GA17290@redhat.com>
References: <20111108214021.GA4538@redhat.com>
 <20111109195901.GA28155@redhat.com>
 <1320870287.3730.6.camel@lappy>
 <20111109205208.GA28599@redhat.com>
 <1320872248.3730.11.camel@lappy>
 <87aa83qoao.fsf@rustcorp.com.au>
 <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
 <87aa7xos3n.fsf@rustcorp.com.au>
 <20111116072137.GF5433@redhat.com>
 <1321431459.3221.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321431459.3221.4.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:17:39AM +0200, Sasha Levin wrote:
> On Wed, 2011-11-16 at 09:21 +0200, Michael S. Tsirkin wrote:
> > On Wed, Nov 16, 2011 at 10:28:52AM +1030, Rusty Russell wrote:
> > > On Fri, 11 Nov 2011 09:39:13 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > > > On Fri, Nov 11, 2011 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > > (2) There's no huge win in keeping the same layout.  Let's make some
> > > > >    cleanups.  There are more users ahead of us then behind us (I
> > > > >    hope!).
> > > > 
> > > > Actually, if we already do cleanups, here are two more suggestions:
> > > > 
> > > > 1. Make 64bit features a one big 64bit block, instead of having 32bits
> > > > in one place and 32 in another.
> > > > 2. Remove the reserved fields out of the config (the ones that were
> > > > caused by moving the ISR and the notifications out).
> > > 
> > > Yes, those were exactly what I was thinking.  I left it vague because
> > > there might be others you can see if we're prepared to abandon the
> > > current format.
> > > 
> > > Cheers,
> > > Rusty.
> > 
> > Yes but driver code doesn't get any cleaner by moving the fields.
> > And in fact, the legacy support makes the code messier.
> > What are the advantages?
> > 

The advantages question is what should really balance out the overhead.

> What about splitting the parts which handle legacy code and new code?

Well, I considered that. Something along the lines of
#define VIRTIO_NEW_MSI_CONFIG_VECTOR        18
And so on for all registers.

This seems to add a significant maintainance burden because of code
duplication. Note that, for example, vector programming is affected.
Multiply that by the number of guest OSes.


> It'll make it easier playing with the new spec more freely

I'm really worried about maintaing drivers long term.
Ease of experimentation is secondary for me.

> and will also
> make it easier removing legacy code in the future since you'll need to
> simply delete a chunk of code instead of removing legacy bits out of
> working code with a surgical knife.

It's unlikely to be a single chunk: we'd have structures and macros
which are separate. So at least 3 chunks.

Just for fun, here's what's involved in removing legacy map
support on top of my patch. As you see there are 4 chunks:
structure decl, map, unmap, and msix enable/disable.
And finding them was as simple as looking for legacy_map.


---

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index d242fcc..6c4d2faf 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -64,9 +64,6 @@ struct virtio_pci_device
 
 	/* Various IO mappings: used for resource tracking only. */
 
-	/* Legacy BAR0: typically PIO. */
-	void __iomem *legacy_map;
-
 	/* Mappings specified by device capabilities: typically in MMIO */
 	void __iomem *isr_map;
 	void __iomem *notify_map;
@@ -81,11 +78,7 @@ struct virtio_pci_device
 static void virtio_pci_set_msix_enabled(struct virtio_pci_device *vp_dev, int enabled)
 {
 	vp_dev->msix_enabled = enabled;
-	if (vp_dev->device_map)
-		vp_dev->ioaddr_device = vp_dev->device_map;
-	else
-		vp_dev->ioaddr_device = vp_dev->legacy_map +
-			VIRTIO_PCI_CONFIG(vp_dev);
+	vp_dev->ioaddr_device = vp_dev->device_map;
 }
 
 static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap_id,
@@ -147,8 +140,6 @@ err:
 
 static void virtio_pci_iounmap(struct virtio_pci_device *vp_dev)
 {
-	if (vp_dev->legacy_map)
-		pci_iounmap(vp_dev->pci_dev, vp_dev->legacy_map);
 	if (vp_dev->isr_map)
 		pci_iounmap(vp_dev->pci_dev, vp_dev->isr_map);
 	if (vp_dev->notify_map)
@@ -176,36 +167,15 @@ static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
 
 	if (!vp_dev->notify_map || !vp_dev->common_map ||
 	    !vp_dev->device_map) {
-		/*
-		 * If not all capabilities present, map legacy PIO.
-		 * Legacy access is at BAR 0. We never need to map
-		 * more than 256 bytes there, since legacy config space
-		 * used PIO which has this size limit.
-		 * */
-		vp_dev->legacy_map = pci_iomap(vp_dev->pci_dev, 0, 256);
-		if (!vp_dev->legacy_map) {
-			dev_err(&vp_dev->vdev.dev, "Unable to map legacy PIO");
-			goto err;
-		}
+		dev_err(&vp_dev->vdev.dev, "Unable to map IO");
+		goto err;
 	}
 
-	/* Prefer MMIO if available. If not, fallback to legacy PIO. */
-	if (vp_dev->common_map)
-		vp_dev->ioaddr = vp_dev->common_map;
-	else
-		vp_dev->ioaddr = vp_dev->legacy_map;
+	vp_dev->ioaddr = vp_dev->common_map;
 
-	if (vp_dev->device_map)
-		vp_dev->ioaddr_device = vp_dev->device_map;
-	else
-		vp_dev->ioaddr_device = vp_dev->legacy_map +
-			VIRTIO_PCI_CONFIG(vp_dev);
+	vp_dev->ioaddr_device = vp_dev->device_map;
 
-	if (vp_dev->notify_map)
-		vp_dev->ioaddr_notify = vp_dev->notify_map;
-	else
-		vp_dev->ioaddr_notify = vp_dev->legacy_map +
-			VIRTIO_PCI_QUEUE_NOTIFY;
+	vp_dev->ioaddr_notify = vp_dev->notify_map;
 
 	return 0;
 err:
