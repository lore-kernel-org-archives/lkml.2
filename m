Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162721Ab2GLXQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162656Ab2GLXQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:16:28 -0400
Date: Fri, 13 Jul 2012 02:16:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Subject: Re: UIO: missing resource mapping
Message-ID: <20120712231632.GC9317@redhat.com>
References: <4FFE7C1F.7080702@gmx.net>
 <20120712194432.GA2592@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712194432.GA2592@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 09:44:33PM +0200, Hans J. Koch wrote:
> On Thu, Jul 12, 2012 at 09:26:23AM +0200, Andreas Schallenberg wrote:
> 
> [Added more people to Cc:]
> 
> > Hello,
> > 
> > I'm doing experiments with the Userspace IO driver (UIO_PCI_GENERIC)
> > and a set of PCIe cards. The kernel version is 3.4.4, CPU is a
> > Marvell MV78200 (ARMv5te). Example with an Intel ethernet card:
> > 
> > This makes /dev/uio0 appear
> > echo -n "8086 10d3" >/sys/bus/pci/drivers/uio_pci_generic/new_id
> > 
> > # lspci -v -k -s 0000:00:01.0
> > 00:01.0 Ethernet controller: Intel Corporation 82574L Gigabit
> > Network Connection
> >         Subsystem: Intel Corporation Gigabit CT Desktop Adapter
> >         Flags: bus master, fast devsel, latency 0, IRQ 36
> >         Memory at c00c0000 (32-bit, non-prefetchable) [size=128K]
> >         Memory at c0000000 (32-bit, non-prefetchable) [size=512K]
> >         I/O ports at f0800000 [size=32]
> >         Memory at c00e0000 (32-bit, non-prefetchable) [size=16K]
> >         [virtual] Expansion ROM at c0080000 [disabled] [size=256K]
> >         Capabilities: [c8] Power Management version 2
> >         Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
> >         Capabilities: [e0] Express Endpoint, MSI 00
> >         Capabilities: [a0] MSI-X: Enable- Count=5 Masked-
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-c4-f7-2f
> >         Kernel driver in use: uio_pci_generic
> > 
> > Suprisingly, there is no "maps" directory in /sys/class/uio/uio0
> > now. I made a small change to the UIO code:
> > 
> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > index a783d53..b639654 100644
> > --- a/drivers/uio/uio.c
> > +++ b/drivers/uio/uio.c
> > @@ -274,8 +274,10 @@ static int uio_dev_add_attributes(struct
> > uio_device *idev)
> > 
> >         for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
> >                 mem = &idev->info->mem[mi];
> > -               if (mem->size == 0)
> > -                       break;
> > +               if (mem->size == 0) {
> > +                       dev_err(idev->dev, "map %d has zero size\n", mi);
> > +                       continue; // was: break
> > +               }
> >                 if (!map_found) {
> >                         map_found = 1;
> >                         idev->map_dir = kobject_create_and_add("maps",
> > 
> > If I have this in the kernel and give the "echo" command as shown
> > above I get:
> > [   43.761723] uio uio0: map 0 has zero size
> > [   43.765760] uio uio0: map 1 has zero size
> > [   43.769787] uio uio0: map 2 has zero size
> > [   43.774298] uio uio0: map 3 has zero size
> > [   43.778333] uio uio0: map 4 has zero size
> > 
> > On the other hand, I can see the resources:
> > # cat /sys/class/uio/uio0/device/resource
> > 0x00000000c00c0000 0x00000000c00dffff 0x0000000000040200
> > 0x00000000c0000000 0x00000000c007ffff 0x0000000000040200
> > 0x00000000f0800000 0x00000000f080001f 0x0000000000040101
> > 0x00000000c00e0000 0x00000000c00e3fff 0x0000000000040200
> > ...more...
> > 
> > Looking further at the code, I cannot see where the mem fields are
> > being filled at all.
> > Which code is supposed to write the struct uio_mem?
> 
> In my opinion, the driver should. However, Michael's idea is to use
> /sys/bus/pci/devices/XXXXXresourceX for mapping purposes.
> 
> That is of course also possible, but obviously it leads to confusion.
> We already had a long thread about this:
> 
> http://www.spinics.net/lists/kvm/msg73837.html
> 
> Michael, can we change the driver to offer all available PCI BARs in the
> normal UIO way? I'm afraid otherwise we'll have the same discussion over
> and over again.
> 
> Thanks,
> Hans

My concern was people will ask for more and more stuff that pci
sysfs already has.
If we do add these is there a way to not duplicate code from pci?
Export pci_mmap_resource and use it? Or make the uio attributes
softlinks to pci sysfs somehow?
Alternatively we could just clarify this in the documentation
which is of course easier and gives us less code to maintain ...

-- 
MST
