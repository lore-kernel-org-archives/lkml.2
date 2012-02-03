Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2BCDEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:04:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:18175 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2BCDEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:04:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 02 Feb 2012 22:04:04 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
In-reply-to: <4F2B4873.5030808@codeaurora.org>
Message-id: <alpine.LFD.2.02.1202022202470.2759@xanadu.home>
References: <1328234629-32735-1-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.02.1202022110080.2759@xanadu.home>
 <4F2B4873.5030808@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012, Stephen Boyd wrote:

> On 02/02/12 18:35, Nicolas Pitre wrote:
> > On Thu, 2 Feb 2012, Stephen Boyd wrote:
> >> On 02/02/12 17:18, Nicolas Pitre wrote:
> >>> If you simply disable/restore IRQs around the critical region then you 
> >>> don't have to worry about __v7_setup.  Plus this will allow for 
> >>> v7_flush_dcache_all to still be callable from atomic context.
> >> Ok. Here's a patch. I still need to test it. I'll send another patch
> >> series to cleanup the get_thread_info stuff (there's two of them?).
> >>
> >>  arch/arm/mm/cache-v7.S |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> >> index 07c4bc8..654a5fc 100644
> >> --- a/arch/arm/mm/cache-v7.S
> >> +++ b/arch/arm/mm/cache-v7.S
> >> @@ -54,9 +54,15 @@ loop1:
> >>  	and	r1, r1, #7			@ mask of the bits for current cache only
> >>  	cmp	r1, #2				@ see what cache we have at this level
> >>  	blt	skip				@ skip if no cache, or just i-cache
> >> +#ifdef CONFIG_PREEMPT
> >> +	save_and_disable_irqs r9		@ make cssr&csidr read atomic
> >> +#endif
> >>  	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
> >>  	isb					@ isb to sych the new cssr&csidr
> >>  	mrc	p15, 1, r1, c0, c0, 0		@ read the new csidr
> >> +#ifdef CONFIG_PREEMPT
> >> +	restore_irqs r9
> >> +#endif
> > I'd suggest using restore_irqs_notrace instead.  The IRQ-off period is 
> > so small that there is no point tracing it.
> 
> Thanks. I'll make sure to do that before uploading to the patch tracker.

Might be worth flagging this for the stable kernels as well
(CC: stable@kernel.org).


Nicolas
