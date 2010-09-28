Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0I1O0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab0I1O0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:26:44 -0400
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level
 PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org
In-Reply-To: <20100928100907.GK12472@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
	 <1285620392.4951.50.camel@x201>  <20100928100907.GK12472@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 08:26:21 -0600
Message-ID: <1285683981.4951.112.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 12:09 +0200, Michael S. Tsirkin wrote:
> On Mon, Sep 27, 2010 at 02:46:32PM -0600, Alex Williamson wrote:
> > On Wed, 2010-09-22 at 14:18 -0700, Tom Lyon wrote:
> > > +ssize_t vfio_mem_readwrite(
> > > +		int write,
> > > +		struct vfio_dev *vdev,
> > > +		char __user *buf,
> > > +		size_t count,
> > > +		loff_t *ppos)
> > > +{
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	resource_size_t end;
> > > +	void __iomem *io;
> > > +	loff_t pos;
> > > +	int pci_space;
> > > +
> > > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > > +	pos = vfio_offset_to_pci_offset(*ppos);
> > > +
> > > +	if (!pci_resource_start(pdev, pci_space))
> > > +		return -EINVAL;
> > > +	end = pci_resource_len(pdev, pci_space);
> > > +	if (vdev->barmap[pci_space] == NULL)
> > > +		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> > > +	io = vdev->barmap[pci_space];
> > > +
> > 
> > So we do a pci_iomap, but never do corresponding pci_iounmap.  This also
> > only works for the first 6 BARs since the ROM BAR needs pci_map_rom.
> 
> 
> An issue with ROM is that I think it can not be enabled together
> with BARs. This is why pci_read_rom/pci_write_rom do what
> they do.

I don't think that's an issue.  pci_read/write_rom doesn't do anything
about disabling BARs when the ROM is read.  The reason that it maps and
unmaps around the read is to be resource friendly.  For vfio, since
we've assigned a device to vfio and it's open, I think it's valid to
assign all the resources and sit on them.  Otherwise I don't think we
can guarantee that a read that worked last time will still get resources
and work this time.

> >  I
> > wonder if we should be doing all the BAR mapping at open and unmap at
> > close so that we can fail if the device can't get basic resources.
> 
> I belive we should do this on ioctl so that e.g. hotunplug
> can reset the device clean it up. Unused device should also not
> consume resources.

If it's assigned to vfio and opened, then it's not unused.  A hotunplug
would involve a close of the vfio device, which could then reset the
device.  I think we probably are still missing a device reset, but I'm
not sure if it needs an ioctl or if a reset on open would be sufficient.

Alex

> > I
> > believe we should also be calling pci_request_regions in here somewhere.
> > Perhaps something like this:
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a18e39a..d3886d9 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -85,6 +85,53 @@ static inline int overlap(int a1, int b1, int a2, int b2)
> >  	return !(b2 <= a1 || b1 <= a2);
> >  }
> >  
> > +static int vfio_setup_pci(struct vfio_dev *vdev)
> > +{
> > +	int ret, bar;
> > +
> > +	ret = pci_enable_device(vdev->pdev);
> > +	if (ret)
> > +		return ret;
> > +		
> > +	ret = pci_request_regions(vdev->pdev, "VFIO");
> > +	if (ret) {
> > +		pci_disable_device(vdev->pdev);
> > +		return ret;
> > +	}
> > +
> > +	for (bar = PCI_STD_RESOURCES; bar <= PCI_ROM_RESOURCE; bar++) {
> > +		if (!pci_resource_len(vdev->pdev, bar))
> > +			continue;
> > +		if (bar != PCI_ROM_RESOURCE) {
> > +			if (!pci_resource_start(vdev->pdev, bar))
> > +				continue;
> > +			vdev->barmap[bar] = pci_iomap(vdev->pdev, bar, 0);
> > +		} else {
> > +			size_t size;
> > +			vdev->barmap[bar] = pci_map_rom(vdev->pdev, &size);
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +
> > +static void vfio_disable_pci(struct vfio_dev *vdev)
> > +{
> > +	int bar;
> > +
> > +	for (bar = PCI_STD_RESOURCES; bar <= PCI_ROM_RESOURCE; bar++) {
> > +		if (!vdev->barmap[bar])
> > +			continue;
> > +		if (bar != PCI_ROM_RESOURCE)
> > +			pci_iounmap(vdev->pdev, vdev->barmap[bar]);
> > +		else
> > +			pci_unmap_rom(vdev->pdev, vdev->barmap[bar]);
> > +		vdev->barmap[bar] = NULL;
> > +	}
> > +
> > +	pci_release_regions(vdev->pdev);
> > +	pci_disable_device(vdev->pdev);
> > +}
> > +
> >  static int vfio_open(struct inode *inode, struct file *filep)
> >  {
> >  	struct vfio_dev *vdev;
> > @@ -110,7 +157,7 @@ static int vfio_open(struct inode *inode, struct file *filep)
> >  	INIT_LIST_HEAD(&listener->dm_list);
> >  	filep->private_data = listener;
> >  	if (vdev->listeners == 0)
> > -		ret = pci_enable_device(vdev->pdev);
> > +		ret = vfio_setup_pci(vdev);
> >  	if (ret == 0)
> >  		vdev->listeners++;
> >  	mutex_unlock(&vdev->lgate);
> > @@ -151,7 +198,7 @@ static int vfio_release(struct inode *inode, struct file *filep)
> >  		vdev->vconfig = NULL;
> >  		kfree(vdev->pci_config_map);
> >  		vdev->pci_config_map = NULL;
> > -		pci_disable_device(vdev->pdev);
> > +		vfio_disable_pci(vdev);
> >  		vfio_domain_unset(vdev);
> >  		wake_up(&vdev->dev_idle_q);
> >  	}
> > diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
> > index 1fd50a6..7705b45 100644
> > --- a/drivers/vfio/vfio_rdwr.c
> > +++ b/drivers/vfio/vfio_rdwr.c
> > @@ -64,7 +64,7 @@ ssize_t vfio_io_readwrite(
> >  	if (pos + count > end)
> >  		return -EINVAL;
> >  	if (vdev->barmap[pci_space] == NULL)
> > -		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> > +		return -EINVAL;
> >  	io = vdev->barmap[pci_space];
> >  
> >  	while (count > 0) {
> > @@ -137,7 +137,12 @@ ssize_t vfio_mem_readwrite(
> >  		return -EINVAL;
> >  	end = pci_resource_len(pdev, pci_space);
> >  	if (vdev->barmap[pci_space] == NULL)
> > -		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> > +		return -EINVAL;
> > +	if (pci_space == PCI_ROM_RESOURCE) {
> > +		u32 rom = *(u32 *)(vdev->vconfig + PCI_ROM_ADDRESS);
> > +		if (!(rom & PCI_ROM_ADDRESS_ENABLE))
> > +			return -EINVAL;
> > +	}
> >  	io = vdev->barmap[pci_space];
> >  
> >  	if (pos > end)
> > 



