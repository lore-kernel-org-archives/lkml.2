Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab2KOE2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:28:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:49513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993074Ab2KOEMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [ 64/66] GFS2: Test bufdata with buffer locked and gfs2_log_lock held
Date: Wed, 14 Nov 2012 20:11:09 -0800
Message-Id: <20121115040943.748338602@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/lops.c  |   14 ++------------
 fs/gfs2/trans.c |    8 ++++++++
 2 files changed, 10 insertions(+), 12 deletions(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -393,12 +393,10 @@ static void buf_lo_add(struct gfs2_sbd *
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
@@ -414,9 +412,6 @@ static void buf_lo_add(struct gfs2_sbd *
 	sdp->sd_log_num_buf++;
 	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 static void gfs2_check_magic(struct buffer_head *bh)
@@ -777,12 +772,10 @@ static void databuf_lo_add(struct gfs2_s
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
@@ -793,9 +786,6 @@ static void databuf_lo_add(struct gfs2_s
 	} else {
 		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 /**
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -155,14 +155,22 @@ void gfs2_trans_add_bh(struct gfs2_glock
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


