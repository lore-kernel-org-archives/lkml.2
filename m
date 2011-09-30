Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1I3XrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:47:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45570 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1I3XrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110930120652.GP2138@amd.com>
References: <016e01cc7f42$f92bfb40$eb83f1c0$%kim@samsung.com>
	<20110930120652.GP2138@amd.com>
Date: Sat, 1 Oct 2011 08:46:51 +0900
X-Google-Sender-Auth: tW3oIM7yNTGu0HOwAalR3wZ7c80
Message-ID: <CAHQjnONrPRynW5_C3+CqOAM095m+FK7P5jJMzN-ohwV_Y6jzGQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] iommu/exynos: Add iommu driver for Exynos4 Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 9:06 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> First comment: Pleas remove the 'inline' annotations in this patch. It
> is better to let the compiler decide what to inline and what not.
Ok. Thanks :)

>
> Hmm, may it make sense to store data directly in dev->arch.iommu? This
> will save you the list traversals to get the information.
>
That looks better.
However, adding features to dev_archdata of ARM is actively discussed
in Linaro-mm-sig and the features also include iommu_domain.

On the other hand,
I was not able to determine what will be accepted to the mainline kernel
between Linaro's one that is suggested by Marek and Ohad's one.

>> +
>> +static inline bool set_sysmmu_active(struct sysmmu_drvdata *data)
>> +{
>> +       /* return true if the System MMU was not active previously
>> +          and it needs to be initialized */
>> +
>> +       data->activations++;
>
> Is this variable only accessed under a lock? If not it should be an
> atomic.
>
All 'sysmmu' functions must be called under a lock because a System MMU
(Samsung's IOMMU) is a shared resource.
I the first patch, I declared the 'data->activations' as atomic_t but
Russell King pointed
that atomic operations on data->activations is not helpful for
preventing to become
a System MMU enabled when its data->activations is 0.

>> +       return data->activations == 1;
>
> Is that right? Shouldn't it be 'data->activations > 0'?
>
The value returned by set_sysmmu_active() means "The System MMU must be
initialized".
System MMU is initialized when its state is changed from
'inactive(disabled)' to active(enabled).
If data->activations++ becomes 2 or more, the System MMU is already enabled and
must not be initialized again.

>> +static inline void __set_fault_handler(struct sysmmu_drvdata *data,
>> +                       int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
>> +                                       unsigned long pgtable_base,
>> +                                       unsigned long fault_addr))
>
> Please typedef the function signature.
>
Ok. thanks.

>> +static int exynos_iommu_domain_init(struct iommu_domain *domain)
>> +{
>> +       struct exynos_iommu_domain *priv;
>> +
>> +       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +       if (!priv)
>> +               return -ENOMEM;
>> +
>> +       priv->pgtable = (unsigned long *)__get_free_pages(GFP_KERNEL,
>> +               (S5P_LV1TABLE_ENTRIES * sizeof(unsigned long)) >> PAGE_SHIFT);
>
> For __get_free_pages you can't just pass in the number of pages, you
> need the order. Please use get_order.
>
Oh! Thank you.
I didn't notice the problem.
It allocated too large memory so far.

>> +       if (!priv->pgtable) {
>> +               kfree(priv);
>> +               return -ENOMEM;
>> +       }
>> +
>> +       memset(priv->pgtable, 0, S5P_LV1TABLE_ENTRIES * sizeof(unsigned long));
>> +       pgtable_flush(priv->pgtable, priv->pgtable + S5P_LV1TABLE_ENTRIES);
>> +
>> +       spin_lock_init(&priv->lock);
>
> No init for the page-table lock?
>
Thank you. I forgot that.


>> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>> +{
>> +       struct exynos_iommu_domain *priv = domain->priv;
>> +
>> +       free_pages((unsigned long)priv->pgtable,
>> +               (S5P_LV1TABLE_ENTRIES * sizeof(unsigned long)) >> PAGE_SHIFT);
>
> Same here, please use get_order.
>
True. I will fix that immediately.

>> +static int __init exynos_iommu_init(void)
>> +{
>> +       l2table_cachep = kmem_cache_create("SysMMU Lv2 Tables",
>> +                               S5P_LV2TABLE_SIZE, S5P_LV2TABLE_SIZE, 0, NULL);
>
> Any reason you allocate a seperate slab-cache? It doesn't have a
> constructor so it would be merged into the kmalloc-slabs anyway (at
> least with SLUB).
>
I found that kmalloc(SZ_1K) returned an address that is not aligned by SZ_1K.
I did not understand why it happened and I changed it to the slab cache.
I will try it again with kmalloc().


Regards,
KyongHo
