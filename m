Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab2CMIuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:50:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48807 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab2CMIuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120312150156.GF18973@amd.com>
References: <017a01ccfdee$4e5e7a00$eb1b6e00$%cho@samsung.com>
	<20120312150156.GF18973@amd.com>
Date: Tue, 13 Mar 2012 17:50:16 +0900
X-Google-Sender-Auth: MvH9SwJAKQXB4vrCi-RQZOw8pz0
Message-ID: <CAHQjnOOCQb4G1aeFB0FQVBstXpaXmahnQO8+FoinPcQNZEieGg@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:01 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> On Fri, Mar 09, 2012 at 09:15:24PM +0900, Cho KyongHo wrote:
>> +/* We does not consider super section mapping (16MB) */
>> +struct iommu_client {
>> +     struct list_head node;
>> +     struct device *dev;
>> +};
>> +
>> +struct exynos_iommu_domain {
>> +     struct list_head clients; /* list of iommu_client */
>> +     unsigned long *pgtable; /* lv1 page table, 16KB */
>> +     short *lv2entcnt; /* free lv2 entry counter for each section */
>> +     spinlock_t lock; /* lock for this structure and attached iommu_client */
>> +     spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
>> +};
>> +
>> +struct sysmmu_drvdata {
>> +     struct device *sysmmu;
>> +     char *dbgname;
>> +     int nsfrs;
>> +     void __iomem **sfrbases;
>> +     struct clk *clk[2];
>> +     int activations;
>> +     rwlock_t lock;
>> +     struct iommu_domain *domain;
>> +     sysmmu_fault_handler_t fault_handler;
>> +     unsigned long pgtable;
>> +     struct iommu_client client;
>> +};
>
> Is there any reason why 'struct iommu_client' is a seperate data
> structure? Otherwise it can be merged with 'truct sysmmu_drvdata'.
>

There is no reason to separate it.
It is not cleanly refactored since patch version 10.

>> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>> +{
>> +     struct exynos_iommu_domain *priv = domain->priv;
>> +     struct list_head *pos, *n;
>> +     unsigned long flags;
>> +     int i;
>> +
>> +     WARN_ON(!list_empty(&priv->clients));
>> +
>> +     spin_lock_irqsave(&priv->lock, flags);
>> +
>> +     list_for_each_safe(pos, n, &priv->clients) {
>> +             struct iommu_client *client;
>> +
>> +             client = list_entry(pos, struct iommu_client, node);
>> +             exynos_sysmmu_disable(client->dev);
>> +             kfree(client);
>> +     }
>
> Why this kfree here? Aren't all iommu_clients just a part of another
> data-structre?

It is absolutely my fault. It must be removed.
I have forgot to care about updating iommu_domain_destroy()
when modifying exynos_iommu_attach/detach_device().

Thank you.

The problems will be soon fixed and I will post next patch tomorrow.

Cho KyongHo/
