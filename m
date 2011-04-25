Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1DYUog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34328 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab1DYUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:48 -0400
Message-Id: <20110425200238.642368233@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 130/173] quota: Dont write quota info in dquot_commit()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/quota/dquot.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: longterm-2.6.27/fs/dquot.c
===================================================================
--- longterm-2.6.27.orig/fs/dquot.c	2011-04-25 18:46:08.692278358 +0200
+++ longterm-2.6.27/fs/dquot.c	2011-04-25 19:00:34.756279725 +0200
@@ -365,7 +365,7 @@
  */
 int dquot_commit(struct dquot *dquot)
 {
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dqopt->dqio_mutex);
@@ -377,13 +377,10 @@
 	spin_unlock(&dq_list_lock);
 	/* Inactive dquot can be only if there was error during read/init
 	 * => we have better not writing it */
-	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
 		ret = dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
-		if (info_dirty(&dqopt->info[dquot->dq_type]))
-			ret2 = dqopt->ops[dquot->dq_type]->write_file_info(dquot->dq_sb, dquot->dq_type);
-		if (ret >= 0)
-			ret = ret2;
-	}
+	else
+		ret = -EIO;
 out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;


