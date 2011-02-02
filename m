Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1BBQLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:11:13 -0500
Received: from www.tglx.de ([62.245.132.106]:41387 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab1BBQLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:11:12 -0500
Date: Wed, 2 Feb 2011 17:10:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] softirq: Avoid stack switch from ksoftirqd
Message-ID: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ksoftirqd() calls do_softirq() which switches stacks on several
architectures. That makes no sense at all. ksoftirqd's stack is
sufficient.

Call __do_softirq() directly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/softirq.c
===================================================================
--- linux-2.6-tip.orig/kernel/softirq.c
+++ linux-2.6-tip/kernel/softirq.c
@@ -738,7 +738,10 @@ static int run_ksoftirqd(void * __bind_c
 			   don't process */
 			if (cpu_is_offline((long)__bind_cpu))
 				goto wait_to_die;
-			do_softirq();
+			local_irq_disable();
+			if (local_softirq_pending())
+				__do_softirq();
+			local_irq_enable();
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
