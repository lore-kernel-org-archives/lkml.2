Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0FBFDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:03:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12277 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0FBFDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:03:01 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,344,1272844800"; 
   d="scan'208";a="538483772"
From: Tom Lyon <pugs@lyon-about.com>
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Tue, 1 Jun 2010 21:59:40 -0700
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
References: <20100530121944.GH27611@redhat.com> <4C04E0E0.3070006@redhat.com> <1275452987.16980.24.camel@x201>
In-Reply-To: <1275452987.16980.24.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006012159.41344.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010 09:29:47 pm Alex Williamson wrote:
> On Tue, 2010-06-01 at 13:28 +0300, Avi Kivity wrote:
> > On 06/01/2010 12:55 PM, Michael S. Tsirkin wrote:
> > >
> > >>   It can't program the iommu.
> > >> What
> > >> the patch proposes is that userspace tells vfio about the needed
> > >> mappings, and vfio programs the iommu.
> > >>      
> > > There seems to be some misunderstanding.  The userspace interface
> > > proposed forces a separate domain per device and forces userspace to
> > > repeat iommu programming for each device.  We are better off sharing a
> > > domain between devices and programming the iommu once.
> > >    
> > 
> >    iommufd = open(/dev/iommu);
> >    ioctl(iommufd, IOMMUFD_ASSIGN_RANGE, ...)
> >    ioctl(vfiofd, VFIO_SET_IOMMU, iommufd)
> 
> It seems part of the annoyance of the current KVM device assignment is
> that we have multiple files open, we mmap here, read there, write over
> there, maybe, if it's not emulated.  I quite like Tom's approach that we
> have one stop shopping with /dev/vfio<n>, including config space
> emulation so each driver doesn't have to try to write their own.  So
> continuing with that, shouldn't we be able to add a GET_IOMMU/SET_IOMMU
> ioctl to vfio so that after we setup one device we can bind the next to
> the same domain?

This is just what I was thinking.  But rather than a get/set, just use two fds.

	ioctl(vfio_fd1, VFIO_SET_DOMAIN, vfio_fd2);

This may fail if there are really 2 different IOMMUs, so user code must be
prepared for failure,  In addition, this is strictlyupwards compatible with 
what is there now, so maybe we can add it later.


