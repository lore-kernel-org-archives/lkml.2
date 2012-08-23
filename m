Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab2HWNMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:12:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21792 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab2HWNMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:12:00 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH] fork: fix oops after fork failure
Date: Thu, 23 Aug 2012 17:08:46 +0400
Message-Id: <1345727326-18730-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to duplicate a new process, dup_task_struct() will undergo
a series of allocations. If alloc_thread_info_node() fails, we call
free_task_struct() and return.

This seems right, but it is not. free_task_struct() will not only free
the task struct from the kmem_cache, but will also call
arch_release_task_struct(). The problem is that this function is
supposed to undo whatever arch-specific work done by
arch_dup_task_struct(), that is not yet called at this point.  The
particular problem I ran accross was that in x86, we will arrive at
fpu_free() without having ever allocated it.

This code is very ancient, and according to git, it is there since the
pre-git era. But forks don't fail that often, so that made it well
hidden.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Frederic Weisbecker <fweisbec@redhat.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 152d023..b397435 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -299,7 +299,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	ti = alloc_thread_info_node(tsk, node);
 	if (!ti) {
-		free_task_struct(tsk);
+		kmem_cache_free(task_struct_cachep, tsk);
 		return NULL;
 	}
 
-- 
1.7.11.4

