Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab2DYVAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:00:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab2DYU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:57:56 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/6] quota: Use precomputed value of sb_dqopt in dquot_quota_sync
Date: Wed, 25 Apr 2012 22:57:46 +0200
Message-Id: <1335387467-4928-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d69a1d1..1b7e0fc 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -638,7 +638,7 @@ int dquot_quota_sync(struct super_block *sb, int type, int wait)
 	dqstats_inc(DQST_SYNCS);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 
-	if (!wait || (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE))
+	if (!wait || (dqopt->flags & DQUOT_QUOTA_SYS_FILE))
 		return 0;
 
 	/* This is not very clever (and fast) but currently I don't know about
@@ -652,18 +652,18 @@ int dquot_quota_sync(struct super_block *sb, int type, int wait)
 	 * Now when everything is written we can discard the pagecache so
 	 * that userspace sees the changes.
 	 */
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
+	mutex_lock(&dqopt->dqonoff_mutex);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
-		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex,
+		mutex_lock_nested(&dqopt->files[cnt]->i_mutex,
 				  I_MUTEX_QUOTA);
-		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
-		mutex_unlock(&sb_dqopt(sb)->files[cnt]->i_mutex);
+		truncate_inode_pages(&dqopt->files[cnt]->i_data, 0);
+		mutex_unlock(&dqopt->files[cnt]->i_mutex);
 	}
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	return 0;
 }
-- 
1.7.1

