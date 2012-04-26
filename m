Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2DZQIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:08:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37198 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757867Ab2DZQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:08:48 -0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: c/r: prctl: Drop VMA flags test on PR_SET_MM_ stack data assignment
Date: Thu, 26 Apr 2012 20:08:35 +0400
Message-Id: <1335456515-18857-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

With the

 | commit b76437579d1344b612cf1851ae610c636cec7db0
 | Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
 | Date:   Wed Mar 21 16:34:04 2012 -0700
 |
 | procfs: mark thread stack correctly in proc/<pid>/maps

the stack allocated via clone() is marked in /proc/<pid>/maps as
[stack:%d] thus it might be out of the former mm->start_stack/end_stack
values (and even has some custom VMA flags set). So to be able to
restore mm->start_stack/end_stack drop vma flags test, but still
require the undrlied VMA to exist.

As always note this feature is under CONFIG_CHECKPOINT_RESTORE
and requires CAP_SYS_RESOURCE to be granted.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sys.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1704,14 +1704,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-static bool vma_flags_mismatch(struct vm_area_struct *vma,
-			       unsigned long required,
-			       unsigned long banned)
-{
-	return (vma->vm_flags & required) != required ||
-		(vma->vm_flags & banned);
-}
-
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct file *exe_file;
@@ -1842,12 +1834,6 @@ static int prctl_set_mm(int opt, unsigne
 			error = -EFAULT;
 			goto out;
 		}
-#ifdef CONFIG_STACK_GROWSUP
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
-#else
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSDOWN, 0))
-#endif
-			goto out;
 		if (opt == PR_SET_MM_START_STACK)
 			mm->start_stack = addr;
 		else if (opt == PR_SET_MM_ARG_START)
