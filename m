Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0HQC6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:58:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0HQC6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:58:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=g8076RU+ykLQzlo7tvERshUqFJMlKj2rk/uTz4gPWEOx/Z4dbk8dX/ZQIRnao0X3U
	SVrmaOQcQFAztMiK8D1ug==
Date: Mon, 16 Aug 2010 19:57:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Whitehouse <swhiteho@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
cc: Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [patch 3/6] gfs2: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008161955500.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/gfs2/log.c     |   10 ++++++++--
 fs/gfs2/meta_io.c |    5 ++++-
 fs/gfs2/rgrp.c    |   27 +++++++++++++++------------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -523,7 +523,10 @@ struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
 	struct buffer_head *bh;
 
-	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		bh = alloc_buffer_head(GFP_NOFS);
+	} while (!bh);
 	atomic_set(&bh->b_count, 1);
 	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
 	set_bh_page(bh, real->b_page, bh_offset(real));
@@ -709,7 +712,10 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	}
 	trace_gfs2_log_flush(sdp, 1);
 
-	ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS);
+	} while (!ai);
 	INIT_LIST_HEAD(&ai->ai_ail1_list);
 	INIT_LIST_HEAD(&ai->ai_ail2_list);
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -289,7 +289,10 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 		return;
 	}
 
-	bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS);
+	} while (!bd);
 	bd->bd_bh = bh;
 	bd->bd_gl = gl;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1440,8 +1440,11 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 		rgrp_blk++;
 
 		if (!bi->bi_clone) {
-			bi->bi_clone = kmalloc(bi->bi_bh->b_size,
-					       GFP_NOFS | __GFP_NOFAIL);
+			do {
+				/* FIXME: this may potentially loop forever */
+				bi->bi_clone = kmalloc(bi->bi_bh->b_size,
+								GFP_NOFS);
+			} while (!bi->bi_clone);
 			memcpy(bi->bi_clone + bi->bi_offset,
 			       bi->bi_bh->b_data + bi->bi_offset,
 			       bi->bi_len);
@@ -1759,9 +1762,6 @@ fail:
  * @block: the block
  *
  * Figure out what RG a block belongs to and add that RG to the list
- *
- * FIXME: Don't use NOFAIL
- *
  */
 
 void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
@@ -1789,8 +1789,11 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
 	if (rlist->rl_rgrps == rlist->rl_space) {
 		new_space = rlist->rl_space + 10;
 
-		tmp = kcalloc(new_space, sizeof(struct gfs2_rgrpd *),
-			      GFP_NOFS | __GFP_NOFAIL);
+		do {
+			/* FIXME: this may potentially loop forever */
+			tmp = kcalloc(new_space, sizeof(struct gfs2_rgrpd *),
+					GFP_NOFS);
+		} while (!tmp);
 
 		if (rlist->rl_rgd) {
 			memcpy(tmp, rlist->rl_rgd,
@@ -1811,17 +1814,17 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
  * @rlist: the list of resource groups
  * @state: the lock state to acquire the RG lock in
  * @flags: the modifier flags for the holder structures
- *
- * FIXME: Don't use NOFAIL
- *
  */
 
 void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
 {
 	unsigned int x;
 
-	rlist->rl_ghs = kcalloc(rlist->rl_rgrps, sizeof(struct gfs2_holder),
-				GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		rlist->rl_ghs = kcalloc(rlist->rl_rgrps,
+					sizeof(struct gfs2_holder), GFP_NOFS);
+	} while (!rlist->rl_ghs);
 	for (x = 0; x < rlist->rl_rgrps; x++)
 		gfs2_holder_init(rlist->rl_rgd[x]->rd_gl,
 				state, 0,
