Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0FMK2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 06:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0FMK2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 06:28:42 -0400
Date: Sun, 13 Jun 2010 13:23:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100613102339.GB4191@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <201006081654.43967.pugs@lyon-about.com> <20100609054557.GB4940@redhat.com> <201006111515.53562.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006111515.53562.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 03:15:53PM -0700, Tom Lyon wrote:
> [ bunch of stuff about MSI-X checking and IOMMUs and config registers...]
> 
> OK, here's the thing.  The IOMMU API today does not do squat about
> dealing with interrupts. Interrupts are special because the APIC
> addresses are not each in their own page.  Yes, the IOMMU hardware
> supports it (at least Intel), and there's some Intel intr remapping
> code (not AMD), but it doesn't look like it is enough.

The iommu book from AMD seems to say that interrupt remapping table
address is taken from the device table entry.  So hardware support seems
to be there, and to me it looks like it should be enough.
Need to look at the iommu/msi code some more to figure out
whether what linux does is handling this correctly -
if it doesn't we need to fix that.

> Therefore, we must not allow the user level driver to diddle the MSI
> or MSI-X areas - either in config space or in the device memory space.

It won't help.
Consider that you want to let a userspace driver control
the device with DMA capabilities.

So if there is a range of addresses that device
can write into that can break host, these writes
can be triggered by userspace. Limiting
userspace access to MSI registers won't help:
you need a way to protect host from the device.

>  If the device doesn't have its MSI-X registers in nice page aligned
>  areas, then it is not "well-behaved" and it is S.O.L. The SR-IOV spec
>  recommends that devices be designed the well-behaved way.
> 
> When the code in vfio_pci_config speaks of "virtualization" it means
> that there are fake registers which the user driver can read or write,
> but do not affect the real registers. BARs are one case, MSI regs
> another. The PCI vendor and device ID are virtual because SR-IOV
> doesn't supply them but I wanted the user driver to find them in the
> same old place.

Sorry, I still don't understand why do we bother.  All this is already
implemented in userspace.  Why can't we just use this existing userspace
implementation?  It seems that all kernel needs to do is prevent
userspace from writing BARs.

Why can't we replace all this complexity with basically:

if (addr <= PCI_BASE_ADDRESS_5 && addr + len >= PCI_BASE_ADDRESS_0)
	return -ENOPERM;

And maybe another register or two. Most registers should be fine.

> [ Re: Hotplug and Suspend/Resume]
> There are *plenty* of real drivers - brand new ones - which don't
> bother with these today.  Yeah, I can see adding them to the framework
> someday - but if there's no urgent need then it is way down the
> priority list.

Well, for kernel drivers everything mostly works out of the box, it is
handled by the PCI subsystem.  So some kind of framework will need to be
added for userspace drivers as well.  And I suspect this issue won't be
fixable later without breaking applications.

> Meanwhile, the other uses beckon.

Which other uses? I thought the whole point was fixing
what's broken with current kvm implementation.
So it seems to be we should not rush it ignoring existing issues such as
hotplug.

> And I never heard
> the Infiniband users complaining about not having these things.

I did.

-- 
MST
