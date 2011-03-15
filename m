Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1COJgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1COJeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/15] GFS2: deallocation performance patch
Date: Tue, 15 Mar 2011 09:11:36 +0000
Message-Id: <1300180305-5993-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is a performance improvement to GFS2's dealloc code.
Rather than update the quota file and statfs file for every
single block that's stripped off in unlink function do_strip,
this patch keeps track and updates them once for every layer
that's stripped.  This is done entirely inside the existing
transaction, so there should be no risk of corruption.
The other functions that deallocate blocks will be unaffected
because they are using wrapper functions that do the same
thing that they do today.

I tested this code on my roth cluster by creating 200
files in a directory, each of which is 100MB, then on
four nodes, I simultaneously deleted the files, thus competing
for GFS2 resources (but different files).  The commands
I used were:

[root@roth-01]# time for i in `seq 1 4 200` ; do rm /mnt/gfs2/bigdir/gfs2.$i; done
[root@roth-02]# time for i in `seq 2 4 200` ; do rm /mnt/gfs2/bigdir/gfs2.$i; done
[root@roth-03]# time for i in `seq 3 4 200` ; do rm /mnt/gfs2/bigdir/gfs2.$i; done
[root@roth-05]# time for i in `seq 4 4 200` ; do rm /mnt/gfs2/bigdir/gfs2.$i; done

The performance increase was significant:

             roth-01     roth-02     roth-03     roth-05
             ---------   ---------   ---------   ---------
old: real    0m34.027    0m25.021s   0m23.906s   0m35.646s
new: real    0m22.379s   0m24.362s   0m24.133s   0m18.562s

Total time spent deleting:
old: 118.6s
new:  89.4

For this particular case, this showed a 25% performance increase for
GFS2 unlinks.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 3c4039d..ef3dc4b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -21,6 +21,7 @@
 #include "meta_io.h"
 #include "quota.h"
 #include "rgrp.h"
+#include "super.h"
 #include "trans.h"
 #include "dir.h"
 #include "util.h"
@@ -757,7 +758,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrp_list rlist;
 	u64 bn, bstart;
-	u32 blen;
+	u32 blen, btotal;
 	__be64 *p;
 	unsigned int rg_blocks = 0;
 	int metadata;
@@ -839,6 +840,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 
 	bstart = 0;
 	blen = 0;
+	btotal = 0;
 
 	for (p = top; p < bottom; p++) {
 		if (!*p)
@@ -851,9 +853,11 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		else {
 			if (bstart) {
 				if (metadata)
-					gfs2_free_meta(ip, bstart, blen);
+					__gfs2_free_meta(ip, bstart, blen);
 				else
-					gfs2_free_data(ip, bstart, blen);
+					__gfs2_free_data(ip, bstart, blen);
+
+				btotal += blen;
 			}
 
 			bstart = bn;
@@ -865,11 +869,17 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	}
 	if (bstart) {
 		if (metadata)
-			gfs2_free_meta(ip, bstart, blen);
+			__gfs2_free_meta(ip, bstart, blen);
 		else
-			gfs2_free_data(ip, bstart, blen);
+			__gfs2_free_data(ip, bstart, blen);
+
+		btotal += blen;
 	}
 
+	gfs2_statfs_change(sdp, 0, +btotal, 0);
+	gfs2_quota_change(ip, -(s64)btotal, ip->i_inode.i_uid,
+			  ip->i_inode.i_gid);
+
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 
 	gfs2_dinode_out(ip, dibh->b_data);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7293ea2..cf930cd 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1602,7 +1602,7 @@ rgrp_error:
  *
  */
 
-void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
+void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd;
@@ -1617,7 +1617,21 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_trans_add_rg(rgd);
+}
 
+/**
+ * gfs2_free_data - free a contiguous run of data block(s)
+ * @ip: the inode these blocks are being freed from
+ * @bstart: first block of a run of contiguous blocks
+ * @blen: the length of the block run
+ *
+ */
+
+void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+
+	__gfs2_free_data(ip, bstart, blen);
 	gfs2_statfs_change(sdp, 0, +blen, 0);
 	gfs2_quota_change(ip, -(s64)blen, ip->i_inode.i_uid, ip->i_inode.i_gid);
 }
@@ -1630,7 +1644,7 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
  *
  */
 
-void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
+void __gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd;
@@ -1645,10 +1659,24 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_trans_add_rg(rgd);
+	gfs2_meta_wipe(ip, bstart, blen);
+}
 
+/**
+ * gfs2_free_meta - free a contiguous run of data block(s)
+ * @ip: the inode these blocks are being freed from
+ * @bstart: first block of a run of contiguous blocks
+ * @blen: the length of the block run
+ *
+ */
+
+void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+
+	__gfs2_free_meta(ip, bstart, blen);
 	gfs2_statfs_change(sdp, 0, +blen, 0);
 	gfs2_quota_change(ip, -(s64)blen, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	gfs2_meta_wipe(ip, bstart, blen);
 }
 
 void gfs2_unlink_di(struct inode *inode)
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 50c2bb0..a80e303 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -52,7 +52,9 @@ extern int gfs2_ri_update(struct gfs2_inode *ip);
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
 extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
+extern void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
+extern void __gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
 extern void gfs2_unlink_di(struct inode *inode);
-- 
1.7.4

