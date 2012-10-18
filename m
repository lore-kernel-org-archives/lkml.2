Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2JRKbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:31:24 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:64636 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2JRKbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:31:23 -0400
Date: Thu, 18 Oct 2012 14:31:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] procfs: Add VmFlags field in smaps output
Message-ID: <20121018103118.GC11750@moon>
References: <20121018095503.GB8790@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018095503.GB8790@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:55:03PM +0400, Cyrill Gorcunov wrote:
> Hi guys, in a sake of c/r we need to fetch additional
> VMA characteristics, so I though would /proc/pid/smaps
> be appropriate place for it? If yes, I would like to
> know if the output format provided below looks reasonable.
> 
> Please review, thanks!
> ---

Also I've had a bit different output format, not sure
which one is better.
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
 fs/proc/task_mmu.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -480,6 +480,25 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	seq_printf(m,
+		   "VmFlags:               %c%c%c%c%c%c%c%c%c\n",
+		   vma->vm_flags & VM_LOCKED ?		'l' : '-',
+		   vma->vm_flags & VM_GROWSDOWN ?	'g' : '-',
+		   vma->vm_flags & VM_RAND_READ ?	'r' : '-',
+		   vma->vm_flags & VM_SEQ_READ ?	'q' : '-',
+		   vma->vm_flags & VM_DONTCOPY ?	'-' : 'c',
+		   vma->vm_flags & VM_MERGEABLE ?	'm' : '-',
+		   vma->vm_flags & VM_HUGEPAGE ?	'h' : '-',
+		   vma->vm_flags & VM_NOHUGEPAGE ?	'-' : 'h',
+		   vma->vm_flags & VM_DONTDUMP ?	'-' : 'd');
+}
+#else
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma) { }
+#endif
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -535,6 +554,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
