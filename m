Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2ILJUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:20:49 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54973 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab2ILJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120912085825.GA4111@e102568-lin.cambridge.arm.com>
References: <1347434328-7207-1-git-send-email-wzch@marvell.com>
 <CAMQu2gwK+TP+7qQG0cET04y7+BYn--5UwkVuffOUu0kuv8Ps6A@mail.gmail.com> <20120912085825.GA4111@e102568-lin.cambridge.arm.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 12 Sep 2012 14:50:25 +0530
Message-ID: <CAMQu2gyf1C0jWJKM5ESpZO4z6oV+g0MkLva6as=53ob3j4QBrA@mail.gmail.com>
Subject: Re: [PATCH] ARM: suspend: use flush range instead of flush all
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: wzch <wzch@marvell.com>, Russell King <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 2:28 PM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Wed, Sep 12, 2012 at 08:43:33AM +0100, Shilimkar, Santosh wrote:
>> + Lorenzo,
>>
>> On Wed, Sep 12, 2012 at 12:48 PM, wzch <wzch@marvell.com> wrote:
>> > From: Wenzeng Chen <wzch@marvell.com>
>> >
>> > In cpu suspend function __cpu_suspend_save(), we save cp15 registers,
>> > resume function, sp and suspend_pgd, then flush the data to DDR, but
>> > no need to flush all D cache, only need to flush range.
>> >
>> > Change-Id: I591a1fde929f3f987c69306b601843ed975d3e41
>> You should drop above.
>>
>> > Signed-off-by: Wenzeng Chen <wzch@marvell.com>
>> > ---
>> Lorenzo and myself discussed about the above expensive flush and he
>> is planning to post a similar patch but with small difference.
>>
>> >  arch/arm/kernel/suspend.c |    4 +++-
>> >  1 files changed, 3 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
>> > index 1794cc3..bb582d8 100644
>> > --- a/arch/arm/kernel/suspend.c
>> > +++ b/arch/arm/kernel/suspend.c
>> > @@ -17,6 +17,7 @@ extern void cpu_resume_mmu(void);
>> >   */
>> >  void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
>> >  {
>> > +       u32 *ptr_orig = ptr;
>> >         *save_ptr = virt_to_phys(ptr);
>> >
>> >         /* This must correspond to the LDM in cpu_resume() assembly */
>> > @@ -26,7 +27,8 @@ void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
>> >
>> >         cpu_do_suspend(ptr);
>> >
>> > -       flush_cache_all();
>> Lorenzo's patch was limiting above flush to local cache (LOUs) instead
>> of dropping
>> it completely.
>
> Because if we remove it completely we have to make sure that every given
> suspend finisher calls flush_cache_all(), hence from my viewpoint this
> patch is incomplete. Either we remove it, and add it to ALL suspend
> finisher (or just make sure it is there) or we leave it but it should use
> the new LoUIS API we are going to add.
>
Yep.

>>
>> > +       __cpuc_flush_dcache_area((void *)ptr_orig, ptrsz);
>> > +       __cpuc_flush_dcache_area((void *)save_ptr, sizeof(*save_ptr));
>> >         outer_clean_range(*save_ptr, *save_ptr + ptrsz);
>> >         outer_clean_range(virt_to_phys(save_ptr),
>> >                           virt_to_phys(save_ptr) + sizeof(*save_ptr));
>>
>> Just thinking bit more, even in case we drop the flush_cache_all()
>> completely, it should be safe since the suspend_finisher()  takes
>> care of the cache maintenance already.
>
> We already discussed this. Fine by me, but we have to make sure it is
> called on all suspend finishers in the mainline.
>
I agree. As mentioned in reply to Russell, am ok to limit this
flush to LoUIS to start with.

Regards
Santosh
