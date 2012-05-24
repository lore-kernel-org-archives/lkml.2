Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2EXWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2EXWrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:47:19 -0400
Message-ID: <1337899615.4714.79.camel@ul30vt>
Subject: Re: [PATCH v2 09/13] vfio: x86 IOMMU implementation
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Thu, 24 May 2012 16:46:55 -0600
In-Reply-To: <4FBEAA5C.4060105@redhat.com>
References: <20120522043607.5871.11340.stgit@bling.home>
	 <20120522050536.5871.65171.stgit@bling.home> <4FBEAA5C.4060105@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:38 -0400, Don Dutile wrote:
> On 05/22/2012 01:05 AM, Alex Williamson wrote:
> > x86 is probably the wrong name for this VFIO IOMMU driver, but x86
> > is the primary target for it.  This driver support a very simple
> > usage model using the existing IOMMU API.  The IOMMU is expected to
> > support the full host address space with no special IOVA windows,
> > number of mappings restrictions, or unique processor target options.
> >
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >
> >   Documentation/ioctl/ioctl-number.txt |    2
> >   drivers/vfio/Kconfig                 |    6
> >   drivers/vfio/Makefile                |    2
> >   drivers/vfio/vfio.c                  |    7
> >   drivers/vfio/vfio_iommu_x86.c        |  743 ++++++++++++++++++++++++++++++++++
> >   include/linux/vfio.h                 |   52 ++
> >   6 files changed, 811 insertions(+), 1 deletions(-)
> >   create mode 100644 drivers/vfio/vfio_iommu_x86.c
> >
> > diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> > index 111e30a..9d1694e 100644
> > --- a/Documentation/ioctl/ioctl-number.txt
> > +++ b/Documentation/ioctl/ioctl-number.txt
> > @@ -88,7 +88,7 @@ Code  Seq#(hex)	Include File		Comments
> >   		and kernel/power/user.c
> >   '8'	all				SNP8023 advanced NIC card
> >   					<mailto:mcr@solidum.com>
> > -';'	64-6F	linux/vfio.h
> > +';'	64-72	linux/vfio.h
> >   '@'	00-0F	linux/radeonfb.h	conflict!
> >   '@'	00-0F	drivers/video/aty/aty128fb.c	conflict!
> >   'A'	00-1F	linux/apm_bios.h	conflict!
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 9acb1e7..bd88a30 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -1,6 +1,12 @@
> > +config VFIO_IOMMU_X86
> > +	tristate
> > +	depends on VFIO&&  X86
> > +	default n
> > +
> >   menuconfig VFIO
> >   	tristate "VFIO Non-Privileged userspace driver framework"
> >   	depends on IOMMU_API
> > +	select VFIO_IOMMU_X86 if X86
> >   	help
> >   	  VFIO provides a framework for secure userspace device drivers.
> >   	  See Documentation/vfio.txt for more details.
> 
> So a future refactoring that uses some chunk of this support
> on a non-x86 machine could be a lot of useless renaming.
> 
> Why not rename vfio_iommu_x86 to something like vfio_iommu_no_iova
> and just make it conditionally compiled on X86 (as you've done above in Kconfig's)?
> Then if another arch can use it, or refactors the file to use
> some of it, and split x86 vs <other-arch> into separate per-arch files,
> or per-iova schemes, it's more descriptive and less disruptive?

Yep, the problem is how to concisely describe what we expect to support
here.  This file supports IOMMU API based usage of an IOMMU with
effectively no DMA window or mapping constraints, optimized for static
mapping of an address space.  What's a good name for that?  Maybe I
should follow the example of others and just call it a Type 1 IOMMU
implementation so the marketing material looks better!  ;-P  That may
honestly be better than calling it x86.  Thoughts?  Thanks,

Alex

