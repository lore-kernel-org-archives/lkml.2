Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1DLOsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:48:30 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab1DLOiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.708585926@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [063/105] quota: Dont write quota info in dquot_commit()
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -442,7 +442,7 @@ EXPORT_SYMBOL(dquot_acquire);
  */
 int dquot_commit(struct dquot *dquot)
 {
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dqopt->dqio_mutex);
@@ -454,15 +454,10 @@ int dquot_commit(struct dquot *dquot)
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


