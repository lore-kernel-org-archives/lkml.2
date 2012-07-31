Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2GaTrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:47:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:58935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2GaTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:43 -0400
Message-Id: <20120731192808.769449391@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/19] mm/mpol: Add MPOL_MF_NOOP
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=mm_mpol-Add_MPOL_MF_NOOP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch augments the MPOL_MF_LAZY feature by adding a "NOOP"
policy to mbind().  When the NOOP policy is used with the 'MOVE
and 'LAZY flags, mbind() [check_range()] will walk the specified
range and unmap eligible pages so that they will be migrated on
next touch.

This allows an application to prepare for a new phase of operation
where different regions of shared storage will be assigned to
worker threads, w/o changing policy.  Note that we could just use
"default" policy in this case.  However, this also allows an
application to request that pages be migrated, only if necessary,
to follow any arbitrary policy that might currently apply to a
range of pages, without knowing the policy, or without specifying
multiple mbind()s for ranges with different policies.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 87fabfa..668311a 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -21,6 +21,7 @@ enum {
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
 	MPOL_LOCAL,
+	MPOL_NOOP,		/* retain existing policy for range */
 	MPOL_MAX,	/* always last member of enum */
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4fba5f2..251ef31 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -251,10 +251,10 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (mode == MPOL_DEFAULT) {
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
-		return NULL;	/* simply delete any existing policy */
+		return NULL;
 	}
 	VM_BUG_ON(!nodes);
 
@@ -1069,7 +1069,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (start & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (mode == MPOL_DEFAULT)
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
 		flags &= ~MPOL_MF_STRICT;
 
 	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
@@ -1121,7 +1121,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma))
+	if (!IS_ERR(vma) && mode != MPOL_NOOP)
 		err = mbind_range(mm, start, end, new);
 
 	if (!err) {
-- 
1.7.2.3



