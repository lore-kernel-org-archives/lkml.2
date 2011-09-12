Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1ILLum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:50:42 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4117 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1ILLuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:50:40 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432Nzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 03/10] iommu/core: Add bus_type parameter to
 iommu_domain_alloc
Thread-Topic: [PATCH 03/10] iommu/core: Add bus_type parameter to
 iommu_domain_alloc
Thread-Index: AQHMbX1GXIZmVQ2Rz0Kd/JI/VJ+3jZVJpuKg
Date: Mon, 12 Sep 2011 11:50:35 +0000
Message-ID: <F1FD01C1EFCE15408DBF59462450B3BD1C463D@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1315410113-26608-4-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Joerg Roedel
> Sent: Wednesday, September 07, 2011 9:12 PM
> To: iommu@lists.linux-foundation.org
> Cc: Greg Kroah-Hartman; Alex Williamson; Ohad Ben-Cohen; David Woodhouse;
> David Brown; joro@8bytes.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Joerg Roedel
> Subject: [PATCH 03/10] iommu/core: Add bus_type parameter to
> iommu_domain_alloc
> 
> This is necessary to store a pointer to the bus-specific iommu_ops in the
> iommu-domain structure. It will be used later to call into bus-specific
> iommu-ops.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/iommu.c              |   14 +++++++++++++-
>  drivers/media/video/omap3isp/isp.c |    2 +-
>  include/linux/iommu.h              |    6 ++++--
>  virt/kvm/iommu.c                   |    2 +-
>  4 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c index
> 3b24a5b..adaee9b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -16,6 +16,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> USA
>   */
> 
> +#include <linux/device.h>
>  #include <linux/kernel.h>
>  #include <linux/bug.h>
>  #include <linux/types.h>
> @@ -44,15 +45,26 @@ bool iommu_found(void)  }
> EXPORT_SYMBOL_GPL(iommu_found);
> 
> -struct iommu_domain *iommu_domain_alloc(void)
> +struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
>  {
>  	struct iommu_domain *domain;
> +	struct iommu_ops *ops;
>  	int ret;
> 
> +	if (bus->iommu_ops)
> +		ops = bus->iommu_ops;
> +	else
> +		ops = iommu_ops;
> +
> +	if (ops == NULL)
> +		return NULL;
> +
>  	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
>  	if (!domain)
>  		return NULL;
> 
> +	domain->ops = ops;
> +
>  	ret = iommu_ops->domain_init(domain);
>  	if (ret)
>  		goto out_free;
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c
> index a4baa61..a7ed985 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -2141,7 +2141,7 @@ static int isp_probe(struct platform_device *pdev)
>  	/* to be removed once iommu migration is complete */
>  	isp->iommu = to_iommu(isp->iommu_dev);
> 
> -	isp->domain = iommu_domain_alloc();
> +	isp->domain = iommu_domain_alloc(pdev->dev.bus);
>  	if (!isp->domain) {
>  		dev_err(isp->dev, "can't alloc iommu domain\n");
>  		ret = -ENOMEM;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> 4739e36..3bd6892 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -25,10 +25,12 @@
>  #define IOMMU_WRITE	(2)
>  #define IOMMU_CACHE	(4) /* DMA cache coherency */
> 
> +struct iommu_ops;
>  struct bus_type;
>  struct device;
> 
>  struct iommu_domain {
> +	struct iommu_ops *ops;
>  	void *priv;
>  };
> 
> @@ -55,7 +57,7 @@ struct iommu_ops {
>  extern void register_iommu(struct iommu_ops *ops);  extern void
> iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);  extern bool
> iommu_found(void); -extern struct iommu_domain *iommu_domain_alloc(void);
> +extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
>  extern void iommu_domain_free(struct iommu_domain *domain);  extern int
> iommu_attach_device(struct iommu_domain *domain,
>  			       struct device *dev);
> @@ -79,7 +81,7 @@ static inline bool iommu_found(void)
>  	return false;
>  }
> 
> -static inline struct iommu_domain *iommu_domain_alloc(void)
> +static inline struct iommu_domain *iommu_domain_alloc(struct bus_type
> +*bus)
>  {
>  	return NULL;
>  }
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c index 78c80f6..20115b1
> 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -233,7 +233,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
>  		return -ENODEV;
>  	}
> 
> -	kvm->arch.iommu_domain = iommu_domain_alloc();
> +	kvm->arch.iommu_domain = iommu_domain_alloc(&pci_bus_type);

Although it might require changes starting all the way from the qemu interface, but
it would certainly be nice if this could be made more extendable/generic in terms
of the bus_type usage. This interface would be used by us (Freescale )for direct
assignment of SOC devices sitting on the platform bus.

-Varun

