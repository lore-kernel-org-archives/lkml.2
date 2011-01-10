Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1AJLTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab1AJLTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:19:47 -0500
Date: Mon, 10 Jan 2011 13:18:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Milton Miller <miltonm@bga.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: remove virtio-pci root device
Message-ID: <20110110111859.GC2202@redhat.com>
References: <20110105191711.GA27489@redhat.com>
 <virtio-pci-whynotsimplify@mdm.bga.com>
 <virtio-pci-noroot@mdm.bga.com>
 <20110109151821.GA9063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109151821.GA9063@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 05:18:21PM +0200, Michael S. Tsirkin wrote:
> On Fri, Jan 07, 2011 at 02:55:06AM -0600, Milton Miller wrote:
> > We sometimes need to map between the virtio device and
> > the given pci device. One such use is OS installer that
> > gets the boot pci device from BIOS and needs to
> > find the relevant block device. Since it can't,
> > installation fails.
> > 
> > Instead of creating a top-level devices/virtio-pci
> > directory, create each device under the corresponding
> > pci device node.  Symlinks to all virtio-pci
> > devices can be found under the pci driver link in
> > bus/pci/drivers/virtio-pci/devices, and all virtio
> > devices under drivers/bus/virtio/devices.
> > 
> > Signed-off-by: Milton Miller <miltonm@bga.com>
> 
> OK, this works fine for me.  I played with options to add compat
> softlinks under devices/virtio-pci but we still don't get exactly the
> same layout and since I don't think anyone actually uses them, it's
> probably ok to just to the simple thing.
> 
> Tested/Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Rusty, since this help fix at least one user, any chance this can be put
> in 2.6.38? OK to backport to -stable?
> 
> Gleb, could you try this out too?
> 
With this patch if I have 3 virtio disks for a VM I get:
/sys/devices/pci0000:00/0000:00:04.0/virtio0/block/vda
/sys/devices/pci0000:00/0000:00:05.0/virtio1/block/vdb
/sys/devices/pci0000:00/0000:00:06.0/virtio2/block/vdc

Number after virtio has no much sense. It either should be dropped at all
or be always zero in case we will support more then one virtio controller
per pci card. In that case each virtio controller will have directories
virtio0/virtio1/virtio2... under same pci device directory.


> > ---
> > 
> > This is an alternative to the patch by Michael S. Tsirkin
> > titled "virtio-pci: add softlinks between virtio and pci"
> > https://patchwork.kernel.org/patch/454581/
> > 
> > It creates simpler code, uses less memory, and should
> > be even easier use by the installer as it won't have to
> > know a virtio symlink to follow (just follow none).
> > 
> > Compile tested only as I don't have kvm setup.
> > 
> > 
> > diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > index ef8d9d5..4fb5b2b 100644
> > --- a/drivers/virtio/virtio_pci.c
> > +++ b/drivers/virtio/virtio_pci.c
> > @@ -96,11 +96,6 @@ static struct pci_device_id virtio_pci_id_table[] = {
> >  
> >  MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
> >  
> > -/* A PCI device has it's own struct device and so does a virtio device so
> > - * we create a place for the virtio devices to show up in sysfs.  I think it
> > - * would make more sense for virtio to not insist on having it's own device. */
> > -static struct device *virtio_pci_root;
> > -
> >  /* Convert a generic virtio device to our structure */
> >  static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
> >  {
> > @@ -629,7 +624,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
> >  	if (vp_dev == NULL)
> >  		return -ENOMEM;
> >  
> > -	vp_dev->vdev.dev.parent = virtio_pci_root;
> > +	vp_dev->vdev.dev.parent = &pci_dev->dev;
> >  	vp_dev->vdev.dev.release = virtio_pci_release_dev;
> >  	vp_dev->vdev.config = &virtio_pci_config_ops;
> >  	vp_dev->pci_dev = pci_dev;
> > @@ -717,17 +712,7 @@ static struct pci_driver virtio_pci_driver = {
> >  
> >  static int __init virtio_pci_init(void)
> >  {
> > -	int err;
> > -
> > -	virtio_pci_root = root_device_register("virtio-pci");
> > -	if (IS_ERR(virtio_pci_root))
> > -		return PTR_ERR(virtio_pci_root);
> > -
> > -	err = pci_register_driver(&virtio_pci_driver);
> > -	if (err)
> > -		root_device_unregister(virtio_pci_root);
> > -
> > -	return err;
> > +	return pci_register_driver(&virtio_pci_driver);
> >  }
> >  
> >  module_init(virtio_pci_init);
> > @@ -735,7 +720,6 @@ module_init(virtio_pci_init);
> >  static void __exit virtio_pci_exit(void)
> >  {
> >  	pci_unregister_driver(&virtio_pci_driver);
> > -	root_device_unregister(virtio_pci_root);
> >  }
> >  
> >  module_exit(virtio_pci_exit);

--
			Gleb.
