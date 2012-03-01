Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361Ab2CAVuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292Ab2CAVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.201.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213925.183202699@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 18/34] ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit b46c0f74657d1fe1c1b0c1452631cc38a9e6987f upstream.

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/cache-v7.S |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -39,9 +39,15 @@ loop1:
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
+	restore_irqs_notrace r9
+#endif
 	and	r2, r1, #7			@ extract the length of the cache lines
 	add	r2, r2, #4			@ add 4 (line length offset)
 	ldr	r4, =0x3ff


