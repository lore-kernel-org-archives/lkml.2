Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2CMASY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:46879 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2CMASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Kara <jack@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 033/196] quota: Don't write quota info in dquot_commit()
Date: Mon, 12 Mar 2012 20:12:41 -0400
Message-Id: <1331597724-31358-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b03f24567ce7caf2420b8be4c6eb74c191d59a91 upstream.

There's no reason to write quota info in dquot_commit(). The writing is a
relict from the old days when we didn't have dquot_acquire() and
dquot_release() and thus dquot_commit() could have created / removed quota
structures from the file. These days dquot_commit() only updates usage counters
/ limits in quota structure and thus there's no need to write quota info.

This also fixes an issue with journaling filesystem which didn't reserve
enough space in the transaction for write of quota info (it could have been
dirty at the time of dquot_commit() because of a race with other operation
changing it).

Reported-and-tested-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/quota/dquot.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 788b580..0d465c7 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -411,7 +411,7 @@ EXPORT_SYMBOL(dquot_acquire);
  */
 int dquot_commit(struct dquot *dquot)
 {
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dqopt->dqio_mutex);
@@ -423,15 +423,10 @@ int dquot_commit(struct dquot *dquot)
 	spin_unlock(&dq_list_lock);
 	/* Inactive dquot can be only if there was error during read/init
 	 * => we have better not writing it */
-	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
 		ret = dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
-		if (info_dirty(&dqopt->info[dquot->dq_type])) {
-			ret2 = dqopt->ops[dquot->dq_type]->write_file_info(
-						dquot->dq_sb, dquot->dq_type);
-		}
-		if (ret >= 0)
-			ret = ret2;
-	}
+	else
+		ret = -EIO;
 out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
-- 
1.7.9.3

