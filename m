Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1KWPdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:33:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab1KWPdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:33:22 -0500
Date: Wed, 23 Nov 2011 17:34:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111123153404.GA27003@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123084640.GE22734@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:46:40AM +0200, Michael S. Tsirkin wrote:
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
> 
> > That's a bigger change than you have here.
> 
> Why can't we just add the new registers at the end?
> With the new capability, we have as much space as we like for that.

Didn't have the time to finish the patch today, but just to clarify,
we can apply something like the below on top of my patch,
and then config_len can be checked to see whether the new fields
like alignment are available.

We probably can make the alignment smaller and save some memory -
the default value could set the default alignment.

Ring size, naturally, can just be made writeable - BIOS can put a
small value there, but linux guest would just use the defaults
so no need for any code changes at all.

As a bonus, the capability length is verified to be large enough.
The change's pretty small, isn't it?

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 681347b..39433d3 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -37,8 +37,9 @@ struct virtio_pci_device
 	struct virtio_device vdev;
 	struct pci_dev *pci_dev;
 
-	/* the IO address for the common PCI config space */
+	/* the IO address and length for the common PCI config space */
 	void __iomem *ioaddr;
+	unsigned config_len;
 	/* the IO address for device specific config */
 	void __iomem *ioaddr_device;
 	/* the IO address to use for notifications operations */
@@ -101,22 +102,24 @@ static void __iomem *virtio_pci_legacy_map(struct virtio_pci_device *vp_dev)
 #endif
 
 /*
- * With PIO, device-specific config moves as MSI-X is enabled/disabled.
- * Use this accessor to keep pointer to that config in sync.
+ * With PIO, device-specific config moves as MSI-X is enabled/disabled,
+ * configuration region length changes as well.  Use this accessor to keep
+ * pointer to that config and common config length, in sync.
  */
 static void virtio_pci_set_msix_enabled(struct virtio_pci_device *vp_dev, int enabled)
 {
 	void __iomem* m;
 	vp_dev->msix_enabled = enabled;
 	m = virtio_pci_legacy_map(vp_dev);
-	if (m)
+	if (m) {
 		vp_dev->ioaddr_device = m + VIRTIO_PCI_CONFIG(vp_dev);
-	else
+		vp_dev->config_len = VIRTIO_PCI_CONFIG(vp_dev);
+	} else
 		vp_dev->ioaddr_device = vp_dev->device_map;
 }
 
 static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap_id,
-					u32 align)
+					u32 align, unsigned *lenp)
 {
         u32 size;
         u32 offset;
@@ -160,12 +163,16 @@ static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap
         offset &= VIRTIO_PCI_CAP_CFG_OFF_MASK;
 	/* Align offset appropriately */
 	offset &= ~(align - 1);
+	if (lenp && size < *lenp)
+		goto err;
 
 	/* It's possible for a device to supply a huge config space,
 	 * but we'll never need to map more than a page ATM. */
 	p = pci_iomap_range(dev, bir, offset, size, PAGE_SIZE);
 	if (!p)
 		dev_err(&vp_dev->vdev.dev, "Unable to map virtio pci memory");
+	if (lenp)
+		*lenp = min(size, PAGE_SIZE);
 	return p;
 err:
 	dev_err(&vp_dev->vdev.dev, "Unable to parse virtio pci capability");
@@ -188,22 +195,24 @@ static void virtio_pci_iounmap(struct virtio_pci_device *vp_dev)
 
 static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
 {
+	unsigned common_len = VIRTIO_PCI_COMMON_CFG_MINSIZE;
 	vp_dev->isr_map = virtio_pci_map_cfg(vp_dev,
 					     VIRTIO_PCI_CAP_ISR_CFG,
-					     sizeof(u8));
+					     sizeof(u8), NULL);
 	vp_dev->notify_map = virtio_pci_map_cfg(vp_dev,
 						VIRTIO_PCI_CAP_NOTIFY_CFG,
-						sizeof(u16));
+						sizeof(u16), NULL);
 	vp_dev->common_map = virtio_pci_map_cfg(vp_dev,
 						VIRTIO_PCI_CAP_COMMON_CFG,
-						sizeof(u32));
+						sizeof(u32), &common_len);
 	vp_dev->device_map = virtio_pci_map_cfg(vp_dev,
 						VIRTIO_PCI_CAP_DEVICE_CFG,
-						sizeof(u8));
+						sizeof(u8), NULL);
 
 	if (vp_dev->notify_map && vp_dev->isr_map &&
 	    vp_dev->common_map && vp_dev->device_map) {
 		vp_dev->ioaddr = vp_dev->common_map;
+		vp_dev->config_len = common_len;
 		vp_dev->ioaddr_isr = vp_dev->isr_map;
 		vp_dev->ioaddr_notify = vp_dev->notify_map;
 		vp_dev->ioaddr_device = vp_dev->device_map;
@@ -221,6 +230,7 @@ static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
 			goto err;
 		}
 		vp_dev->ioaddr = m;
+		vp_dev->config_len = VIRTIO_PCI_CONFIG(vp_dev);
 		vp_dev->ioaddr_isr = m + VIRTIO_PCI_ISR;
 		vp_dev->ioaddr_notify = m + VIRTIO_PCI_QUEUE_NOTIFY;
 		vp_dev->ioaddr_device = m + VIRTIO_PCI_CONFIG(vp_dev);
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index d6568e7..8133851 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -133,4 +133,6 @@
 #define VIRTIO_PCI_CAP_CFG_OFF_MASK	0xffffffff
 #define VIRTIO_PCI_CAP_CFG_OFF_SHIFT	0
 
+#define VIRTIO_PCI_COMMON_CFG_MINSIZE	24
+
 #endif
