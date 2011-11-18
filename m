Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab1KRQco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:32:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab1KRQcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:32:42 -0500
Message-ID: <1321633956.26410.126.camel@bling.home>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 18 Nov 2011 09:32:36 -0700
In-Reply-To: <20111118152710.GA5098@amd.com>
References: <20111117170800.3125.84150.stgit@bling.home>
	 <20111118104651.GJ5627@amd.com> <1321628190.26410.63.camel@bling.home>
	 <20111118152710.GA5098@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:27 +0100, Joerg Roedel wrote:
> On Fri, Nov 18, 2011 at 07:56:30AM -0700, Alex Williamson wrote:
> > As you say, the interface is to tell userspace what devices the IOMMU
> > can safely distinguish between.  On x86, the IOMMU cannot distinguish
> > DMA to the interrupt region between devices without interrupt remapping.
> > Therefore, to only expose devices we can safely distinguish between, we
> > shouldn't expose any devices by default if we don't provide this
> > isolation.  The interrupt remapping capability of the IOMMU isn't
> > exposed to userspace, nor should userspace need to make the leap in
> > understanding how MSIs are generated on a specific platform and whether
> > interrupt remapping is required to provide isolation.
> 
> But the isolation domains are different. The iommu-group interface is
> about device isolation and interrupt remapping is about DMA address
> space isolation (MSI range vs. the rest). The iommu can still
> distinguish between devices when it can not distinguish between DMA and
> MSI interrupts.

I guess I fail to see the difference.  We group devices behind certain
bridges together because we can't distinguish DMA from those devices.
MSI presents an address window across all devices for which we
potentially can't distinguish between any of them.  If instead of MSI
the window was VGA and the IOMMU could differentiate all devices, so
long as they don't do DMA to 0xa0000-0xc0000, what would we do?  I think
we'd have to exclude such an IOMMU from providing grouping information.

> So what you want to do belongs to the VFIO driver or (as it is today)
> into the KVM device assignment code and not into the iommu-group
> interface.

The trouble is that interrupt remapping closing a hole in DMA isolation
is a platform issue.  Is vfio supposed to know that on architecture foo
we don't have such a hole and we don't need to look for interrupt
remapping.  Or maybe that platform bar solved it differently and we need
to instead check flag MSI_OK.  Current KVM doesn't care about this
because it only does device assignment on x86.

Another way to solve this might be to expose a more generic capability
for the IOMMU.  Instead of exposing "interrupt remapping support" it
could expose "full DMA isolation", then amd_iommu/intel-iommu could set
it based on interrupt remapping capability.  The trouble is that then we
expose grouping information for devices, but can't figure out the domain
capabilities until we actually create a domain and attach those devices,
which is kind of a crappy experience for a vfio user to find out they
don't actually get to use those device.

Instead, it seems like the device-group interface should only provide
grouping information for devices with full DMA isolation, and hide the
rest.  Then we know that if iommu_device_group() returns an error, we
can't safely use that device.  Thanks,

Alex

