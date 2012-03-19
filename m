Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2CSKuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab2CSKt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/12] GFS2: call gfs2_write_alloc_required for each chunk
Date: Mon, 19 Mar 2012 10:25:28 +0000
Message-Id: <1332152728-4027-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

gfs2_fallocate was calling gfs2_write_alloc_required() once at the start of
the function. This caused problems since gfs2_write_alloc_required used a
long unsigned int for the len, but gfs2_fallocate could allocate a much
larger amount.  This patch will move the call into the loop where the
chunks are actually allocated and zeroed out. This will keep the allocation
size under the limit, and also allow gfs2_fallocate to quickly skip over
sections of the file that are already completely allocated.

fallcate_chunk was also not correctly setting the file size.  It was using the
len veriable to find the last block written to, but by the time it was setting
the size, the len variable had already been decremented to 0.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 310f2fb..7683458 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -676,6 +676,7 @@ static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *dibh;
 	int error;
+	loff_t size = len;
 	unsigned int nr_blks;
 	sector_t lblock = offset >> inode->i_blkbits;
 
@@ -709,8 +710,8 @@ static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
 			goto out;
 		}
 	}
-	if (offset + len > inode->i_size && !(mode & FALLOC_FL_KEEP_SIZE))
-		i_size_write(inode, offset + len);
+	if (offset + size > inode->i_size && !(mode & FALLOC_FL_KEEP_SIZE))
+		i_size_write(inode, offset + size);
 
 	mark_inode_dirty(inode);
 
@@ -779,12 +780,14 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (unlikely(error))
 		goto out_uninit;
 
-	if (!gfs2_write_alloc_required(ip, offset, len))
-		goto out_unlock;
-
 	while (len > 0) {
 		if (len < bytes)
 			bytes = len;
+		if (!gfs2_write_alloc_required(ip, offset, bytes)) {
+			len -= bytes;
+			offset += bytes;
+			continue;
+		}
 		qa = gfs2_qadata_get(ip);
 		if (!qa) {
 			error = -ENOMEM;
-- 
1.7.4

