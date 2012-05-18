Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161066Ab2ERKZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:25:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2ERKZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:25:32 -0400
Date: Fri, 18 May 2012 03:24:46 -0700
From: tip-bot for Lee Schermerhorn <lee.schermerhorn@hp.com>
Message-ID: <tip-bi11pj8hp89gbtsqs879fw2v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        akpm@linux-foundation.org, bharata.rao@gmail.com, aarcange@redhat.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        lee.schermerhorn@hp.com, cl@linux.com, riel@redhat.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org, aarcange@redhat.com,
        danms@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Add MPOL_MF_NOOP
Git-Commit-ID: 84f1e3478238c0c65711364e43d081ef32c068fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:24:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f1e3478238c0c65711364e43d081ef32c068fb
Gitweb:     http://git.kernel.org/tip/84f1e3478238c0c65711364e43d081ef32c068fb
Author:     Lee Schermerhorn <lee.schermerhorn@hp.com>
AuthorDate: Mon, 16 Jan 2012 14:43:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:17 +0200

mm/mpol: Add MPOL_MF_NOOP

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-bi11pj8hp89gbtsqs879fw2v@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 801ad50..b484ae2 100644
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
index f261c52..e972ba0 100644
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
 
@@ -1056,7 +1056,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (start & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (mode == MPOL_DEFAULT)
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
 		flags &= ~MPOL_MF_STRICT;
 
 	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
@@ -1108,7 +1108,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma))
+	if (!IS_ERR(vma) && mode != MPOL_NOOP)
 		err = mbind_range(mm, start, end, new);
 
 	if (!err) {
