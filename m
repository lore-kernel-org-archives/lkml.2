Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2BHP2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:28:02 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37005
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab2BHP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:28:00 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R6d523hz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ2YYF-01-1JI-02
X-M-MSG: 
Date: Wed, 8 Feb 2012 16:27:48 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Gibson <david@gibson.dropbear.id.au>
CC: <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>, <aik@ozlabs.ru>,
        <benh@kernel.crashing.org>, <qemu-devel@nongnu.org>,
        <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Device isolation group infrastructure (v3)
Message-ID: <20120208152748.GD22598@amd.com>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
 <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:46:52PM +1100, David Gibson wrote:
> In order to safely drive a device with a userspace driver, or to pass
> it through to a guest system, we must first make sure that the device
> is isolated in such a way that it cannot interfere with other devices
> on the system.  This isolation is only available on some systems and
> will generally require an iommu, and might require other support in
> bridges or other system hardware.
> 
> Often, it's not possible to isolate every device from every other
> device in the system.  For example, certain PCI/PCIe bridge
> configurations mean that an iommu cannot reliably distinguish which
> device behind the bridge initiated a DMA transaction.  Similarly some
> buggy PCI multifunction devices initiate all DMAs as function 0, so
> the functions cannot be isolated from each other, even if the IOMMU
> normally allows this.
> 
> Therefore, the user, and code to allow userspace drivers or guest
> passthrough, needs a way to determine which devices can be isolated
> from which others.  This patch adds infrastructure to handle this by
> introducing the concept of a "device isolation group" - a group of
> devices which can, as a unit, be safely isolated from the rest of the
> system and therefore can be, as a unit, safely assigned to an
> unprivileged used or guest.  That is, the groups represent the minimum
> granularity with which devices may be assigned to untrusted
> components.
> 
> This code manages groups, but does not create them or allow use of
> grouped devices by a guest.  Creating groups would be done by iommu or
> bridge drivers, using the interface this patch provides.  It's
> expected that the groups will be used in future by the in-kernel iommu
> interface, and would also be used by VFIO or other subsystems to allow
> safe passthrough of devices to userspace or guests.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  drivers/base/Kconfig             |    3 +
>  drivers/base/Makefile            |    1 +
>  drivers/base/base.h              |    3 +
>  drivers/base/core.c              |    6 ++
>  drivers/base/device_isolation.c  |  184 ++++++++++++++++++++++++++++++++++++++
>  drivers/base/init.c              |    2 +
>  include/linux/device.h           |    5 +
>  include/linux/device_isolation.h |  100 +++++++++++++++++++++

Again, device grouping is done by the IOMMU drivers, so this all belongs
into the generic iommu-code rather than the driver core.

I think it makes sense to introduce a device->iommu pointer which
depends on CONFIG_IOMMU_API and put the group information into it.
This also has the benefit that we can consolidate all the
device->arch.iommu pointers into device->iommu as well.


>  8 files changed, 304 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/base/device_isolation.c
>  create mode 100644 include/linux/device_isolation.h
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 7be9f79..a52f2db 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -189,4 +189,7 @@ config DMA_SHARED_BUFFER
>  	  APIs extension; the file's descriptor can then be passed on to other
>  	  driver.
>  
> +config DEVICE_ISOLATION
> +	bool "Enable isolating devices for safe pass-through to guests or user space."
> +

No need for a config option. When IOMMU drivers are enabled we also want
the group code to be active.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

