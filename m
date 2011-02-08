Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1BHSkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:40:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:57071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab1BHSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:40:23 -0500
Date: Tue, 8 Feb 2011 18:39:43 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
        frank.rowand@am.sony.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, frank.rowand@am.sony.com
In-Reply-To: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] softirq: Avoid stack switch from ksoftirqd
Message-ID: <tip-c305d524e5dd3c3c7a6035083e30950bea1b52dc@git.kernel.org>
Git-Commit-ID: c305d524e5dd3c3c7a6035083e30950bea1b52dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 18:39:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c305d524e5dd3c3c7a6035083e30950bea1b52dc
Gitweb:     http://git.kernel.org/tip/c305d524e5dd3c3c7a6035083e30950bea1b52dc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 17:10:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 Feb 2011 19:37:12 +0100

softirq: Avoid stack switch from ksoftirqd

ksoftirqd() calls do_softirq() which switches stacks on several
architectures. That makes no sense at all. ksoftirqd's stack is
sufficient.

Call __do_softirq() directly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
LKML-Reference: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
---
 kernel/softirq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 68eb5ef..c049046 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -738,7 +738,10 @@ static int run_ksoftirqd(void * __bind_cpu)
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
