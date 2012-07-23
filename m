Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2GWI1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab2GWI00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:26 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <steve@chygwyn.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/16] GFS2: Fix error handling when reading an invalid block from the journal
Date: Mon, 23 Jul 2012 09:00:54 +0100
Message-Id: <1343030466-3053-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <steve@chygwyn.com>

When we read an invalid block from the journal, we should not call
withdraw, but simply print a message and return an error. It is
up to the caller to then handle that error. In the case of mount
that means a failed mount, rather than a withdraw (requiring a
reboot). In the case of recovering another nodes journal then
we return an error via the uevent.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 852c1be..8ff95a2 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -401,9 +401,14 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 		goto out;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
-	gfs2_meta_check(sdp, bd->bd_bh);
-	gfs2_pin(sdp, bd->bd_bh);
 	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
+	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
+		printk(KERN_ERR
+		       "Attempting to add uninitialised block to journal (inplace block=%lld)\n",
+		       (unsigned long long)bd->bd_bh->b_blocknr);
+		BUG();
+	}
+	gfs2_pin(sdp, bd->bd_bh);
 	mh->__pad0 = cpu_to_be64(0);
 	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	sdp->sd_log_num_buf++;
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 3586b0d..8053573 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -79,23 +79,19 @@ int gfs2_meta_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		       const char *type, const char *function,
 		       char *file, unsigned int line);
 
-static inline int gfs2_meta_check_i(struct gfs2_sbd *sdp,
-				    struct buffer_head *bh,
-				    const char *function,
-				    char *file, unsigned int line)
+static inline int gfs2_meta_check(struct gfs2_sbd *sdp,
+				    struct buffer_head *bh)
 {
 	struct gfs2_meta_header *mh = (struct gfs2_meta_header *)bh->b_data;
 	u32 magic = be32_to_cpu(mh->mh_magic);
-	if (unlikely(magic != GFS2_MAGIC))
-		return gfs2_meta_check_ii(sdp, bh, "magic number", function,
-					  file, line);
+	if (unlikely(magic != GFS2_MAGIC)) {
+		printk(KERN_ERR "GFS2: Magic number missing at %llu\n",
+		       (unsigned long long)bh->b_blocknr);
+		return -EIO;
+	}
 	return 0;
 }
 
-#define gfs2_meta_check(sdp, bh) \
-gfs2_meta_check_i((sdp), (bh), __func__, __FILE__, __LINE__)
-
-
 int gfs2_metatype_check_ii(struct gfs2_sbd *sdp, struct buffer_head *bh,
 			   u16 type, u16 t,
 			   const char *function,
-- 
1.7.4

