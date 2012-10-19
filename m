Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2JSJpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:45:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61504 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab2JSJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:45:40 -0400
Date: Fri, 19 Oct 2012 13:45:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [RFC] procfs: Add VmFlags field in smaps output
Message-ID: <20121019094536.GB11272@moon>
References: <20121018095503.GB8790@moon>
 <20121018103118.GC11750@moon>
 <20121018140259.dad6d5b5.akpm@linux-foundation.org>
 <20121018212835.GK8790@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018212835.GK8790@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:28:35AM +0400, Cyrill Gorcunov wrote:
> > 
> > A common way in which we do this future-proofing is to display the info
> > in name:value tuples (eg, /proc/meminfo).  So userspace parses for the
> > "name" rather than looking into a fixed position in the /proc output.
> > 
> > So....  with this thought in mind, perhaps a better output format would
> > be something like:
> > 
> > 	VmFlags: LO:1 GR:0 RA:0 SE:1 ...
> > 
> > ie: a two-character "name" and a boolean "value".  Something like that.
> 
> OK, Andrew, I'll try to come with something like that tomorrow, thanks!

Does the format below looks well enough (i'll make docs update as well
once things settle down)? Also I thought maybe it should be protected
with CAP_SYS_ADMIN or something?
---
Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -480,6 +480,33 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+#define __VM_FLAG(_f) (!!(vma->vm_flags & (_f)))
+	seq_printf(m, "VmFlags: "
+		   "RD:%d WR:%d EX:%d SH:%d MR:%d "
+		   "MW:%d ME:%d MS:%d GD:%d PF:%d "
+		   "DW:%d LO:%d IO:%d SR:%d RR:%d "
+		   "DC:%d DE:%d AC:%d NR:%d HT:%d "
+		   "NL:%d AR:%d DD:%d MM:%d HG:%d "
+		   "NH:%d MG:%d\n",
+		   __VM_FLAG(VM_READ), __VM_FLAG(VM_WRITE),
+		   __VM_FLAG(VM_EXEC), __VM_FLAG(VM_SHARED),
+		   __VM_FLAG(VM_MAYREAD), __VM_FLAG(VM_MAYWRITE),
+		   __VM_FLAG(VM_MAYEXEC), __VM_FLAG(VM_MAYSHARE),
+		   __VM_FLAG(VM_GROWSDOWN), __VM_FLAG(VM_PFNMAP),
+		   __VM_FLAG(VM_DENYWRITE), __VM_FLAG(VM_LOCKED),
+		   __VM_FLAG(VM_IO), __VM_FLAG(VM_SEQ_READ),
+		   __VM_FLAG(VM_RAND_READ), __VM_FLAG(VM_DONTCOPY),
+		   __VM_FLAG(VM_DONTEXPAND), __VM_FLAG(VM_ACCOUNT),
+		   __VM_FLAG(VM_NORESERVE), __VM_FLAG(VM_HUGETLB),
+		   __VM_FLAG(VM_NONLINEAR), __VM_FLAG(VM_ARCH_1),
+		   __VM_FLAG(VM_DONTDUMP), __VM_FLAG(VM_MIXEDMAP),
+		   __VM_FLAG(VM_HUGEPAGE), __VM_FLAG(VM_NOHUGEPAGE),
+		   __VM_FLAG(VM_MERGEABLE));
+#undef __VM_FLAG
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -535,6 +562,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
