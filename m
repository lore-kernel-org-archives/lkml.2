Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2CLPCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:02:13 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:14407
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116Ab2CLPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:02:10 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0S1R8-02-O85-02
X-M-MSG: 
Date: Mon, 12 Mar 2012 16:01:56 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Cho KyongHo <pullip.cho@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
Subject: Re: [PATCH v11 3/3] iommu/exynos: Add iommu driver for Exynos
 Platforms
Message-ID: <20120312150156.GF18973@amd.com>
References: <017a01ccfdee$4e5e7a00$eb1b6e00$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <017a01ccfdee$4e5e7a00$eb1b6e00$%cho@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 09:15:24PM +0900, Cho KyongHo wrote:
> +/* We does not consider super section mapping (16MB) */
> +struct iommu_client {
> +	struct list_head node;
> +	struct device *dev;
> +};
> +
> +struct exynos_iommu_domain {
> +	struct list_head clients; /* list of iommu_client */
> +	unsigned long *pgtable; /* lv1 page table, 16KB */
> +	short *lv2entcnt; /* free lv2 entry counter for each section */
> +	spinlock_t lock; /* lock for this structure and attached iommu_client */
> +	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
> +};
> +
> +struct sysmmu_drvdata {
> +	struct device *sysmmu;
> +	char *dbgname;
> +	int nsfrs;
> +	void __iomem **sfrbases;
> +	struct clk *clk[2];
> +	int activations;
> +	rwlock_t lock;
> +	struct iommu_domain *domain;
> +	sysmmu_fault_handler_t fault_handler;
> +	unsigned long pgtable;
> +	struct iommu_client client;
> +};

Is there any reason why 'struct iommu_client' is a seperate data
structure? Otherwise it can be merged with 'truct sysmmu_drvdata'.

> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct list_head *pos, *n;
> +	unsigned long flags;
> +	int i;
> +
> +	WARN_ON(!list_empty(&priv->clients));
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	list_for_each_safe(pos, n, &priv->clients) {
> +		struct iommu_client *client;
> +
> +		client = list_entry(pos, struct iommu_client, node);
> +		exynos_sysmmu_disable(client->dev);
> +		kfree(client);
> +	}

Why this kfree here? Aren't all iommu_clients just a part of another
data-structre?


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

