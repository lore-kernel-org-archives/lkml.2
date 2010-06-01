Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0FAVaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:30:14 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15541 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab0FAVaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:30:12 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,342,1272844800"; 
   d="scan'208";a="538332997"
From: Tom Lyon <pugs@lyon-about.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Tue, 1 Jun 2010 14:26:53 -0700
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
References: <20100530124949.GI27611@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com>
In-Reply-To: <20100601104651.GA9415@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006011426.53563.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010 03:46:51 am Michael S. Tsirkin wrote:
> On Tue, Jun 01, 2010 at 01:28:48PM +0300, Avi Kivity wrote:
> > On 06/01/2010 12:55 PM, Michael S. Tsirkin wrote:
> >>
> >>>   It can't program the iommu.
> >>> What
> >>> the patch proposes is that userspace tells vfio about the needed
> >>> mappings, and vfio programs the iommu.
> >>>      
> >> There seems to be some misunderstanding.  The userspace interface
> >> proposed forces a separate domain per device and forces userspace to
> >> repeat iommu programming for each device.  We are better off sharing a
> >> domain between devices and programming the iommu once.
> >>    
> >
> >   iommufd = open(/dev/iommu);
> >   ioctl(iommufd, IOMMUFD_ASSIGN_RANGE, ...)
> >   ioctl(vfiofd, VFIO_SET_IOMMU, iommufd)
> >
> > ?
> 
> Yes.
> 
> > If so, I agree.
> 
> Good.

I'm not really opposed to multiple devices per domain, but let me point out how I
ended up here.  First, the driver has two ways of mapping pages, one based on the
iommu api and one based on the dma_map_sg api.  With the latter, the system
already allocates a domain per device and there's no way to control it. This was
presumably done to help isolation between drivers.  If there are multiple drivers
in the user level, do we not want the same isoation to apply to them?  
Also, domains are not a very scarce resource - my little core i5 has 256, 
and the intel architecture goes to 64K.
And then there's the fact that it is possible to have multiple disjoint iommus on a system,
so it may not even be possible to bring 2 devices under one domain. 

Given all that, I am inclined to leave it alone until someone has a real problem.
Note that not sharing iommu domains doesn't mean you can't share device memory,
just that you have to do multiple mappings
