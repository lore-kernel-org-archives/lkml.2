Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1C1HI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1C1HI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:08:27 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/2] proc: do cleanup in m_start() rather than m_stop()
Date: Mon, 28 Mar 2011 15:07:32 +0800
Message-Id: <1301296053-23589-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1301296053-23589-1-git-send-email-amwang@redhat.com>
References: <4D90206E.1090307@redhat.com>
 <1301296053-23589-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the future, we will not call ->stop() anymore when ->start() fails,
so ->start() is responsible to do cleanups within itself.

Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 fs/proc/task_mmu.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3c06570..9ebbe20 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -124,8 +124,10 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_for_maps(priv->task);
-	if (IS_ERR_OR_NULL(mm))
+	if (IS_ERR_OR_NULL(mm)) {
+		put_task_struct(priv->task);
 		return mm;
+	}
 	down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(priv->task->mm);
@@ -182,8 +184,9 @@ static void m_stop(struct seq_file *m, void *v)
 	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 
-	if (!IS_ERR_OR_NULL(vma))
-		vma_stop(priv, vma);
+	if (IS_ERR_OR_NULL(vma))
+		return;
+	vma_stop(priv, vma);
 	if (priv->task)
 		put_task_struct(priv->task);
 }
-- 
1.7.4

