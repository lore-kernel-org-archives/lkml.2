Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1AaVsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:48:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab1AaVsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:48:13 -0500
Date: Mon, 31 Jan 2011 16:42:38 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [PATCH -v8 2/7] sched: limit the scope of clear_buddies
Message-ID: <20110131164238.602b231b@annuminas.surriel.com>
In-Reply-To: <20110131164049.0ad68e72@annuminas.surriel.com>
References: <20110131164049.0ad68e72@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clear_buddies function does not seem to play well with the concept
of hierarchical runqueues.  In the following tree, task groups are
represented by 'G', tasks by 'T', next by 'n' and last by 'l'.

     (nl)
    /    \
   G(nl)  G
   / \     \
 T(l) T(n)  T

This situation can arise when a task is woken up T(n), and the previously
running task T(l) is marked last.

When clear_buddies is called from either T(l) or T(n), the next and last
buddies of the group G(nl) will be cleared.  This is not the desired
result, since we would like to be able to find the other type of buddy
in many cases.

This especially a worry when implementing yield_task_fair through the
buddy system.

The fix is simple: only clear the buddy type that the task itself
is indicated to be.  As an added bonus, we stop walking up the tree
when the buddy has already been cleared or pointed elsewhere.

Signed-off-by: Rik van Riel <riel@redhat.coM>
---
 kernel/sched_fair.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4ee445..0321473 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -784,19 +784,35 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 }
 
-static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __clear_buddies_last(struct sched_entity *se)
 {
-	if (!se || cfs_rq->last == se)
-		cfs_rq->last = NULL;
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->last == se)
+			cfs_rq->last = NULL;
+		else
+			break;
+	}
+}
 
-	if (!se || cfs_rq->next == se)
-		cfs_rq->next = NULL;
+static void __clear_buddies_next(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->next == se)
+			cfs_rq->next = NULL;
+		else
+			break;
+	}
 }
 
 static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		__clear_buddies(cfs_rq_of(se), se);
+	if (cfs_rq->last == se)
+		__clear_buddies_last(se);
+
+	if (cfs_rq->next == se)
+		__clear_buddies_next(se);
 }
 
 static void

