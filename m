Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2J1RKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:10:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2J1RKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:10:18 -0400
Date: Sun, 28 Oct 2012 10:09:42 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-f9848081ba2cf98628df165cc2784c32fe9fc9e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, aarcange@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, aarcange@redhat.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm/mpol: Add_MPOL_F_HOME
Git-Commit-ID: f9848081ba2cf98628df165cc2784c32fe9fc9e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 28 Oct 2012 10:09:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9848081ba2cf98628df165cc2784c32fe9fc9e2
Gitweb:     http://git.kernel.org/tip/f9848081ba2cf98628df165cc2784c32fe9fc9e2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Jul 2012 22:06:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 28 Oct 2012 17:31:14 +0100

sched, numa, mm/mpol: Add_MPOL_F_HOME

Add MPOL_F_HOME, to implement multi-stage home node binding.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-ec1gnZa9xaqwlsSjsfqjyxcl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/mempolicy.h |    1 +
 mm/mempolicy.c                 |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 6a1baae..a2bcd04 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -69,6 +69,7 @@ enum mpol_rebind_step {
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
+#define MPOL_F_HOME	(1 << 4) /* this is the home-node policy */
 
 
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 97e6d99..1ac0479 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2216,6 +2216,7 @@ static void sp_free(struct sp_node *n)
  * @page   - page to be checked
  * @vma    - vm area where page mapped
  * @addr   - virtual address where page mapped
+ * @multi  - use multi-stage node binding
  *
  * Lookup current policy node id for vma,addr and "compare to" page's
  * node id.
@@ -2278,6 +2279,37 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 	default:
 		BUG();
 	}
+
+	/*
+	 * Multi-stage node selection is used in conjunction with a periodic
+	 * migration fault to build a temporal task<->page relation. By
+	 * using a two-stage filter we remove short/unlikely relations.
+	 *
+	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can
+	 * equate a task's usage of a particular page (n_p) per total usage
+	 * of this page (n_t) (in a given time-span) to a probability.
+	 *
+	 * Our periodic faults will then sample this probability and getting
+	 * the same result twice in a row, given these samples are fully
+	 * independent, is then given by P(n)^2, provided our sample period
+	 * is sufficiently short compared to the usage pattern.
+	 *
+	 * This quadric squishes small probabilities, making it less likely
+	 * we act on an unlikely task<->page relation.
+	 */
+	if (pol->flags & MPOL_F_HOME) {
+		int last_nid;
+
+		/*
+		 * Migrate towards the current node, depends on
+		 * task_numa_placement() details.
+		 */
+		polnid = numa_node_id();
+		last_nid = page_xchg_last_nid(page, polnid);
+		if (last_nid != polnid)
+			goto out;
+	}
+
 	if (curnid != polnid)
 		ret = polnid;
 out:
@@ -2470,7 +2502,7 @@ void __init numa_policy_init(void)
 		preferred_node_policy[nid] = (struct mempolicy) {
 			.refcnt = ATOMIC_INIT(1),
 			.mode = MPOL_PREFERRED,
-			.flags = MPOL_F_MOF,
+			.flags = MPOL_F_MOF | MPOL_F_HOME,
 			.v = { .preferred_node = nid, },
 		};
 	}
