Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2LMOIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44538 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2LMOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 118/241] reiserfs: Protect reiserfs_quota_on() with write lock
Date: Thu, 13 Dec 2012 11:58:03 -0200
Message-Id: <1355407206-17100-119-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit b9e06ef2e8706fe669b51f4364e3aeed58639eb2 upstream.

In reiserfs_quota_on() we do quite some work - for example unpacking
tail of a quota file. Thus we have to hold write lock until a moment
we call back into the quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/reiserfs/super.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 2ad0789..9b1745f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2206,8 +2206,11 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	struct reiserfs_transaction_handle th;
 	int opt = type == USRQUOTA ? REISERFS_USRQUOTA : REISERFS_GRPQUOTA;
 
-	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << opt)))
-		return -EINVAL;
+	reiserfs_write_lock(sb);
+	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << opt))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* Quotafile not on the same filesystem? */
 	if (path->dentry->d_sb != sb) {
@@ -2249,8 +2252,10 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		if (err)
 			goto out;
 	}
-	err = dquot_quota_on(sb, type, format_id, path);
+	reiserfs_write_unlock(sb);
+	return dquot_quota_on(sb, type, format_id, path);
 out:
+	reiserfs_write_unlock(sb);
 	return err;
 }
 
-- 
1.7.9.5

