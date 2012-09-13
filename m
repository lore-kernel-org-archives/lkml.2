Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2IMCUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:20:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52667 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2IMCUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120912094648.GX13739@n2100.arm.linux.org.uk>
References: <1347434328-7207-1-git-send-email-wzch@marvell.com>
	<CAMQu2gwK+TP+7qQG0cET04y7+BYn--5UwkVuffOUu0kuv8Ps6A@mail.gmail.com>
	<20120912085445.GW13739@n2100.arm.linux.org.uk>
	<CAMQu2gx_Wk259F2PNY-T5H1N04i-JwseO5mPNw7xZ__tjonw1A@mail.gmail.com>
	<20120912094648.GX13739@n2100.arm.linux.org.uk>
Date: Thu, 13 Sep 2012 10:20:30 +0800
Message-ID: <CAG9bXv=UzR1iDJ_+6JAC5Ue2caZs7JvGOMjABidsbgRKNhxJrA@mail.gmail.com>
Subject: Re: [PATCH] ARM: suspend: use flush range instead of flush all
From: Raul Xiong <raulxiong@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Dave Martin <dave.martin@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        wzch <wzch@marvell.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/12 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Wed, Sep 12, 2012 at 02:40:45PM +0530, Shilimkar, Santosh wrote:
>> On Wed, Sep 12, 2012 at 2:24 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Wed, Sep 12, 2012 at 01:13:33PM +0530, Shilimkar, Santosh wrote:
>> >> On Wed, Sep 12, 2012 at 12:48 PM, wzch <wzch@marvell.com> wrote:
>> >> >  void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
>> >> >  {
>> >> > +       u32 *ptr_orig = ptr;
>> >> >         *save_ptr = virt_to_phys(ptr);
>> >> >
>> >> >         /* This must correspond to the LDM in cpu_resume() assembly */
>> >> > @@ -26,7 +27,8 @@ void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
>> >> >
>> >> >         cpu_do_suspend(ptr);
>> >> >
>> >> > -       flush_cache_all();
>> >> Lorenzo's patch was limiting above flush to local cache (LOUs) instead
>> >> of dropping it completely.
>> >
>> > Err, that is wrong.  Normally, when CPUs go into suspend, the L1 cache is
>> > lost entirely.  This is the only flush which many CPUs see of the L1
>> > cache.
>> >
>> > So removing this flush _will_ break suspend to RAM on existing CPUs.
>>
>> As mentioned, keeping that flush till inner shareability domain(L1) should be
>> enough. In fact if that part gets pushed down to the finisher() which any
>> way needs to take care of the cache maintenance, we can get rid of completely.
>
> It is difficult to call the cache maintenance functions from assembly.
> Why not have the generic code do the inner shareability flush, and then
> leave the responsibility for any further cache maintenance caused by the
> actions of the finisher to the finisher to deal with - as it is now.
>
> That way we end up with more generic code, and don't go back to the
> rediculous situation where we had everyone implementing this crap in
> their own broken way time and time again in their platform code.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Hi Russell/All,

I have several questions:
1. Even we call flush_calche_all in __cpu_suspend_save, since later we
will outer_clean_range which may cause cache operations so we still
need to flush again in finisher, right?
2. Not every platform the L1 will be lost, we have the option to keep
L1 retentive, right? Just consider single core CA9. So we may not need
to flush all every time.
3. Why it's difficult to call cache maintenance in assembly? Moreover,
not every finisher is assembly, right?
