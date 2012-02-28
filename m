Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2B1Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:35:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2B1LfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:35:25 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Fix race between lru_list and glock ref count
Date: Tue, 28 Feb 2012 11:11:02 +0000
Message-Id: <1330427465-5417-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
References: <1330427465-5417-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a narrow race window between the glock ref count
hitting zero and glocks being removed from the lru_list.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 376816f..351a3e7 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -167,14 +167,19 @@ void gfs2_glock_add_to_lru(struct gfs2_glock *gl)
 	spin_unlock(&lru_lock);
 }
 
-static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
+static void __gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
 {
-	spin_lock(&lru_lock);
 	if (!list_empty(&gl->gl_lru)) {
 		list_del_init(&gl->gl_lru);
 		atomic_dec(&lru_count);
 		clear_bit(GLF_LRU, &gl->gl_flags);
 	}
+}
+
+static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
+{
+	spin_lock(&lru_lock);
+	__gfs2_glock_remove_from_lru(gl);
 	spin_unlock(&lru_lock);
 }
 
@@ -217,11 +222,12 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 
-	if (atomic_dec_and_test(&gl->gl_ref)) {
+	if (atomic_dec_and_lock(&gl->gl_ref, &lru_lock)) {
+		__gfs2_glock_remove_from_lru(gl);
+		spin_unlock(&lru_lock);
 		spin_lock_bucket(gl->gl_hash);
 		hlist_bl_del_rcu(&gl->gl_list);
 		spin_unlock_bucket(gl->gl_hash);
-		gfs2_glock_remove_from_lru(gl);
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
 		trace_gfs2_glock_put(gl);
-- 
1.7.4

