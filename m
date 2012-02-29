Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434Ab2B2FZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:25:53 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45573 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab2B2FZr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2UDXdDwfsynPEZ8rN9_Wbw4axYDWnMHEU5GoHPFJvZ_Rg@mail.gmail.com>
References: <001a01ccf5e3$74a0d360$5de27a20$%cho@samsung.com>
	<CAH9JG2UDXdDwfsynPEZ8rN9_Wbw4axYDWnMHEU5GoHPFJvZ_Rg@mail.gmail.com>
Date: Wed, 29 Feb 2012 14:25:45 +0900
X-Google-Sender-Auth: 418OjqC3LNMMW9vZ-C_c3ETmzZ8
Message-ID: <CAHQjnOOy__H8C0YAJq5TOD0Tv-18LRwaTosqp+pc9L8-Dq9TYw@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 4:53 PM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
>> +void exynos_sysmmu_set_prefbuf(struct device *owner,
>> +                             unsigned long base0, unsigned long size0,
>> +                             unsigned long base1, unsigned long size1)
>> +{
>> +     struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
>> +     unsigned long flags;
>> +     int i;
>> +
>> +     BUG_ON((base0 + (size0 - 1)) <= base0);
>> +     BUG_ON((base1 + (size1 - 1)) <= base1);
> Do you want to check size? BUG_ON(size <= 1);?

My mistake. :)
Thank you.

>> +
>> +     read_lock_irqsave(&data->lock, flags);
>> +     if (!is_sysmmu_active(data))
>> +             goto finish;
>> +
>> +     for (i = 0; i < data->nsfrs; i++) {
>> +             if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
>> +                     sysmmu_block(data->sfrbases[i]);
>> +
>> +                     if (size1 == 0) {
> Is it possible? if size1 is '0', it can't pass the BUG_ON condition.
Although the above BUG_ON condition is incorrect, it can pass if size1
and base1 are 0
because the type of them is unsigned.

>> +
>> +     for (i = 0; i < data->nsfrs; i++) {
>> +             __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
>> +
>> +             if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
>> +                     /* System MMU version is 3.x */
>> +                     __raw_writel((1 << 12) | (2 << 28),
> Can you use the DEFINE instead of hard-code?

Do you think it is required even though it is used nowhere else here?

>> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
>> +                                struct device *dev)
>> +{
>> +     int ret;
>> +     struct exynos_iommu_domain *priv = domain->priv;
>> +     struct iommu_client *client = NULL;
>> +     struct list_head *pos;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&priv->lock, flags);
>> +
>> +     list_for_each(pos, &priv->clients) {
> Simply list_for_each_entry.

Variable 'client' must not be used as a loop cursor
because its value must not be changed unless a condition meets.

>> +             struct iommu_client *cur;
>> +
>> +             cur = list_entry(pos, struct iommu_client, node);
>> +             if (cur->dev == dev) {
>> +                     client = cur;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (client != NULL) {
>> +             dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
>> +                                     __func__, __pa(priv->pgtable));
>> +             client->refcnt++;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&priv->lock, flags);
>> +
>> +     if (client != NULL)
>> +             return 0;
>> +
>> +     client = kmalloc(sizeof(*client), GFP_KERNEL);
> Maybe attach called frequently. how about to use kmem_cache-*?
Thank you for advice.

>> +     if (!client)
>> +             return -ENOMEM;
>> +
>> +     INIT_LIST_HEAD(&client->node);
>> +     client->dev = dev;
>> +     client->refcnt = 1;
> Dose it possible attach more than one? OMAP has multiple attach codes.
Yes. This function returns earlier than this if client->refcnt is larger than 1.
Please check "if (client != NULL) return 0;" statement in this function.

>> +     ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
>> +     if (ret) {
>> +             kfree(client);
>> +             return ret;
>> +     }
>> +
>> +     spin_lock_irqsave(&priv->lock, flags);
>> +     list_add_tail(&client->node, &priv->clients);
>> +     spin_unlock_irqrestore(&priv->lock, flags);
>> +
>> +     dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n", __func__,
>> +                                             __pa(priv->pgtable));
>> +     return 0;
>> +}
>> +
>> +static void exynos_iommu_detach_device(struct iommu_domain *domain,
>> +                                 struct device *dev)
>> +{
>> +     struct exynos_iommu_domain *priv = domain->priv;
>> +     struct iommu_client *client = NULL;
>> +     struct list_head *pos;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&priv->lock, flags);
>> +
>> +     list_for_each(pos, &priv->clients) {
>> +             struct iommu_client *cur;
>> +
>> +             cur = list_entry(pos, struct iommu_client, node);
>> +             if (cur->dev == dev) {
>> +                     cur->refcnt--;
>> +                     client = cur;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     spin_unlock_irqrestore(&priv->lock, flags);
>> +
>> +     if (WARN_ON(client == NULL))
>> +             return;
>> +
>> +     if (client->refcnt > 0) {
> It never triggered. as you use true/false scheme. I remember you said
> previous patch. use the refcount but actual meaning is true/false.

I think you are talking about the conversations about v6 patchset.
client->refcnt is really a reference counter.

>> +             dev_dbg(dev, "%s: Detaching IOMMU with pgtable 0x%lx delayed\n",
>> +                                     __func__, __pa(priv->pgtable));
>> +             return;
>> +     }
>> +
>> +     BUG_ON(client->refcnt != 0);
> Do you think "minus value"?

Yes. but I think it never be happened logically.
It is just "assert(client->refcnt == 0)".
May it is better to remove the BUG_ON.


Thank you for kind review.

Cho KyongHo.
