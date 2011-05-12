Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1ELJOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:14:54 -0400
Received: from mail4.comsite.net ([205.238.176.238]:30013 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab1ELJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:14:52 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH] seqlock: don't smp_rmb in seqlock reader spin loop
From: Milton Miller <miltonm@bga.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] seqlock: don't smp_rmb in seqlock reader spin loop
Message-Id: <seqlock-rmb@mdm.bga.com>
In-Reply-To: <alpine.LFD.2.02.1105091036000.2895@ionos>
References: <alpine.LFD.2.02.1105091036000.2895@ionos>
	<1304574244.32152.666.camel@edumazet-laptop>
	<1304576495.2943.40.camel@work-vm>
	<1304604284.3032.78.camel@edumazet-laptop>
	<alpine.LFD.2.02.1105051630390.3005@ionos>
	<1304608095.3032.95.camel@edumazet-laptop>
	<alpine.LFD.2.02.1105051750540.3005@ionos>
	<20110505210118.GI2925@one.firstfloor.org>
	<alpine.LFD.2.02.1105061117220.3005@ionos>
	<20110506165913.GF11636@one.firstfloor.org>
	<1304703767.3066.211.camel@edumazet-laptop>
	<20110506175051.GL11636@one.firstfloor.org>
	<1304710003.2821.0.camel@edumazet-laptop>
	<1304712267.2821.29.camel@edumazet-laptop>
	<1304713443.20980.124.camel@work-vm>
	<1304721004.2821.148.camel@edumazet-laptop>
	<1304722000.20980.130.camel@work-vm>
	<1304722835.2821.192.camel@edumazet-laptop>
	<1304724519.20980.139.camel@work-vm>
Date: Thu, 12 May 2011 04:13:54 -0500
X-Originating-IP: 71.22.127.106
X-HeloNotChecked: Helo response was not checked before commands sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Cc: <stable@vger.kernel.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
---

To the readers of [RFC] time: xtime_lock is held too long:

I initially thought x86 would not see this because rmb would
be a nop, but upon closer inspection X86_PPRO_FENCE will add
a lfence for rmb.

milton

Index: common/include/linux/seqlock.h
===================================================================
--- common.orig/include/linux/seqlock.h	2011-04-06 03:27:02.000000000 -0500
+++ common/include/linux/seqlock.h	2011-04-06 03:35:02.000000000 -0500
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
