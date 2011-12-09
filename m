Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1LIFqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:46:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1LIFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:45:54 -0500
Date: Thu, 8 Dec 2011 21:47:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20111208214744.19117662.akpm@linux-foundation.org>
In-Reply-To: <20111209160856.d1f8de40a6d415cd5d9cafc7@canb.auug.org.au>
References: <20111209160856.d1f8de40a6d415cd5d9cafc7@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011 16:08:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from kernel/fork.c:21:0:
> include/linux/mempolicy.h: In function 'task_has_mempolicy':
> include/linux/mempolicy.h:258:13: error: dereferencing pointer to incomplete type
> 
> And several more like that.
> 
> Caused by commit 9d15457f147d
> ("cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2").

I suppose this is a good enough fix for that:

 include/linux/mempolicy.h |   10 ----------
 mm/mempolicy.c            |   12 ++++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN include/linux/mempolicy.h~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2 include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2
+++ a/include/linux/mempolicy.h
@@ -253,11 +253,6 @@ static inline int vma_migratable(struct 
 	return 1;
 }
 
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return task->mempolicy;
-}
-
 #else
 
 struct mempolicy {};
@@ -384,11 +379,6 @@ static inline int mpol_to_str(char *buff
 	return 0;
 }
 
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return false;
-}
-
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff -puN mm/mempolicy.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2 mm/mempolicy.c
--- a/mm/mempolicy.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2
+++ a/mm/mempolicy.c
@@ -137,6 +137,18 @@ static const struct mempolicy_operations
 			enum mpol_rebind_step step);
 } mpol_ops[MPOL_MAX];
 
+#ifdef CONFIG_NUMA
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return task->mempolicy;
+}
+#else
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return false;
+}
+#endif
+
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(const nodemask_t *nodemask)
 {
_

> I have reverted that patch for today (and the following trivial patch
> "cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix").

And I'll drop that one now.
