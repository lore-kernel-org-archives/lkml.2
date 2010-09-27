Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab0I0Uqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760199Ab0I0Uqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:46:49 -0400
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level
 PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        mst@redhat.com
In-Reply-To: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 14:46:32 -0600
Message-ID: <1285620392.4951.50.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 14:18 -0700, Tom Lyon wrote:
> +ssize_t vfio_mem_readwrite(
> +		int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	resource_size_t end;
> +	void __iomem *io;
> +	loff_t pos;
> +	int pci_space;
> +
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	pos = vfio_offset_to_pci_offset(*ppos);
> +
> +	if (!pci_resource_start(pdev, pci_space))
> +		return -EINVAL;
> +	end = pci_resource_len(pdev, pci_space);
> +	if (vdev->barmap[pci_space] == NULL)
> +		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> +	io = vdev->barmap[pci_space];
> +

So we do a pci_iomap, but never do corresponding pci_iounmap.  This also
only works for the first 6 BARs since the ROM BAR needs pci_map_rom.  I
wonder if we should be doing all the BAR mapping at open and unmap at
close so that we can fail if the device can't get basic resources.  I
believe we should also be calling pci_request_regions in here somewhere.
Perhaps something like this:

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a18e39a..d3886d9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -85,6 +85,53 @@ static inline int overlap(int a1, int b1, int a2, int b2)
 	return !(b2 <= a1 || b1 <= a2);
 }
 
+static int vfio_setup_pci(struct vfio_dev *vdev)
+{
+	int ret, bar;
+
+	ret = pci_enable_device(vdev->pdev);
+	if (ret)
+		return ret;
+		
+	ret = pci_request_regions(vdev->pdev, "VFIO");
+	if (ret) {
+		pci_disable_device(vdev->pdev);
+		return ret;
+	}
+
+	for (bar = PCI_STD_RESOURCES; bar <= PCI_ROM_RESOURCE; bar++) {
+		if (!pci_resource_len(vdev->pdev, bar))
+			continue;
+		if (bar != PCI_ROM_RESOURCE) {
+			if (!pci_resource_start(vdev->pdev, bar))
+				continue;
+			vdev->barmap[bar] = pci_iomap(vdev->pdev, bar, 0);
+		} else {
+			size_t size;
+			vdev->barmap[bar] = pci_map_rom(vdev->pdev, &size);
+		}
+	}
+	return ret;
+}
+
+static void vfio_disable_pci(struct vfio_dev *vdev)
+{
+	int bar;
+
+	for (bar = PCI_STD_RESOURCES; bar <= PCI_ROM_RESOURCE; bar++) {
+		if (!vdev->barmap[bar])
+			continue;
+		if (bar != PCI_ROM_RESOURCE)
+			pci_iounmap(vdev->pdev, vdev->barmap[bar]);
+		else
+			pci_unmap_rom(vdev->pdev, vdev->barmap[bar]);
+		vdev->barmap[bar] = NULL;
+	}
+
+	pci_release_regions(vdev->pdev);
+	pci_disable_device(vdev->pdev);
+}
+
 static int vfio_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_dev *vdev;
@@ -110,7 +157,7 @@ static int vfio_open(struct inode *inode, struct file *filep)
 	INIT_LIST_HEAD(&listener->dm_list);
 	filep->private_data = listener;
 	if (vdev->listeners == 0)
-		ret = pci_enable_device(vdev->pdev);
+		ret = vfio_setup_pci(vdev);
 	if (ret == 0)
 		vdev->listeners++;
 	mutex_unlock(&vdev->lgate);
@@ -151,7 +198,7 @@ static int vfio_release(struct inode *inode, struct file *filep)
 		vdev->vconfig = NULL;
 		kfree(vdev->pci_config_map);
 		vdev->pci_config_map = NULL;
-		pci_disable_device(vdev->pdev);
+		vfio_disable_pci(vdev);
 		vfio_domain_unset(vdev);
 		wake_up(&vdev->dev_idle_q);
 	}
diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
index 1fd50a6..7705b45 100644
--- a/drivers/vfio/vfio_rdwr.c
+++ b/drivers/vfio/vfio_rdwr.c
@@ -64,7 +64,7 @@ ssize_t vfio_io_readwrite(
 	if (pos + count > end)
 		return -EINVAL;
 	if (vdev->barmap[pci_space] == NULL)
-		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
+		return -EINVAL;
 	io = vdev->barmap[pci_space];
 
 	while (count > 0) {
@@ -137,7 +137,12 @@ ssize_t vfio_mem_readwrite(
 		return -EINVAL;
 	end = pci_resource_len(pdev, pci_space);
 	if (vdev->barmap[pci_space] == NULL)
-		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
+		return -EINVAL;
+	if (pci_space == PCI_ROM_RESOURCE) {
+		u32 rom = *(u32 *)(vdev->vconfig + PCI_ROM_ADDRESS);
+		if (!(rom & PCI_ROM_ADDRESS_ENABLE))
+			return -EINVAL;
+	}
 	io = vdev->barmap[pci_space];
 
 	if (pos > end)


