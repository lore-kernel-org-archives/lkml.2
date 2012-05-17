Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856Ab2EQMsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761832Ab2EQMsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/24] GFS2: Log code fixes
Date: Thu, 17 May 2012 13:23:21 +0100
Message-Id: <1337257411-3173-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a log lock from around atomic operation where
it is not needed, removes an unused variable, and also changes
a void pointer used incorrectly to a struct page pointer.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 2307218..db9cb18 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -643,10 +643,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
 		log_write_header(sdp, 0);
 	} else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
-		gfs2_log_lock(sdp);
 		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 		trace_gfs2_log_blocks(sdp, -1);
-		gfs2_log_unlock(sdp);
 		log_write_header(sdp, 0);
 	}
 	lops_after_commit(sdp, ai);
@@ -797,11 +795,9 @@ int gfs2_logd(void *data)
 	struct gfs2_sbd *sdp = data;
 	unsigned long t = 1;
 	DEFINE_WAIT(wait);
-	unsigned preflush;
 
 	while (!kthread_should_stop()) {
 
-		preflush = atomic_read(&sdp->sd_log_pinned);
 		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
 			gfs2_ail1_empty(sdp);
 			gfs2_log_flush(sdp, NULL);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index e9709da..11fedb5 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -375,7 +375,7 @@ void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page)
 static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type,
 				      u32 ld_length, u32 ld_data1)
 {
-	void *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+	struct page *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 	struct gfs2_log_descriptor *ld = page_address(page);
 	clear_page(ld);
 	ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-- 
1.7.4

