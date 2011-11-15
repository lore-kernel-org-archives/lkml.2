Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1KOH0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:26:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39479 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1KOH0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2U1L1st_D+jp0Qm42HR8Ur7JpdYz6gFJSv+z_ZkGAQv8A@mail.gmail.com>
References: <1321333132-17662-1-git-send-email-pullip.cho@samsung.com>
	<1321333132-17662-3-git-send-email-pullip.cho@samsung.com>
	<CAH9JG2U1L1st_D+jp0Qm42HR8Ur7JpdYz6gFJSv+z_ZkGAQv8A@mail.gmail.com>
Date: Tue, 15 Nov 2011 16:26:43 +0900
X-Google-Sender-Auth: I49F7yklGTBWxScYdrImr6mgFms
Message-ID: <CAHQjnOPMxtQFn1LMsXg7JKeW-iGe87jTN_kA+6BK9MGeF=0qDw@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 3:05 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> +static bool set_sysmmu_active(struct sysmmu_drvdata *data)
>> +{
>> +     /* return true if the System MMU was not active previously
>> +        and it needs to be initialized */
>> +     data->activations++;
>> +     return data->activations == 1;
>> +}
> If it calls the twice, then caller get the active failed return value.
> Are there no case to call the multiple activation?

Return value of set_sysmmu_active() does not mean that activation is successful
but that System MMU H/W is needed to be initialized.

System MMU driver only initializes System MMU H/W when data->activation
becomes 1 from 0 and deinitializes when it becomes 0 from 1.

>> +void exynos_sysmmu_set_tablebase_pgd(struct device *owner, unsigned long
>> pgd)
>> +{
>> +     struct sysmmu_drvdata *data = NULL;
>> +
>> +     while ((data = get_sysmmu_data(owner, data))) {
>> +             unsigned long flags;
>> +
>> +             read_lock_irqsave(&data->lock, flags);
> It should be 'write_lock_irqsave'

data->lock just protects contents of 'data' from race condition.
It does not care about control registers of System MMU.
Since no contents in 'data' is modified in this function,
I think read_lock is more proper.

However, suddenly, I think exynos_sysmmu_set_tablebase_pgd()
must be removed because it modifies page table base
that is already set with exynos_sysmmu_enable().

>> +
>> +             if (is_sysmmu_active(data)) {
>> +                     sysmmu_block(data->sfrbase);
>> +                     __sysmmu_set_ptbase(data->sfrbase, pgd);
>> +                     sysmmu_unblock(data->sfrbase);
>> +                     dev_dbg(data->dev, "New page table base is %p\n",
>> +                                                             (void *)pgd);
>> +             } else {
>> +                     dev_dbg(data->dev,
>> +                     "Disabled: Skipping setting page table base.\n");
>> +             }
>> +
>> +             read_unlock_irqrestore(&data->lock, flags);
> It should be 'write_unlock_irqrestore'

Ditto.

>> +void exynos_sysmmu_tlb_invalidate(struct device *owner)
>> +{
>> +     struct sysmmu_drvdata *data = NULL;
>> +
>> +     while ((data = get_sysmmu_data(owner, data))) {
>> +             unsigned long flags;
>> +
>> +             read_lock_irqsave(&data->lock, flags);
> doesn't use the write_lock_irqsave here?

Ditto.

>> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>> +{
>> +     struct exynos_iommu_domain *priv = domain->priv;
>> +     struct list_head *pos, *n;
>> +
>> +     WARN_ON(!list_empty(&priv->clients));
>> +
>> +     spin_lock(&priv->lock);
>> +
>> +     list_for_each_safe(pos, n, &priv->clients) {
>> +             struct iommu_client *client;
>> +
>> +             client = list_entry(pos, struct iommu_client, node);
>> +             exynos_sysmmu_disable(client->dev);
> I think It occurs sleeping lock error message since it calls the
> write_lock within spin_lock.

Sorry, I don't understand why it makes problem.

I also tested it with various devices.
It is also not a condition of neither deadlock nor livelock.

Thank you.

KyongHo.
