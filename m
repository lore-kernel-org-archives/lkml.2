Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2JRJzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:55:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35543 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2JRJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:55:07 -0400
Date: Thu, 18 Oct 2012 13:55:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC] procfs: Add VmFlags field in smaps output
Message-ID: <20121018095503.GB8790@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, in a sake of c/r we need to fetch additional
VMA characteristics, so I though would /proc/pid/smaps
be appropriate place for it? If yes, I would like to
know if the output format provided below looks reasonable.

Please review, thanks!
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC] procfs: Add VmFlags field in smaps output

When we do restore VMA area after checkpoint
we would like to know if the area was locked
or say it has mergeable attribute, but at moment
the kernel does not provide such information, thus
we can't figure out if we should call mlock/madvise
on VMA restore.

This patch adds new VmFlags field to smaps output
with vma->vm_flags encoded.

This field is CONFIG_CHECKPOINT_RESTORE dependent
since at moment I don't know if someone else might
need it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/proc/task_mmu.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -480,6 +480,44 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	seq_puts(m, "VmFlags:              ");
+
+	if (vma->vm_flags & VM_LOCKED)
+		seq_puts(m, " locked");
+
+	if (vma->vm_flags & VM_GROWSDOWN)
+		seq_puts(m, " growsdown");
+
+	if (vma->vm_flags & VM_RAND_READ)
+		seq_puts(m, " rand_read");
+
+	if (vma->vm_flags & VM_SEQ_READ)
+		seq_puts(m, " seq_read");
+
+	if (vma->vm_flags & VM_DONTCOPY)
+		seq_puts(m, " dontcopy");
+
+	if (vma->vm_flags & VM_MERGEABLE)
+		seq_puts(m, " mergeable");
+
+	if (vma->vm_flags & VM_HUGEPAGE)
+		seq_puts(m, " hugepage");
+
+	if (vma->vm_flags & VM_NOHUGEPAGE)
+		seq_puts(m, " nohugepage");
+
+	if (vma->vm_flags & VM_DONTDUMP)
+		seq_puts(m, " dontdump");
+
+	seq_putc(m, '\n');
+}
+#else
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma) { }
+#endif
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -535,6 +573,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
