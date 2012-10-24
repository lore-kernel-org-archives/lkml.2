Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab2JXIpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:45:25 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50346 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab2JXIpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:45:20 -0400
Date: Wed, 24 Oct 2012 12:45:15 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: akpm@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, xemul@parallels.com, sfr@canb.auug.org.au,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
Message-ID: <20121024084515.GB30983@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:02:59PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-2
> has been added to the -mm tree.  Its filename is
>      procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch
> 
> ------------------------------------------------------
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-2
> 
> Use designated init to assign "??" mnemonic on unknown flags.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew, could you stack the patch below on top, this one
should be a final for sure ;-)
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-on-top-2

Make assignment more readable [by peterz@] and fix bit
tests (we need unsigned long here explicitly stated).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/task_mmu.c |   63 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -482,6 +482,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 
 static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 {
+#define __VM_FLAG(_f, _s)	[ilog2(_f)] = {(const char [2]){_s}}
+
 	/*
 	 * Don't forget to update Documentation/ on changes.
 	 */
@@ -491,46 +493,49 @@ static void show_smap_vma_flags(struct s
 		/*
 		 * In case if we meet a flag we don't know about.
 		 */
-		[0 ... (BITS_PER_LONG-1)] = { {'?', '?'} },
+		[0 ... (BITS_PER_LONG-1)] = { (const char [2]){"??"} },
 
-		[ilog2(VM_READ)]	= { {'r', 'd'} },
-		[ilog2(VM_WRITE)]	= { {'w', 'r'} },
-		[ilog2(VM_EXEC)]	= { {'e', 'x'} },
-		[ilog2(VM_SHARED)]	= { {'s', 'h'} },
-		[ilog2(VM_MAYREAD)]	= { {'m', 'r'} },
-		[ilog2(VM_MAYWRITE)]	= { {'m', 'w'} },
-		[ilog2(VM_MAYEXEC)]	= { {'m', 'e'} },
-		[ilog2(VM_MAYSHARE)]	= { {'m', 's'} },
-		[ilog2(VM_GROWSDOWN)]	= { {'g', 'd'} },
-		[ilog2(VM_PFNMAP)]	= { {'p', 'f'} },
-		[ilog2(VM_DENYWRITE)]	= { {'d', 'w'} },
-		[ilog2(VM_LOCKED)]	= { {'l', 'o'} },
-		[ilog2(VM_IO)]		= { {'i', 'o'} },
-		[ilog2(VM_SEQ_READ)]	= { {'s', 'r'} },
-		[ilog2(VM_RAND_READ)]	= { {'r', 'r'} },
-		[ilog2(VM_DONTCOPY)]	= { {'d', 'c'} },
-		[ilog2(VM_DONTEXPAND)]	= { {'d', 'e'} },
-		[ilog2(VM_ACCOUNT)]	= { {'a', 'c'} },
-		[ilog2(VM_NORESERVE)]	= { {'n', 'r'} },
-		[ilog2(VM_HUGETLB)]	= { {'h', 't'} },
-		[ilog2(VM_NONLINEAR)]	= { {'n', 'l'} },
-		[ilog2(VM_ARCH_1)]	= { {'a', 'r'} },
-		[ilog2(VM_DONTDUMP)]	= { {'d', 'd'} },
-		[ilog2(VM_MIXEDMAP)]	= { {'m', 'm'} },
-		[ilog2(VM_HUGEPAGE)]	= { {'h', 'g'} },
-		[ilog2(VM_NOHUGEPAGE)]	= { {'n', 'h'} },
-		[ilog2(VM_MERGEABLE)]	= { {'m', 'g'} },
+		__VM_FLAG(VM_READ,	"rd"),
+		__VM_FLAG(VM_WRITE,	"wr"),
+		__VM_FLAG(VM_EXEC,	"ex"),
+		__VM_FLAG(VM_SHARED,	"sh"),
+		__VM_FLAG(VM_MAYREAD,	"mr"),
+		__VM_FLAG(VM_MAYWRITE,	"mw"),
+		__VM_FLAG(VM_MAYEXEC,	"me"),
+		__VM_FLAG(VM_MAYSHARE,	"ms"),
+		__VM_FLAG(VM_GROWSDOWN,	"gd"),
+		__VM_FLAG(VM_PFNMAP,	"pf"),
+		__VM_FLAG(VM_DENYWRITE,	"dw"),
+		__VM_FLAG(VM_LOCKED,	"lo"),
+		__VM_FLAG(VM_IO,	"io"),
+		__VM_FLAG(VM_SEQ_READ,	"sr"),
+		__VM_FLAG(VM_RAND_READ,	"rr"),
+		__VM_FLAG(VM_DONTCOPY,	"dc"),
+		__VM_FLAG(VM_DONTEXPAND,"de"),
+		__VM_FLAG(VM_ACCOUNT,	"ac"),
+		__VM_FLAG(VM_NORESERVE,	"nr"),
+		__VM_FLAG(VM_HUGETLB,	"ht"),
+		__VM_FLAG(VM_NONLINEAR,	"nl"),
+		__VM_FLAG(VM_ARCH_1,	"ar"),
+		__VM_FLAG(VM_DONTDUMP,	"dd"),
+		__VM_FLAG(VM_MIXEDMAP,	"mm"),
+		__VM_FLAG(VM_HUGEPAGE,	"hg"),
+		__VM_FLAG(VM_NOHUGEPAGE,"nh"),
+		__VM_FLAG(VM_MERGEABLE,	"mg"),
 	};
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
 	for (i = 0; i < BITS_PER_LONG; i++) {
-		if (vma->vm_flags & (1 << i))
+		if (vma->vm_flags & (1ul << i)) {
 			seq_printf(m, "%c%c ",
 				   mnemonics[i].l[0],
 				   mnemonics[i].l[1]);
+		}
 	}
 	seq_putc(m, '\n');
+
+#undef __VM_FLAG
 }
 
 static int show_smap(struct seq_file *m, void *v, int is_pid)
