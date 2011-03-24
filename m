Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1CXRuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:04 -0400
Received: from flusers.ccur.com ([173.221.59.2]:49936 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756641Ab1CXRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:58 -0400
Date: Thu, 24 Mar 2011 13:48:02 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/24] jrcu: use xchg to toggle rcu_which
Message-ID: <20110324174802.GA18878@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use xchg rather than wmb()s to change the value
of rcu_which.

This may be better than wmb()s as xchg will not
let the insn counter advance past the xchg until
the exchanged result is visible to other cpus.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -371,14 +371,16 @@ static void __rcu_delimit_batches(struct
 		else
 			rd->wait = 0;
 	}
+	smp_wmb(); /* just paranoia, the below xchg should do this on all archs */
 
 	/*
-	 * Swap current and previous lists.  The other cpus must not see this
-	 * out-of-order w.r.t. the above emptying of each cpu's previous list,
-	 * hence the smp_wmb.
+	 * Swap current and previous lists.  The other cpus must not
+	 * see this out-of-order w.r.t. the above emptying of each cpu's
+	 * previous list.  The xchg accomplishes that and, as a side (but
+	 * seemingly unneeded) bonus, keeps this cpu from advancing its insn
+	 * counter until the results of that xchg are visible on other cpus.
 	 */
-	smp_wmb();
-	rcu_which = prev;
+	xchg(&rcu_which, prev); /* only place where rcu_which is written to */
 	rcu_stats.nbatches++;
 }
 
