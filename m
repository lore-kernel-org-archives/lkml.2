Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1LPLBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:01:42 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48914 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab1LPLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:01:36 -0500
Date: Fri, 16 Dec 2011 11:01:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
Message-ID: <20111216110100.GA6342@arm.com>
References: <4EEAB90D.3050504@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEAB90D.3050504@am.sony.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Fri, Dec 16, 2011 at 03:20:45AM +0000, Frank Rowand wrote:
> ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
> (application specific ID). The number of ASIDs is limited to 256 and
> the allocation algorithm requires IPIs when all the ASIDs have been
> used.  The IPIs require interrupts enabled during context switch for
> deadlock avoidance.
> 
> The RT patch mm-protect-activate-switch-mm.patch disables irqs around
> activate_mm() and switch_mm(), which are the portion of the ARMv6
> context switch that require interrupts enabled.
> 
> The solution for the ARMv6 processors could be to _not_ disable irqs.
> A more conservative solution is to provide the same environment that
> the scheduler provides, that is preempt_disable().  This is more
> resilient for possible future changes to the ARM context switch code
> that is not aware of the RT patches.
> 
> This patch will conflict slightly with Catalin's patch set to remove
> __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
> 
>    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
> 
> When Catalin's patch set is accepted, this RT patch will need to reverse
> the change in patch 6 to arch/arm/include/asm/system.h:
> 
>    -#ifndef CONFIG_CPU_HAS_ASID
>    -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
>    -#endif
> 
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

The whole point of my patches was to no longer define
__ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM, so bringing it back in is not
feasible.

But by reading your patch I realised that there are two more switch_mm()
calls outside the scheduler switch and the post-switch hook would not be
called:

1. idle_task_exit() - this function switches to the init_mm. With my new
patches, even if the switch does not explicitly happen because it
requires a new ASID, the ARMv6+ code sets the init_mm.pgd anyway. On
ARMv5 such hook would not happen but we don't have CONFIG_HOTPLUG_CPU
either. But even if it happens to work, it's not correct behaviour in
either case.

2. use_mm() - this also assumes an immediate switch_mm() which may not
happen.

My question - can we not use activate_mm() directly in both cases? This
function would ensure that the new mm is actually active on ARM and it
does not disable the interrupts for the critical code. You may still
need some RT patch if the RT series disables the interrupts for the
switch_mm() calls.

If that sounds reasonable, I'll repost my series with activate_mm() fix.

Thanks.

-- 
Catalin
