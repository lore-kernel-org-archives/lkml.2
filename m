Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330Ab1D0XiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:38:08 -0400
Received: from mout.perfora.net ([74.208.4.194]:49952 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760320Ab1D0XiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:38:04 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] proc: allocate storage for numa_maps statistics once
Date: Wed, 27 Apr 2011 19:35:49 -0400
Message-Id: <1303947349-3620-9-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:vP8tTsLg37Ze7I6DaPUq8uJ5o8/AnCdR0O3881FIhAu
 PiHN5qSlPQ2iRgts94GXLoz2GG5voT5LvazTAReEiMyyucd2SU
 hMKex6r0Jj47I8exoncYTEIh9t2b47K5zxB4MGP9vvDO5a51dD
 b7/riMUX7CfIgic4uuRTTDYp/xrBWd21pjdVOUfiAhln2xOeR4
 9vwODijx0wWTq80m+KF6+c3B06RQHQvD10F6kpCnJk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In show_numa_map() we collect statistics into a numa_maps structure.
Since the number of NUMA nodes can be very large, this structure is not
a candidate for stack allocation.

Instead of going thru a kmalloc()+kfree() cycle each time show_numa_map()
is invoked, perform the allocation just once when /proc/pid/numa_maps is
opened.

Performing the allocation when numa_maps is opened, and thus before a
reference to the target tasks mm is taken, eliminates a potential
stalemate condition in the oom-killer as originally described by Hugh
Dickins:

  ... imagine what happens if the system is out of memory, and the mm
  we're looking at is selected for killing by the OOM killer: while
  we wait in __get_free_page for more memory, no memory is freed
  from the selected mm because it cannot reach exit_mmap while we hold
  that reference.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/task_mmu.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9f069d2..1ca3a00 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -868,6 +868,11 @@ struct numa_maps {
 	unsigned long node[MAX_NUMNODES];
 };
 
+struct numa_maps_private {
+	struct proc_maps_private proc_maps;
+	struct numa_maps md;
+};
+
 static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
 {
 	int count = page_mapcount(page);
@@ -949,9 +954,10 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
  */
 static int show_numa_map(struct seq_file *m, void *v)
 {
-	struct proc_maps_private *priv = m->private;
+	struct numa_maps_private *numa_priv = m->private;
+	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
 	struct vm_area_struct *vma = v;
-	struct numa_maps *md;
+	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
@@ -962,16 +968,15 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (!mm)
 		return 0;
 
-	md = kzalloc(sizeof(struct numa_maps), GFP_KERNEL);
-	if (!md)
-		return 0;
+	/* Ensure we start with an empty set of numa_maps statistics. */
+	memset(md, 0, sizeof(*md));
 
 	walk.hugetlb_entry = gather_hugetbl_stats;
 	walk.pte_entry = gather_pte_stats;
 	walk.private = md;
 	walk.mm = mm;
 
-	pol = get_vma_policy(priv->task, vma, vma->vm_start);
+	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
 
@@ -1018,12 +1023,12 @@ static int show_numa_map(struct seq_file *m, void *v)
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
 	seq_putc(m, '\n');
-	kfree(md);
 
 	if (m->count < m->size)
-		m->version = (vma != priv->tail_vma) ? vma->vm_start : 0;
+		m->version = (vma != proc_priv->tail_vma) ? vma->vm_start : 0;
 	return 0;
 }
+
 static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
@@ -1033,7 +1038,20 @@ static const struct seq_operations proc_pid_numa_maps_op = {
 
 static int numa_maps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
+	struct numa_maps_private *priv;
+	int ret = -ENOMEM;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		priv->proc_maps.pid = proc_pid(inode);
+		ret = seq_open(file, &proc_pid_numa_maps_op);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = priv;
+		} else {
+			kfree(priv);
+		}
+	}
+	return ret;
 }
 
 const struct file_operations proc_numa_maps_operations = {
-- 
1.7.3.5

