Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2FFRKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:10:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49141 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225Ab2FFRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:10:34 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ipc: shm: restore MADV_REMOVE functionality on shared memory segments
Date: Wed,  6 Jun 2012 18:10:06 +0100
Message-Id: <1339002606-30921-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 17cf28af ("mm/fs: remove truncate_range") removed the
truncate_range inode operation in favour of the fallocate file
operation.

When using SYSV IPC shared memory segments, calling madvise with the
MADV_REMOVE advice on an area of shared memory will attempt to invoke
the .fallocate function for the shm_file_operations, which is NULL and
therefore returns -EOPNOTSUPP to userspace. The previous behaviour would
inherit the inode_operations from the underlying tmpfs file and invoke
truncate_range there.

This patch restores the previous behaviour by wrapping the underlying
fallocate function in shm_fallocate, as we do for fsync.

Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 ipc/shm.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 5e2cbfd..8830e79 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -393,6 +393,16 @@ static int shm_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return sfd->file->f_op->fsync(sfd->file, start, end, datasync);
 }
 
+static long shm_fallocate(struct file *file, int mode, loff_t offset,
+			  loff_t len)
+{
+	struct shm_file_data *sfd = shm_file_data(file);
+
+	if (!sfd->file->f_op->fallocate)
+		return -EINVAL;
+	return sfd->file->f_op->fallocate(file, mode, offset, len);
+}
+
 static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long addr, unsigned long len, unsigned long pgoff,
 	unsigned long flags)
@@ -410,6 +420,7 @@ static const struct file_operations shm_file_operations = {
 	.get_unmapped_area	= shm_get_unmapped_area,
 #endif
 	.llseek		= noop_llseek,
+	.fallocate	= shm_fallocate,
 };
 
 static const struct file_operations shm_file_operations_huge = {
@@ -418,6 +429,7 @@ static const struct file_operations shm_file_operations_huge = {
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 	.llseek		= noop_llseek,
+	.fallocate	= shm_fallocate,
 };
 
 int is_file_shm_hugepages(struct file *file)
-- 
1.7.4.1

