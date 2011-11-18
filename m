Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1KRKkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:40:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1KRKkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:40:24 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        WANG Cong <amwang@redhat.com>, linux-mm@kvack.org
Subject: [V2 PATCH] tmpfs: add fallocate support
Date: Fri, 18 Nov 2011 18:39:50 +0800
Message-Id: <1321612791-4764-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that systemd needs tmpfs to support fallocate,
see http://lkml.org/lkml/2011/10/20/275. This patch adds
fallocate support to tmpfs.

As we already have shmem_truncate_range(), it is also easy
to add FALLOC_FL_PUNCH_HOLE support too.

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
 mm/shmem.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d672250..96bf619 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
+#include <linux/falloc.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -1431,6 +1432,47 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	return error;
 }
 
+static long shmem_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	pgoff_t start = offset >> PAGE_CACHE_SHIFT;
+	pgoff_t end = DIV_ROUND_UP((offset + len), PAGE_CACHE_SIZE);
+	pgoff_t index = start;
+	loff_t i_size = i_size_read(inode);
+	struct page *page = NULL;
+	int ret = 0;
+
+	mutex_lock(&inode->i_mutex);
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		if (!(offset > i_size || (end << PAGE_CACHE_SHIFT) > i_size))
+			shmem_truncate_range(inode, offset,
+					     (end << PAGE_CACHE_SHIFT) - 1);
+		goto unlock;
+	}
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		ret = inode_newsize_ok(inode, (offset + len));
+		if (ret)
+			goto unlock;
+	}
+
+	while (index < end) {
+		ret = shmem_getpage(inode, index, &page, SGP_WRITE, NULL);
+		if (ret)
+			goto unlock;
+		if (page)
+			unlock_page(page);
+		index++;
+	}
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && (index << PAGE_CACHE_SHIFT) > i_size)
+		i_size_write(inode, index << PAGE_CACHE_SHIFT);
+
+unlock:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -2286,6 +2328,7 @@ static const struct file_operations shmem_file_operations = {
 	.fsync		= noop_fsync,
 	.splice_read	= shmem_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.fallocate	= shmem_fallocate,
 #endif
 };
 
