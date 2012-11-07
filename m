Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2KGKme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:42:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2KGKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:42:07 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 7/7] GFS2: Test bufdata with buffer locked and gfs2_log_lock held
Date: Wed,  7 Nov 2012 10:15:59 +0000
Message-Id: <1352283359-3314-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to the
buffer without having the gfs2_log_lock held. It was then assuming it would
stay attached for the rest of the function. However, without either the log
lock being held of the buffer locked, __gfs2_ail_flush() could detach bd at any
time.  This patch moves the locking before the test.  If there isn't a bd
already attached, gfs2 can safely allocate one and attach it before locking.
There is no way that the newly allocated bd could be on the ail list,
and thus no way for __gfs2_ail_flush() to detach it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 01e444b..9ceccb1 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -393,12 +393,10 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
 
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	if (!list_empty(&bd->bd_list))
-		goto out;
+		return;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
@@ -414,9 +412,6 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	sdp->sd_log_num_buf++;
 	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 static void gfs2_check_magic(struct buffer_head *bh)
@@ -775,12 +770,10 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	struct address_space *mapping = bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (tr)
 		tr->tr_touched = 1;
 	if (!list_empty(&bd->bd_list))
-		goto out;
+		return;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	if (gfs2_is_jdata(ip)) {
@@ -791,9 +784,6 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	} else {
 		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 /**
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index adbd278..4136270 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -155,14 +155,22 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_bufdata *bd;
 
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
 	bd = bh->b_private;
 	if (bd)
 		gfs2_assert(sdp, bd->bd_gl == gl);
 	else {
+		gfs2_log_unlock(sdp);
+		unlock_buffer(bh);
 		gfs2_attach_bufdata(gl, bh, meta);
 		bd = bh->b_private;
+		lock_buffer(bh);
+		gfs2_log_lock(sdp);
 	}
 	lops_add(sdp, bd);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
 }
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-- 
1.7.4

