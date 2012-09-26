Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2IZIvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2IZIv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/27] GFS2: Merge two nearly identical xattr functions
Date: Wed, 26 Sep 2012 09:25:22 +0100
Message-Id: <1348647948-3219-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were two functions in the xattr code which were nearly
identical, the only difference being that one was copy data into
the unstuffed xattrs and the other was copying data out from it.

This patch merges the two functions such that the code which deal
with iteration over the unstuffed xattrs is no longer duplicated.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 27a0b4a..5404ed1 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -448,17 +448,18 @@ ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
 }
 
 /**
- * ea_get_unstuffed - actually copies the unstuffed data into the
- *                    request buffer
+ * ea_iter_unstuffed - copies the unstuffed xattr data to/from the
+ *                     request buffer
  * @ip: The GFS2 inode
  * @ea: The extended attribute header structure
- * @data: The data to be copied
+ * @din: The data to be copied in
+ * @dout: The data to be copied out (one of din,dout will be NULL)
  *
  * Returns: errno
  */
 
-static int ea_get_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
-			    char *data)
+static int gfs2_iter_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
+			       const char *din, char *dout)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head **bh;
@@ -467,6 +468,8 @@ static int ea_get_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 	__be64 *dataptrs = GFS2_EA2DATAPTRS(ea);
 	unsigned int x;
 	int error = 0;
+	unsigned char *pos;
+	unsigned cp_size;
 
 	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_NOFS);
 	if (!bh)
@@ -497,12 +500,21 @@ static int ea_get_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			goto out;
 		}
 
-		memcpy(data, bh[x]->b_data + sizeof(struct gfs2_meta_header),
-		       (sdp->sd_jbsize > amount) ? amount : sdp->sd_jbsize);
+		pos = bh[x]->b_data + sizeof(struct gfs2_meta_header);
+		cp_size = (sdp->sd_jbsize > amount) ? amount : sdp->sd_jbsize;
 
-		amount -= sdp->sd_jbsize;
-		data += sdp->sd_jbsize;
+		if (dout) {
+			memcpy(dout, pos, cp_size);
+			dout += sdp->sd_jbsize;
+		}
+
+		if (din) {
+			gfs2_trans_add_bh(ip->i_gl, bh[x], 1);
+			memcpy(pos, din, cp_size);
+			din += sdp->sd_jbsize;
+		}
 
+		amount -= sdp->sd_jbsize;
 		brelse(bh[x]);
 	}
 
@@ -523,7 +535,7 @@ static int gfs2_ea_get_copy(struct gfs2_inode *ip, struct gfs2_ea_location *el,
 		memcpy(data, GFS2_EA2DATA(el->el_ea), len);
 		return len;
 	}
-	ret = ea_get_unstuffed(ip, el->el_ea, data);
+	ret = gfs2_iter_unstuffed(ip, el->el_ea, NULL, data);
 	if (ret < 0)
 		return ret;
 	return len;
@@ -1220,69 +1232,23 @@ static int gfs2_xattr_set(struct dentry *dentry, const char *name,
 				size, flags, type);
 }
 
+
 static int ea_acl_chmod_unstuffed(struct gfs2_inode *ip,
 				  struct gfs2_ea_header *ea, char *data)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct buffer_head **bh;
 	unsigned int amount = GFS2_EA_DATA_LEN(ea);
 	unsigned int nptrs = DIV_ROUND_UP(amount, sdp->sd_jbsize);
-	__be64 *dataptrs = GFS2_EA2DATAPTRS(ea);
-	unsigned int x;
-	int error;
-
-	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_NOFS);
-	if (!bh)
-		return -ENOMEM;
-
-	error = gfs2_trans_begin(sdp, nptrs + RES_DINODE, 0);
-	if (error)
-		goto out;
-
-	for (x = 0; x < nptrs; x++) {
-		error = gfs2_meta_read(ip->i_gl, be64_to_cpu(*dataptrs), 0,
-				       bh + x);
-		if (error) {
-			while (x--)
-				brelse(bh[x]);
-			goto fail;
-		}
-		dataptrs++;
-	}
-
-	for (x = 0; x < nptrs; x++) {
-		error = gfs2_meta_wait(sdp, bh[x]);
-		if (error) {
-			for (; x < nptrs; x++)
-				brelse(bh[x]);
-			goto fail;
-		}
-		if (gfs2_metatype_check(sdp, bh[x], GFS2_METATYPE_ED)) {
-			for (; x < nptrs; x++)
-				brelse(bh[x]);
-			error = -EIO;
-			goto fail;
-		}
-
-		gfs2_trans_add_bh(ip->i_gl, bh[x], 1);
-
-		memcpy(bh[x]->b_data + sizeof(struct gfs2_meta_header), data,
-		       (sdp->sd_jbsize > amount) ? amount : sdp->sd_jbsize);
-
-		amount -= sdp->sd_jbsize;
-		data += sdp->sd_jbsize;
-
-		brelse(bh[x]);
-	}
+	int ret;
 
-out:
-	kfree(bh);
-	return error;
+	ret = gfs2_trans_begin(sdp, nptrs + RES_DINODE, 0);
+	if (ret)
+		return ret;
 
-fail:
+	ret = gfs2_iter_unstuffed(ip, ea, data, NULL);
 	gfs2_trans_end(sdp);
-	kfree(bh);
-	return error;
+
+	return ret;
 }
 
 int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
-- 
1.7.4

