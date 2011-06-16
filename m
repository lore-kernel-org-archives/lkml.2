Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1FPH0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:26:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39627 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442Ab1FPHFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:31 -0400
X-Sasl-enc: +V0TAlAHOSZVoSRhh9G6rhzNfaUZDQerE5UmivnD3PFu 1308207930
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.375030180@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>, <linuxppc-dev@lists.ozlabs.org>,
        Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@kernel.dk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [21/91] seqlock: Dont smp_rmb in seqlock reader spin loop
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
Link: http://lkml.kernel.org/r/%3Cseqlock-rmb%40mdm.bga.com%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/seqlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
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


