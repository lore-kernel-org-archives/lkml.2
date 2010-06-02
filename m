Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0FBKTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:19:43 -0400
Received: from 8bytes.org ([88.198.83.132]:58973 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab0FBKTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:19:42 -0400
Date: Wed, 2 Jun 2010 12:19:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602101940.GG964@8bytes.org>
References: <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602095312.GA25335@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 12:53:12PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 11:42:01AM +0200, Joerg Roedel wrote:

> > IMO a seperate iommu-userspace driver is a nightmare for a userspace
> > interface. It is just too complicated to use.
> 
> One advantage would be that we can reuse the uio framework
> for the devices themselves. So an existing app can just program
> an iommu for DMA and keep using uio for interrupts and access.

The driver is called UIO and not U-INTR-MMIO ;-) So I think handling
IOMMU mappings belongs there.

> > We can solve the problem
> > of multiple devices-per-domain with an ioctl which allows binding one
> > uio-device to the address-space on another.
> 
> This would imply switching an iommu domain for a device while
> it could potentially be doing DMA. No idea whether this can be done
> in a safe manner.

It can. The worst thing that can happen is an io-page-fault.

> Forcing iommu assignment to be done as a first step seems much saner.

If we force it, there is no reason why not doing it implicitly.

We can do something like this then:

dev1 = open();
ioctl(dev1, IOMMU_MAP, ...); /* creates IOMMU domain and assigns dev1 to
			        it*/

dev2 = open();
ioctl(dev2, IOMMU_MAP, ...);

/* Now dev1 and dev2 are in seperate domains */

ioctl(dev2, IOMMU_SHARE, dev1); /* destroys all mapping for dev2 and
				   assigns it to the same domain as
				   dev1. Domain has a refcount of two
				   now */

close(dev1); /* domain refcount goes down to one */
close(dev2); /* domain refcount is zero and domain gets destroyed */


	Joerg

