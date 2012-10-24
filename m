Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab2JXM1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:27:36 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55552 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2JXM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:27:34 -0400
Date: Wed, 24 Oct 2012 16:27:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH -mm] procfs: add VmFlags field in smaps output v3
Message-ID: <20121024122730.GO30983@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During c/r sessions we've found that there is no way at the moment to
fetch some VMA associated flags, such as mlock() and madvise().

This leads us to a problem -- we don't know if we should call for mlock()
and/or madvise() after restore on the vma area we're bringing back to
life.

This patch intorduces a new field into "smaps" output called VmFlags,
where all set flags associated with the particular VMA is shown as two
letter mnemonics.

[ Strictly speaking for c/r we only need mlock/madvise bits but it has been
  said that providing just a few flags looks somehow inconsistent.  So all
  flags are here now. ]

This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
other applications may start to use these fields.

The data is encoded in a somewhat awkward two letters mnemonic form, to
encourage userspace to be prepared for fields being added or removed in
the future.

[peterz: props to use for_each_set_bit]
[stephen: props to use array instead of struct]
[akpm: overall redesign and simplification]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Andrew, this patch is one instead of all those small series which
is in -mm tree now. If there will be no more comments could you
please substitute the existing series with it.

 Documentation/filesystems/proc.txt |   40 +++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 2 deletions(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -142,7 +142,7 @@ Table 1-1: Process specific entries in /
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
-		each mapping
+		each mapping and flags associated with it
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -415,8 +415,9 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
+VmFlags: rd ex mr mw me de
 
-The first of these lines shows the same information as is displayed for the
+the first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
 (size), the amount of the mapping that is currently resident in RAM (RSS), the
 process' proportional share of this mapping (PSS), the number of clean and
@@ -430,6 +431,41 @@ and a page is modified, the file page is
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
 
+"VmFlags" field deserves a separate description. This member represents the kernel
+flags associated with the particular virtual memory area in two letter encoded
+manner. The codes are the following:
+    rd  - readable
+    wr  - writeable
+    ex  - executable
+    sh  - shared
+    mr  - may read
+    mw  - may write
+    me  - may execute
+    ms  - may share
+    gd  - stack segment growns down
+    pf  - pure PFN range
+    dw  - disabled write to the mapped file
+    lo  - pages are locked in memory
+    io  - memory mapped I/O area
+    sr  - sequential read advise provided
+    rr  - random read advise provided
+    dc  - do not copy area on fork
+    de  - do not expand area on remapping
+    ac  - area is accountable
+    nr  - swap space is not reserved for the area
+    ht  - area uses huge tlb pages
+    nl  - non-linear mapping
+    ar  - architecture specific flag
+    dd  - do not include area into core dump
+    mm  - mixed map area
+    hg  - huge page advise flag
+    nh  - no-huge page advise flag
+    mg  - mergable advise flag
+
+Note that there is no guarantee that every flag and associated mnemonic will
+be present in all further kernel releases. Things get changed, the flags may
+be vanished or the reverse -- new added.
+
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -480,6 +480,56 @@ static int smaps_pte_range(pmd_t *pmd, u
 	return 0;
 }
 
+static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
+{
+	/*
+	 * Don't forget to update Documentation/ on changes.
+	 */
+	static const char mnemonics[BITS_PER_LONG][2] = {
+		/*
+		 * In case if we meet a flag we don't know about.
+		 */
+		[0 ... (BITS_PER_LONG-1)] = { "??" },
+
+		[ilog2(VM_READ)]	= "rd",
+		[ilog2(VM_WRITE)]	= "wr",
+		[ilog2(VM_EXEC)]	= "ex",
+		[ilog2(VM_SHARED)]	= "sh",
+		[ilog2(VM_MAYREAD)]	= "mr",
+		[ilog2(VM_MAYWRITE)]	= "mw",
+		[ilog2(VM_MAYEXEC)]	= "me",
+		[ilog2(VM_MAYSHARE)]	= "ms",
+		[ilog2(VM_GROWSDOWN)]	= "gd",
+		[ilog2(VM_PFNMAP)]	= "pf",
+		[ilog2(VM_DENYWRITE)]	= "dw",
+		[ilog2(VM_LOCKED)]	= "lo",
+		[ilog2(VM_IO)]		= "io",
+		[ilog2(VM_SEQ_READ)]	= "sr",
+		[ilog2(VM_RAND_READ)]	= "rr",
+		[ilog2(VM_DONTCOPY)]	= "dc",
+		[ilog2(VM_DONTEXPAND)]	= "de",
+		[ilog2(VM_ACCOUNT)]	= "ac",
+		[ilog2(VM_NORESERVE)]	= "nr",
+		[ilog2(VM_HUGETLB)]	= "ht",
+		[ilog2(VM_NONLINEAR)]	= "nl",
+		[ilog2(VM_ARCH_1)]	= "ar",
+		[ilog2(VM_DONTDUMP)]	= "dd",
+		[ilog2(VM_MIXEDMAP)]	= "mm",
+		[ilog2(VM_HUGEPAGE)]	= "hg",
+		[ilog2(VM_NOHUGEPAGE)]	= "nh",
+		[ilog2(VM_MERGEABLE)]	= "mg",
+	};
+	size_t i;
+
+	seq_puts(m, "VmFlags: ");
+	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
+		seq_printf(m, "%c%c ",
+			   mnemonics[i][0],
+			   mnemonics[i][1]);
+	}
+	seq_putc(m, '\n');
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -535,6 +585,8 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	show_smap_vma_flags(m, vma);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
