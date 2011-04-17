Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1DQJ7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:59:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1DQJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:06 -0400
Message-Id: <20110417095506.923074742@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/7] lockdep: Remove redundant read checks
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-remove_redundant_read_checks_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

Do various simplifications:

1) In kernel/lockdep.c::validate_chain():

	ret = check_deadlock(curr, hlock, lock, hlock->read);

ret == 2 only if hlock->read == 2.

Hence:

	if (ret == 2)
		hlock->read = 2;

is redundant and can be removed.

2) In kernel/lockdep.c::check_prevs_add(curr, next):

	if (hlock->read != 2)
		check_prev_add(curr, hlock, next, distance);

Thus, check_prev_add is called only when hlock->read != 2.

>From the conclusions of 2):

kernel/lockdep.c::check_prev_add(curr, prev, next, distance) gets called
iff prev->read != 2.

Hence, in kernel/lockdep.c::check_prev_add(curr, prev, next, distance):

	if (prev->read == 2)
		return 1;

is redunant and can be removed.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: tip/kernel/lockdep.c
===================================================================
--- tip.orig/kernel/lockdep.c
+++ tip/kernel/lockdep.c
@@ -1676,7 +1676,7 @@ check_prev_add(struct task_struct *curr,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
-	if (next->read == 2 || prev->read == 2)
+	if (next->read == 2)
 		return 1;
 	/*
 	 * Is the <prev> -> <next> dependency already present?
@@ -1940,13 +1940,6 @@ static int validate_chain(struct task_st
 		if (!ret)
 			return 0;
 		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
-		 */
-		if (ret == 2)
-			hlock->read = 2;
-		/*
 		 * Add dependency only if this lock is not the head
 		 * of the chain, and if it's not a secondary read-lock:
 		 */


