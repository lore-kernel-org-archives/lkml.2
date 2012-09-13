Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2IMIwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:52:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60169 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2IMIwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:52:25 -0400
Date: Thu, 13 Sep 2012 09:52:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Raul Xiong <raulxiong@gmail.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Dave Martin <dave.martin@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        wzch <wzch@marvell.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: suspend: use flush range instead of flush all
Message-ID: <20120913085206.GA13739@n2100.arm.linux.org.uk>
References: <1347434328-7207-1-git-send-email-wzch@marvell.com> <CAMQu2gwK+TP+7qQG0cET04y7+BYn--5UwkVuffOUu0kuv8Ps6A@mail.gmail.com> <20120912085445.GW13739@n2100.arm.linux.org.uk> <CAMQu2gx_Wk259F2PNY-T5H1N04i-JwseO5mPNw7xZ__tjonw1A@mail.gmail.com> <20120912094648.GX13739@n2100.arm.linux.org.uk> <CAG9bXv=UzR1iDJ_+6JAC5Ue2caZs7JvGOMjABidsbgRKNhxJrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG9bXv=UzR1iDJ_+6JAC5Ue2caZs7JvGOMjABidsbgRKNhxJrA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:20:30AM +0800, Raul Xiong wrote:
> I have several questions:
> 1. Even we call flush_calche_all in __cpu_suspend_save, since later we
> will outer_clean_range which may cause cache operations so we still
> need to flush again in finisher, right?

Why would it?  Any data which would be pulled back into the L1 cache
from that point is either going to be clean (in other words, a copy of
it exists elsewhere in the system) or it is going to be dirty (in
which case, it's been explicitly written to - and that's the stuff the
finisher needs to take care of.

We do not care abou the dirty data created by calling subsequent
functions as this is not used for resuming.

> 2. Not every platform the L1 will be lost, we have the option to keep
> L1 retentive, right? Just consider single core CA9. So we may not need
> to flush all every time.

That's where you start paying the price for having such a complex
architecture, and the need to have generic code to keep things simple.

Rather than thinking "we need to eliminate that flush and move it into
the finisher" start thinking "we need to communicate what parts of the
system are lost over suspend and get the suspend code to use that to
determine what it needs to do".

> 3. Why it's difficult to call cache maintenance in assembly? Moreover,
> not every finisher is assembly, right?

Have you tried to see whether a function called 'flush_cache_all'
actually exists in your System.map file?  It doesn't.  What you have
is a bunch of cache specific functions, one of which either gets aliased
to that name at build time, or that name gets aliased to a function
pointer (in a structure) to point at the relevant cache specific
function.  And there are platforms where hard-coding just one is not
correct.

What we have today is a massive improvement over what we had earlier on
where every platform was implementing all the suspend/resume stuff
themselves.  I'm not going back to the situation where we have that
again.
