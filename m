Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1LSG1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:27:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18271 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1LSG1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:27:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 18 Dec 2011 22:27:37 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "ohad@wizery.com" <ohad@wizery.com>, "tony@atomide.com" <tony@atomide.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 19 Dec 2011 07:27:28 +0100
Subject: Re: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART
 driver
Thread-Topic: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART
 driver
Thread-Index: Acy+F0ta8ogWjQZwTaCz2iVLxpOE0Q==
Message-ID: <20111219.082728.2074123164274991497.hdoyu@nvidia.com>
References: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com><1323954690-7000-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1323954690-7000-2-git-send-email-hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One question is inlined below:

From: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART driver
Date: Thu, 15 Dec 2011 14:11:29 +0100
Message-ID: <1323954690-7000-2-git-send-email-hdoyu@nvidia.com>

> Tegra 20 IOMMU H/W, GART (Graphics Address Relocation Table). This
> patch implements struct iommu_ops for GART for the upper IOMMU API.
>
> This H/W module supports only single virtual address space(domain),
> and manages a single level 1-to-1 mapping H/W translation page table.
>
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  drivers/iommu/Kconfig      |   11 +
>  drivers/iommu/Makefile     |    1 +
>  drivers/iommu/tegra-gart.c |  451 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 463 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iommu/tegra-gart.c
>
....
> +
> +struct gart_device {
> +       void __iomem            *regs;
> +       u32                     *savedata;
> +       u32                     page_count; /* total remappable size */
> +       dma_addr_t              iovmm_base; /* offset to apply to vmm_area */
> +       spinlock_t              pte_lock; /* for pagetable */
> +       struct list_head        client;
> +       spinlock_t              client_lock; /* for client list */
> +       struct device           *dev;
> +};
> +
> +static struct gart_device *gart_handle; /* unique for a system */
			      ^^^^^^^^^^^
.....
> +
> +static int gart_iommu_domain_init(struct iommu_domain *domain)
> +{
> +       domain->priv = gart_handle;
	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +       pr_debug("gart@%p\n", gart_handle);
> +       return 0;
> +}

In the above, the global pointer is used to pass gart_device to set it
in dmain->priv. It works with a single gart_device, but not with
multiple gart_devices. This is too bad, I know;). I guess that this
can be solved with device tree info where a client device is set as a
child of gart_device at device registration. Is this the right way
from IOMMU API POV?

 for (i = 0; i < ARRAY_SIZE(dmaapi_dummy_device); i++) {
	 int err;
	 struct platform_device *pdev = &dmaapi_dummy_device[i];

	 pdev->dev.platform_data = (void *)dummy_hwgrp_map[i];
	 pdev->dev.parent = &tegra_gart_device;
			    ^^^^^^^^^^^^^^^^^^^
	 err = platform_device_register(pdev);
