Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1JXMr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/24] GFS2: Clean up dir hash table reading
Date: Mon, 24 Oct 2011 13:48:15 +0100
Message-Id: <1319460518-9046-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is now only a single caller to gfs2_dir_read_data()
and it has a number of constant arguments, we can factor
those out. Also some tests relating to the inode size were
being done twice.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1cc2f8e..2045d70 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -240,16 +240,15 @@ fail:
 	return error;
 }
 
-static int gfs2_dir_read_stuffed(struct gfs2_inode *ip, char *buf,
-				 u64 offset, unsigned int size)
+static int gfs2_dir_read_stuffed(struct gfs2_inode *ip, __be64 *buf,
+				 unsigned int size)
 {
 	struct buffer_head *dibh;
 	int error;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		offset += sizeof(struct gfs2_dinode);
-		memcpy(buf, dibh->b_data + offset, size);
+		memcpy(buf, dibh->b_data + sizeof(struct gfs2_dinode), size);
 		brelse(dibh);
 	}
 
@@ -261,13 +260,12 @@ static int gfs2_dir_read_stuffed(struct gfs2_inode *ip, char *buf,
  * gfs2_dir_read_data - Read a data from a directory inode
  * @ip: The GFS2 Inode
  * @buf: The buffer to place result into
- * @offset: File offset to begin jdata_readng from
  * @size: Amount of data to transfer
  *
  * Returns: The amount of data actually copied or the error
  */
-static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
-			      unsigned int size, unsigned ra)
+static int gfs2_dir_read_data(struct gfs2_inode *ip, __be64 *buf,
+			      unsigned int size)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	u64 lblock, dblock;
@@ -275,24 +273,14 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
 	unsigned int o;
 	int copied = 0;
 	int error = 0;
-	u64 disksize = i_size_read(&ip->i_inode);
-
-	if (offset >= disksize)
-		return 0;
-
-	if (offset + size > disksize)
-		size = disksize - offset;
-
-	if (!size)
-		return 0;
 
 	if (gfs2_is_stuffed(ip))
-		return gfs2_dir_read_stuffed(ip, buf, offset, size);
+		return gfs2_dir_read_stuffed(ip, buf, size);
 
 	if (gfs2_assert_warn(sdp, gfs2_is_jdata(ip)))
 		return -EINVAL;
 
-	lblock = offset;
+	lblock = 0;
 	o = do_div(lblock, sdp->sd_jbsize) + sizeof(struct gfs2_meta_header);
 
 	while (copied < size) {
@@ -311,8 +299,6 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
 			if (error || !dblock)
 				goto fail;
 			BUG_ON(extlen < 1);
-			if (!ra)
-				extlen = 1;
 			bh = gfs2_meta_ra(ip->i_gl, dblock, extlen);
 		} else {
 			error = gfs2_meta_read(ip->i_gl, dblock, DIO_WAIT, &bh);
@@ -328,7 +314,7 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
 		extlen--;
 		memcpy(buf, bh->b_data + o, amount);
 		brelse(bh);
-		buf += amount;
+		buf += (amount/sizeof(__be64));
 		copied += amount;
 		lblock++;
 		o = sizeof(struct gfs2_meta_header);
@@ -371,7 +357,7 @@ static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
 	if (hc == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	ret = gfs2_dir_read_data(ip, (char *)hc, 0, hsize, 1);
+	ret = gfs2_dir_read_data(ip, hc, hsize);
 	if (ret < 0) {
 		kfree(hc);
 		return ERR_PTR(ret);
-- 
1.7.4.4

