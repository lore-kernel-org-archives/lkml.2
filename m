Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2DPWz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:55:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63952 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab2DPWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:55:25 -0400
Date: Tue, 17 Apr 2012 02:55:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data
 assignment
Message-ID: <20120416225520.GD9756@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mm::start_code, end_code, start_data, end_data members
are set during startup of executable file and are not changed
after.

But the program itself might map new executable or/and data areas in
time so the original values written into mm fields mentioned above
might not have correspond VMA area at all, thus if one try to
use this prctl codes without underlied VMA, the error will be
returned.

Drop this requirement. This shrinks the code and eliminates
redundant calls to vma_flags_mismatch. The worst thing one can
do (if say to write some bad values here) -- the weird results
will be shown in /proc/$pid/statm or in /proc/pid/stat.

Still, assignement of data on stack (such as command line and
environment variables) requires the underlied VMA to exist.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
This code is under CONFIG_CHECKPOINT_RESTORE. I would really
appreciate some review, just to check I've not missed something.

 kernel/sys.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1777,38 +1777,18 @@ static int prctl_set_mm(int opt, unsigne
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
-	if (opt != PR_SET_MM_START_BRK &&
-	    opt != PR_SET_MM_BRK &&
-	    opt != PR_SET_MM_AUXV) {
-		/* It must be existing VMA */
-		if (!vma || vma->vm_start > addr)
-			goto out;
-	}
-
-	error = -EINVAL;
 	switch (opt) {
 	case PR_SET_MM_START_CODE:
+		mm->start_code = addr;
+		break;
 	case PR_SET_MM_END_CODE:
-		if (vma_flags_mismatch(vma, VM_READ | VM_EXEC,
-				       VM_WRITE | VM_MAYSHARE))
-			goto out;
-
-		if (opt == PR_SET_MM_START_CODE)
-			mm->start_code = addr;
-		else
-			mm->end_code = addr;
+		mm->end_code = addr;
 		break;
-
 	case PR_SET_MM_START_DATA:
+		mm->start_data = addr;
+		break;
 	case PR_SET_MM_END_DATA:
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE,
-				       VM_EXEC | VM_MAYSHARE))
-			goto out;
-
-		if (opt == PR_SET_MM_START_DATA)
-			mm->start_data = addr;
-		else
-			mm->end_data = addr;
+		mm->end_data = addr;
 		break;
 
 	case PR_SET_MM_START_BRK:
@@ -1847,6 +1827,8 @@ static int prctl_set_mm(int opt, unsigne
 	case PR_SET_MM_ARG_END:
 	case PR_SET_MM_ENV_START:
 	case PR_SET_MM_ENV_END:
+		if (!vma)
+			goto out;
 #ifdef CONFIG_STACK_GROWSUP
 		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
 #else
