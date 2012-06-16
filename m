Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2FPIvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 04:51:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34266 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2FPIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 04:51:10 -0400
Subject: [PATCH 3.5] c/r: prctl: less paranoid prctl_set_mm_exe_file()
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-mm@kvack.org, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Tejun Heo <tj@kernel.org>
Date: Sat, 16 Jun 2012 12:51:04 +0400
Message-ID: <20120616085104.14682.16723.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"no other files mapped" requirement from my previous patch
(c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal)
is too paranoid, it forbids operation even if there mapped one shared-anon vma.

Let's check that current mm->exe_file already unmapped, in this case exe_file
symlink already outdated and its changing is reasonable.

Plus, this patch fixes exit code in case operation success.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
---
 kernel/sys.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index f0ec44d..eb4c87a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1788,7 +1788,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 #ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
-	struct vm_area_struct *vma;
 	struct file *exe_file;
 	struct dentry *dentry;
 	int err;
@@ -1816,13 +1815,17 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	down_write(&mm->mmap_sem);
 
 	/*
-	 * Forbid mm->exe_file change if there are mapped other files.
+	 * Forbid mm->exe_file change if old file still mapped.
 	 */
 	err = -EBUSY;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (vma->vm_file && !path_equal(&vma->vm_file->f_path,
-						&exe_file->f_path))
-			goto exit_unlock;
+	if (mm->exe_file) {
+		struct vm_area_struct *vma;
+
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (vma->vm_file &&
+			    path_equal(&vma->vm_file->f_path,
+				       &mm->exe_file->f_path))
+				goto exit_unlock;
 	}
 
 	/*
@@ -1835,6 +1838,7 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
 		goto exit_unlock;
 
+	err = 0;
 	set_mm_exe_file(mm, exe_file);
 exit_unlock:
 	up_write(&mm->mmap_sem);

