Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695Ab2EXVjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965637Ab2EXVjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:39:07 -0400
Message-ID: <4FBEAA5C.4060105@redhat.com>
Date: Thu, 24 May 2012 17:38:36 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Subject: Re: [PATCH v2 09/13] vfio: x86 IOMMU implementation
References: <20120522043607.5871.11340.stgit@bling.home> <20120522050536.5871.65171.stgit@bling.home>
In-Reply-To: <20120522050536.5871.65171.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:05 AM, Alex Williamson wrote:
> x86 is probably the wrong name for this VFIO IOMMU driver, but x86
> is the primary target for it.  This driver support a very simple
> usage model using the existing IOMMU API.  The IOMMU is expected to
> support the full host address space with no special IOVA windows,
> number of mappings restrictions, or unique processor target options.
>
> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> ---
>
>   Documentation/ioctl/ioctl-number.txt |    2
>   drivers/vfio/Kconfig                 |    6
>   drivers/vfio/Makefile                |    2
>   drivers/vfio/vfio.c                  |    7
>   drivers/vfio/vfio_iommu_x86.c        |  743 ++++++++++++++++++++++++++++++++++
>   include/linux/vfio.h                 |   52 ++
>   6 files changed, 811 insertions(+), 1 deletions(-)
>   create mode 100644 drivers/vfio/vfio_iommu_x86.c
>
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 111e30a..9d1694e 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -88,7 +88,7 @@ Code  Seq#(hex)	Include File		Comments
>   		and kernel/power/user.c
>   '8'	all				SNP8023 advanced NIC card
>   					<mailto:mcr@solidum.com>
> -';'	64-6F	linux/vfio.h
> +';'	64-72	linux/vfio.h
>   '@'	00-0F	linux/radeonfb.h	conflict!
>   '@'	00-0F	drivers/video/aty/aty128fb.c	conflict!
>   'A'	00-1F	linux/apm_bios.h	conflict!
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 9acb1e7..bd88a30 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -1,6 +1,12 @@
> +config VFIO_IOMMU_X86
> +	tristate
> +	depends on VFIO&&  X86
> +	default n
> +
>   menuconfig VFIO
>   	tristate "VFIO Non-Privileged userspace driver framework"
>   	depends on IOMMU_API
> +	select VFIO_IOMMU_X86 if X86
>   	help
>   	  VFIO provides a framework for secure userspace device drivers.
>   	  See Documentation/vfio.txt for more details.

So a future refactoring that uses some chunk of this support
on a non-x86 machine could be a lot of useless renaming.

Why not rename vfio_iommu_x86 to something like vfio_iommu_no_iova
and just make it conditionally compiled on X86 (as you've done above in Kconfig's)?
Then if another arch can use it, or refactors the file to use
some of it, and split x86 vs <other-arch> into separate per-arch files,
or per-iova schemes, it's more descriptive and less disruptive?

> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 7500a67..1f1abee 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1 +1,3 @@
>   obj-$(CONFIG_VFIO) += vfio.o
> +obj-$(CONFIG_VFIO_IOMMU_X86) += vfio_iommu_x86.o
> +obj-$(CONFIG_VFIO_PCI) += pci/
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 6558eef..89899a8 100644
