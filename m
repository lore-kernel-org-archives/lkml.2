Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2DQTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:49:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37690 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2DQTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:49:50 -0400
Date: Tue, 17 Apr 2012 23:49:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data
 assignment
Message-ID: <20120417194945.GB14663@moon>
References: <20120416225520.GD9756@moon>
 <CAGXu5jKnfOsXGTx8QbKCCH9C9c+szFwi5oA1R99pjCue9kfpWg@mail.gmail.com>
 <20120417191916.GQ1906@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417191916.GQ1906@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:19:16PM +0400, Cyrill Gorcunov wrote:
...
> > Since this is CAP_SYS_RESOURCE, and mmap_min_addr is CAP_SYS_RAWIO,
> > how about a lower-bounds check against mmap_min_addr? (We're already
> > doing the TASK_SIZE upper check, so this additional sanity checking
> > seems reasonable to me.)
> 
> I think this is good idea, thanks Kees. I'll check it out.

Updated and tested version is below.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] c/r: prctl: Simplify PR_SET_MM on mm::code/data assignment v2

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

v2:
 Also make sure the address being set is greater than mmap_min_addr.
 Suggested by Kees Cook.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sys.c |   36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1771,44 +1771,24 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE)
+	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;
 
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
