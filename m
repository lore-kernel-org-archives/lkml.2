Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2JVTU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:20:26 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45250 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2JVTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:20:24 -0400
Message-Id: <20121022192020.193773807@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 22 Oct 2012 23:14:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 1/2] [RFC] procfs: Add VmFlags field in smaps output
References: <20121022191452.785366817@openvz.org>
Content-Disposition: inline; filename=mm-vma-flags-4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do restore VMA area after checkpoint we would like
to know if the area was locked or say it had mergeable attribute,
but at moment the kernel does not provide such information, thus
we can't figure out if we should call mlock/madvise on VMA restore.

This patch adds new VmFlags field to smaps output with vma->vm_flags
encoded.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/proc/task_mmu.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -480,6 +480,36 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	/*
+	 * Don't forget to update Documentation/ on changes.
+	 */
+#define __VM_FLAG(_f) (!!(vma->vm_flags & (_f)))
+	seq_printf(m, "VmFlags: "
+		   "RD:%d WR:%d EX:%d SH:%d MR:%d "
+		   "MW:%d ME:%d MS:%d GD:%d PF:%d "
+		   "DW:%d LO:%d IO:%d SR:%d RR:%d "
+		   "DC:%d DE:%d AC:%d NR:%d HT:%d "
+		   "NL:%d AR:%d DD:%d MM:%d HG:%d "
+		   "NH:%d MG:%d\n",
+		   __VM_FLAG(VM_READ),		__VM_FLAG(VM_WRITE),
+		   __VM_FLAG(VM_EXEC),		__VM_FLAG(VM_SHARED),
+		   __VM_FLAG(VM_MAYREAD),	__VM_FLAG(VM_MAYWRITE),
+		   __VM_FLAG(VM_MAYEXEC),	__VM_FLAG(VM_MAYSHARE),
+		   __VM_FLAG(VM_GROWSDOWN),	__VM_FLAG(VM_PFNMAP),
+		   __VM_FLAG(VM_DENYWRITE),	__VM_FLAG(VM_LOCKED),
+		   __VM_FLAG(VM_IO),		__VM_FLAG(VM_SEQ_READ),
+		   __VM_FLAG(VM_RAND_READ),	__VM_FLAG(VM_DONTCOPY),
+		   __VM_FLAG(VM_DONTEXPAND),	__VM_FLAG(VM_ACCOUNT),
+		   __VM_FLAG(VM_NORESERVE),	__VM_FLAG(VM_HUGETLB),
+		   __VM_FLAG(VM_NONLINEAR),	__VM_FLAG(VM_ARCH_1),
+		   __VM_FLAG(VM_DONTDUMP),	__VM_FLAG(VM_MIXEDMAP),
+		   __VM_FLAG(VM_HUGEPAGE),	__VM_FLAG(VM_NOHUGEPAGE),
+		   __VM_FLAG(VM_MERGEABLE));
+#undef __VM_FLAG
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -535,6 +565,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;

