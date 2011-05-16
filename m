Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1EPKjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:39:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:50406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab1EPKjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:39:08 -0400
Date: Mon, 16 May 2011 10:38:20 GMT
From: tip-bot for Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Message-ID: <tip-0pz0wnyalr4tk4ln11xwumdx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        stephan.baerwolf@tu-ilmenau.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stephan.baerwolf@tu-ilmenau.de, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix and optimise calculation of the weight-inverse
Git-Commit-ID: db670dac49b5423b39b5e523d28fe32045d71b10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 10:38:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db670dac49b5423b39b5e523d28fe32045d71b10
Gitweb:     http://git.kernel.org/tip/db670dac49b5423b39b5e523d28fe32045d71b10
Author:     Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
AuthorDate: Wed, 11 May 2011 18:03:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 May 2011 11:01:18 +0200

sched: Fix and optimise calculation of the weight-inverse

If the inverse loadweight should be zero, function "calc_delta_mine"
calculates the inverse of "lw->weight" (in 32bit integer ops).

This calculation is actually a little bit impure (because it is
inverting something around "lw-weight"+1), especially when
"lw->weight" becomes smaller.

The correct inverse would be 1/lw->weight multiplied by
"WMULT_CONST" for fixcomma-scaling it into integers.
(So WMULT_CONST/lw->weight ...)

The old, impure algorithm took two divisions for inverting lw->weight,
the new, more exact one only takes one and an additional unlikely-if.

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-0pz0wnyalr4tk4ln11xwumdx@git.kernel.org
[ This could explain some aritmetical issues for small shares but nothing
  concrete has been reported yet so we are not confident enough to queue
  this up in sched/urgent and for -stable backport. But if anyone finds
  this commit and sees it to fix some badness then we can certainly
  change our mind! ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 70bec4f..c62acf4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1330,15 +1330,15 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
+	tmp = (u64)delta_exec * weight;
+
 	if (!lw->inv_weight) {
 		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
 			lw->inv_weight = 1;
 		else
-			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-				/ (lw->weight+1);
+			lw->inv_weight = WMULT_CONST / lw->weight;
 	}
 
-	tmp = (u64)delta_exec * weight;
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
