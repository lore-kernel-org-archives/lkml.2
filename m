Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2F2P1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:27:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64453 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2F2P1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:27:44 -0400
Date: Fri, 29 Jun 2012 17:27:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] RCU fix
Message-ID: <20120629152739.GA2725@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: b41772abebc27c61dd578b76da99aa5240b4c99a rcu: Stop rcu_do_batch() from multiplexing the "count" variable

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      rcu: Stop rcu_do_batch() from multiplexing the "count" variable


 kernel/rcutree.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3b0f133..38ecdda 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1530,7 +1530,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy;
+	int bl, count, count_lazy, i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
@@ -1553,9 +1553,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
 	tail = rdp->nxttail[RCU_DONE_TAIL];
-	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
-		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
-			rdp->nxttail[count] = &rdp->nxtlist;
+	for (i = RCU_NEXT_SIZE - 1; i >= 0; i--)
+		if (rdp->nxttail[i] == rdp->nxttail[RCU_DONE_TAIL])
+			rdp->nxttail[i] = &rdp->nxtlist;
 	local_irq_restore(flags);
 
 	/* Invoke callbacks. */
@@ -1583,9 +1583,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	if (list != NULL) {
 		*tail = rdp->nxtlist;
 		rdp->nxtlist = list;
-		for (count = 0; count < RCU_NEXT_SIZE; count++)
-			if (&rdp->nxtlist == rdp->nxttail[count])
-				rdp->nxttail[count] = tail;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			if (&rdp->nxtlist == rdp->nxttail[i])
+				rdp->nxttail[i] = tail;
 			else
 				break;
 	}
