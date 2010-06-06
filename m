Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0FFJ70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0FFJ7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:59:24 -0400
Date: Sun, 6 Jun 2010 12:54:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100606095450.GA26394@redhat.com>
References: <20100601095532.GA9178@redhat.com> <20100602174615.GV8301@sequoia.sous-sol.org> <4C074A64.1000009@redhat.com> <201006031441.38799.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006031441.38799.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:41:38PM -0700, Tom Lyon wrote:
> OK, in the interest of making progress, I am about to embark on the following:
> 
> 1. Create a user-iommu-domain driver - opening it will give a new empty domain.
>     Ultimately this can also populate sysfs with the state of its world, which would
>     also be a good addition to the base iommu stuff.
>     If someone closes the fd while in use, the domain stays valid anyway until users
>     drop off.
> 
> 2. Add DOMAIN_SET and DOMAIN_UNSET ioctls to the vfio driver.  Require that
>    a domain be set before using the VFIO_DMA_MAP_IOVA ioctl

Require domain to be set before you allow any access to the device:
mmap, write, read.  IMO this is the only safe way to make sure userspace
does not corrupt memory, and this removes the need to special-case
MSI memory, play with bus master enable and hope it can be cleared without
reset, etc.

> (this is the one
>    that KVM wants).

Not sure I understand. I think that MAP should be done on the domain,
not the device, this handles pinning pages correctly and
this way you don't need any special checks.

>    However, the VFIO_DMA_MAP_ANYWHERE ioctl is the one
>    which uses the dma_sg interface which has no expicit control of domains. I
>    intend to keep it the way it is, but expect only non-hypervisor programs would
>    want to use it.

If we support MAP_IOVA, why is MAP_ANYWHERE useful? Can't
non-hypervisors just pick an address?

> 3. Clean up the docs and other nits that folks have found.
> 
> Comments? 
