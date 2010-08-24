Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0HXTCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:02:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab0HXTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:02:08 -0400
Date: Tue, 24 Aug 2010 21:01:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core fixes
Message-ID: <20100824190121.GA745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4735]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

This contains the mutex optimistic spinning fix from Tim Chen. It is not 
a regression fix per se - but the improvement is significant enough (and 
the patch is simple enough as well) to not let this sit for yet another 
cycle.

 Thanks,

	Ingo

------------------>
Tim Chen (1):
      mutex: Improve the scalability of optimistic spinning


 kernel/sched.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 41541d7..09b574e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3865,8 +3865,16 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
-		if (lock->owner != owner)
+		if (lock->owner != owner) {
+			/*
+			 * If the lock has switched to a different owner,
+			 * we likely have heavy contention. Return 0 to quit
+			 * optimistic spinning and not contend further:
+			 */
+			if (lock->owner)
+				return 0;
 			break;
+		}
 
 		/*
 		 * Is that owner really running on that cpu?
