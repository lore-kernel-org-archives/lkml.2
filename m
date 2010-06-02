Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0FBJ5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0FBJ5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:57:37 -0400
Date: Wed, 2 Jun 2010 12:53:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602095312.GA25335@redhat.com>
References: <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602094201.GC964@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:42:01AM +0200, Joerg Roedel wrote:
> On Tue, Jun 01, 2010 at 12:55:32PM +0300, Michael S. Tsirkin wrote:
> 
> > There seems to be some misunderstanding.  The userspace interface
> > proposed forces a separate domain per device and forces userspace to
> > repeat iommu programming for each device.  We are better off sharing a
> > domain between devices and programming the iommu once.
> > 
> > The natural way to do this is to have an iommu driver for programming
> > iommu.
> 
> IMO a seperate iommu-userspace driver is a nightmare for a userspace
> interface. It is just too complicated to use.

One advantage would be that we can reuse the uio framework
for the devices themselves. So an existing app can just program
an iommu for DMA and keep using uio for interrupts and access.

> We can solve the problem
> of multiple devices-per-domain with an ioctl which allows binding one
> uio-device to the address-space on another.

This would imply switching an iommu domain for a device while
it could potentially be doing DMA. No idea whether this can be done
in a safe manner.
Forcing iommu assignment to be done as a first step seems much saner.


> Thats much simpler.
> 
> 	Joerg


So instead of
dev = open();
ioctl(dev, ASSIGN, iommu)
mmap

and if we for ioctl mmap will fail
we have

dev = open();
if (ndevices > 0)
	ioctl(devices[0], ASSIGN, dev)
mmap

And if we forget ioctl we get errors from device.
Seems more complicated to me.


There will also always exist the confusion: address space for
which device are we modifying? With a separate driver for iommu,
we can safely check that binding is done correctly.

-- 
MST
