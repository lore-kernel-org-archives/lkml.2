Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2JWHPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:15:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52767 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab2JWHPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:15:54 -0400
Date: Tue, 23 Oct 2012 11:15:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121023071549.GC7020@moon>
References: <20121022191452.785366817@openvz.org>
 <20121022122934.d2e2fa57.akpm@linux-foundation.org>
 <5085B1A8.4020609@parallels.com>
 <20121022205641.GL2303@moon>
 <20121022213449.GH31440@moon>
 <20121022145158.53bddfc1.akpm@linux-foundation.org>
 <20121023061341.GA7020@moon>
 <20121022233025.09ec2d92.akpm@linux-foundation.org>
 <20121023063430.GB7020@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023063430.GB7020@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:34:30AM +0400, Cyrill Gorcunov wrote:
> On Mon, Oct 22, 2012 at 11:30:25PM -0700, Andrew Morton wrote:
> ...
> > > Yup, but not only that, this kind of trick hides associativity between
> > > VM_ constant and mnemonic, so on changes one would have to figure out
> > > which position some flag has in this foo[] array, so I vote for not
> > > use it :-)
> > 
> > Well you could do
> > 
> > struct {
> > 	char x[2];
> > } y[] = {
> > 	[CLOG2(VM_DONTEXPAND)] =	{ 'd', 'e' },
> > 	[CLOG2(VM_ACCOUNT)] =		{ 'a', 'c' },
> > 	[CLOG2(VM_NORESERVE)] =		{ 'n', 'r' },
> > };
> > 
> > 	...
> > 
> > 	for (i = 0; i < BITS_PER_LONG; i++) {
> > 		if (flags & (1 << i))
> > 			seq_printf("%c%c ", y[i][0], y[i][1]);
> > 	}
> > 
> > where CLOG2() is extracted from the guts of ilog2().
> > 
> > I'll stop now :)
> 
> Yup, this one will be a wy better. Letme try it out :)

ilog2 works well enough here as well.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: add VmFlags field in smaps output v3

During c/r sessions we've found that there is no way at the moment to
fetch some VMA associated flags, such as mlock() and madvise().

This leads us to a problem -- we don't know if we should call for
mlock() and/or madvise() after restore on the vma area we're bringing
back to life.

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

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

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
+
+	const struct {
+		const char l[2];
+	} mnemonics[BITS_PER_LONG] = {
+		[ilog2(VM_READ)]	= { .l = {'r', 'd'} },
+		[ilog2(VM_WRITE)]	= { .l = {'w', 'r'} },
+		[ilog2(VM_EXEC)]	= { .l = {'e', 'x'} },
+		[ilog2(VM_SHARED)]	= { .l = {'s', 'h'} },
+		[ilog2(VM_MAYREAD)]	= { .l = {'m', 'r'} },
+		[ilog2(VM_MAYWRITE)]	= { .l = {'m', 'w'} },
+		[ilog2(VM_MAYEXEC)]	= { .l = {'m', 'e'} },
+		[ilog2(VM_MAYSHARE)]	= { .l = {'m', 's'} },
+		[ilog2(VM_GROWSDOWN)]	= { .l = {'g', 'd'} },
+		[ilog2(VM_PFNMAP)]	= { .l = {'p', 'f'} },
+		[ilog2(VM_DENYWRITE)]	= { .l = {'d', 'w'} },
+		[ilog2(VM_LOCKED)]	= { .l = {'l', 'o'} },
+		[ilog2(VM_IO)]		= { .l = {'i', 'o'} },
+		[ilog2(VM_SEQ_READ)]	= { .l = {'s', 'r'} },
+		[ilog2(VM_RAND_READ)]	= { .l = {'r', 'r'} },
+		[ilog2(VM_DONTCOPY)]	= { .l = {'d', 'c'} },
+		[ilog2(VM_DONTEXPAND)]	= { .l = {'d', 'e'} },
+		[ilog2(VM_ACCOUNT)]	= { .l = {'a', 'c'} },
+		[ilog2(VM_NORESERVE)]	= { .l = {'n', 'r'} },
+		[ilog2(VM_HUGETLB)]	= { .l = {'h', 't'} },
+		[ilog2(VM_NONLINEAR)]	= { .l = {'n', 'l'} },
+		[ilog2(VM_ARCH_1)]	= { .l = {'a', 'r'} },
+		[ilog2(VM_DONTDUMP)]	= { .l = {'d', 'd'} },
+		[ilog2(VM_MIXEDMAP)]	= { .l = {'m', 'm'} },
+		[ilog2(VM_HUGEPAGE)]	= { .l = {'h', 'g'} },
+		[ilog2(VM_NOHUGEPAGE)]	= { .l = {'n', 'h'} },
+		[ilog2(VM_MERGEABLE)]	= { .l = {'m', 'g'} },
+	};
+
+	size_t i;
+
+	seq_puts(m, "VmFlags: ");
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		if (vma->vm_flags & (1 << i))
+			seq_printf(m, "%c%c ",
+				   mnemonics[i].l[0],
+				   mnemonics[i].l[1]);
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
