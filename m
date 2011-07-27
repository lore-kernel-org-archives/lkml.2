Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1G0WJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:09:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:59981 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab1G0VsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826247"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: miltonm@bga.com, linuxppc-dev@lists.ozlabs.org,
        torvalds@linux-foundation.org, andi@firstfloor.org, npiggin@kernel.dk,
        benh@kernel.crashing.org, anton@samba.org, paulmck@linux.vnet.ibm.com,
        eric.dumazet@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [6/99] seqlock: Don't smp_rmb in seqlock reader spin loop
Message-Id: <20110727214804.6E36E2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Milton Miller <miltonm@bga.com>

commit 5db1256a5131d3b133946fa02ac9770a784e6eb2 upstream.

Move the smp_rmb after cpu_relax loop in read_seqlock and add
ACCESS_ONCE to make sure the test and return are consistent.

A multi-threaded core in the lab didn't like the update
from 2.6.35 to 2.6.36, to the point it would hang during
boot when multiple threads were active.  Bisection showed
af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867 (clockevents:
Remove the per cpu tick skew) as the culprit and it is
supported with stack traces showing xtime_lock waits including
tick_do_update_jiffies64 and/or update_vsyscall.

Experimentation showed the combination of cpu_relax and smp_rmb
was significantly slowing the progress of other threads sharing
the core, and this patch is effective in avoiding the hang.

A theory is the rmb is affecting the whole core while the
cpu_relax is causing a resource rebalance flush, together they
cause an interfernce cadance that is unbroken when the seqlock
reader has interrupts disabled.

At first I was confused why the refactor in
3c22cd5709e8143444a6d08682a87f4c57902df3 (kernel: optimise
seqlock) didn't affect this patch application, but after some
study that affected seqcount not seqlock. The new seqcount was
not factored back into the seqlock.  I defer that the future.

While the removal of the timer interrupt offset created
contention for the xtime lock while a cpu does the
additonal work to update the system clock, the seqlock
implementation with the tight rmb spin loop goes back much
further, and is just waiting for the right trigger.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: <linuxppc-dev@lists.ozlabs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/%3Cseqlock-rmb%40mdm.bga.com%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/include/linux/seqlock.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/seqlock.h
+++ linux-2.6.35.y/include/linux/seqlock.h
@@ -88,12 +88,12 @@ static __always_inline unsigned read_seq
 	unsigned ret;
 
 repeat:
-	ret = sl->sequence;
-	smp_rmb();
+	ret = ACCESS_ONCE(sl->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
+	smp_rmb();
 
 	return ret;
 }
