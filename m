Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2KPL3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:29:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab2KPLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:23:19 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 16/43] mm: mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY from userspace for now
Date: Fri, 16 Nov 2012 11:22:26 +0000
Message-Id: <1353064973-26082-17-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353064973-26082-1-git-send-email-mgorman@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of MPOL_NOOP and MPOL_MF_LAZY to allow an application to
explicitly request lazy migration is a good idea but the actual
API has not been well reviewed and once released we have to support it.
For now this patch prevents an application using the services. This
will need to be revisited.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/uapi/linux/mempolicy.h |    4 +---
 mm/mempolicy.c                 |    9 ++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 6a1baae..16fb4e6 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -21,7 +21,6 @@ enum {
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
 	MPOL_LOCAL,
-	MPOL_NOOP,		/* retain existing policy for range */
 	MPOL_MAX,	/* always last member of enum */
 };
 
@@ -57,8 +56,7 @@ enum mpol_rebind_step {
 
 #define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
 			 MPOL_MF_MOVE     | 	\
-			 MPOL_MF_MOVE_ALL |	\
-			 MPOL_MF_LAZY)
+			 MPOL_MF_MOVE_ALL)
 
 /*
  * Internal flags that share the struct mempolicy flags word with
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 11052ea..09d477a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -252,7 +252,7 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP) {
+	if (mode == MPOL_DEFAULT) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
 		return NULL;
@@ -1289,7 +1289,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (start & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
+	if (mode == MPOL_DEFAULT)
 		flags &= ~MPOL_MF_STRICT;
 
 	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
@@ -1344,7 +1344,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma) && mode != MPOL_NOOP)
+	if (!IS_ERR(vma))
 		err = mbind_range(mm, start, end, new);
 
 	if (!err) {
@@ -2633,7 +2633,6 @@ static const char * const policy_modes[] =
 	[MPOL_BIND]       = "bind",
 	[MPOL_INTERLEAVE] = "interleave",
 	[MPOL_LOCAL]      = "local",
-	[MPOL_NOOP]	  = "noop",	/* should not actually be used */
 };
 
 
@@ -2684,7 +2683,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			break;
 		}
 	}
-	if (mode >= MPOL_MAX || mode == MPOL_NOOP)
+	if (mode >= MPOL_MAX)
 		goto out;
 
 	switch (mode) {
-- 
1.7.9.2

