Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1JOBzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 21:55:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1JOBzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 21:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111014141714.GD2198@amd.com>
References: <000501cc897f$fa0204f0$ee060ed0$%cho@samsung.com>
	<20111014141714.GD2198@amd.com>
Date: Sat, 15 Oct 2011 10:55:52 +0900
X-Google-Sender-Auth: c7H-cif0Y6qeX7Gw7SeXpj-IMWA
Message-ID: <CAHQjnOPsBr5sV=08CaO0bpvjVXA9y_rE5tumVuseRU-N6uHx-Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 11:17 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> On Thu, Oct 13, 2011 at 04:13:23AM -0400, KyongHo Cho wrote:
>> +struct exynos_iommu_domain {
>> +       struct device *dev;
>> +       unsigned long *pgtable;
>> +       spinlock_t lock;
>> +       spinlock_t pgtablelock;
>> +};
>
> Can you please add comments to document what these spinlocks protect?
>
'lock' protects race condition on the domain private data.
'pgtablelock' does it on the page table of the domain.
Since updating page table does not need to be synchronized with
domain private data, I defined those 2 locks seperately.

I will add this information in the source code as comments.

>> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
>> +                                  struct device *dev)
>> +{
>> +       struct exynos_iommu_domain *priv = domain->priv;
>> +       int ret;
>> +
>> +       spin_lock(&priv->lock);
>> +
>> +       priv->dev = dev;
>> +
>> +       spin_unlock(&priv->lock);
>> +
>> +       ret = exynos_iommu_enable(domain);
>> +
>> +       return ret;
>> +}
>> +
>> +static void exynos_iommu_detach_device(struct iommu_domain *domain,
>> +                                   struct device *dev)
>> +{
>> +       struct exynos_iommu_domain *priv = domain->priv;
>> +
>> +       spin_lock(&priv->lock);
>> +
>> +       if (priv->dev == dev) {
>> +               priv->dev = NULL;
>> +
>> +               spin_unlock(&priv->lock);
>> +
>> +               exynos_iommu_disable(domain);
>> +       } else {
>> +               spin_unlock(&priv->lock);
>> +       }
>> +}
>
> That looks weird. As I read this code there is a 1-1 mapping between a
> device and a domain. This breaks semantics of the iommu-api where a
> domain can contain multiple devices.

I agree.
I will implement it soon.


Thank you

KyongHo
