Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2ILJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:49:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59155 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2ILJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:49:18 -0400
Date: Wed, 12 Sep 2012 10:46:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: wzch <wzch@marvell.com>, Dave Martin <dave.martin@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] ARM: suspend: use flush range instead of flush all
Message-ID: <20120912094648.GX13739@n2100.arm.linux.org.uk>
References: <1347434328-7207-1-git-send-email-wzch@marvell.com> <CAMQu2gwK+TP+7qQG0cET04y7+BYn--5UwkVuffOUu0kuv8Ps6A@mail.gmail.com> <20120912085445.GW13739@n2100.arm.linux.org.uk> <CAMQu2gx_Wk259F2PNY-T5H1N04i-JwseO5mPNw7xZ__tjonw1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMQu2gx_Wk259F2PNY-T5H1N04i-JwseO5mPNw7xZ__tjonw1A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:40:45PM +0530, Shilimkar, Santosh wrote:
> On Wed, Sep 12, 2012 at 2:24 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Sep 12, 2012 at 01:13:33PM +0530, Shilimkar, Santosh wrote:
> >> On Wed, Sep 12, 2012 at 12:48 PM, wzch <wzch@marvell.com> wrote:
> >> >  void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
> >> >  {
> >> > +       u32 *ptr_orig = ptr;
> >> >         *save_ptr = virt_to_phys(ptr);
> >> >
> >> >         /* This must correspond to the LDM in cpu_resume() assembly */
> >> > @@ -26,7 +27,8 @@ void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
> >> >
> >> >         cpu_do_suspend(ptr);
> >> >
> >> > -       flush_cache_all();
> >> Lorenzo's patch was limiting above flush to local cache (LOUs) instead
> >> of dropping it completely.
> >
> > Err, that is wrong.  Normally, when CPUs go into suspend, the L1 cache is
> > lost entirely.  This is the only flush which many CPUs see of the L1
> > cache.
> >
> > So removing this flush _will_ break suspend to RAM on existing CPUs.
> 
> As mentioned, keeping that flush till inner shareability domain(L1) should be
> enough. In fact if that part gets pushed down to the finisher() which any
> way needs to take care of the cache maintenance, we can get rid of completely.

It is difficult to call the cache maintenance functions from assembly.
Why not have the generic code do the inner shareability flush, and then
leave the responsibility for any further cache maintenance caused by the
actions of the finisher to the finisher to deal with - as it is now.

That way we end up with more generic code, and don't go back to the
rediculous situation where we had everyone implementing this crap in
their own broken way time and time again in their platform code.
