Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2ILJ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:57:42 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:54006 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab2ILJ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:57:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120912094648.GX13739@n2100.arm.linux.org.uk>
References: <1347434328-7207-1-git-send-email-wzch@marvell.com>
 <CAMQu2gwK+TP+7qQG0cET04y7+BYn--5UwkVuffOUu0kuv8Ps6A@mail.gmail.com>
 <20120912085445.GW13739@n2100.arm.linux.org.uk> <CAMQu2gx_Wk259F2PNY-T5H1N04i-JwseO5mPNw7xZ__tjonw1A@mail.gmail.com>
 <20120912094648.GX13739@n2100.arm.linux.org.uk>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 12 Sep 2012 15:27:16 +0530
Message-ID: <CAMQu2gwN6XFfuuRnZgyaETx1qi6KSHVL+0gHHLgWL-s3kxJ4-Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: suspend: use flush range instead of flush all
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: wzch <wzch@marvell.com>, Dave Martin <dave.martin@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 3:16 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
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

Fully agree with you.
Leaving the local cache flush should be better choice and that
is the additional bit Lorenzo's patch(yet to be posted) is doing on top
of the $subject patch. If the platform has special need like secure
cache maintenance, they can take care of that additionally in the
finisher.

Regards
Santosh
