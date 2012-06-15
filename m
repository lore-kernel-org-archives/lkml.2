Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2FOPNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:13:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2FOPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:13:16 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: [PATCH v2 1/2] msync: support syncing a small part of the file
Date: Fri, 15 Jun 2012 17:12:58 +0200
Message-Id: <1339773179-31210-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339773179-31210-1-git-send-email-pbonzini@redhat.com>
References: <1339773179-31210-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msync does not need to flush changes to the entire file, even with MS_SYNC.
Instead, it can use vfs_fsync_range to only synchronize a part of the file.
This is part of the specification; expecting msync to synchronize all the
file would take a very creative interpretation of the manual page as well
as the specification.

In addition, not all metadata has to be synced; msync is closer to
fdatasync than it is to fsync.  So, pass 1 to vfs_fsync_range.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Friesen <chris.friesen@genband.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
        v1->v2: fixed off-by-one in vall to vfs_fsync_range.

 mm/msync.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/msync.c b/mm/msync.c
index 632df45..505fe99 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 
 /*
- * MS_SYNC syncs the entire file - including mappings.
+ * MS_SYNC syncs the specified range - including mappings.
  *
  * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
  * Nor does it marks the relevant pages dirty (it used to up to 2.6.17).
@@ -58,6 +58,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 	vma = find_vma(mm, start);
 	for (;;) {
 		struct file *file;
+		unsigned long next;
+		loff_t file_offset;
 
 		/* Still start < end. */
 		error = -ENOMEM;
@@ -77,18 +79,23 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 			goto out_unlock;
 		}
 		file = vma->vm_file;
-		start = vma->vm_end;
+		next = min(end, vma->vm_end);
 		if ((flags & MS_SYNC) && file &&
 				(vma->vm_flags & VM_SHARED)) {
+			file_offset = vma->vm_pgoff * PAGE_SIZE;
 			get_file(file);
 			up_read(&mm->mmap_sem);
-			error = vfs_fsync(file, 0);
+			error = vfs_fsync_range(file,
+				    start - vma->vm_start + file_offset,
+				    next - vma->vm_start + file_offset - 1, 1);
 			fput(file);
+			start = next;
 			if (error || start >= end)
 				goto out;
 			down_read(&mm->mmap_sem);
 			vma = find_vma(mm, start);
 		} else {
+			start = next;
 			if (start >= end) {
 				error = 0;
 				goto out_unlock;
-- 
1.7.1



