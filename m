Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab1JNORe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:17:34 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:33111
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab1JNORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:17:32 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT27P0-01-3D6-02
X-M-MSG: 
Date: Fri, 14 Oct 2011 16:17:14 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: KyongHo Cho <pullip.cho@samsung.com>
CC: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH v5 2/2] iommu/exynos: Add iommu driver for Exynos
 Platforms
Message-ID: <20111014141714.GD2198@amd.com>
References: <000501cc897f$fa0204f0$ee060ed0$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000501cc897f$fa0204f0$ee060ed0$%cho@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:13:23AM -0400, KyongHo Cho wrote:
> +struct exynos_iommu_domain {
> +       struct device *dev;
> +       unsigned long *pgtable;
> +       spinlock_t lock;
> +       spinlock_t pgtablelock;
> +};

Can you please add comments to document what these spinlocks protect?

> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
> +                                  struct device *dev)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       int ret;
> +
> +       spin_lock(&priv->lock);
> +
> +       priv->dev = dev;
> +
> +       spin_unlock(&priv->lock);
> +
> +       ret = exynos_iommu_enable(domain);
> +
> +       return ret;
> +}
> +
> +static void exynos_iommu_detach_device(struct iommu_domain *domain,
> +                                   struct device *dev)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +
> +       spin_lock(&priv->lock);
> +
> +       if (priv->dev == dev) {
> +               priv->dev = NULL;
> +
> +               spin_unlock(&priv->lock);
> +
> +               exynos_iommu_disable(domain);
> +       } else {
> +               spin_unlock(&priv->lock);
> +       }
> +}

That looks weird. As I read this code there is a 1-1 mapping between a
device and a domain. This breaks semantics of the iommu-api where a
domain can contain multiple devices.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

