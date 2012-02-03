Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab2BCCDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:03:52 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2BCCDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:03:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6608"; a="157854874"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Date: Thu,  2 Feb 2012 18:03:49 -0800
Message-Id: <1328234629-32735-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.48.g85da4d
In-reply-to: <alpine.LFD.2.02.1202022016480.2759@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

armv7's flush_cache_all() flushes caches via set/way. To
determine the cache attributes (line size, number of sets,
etc.) the assembly first writes the CSSELR register to select a
cache level and then reads the CCSIDR register. The CSSELR register
is banked per-cpu and is used to determine which cache level CCSIDR
reads. If the task is migrated between when the CSSELR is written and
the CCSIDR is read the CCSIDR value may be for an unexpected cache
level (for example L1 instead of L2) and incorrect cache flushing
could occur.

Disable interrupts across the write and read so that the correct
cache attributes are read and used for the cache flushing
routine. We disable interrupts instead of disabling preemption
because the critical section is only 3 instructions and we want
to call v7_dcache_flush_all from __v7_setup which doesn't have a
full kernel stack with a struct thread_info.

This fixes a problem we see in scm_call() when flush_cache_all()
is called from preemptible context and sometimes the L2 cache is
not properly flushed out.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
---

On 02/02/12 17:18, Nicolas Pitre wrote:
>>> If that's too much, then the simple method in assembly to quickly disable
>>> preemption over a very few set of instructions is using mrs/msr and cpsid i.
>>> That'll be far cheaper than fiddling about with preempt counters or
>>> messing about with veneers in C code.
>>
>> I'll try the macros. So far it isn't bad, just the __v7_setup to resolve.
>
> If you simply disable/restore IRQs around the critical region then you 
> don't have to worry about __v7_setup.  Plus this will allow for 
> v7_flush_dcache_all to still be callable from atomic context.

Ok. Here's a patch. I still need to test it. I'll send another patch
series to cleanup the get_thread_info stuff (there's two of them?).

 arch/arm/mm/cache-v7.S |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 07c4bc8..654a5fc 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -54,9 +54,15 @@ loop1:
 	and	r1, r1, #7			@ mask of the bits for current cache only
 	cmp	r1, #2				@ see what cache we have at this level
 	blt	skip				@ skip if no cache, or just i-cache
+#ifdef CONFIG_PREEMPT
+	save_and_disable_irqs r9		@ make cssr&csidr read atomic
+#endif
 	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
 	isb					@ isb to sych the new cssr&csidr
 	mrc	p15, 1, r1, c0, c0, 0		@ read the new csidr
+#ifdef CONFIG_PREEMPT
+	restore_irqs r9
+#endif
 	and	r2, r1, #7			@ extract the length of the cache lines
 	add	r2, r2, #4			@ add 4 (line length offset)
 	ldr	r4, =0x3ff
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

