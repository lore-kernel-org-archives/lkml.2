Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2JVT3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:29:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2JVT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:29:35 -0400
Date: Mon, 22 Oct 2012 12:29:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-Id: <20121022122934.d2e2fa57.akpm@linux-foundation.org>
In-Reply-To: <20121022191452.785366817@openvz.org>
References: <20121022191452.785366817@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 23:14:52 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Hi guys, during c/r sessions we've found that there is no way at
> the moment to fetch some VMA associated flags, such as mlock()
> and madvise(), thus the patches in this series intorduce new field
> into "smaps" output called VmFlags where all flags associated with
> the particular VMA is shown in two letter mnemonic.
> 
> Strictly speaking for c/r we only need mlock/madvise bits but it
> has been said that providing just a few flags looks somehow inconsistent.
> So all flags are here now.
> 
> Please review. Comments and complains are quite welcome!

Sigh, it's still a pretty nasty-looking interface.  Better ideas are
welcomed.

I joined the patches into one, massaged the changelog a bit and added a
couple more paragraphs explaining why we're doing this to ourselves.



From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: add VmFlags field in smaps output

During c/r sessions we've found that there is no way at the moment to
fetch some VMA associated flags, such as mlock() and madvise(), thus the
patches in this series intorduce new field into "smaps" output called
VmFlags where all flags associated with the particular VMA is shown in two
letter mnemonic.

Strictly speaking for c/r we only need mlock/madvise bits but it has been
said that providing just a few flags looks somehow inconsistent.  So all
flags are here now.

When we restore a VMA after checkpoint we would like to know if the area
was locked or say it had mergeable attribute, but at moment the kernel
does not provide such information, thus we can't figure out if we should
call mlock/madvise on VMA restore.

This patch adds new VmFlags field to smaps output with vma->vm_flags
encoded.

This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
other applications may start to use these fields.

The data is encoded in a somewhat awkward name:value form, to encourage
userspace to be prepared for fields being added or removed in the future.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   38 ++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   32 ++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output
+++ a/fs/proc/task_mmu.c
@@ -526,6 +526,36 @@ static int smaps_pte_range(pmd_t *pmd, u
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
@@ -581,6 +611,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
diff -puN Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output
+++ a/Documentation/filesystems/proc.txt
@@ -142,7 +142,7 @@ Table 1-1: Process specific entries in /
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
-		each mapping
+		each mapping and flags associated with it
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -415,6 +415,7 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
+VmFlags: RD:1 WR:0 EX:1 SH:0 MR:1 MW:1 ME:1 MS:0 GD:0 PF:0 DW:1 LO:0 IO:0 SR:0 RR:0 DC:0 DE:0 AC:0 NR:0 HT:0 NL:0 AR:0 DD:0 MM:0 HG:0 NH:0 MG:0
 
 The first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
@@ -430,6 +431,41 @@ and a page is modified, the file page is
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
 
+"VmFlags" field deserves a separate description. This member represents the kernel
+flags associated with the particular virtual memory area in two letter encoded
+manner. The codes are the following:
+    RD  - readable
+    WR  - writeable
+    EX  - executable
+    SH  - shared
+    MR  - may read
+    MW  - may write
+    ME  - may execute
+    MS  - may share
+    GD  - stack segment growns down
+    PF  - pure PFN range
+    DW  - disabled write to the mapped file
+    LO  - pages are locked in memory
+    IO  - memory mapped I/O area
+    SR  - sequential read advise provided
+    RR  - random read advise provided
+    DC  - do not copy area on fork
+    DE  - do not expand area on remapping
+    AC  - area is accountable
+    NR  - swap space is not reserved for the area
+    HT  - area uses huge tlb pages
+    NL  - non-linear mapping
+    AR  - architecture specific flag
+    DD  - do not include area into core dump
+    MM  - mixed map area
+    HG  - huge page advise flag
+    NH  - no-huge page advise flag
+    MG  - mergable advise flag
+
+Note that there is no guarantee that every flag and associated mnemonic will
+be present in all further kernel releases. Things get changed, the flags may
+be vanished or the reverse -- new added.
+
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
_

