Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2LMO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:26:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2LMOMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 192/241] GFS2: Test bufdata with buffer locked and gfs2_log_lock held
Date: Thu, 13 Dec 2012 11:59:17 -0200
Message-Id: <1355407206-17100-193-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/gfs2/lops.c  |   14 ++------------
 fs/gfs2/trans.c |    8 ++++++++
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 852c1be..e435b7c 100644
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
 	gfs2_meta_check(sdp, bd->bd_bh);
@@ -409,9 +407,6 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	sdp->sd_log_num_buf++;
 	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 static void gfs2_check_magic(struct buffer_head *bh)
@@ -772,12 +767,10 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
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
@@ -788,9 +781,6 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	} else {
 		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 /**
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index ad3e2fb..5a14e8c 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -151,14 +151,22 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
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
1.7.9.5

