Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2KVV32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:29:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab2KVSkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 33/38] reiserfs: Protect reiserfs_quota_on() with write lock
Date: Wed, 21 Nov 2012 16:40:16 -0800
Message-Id: <20121122003907.989159152@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit b9e06ef2e8706fe669b51f4364e3aeed58639eb2 upstream.

In reiserfs_quota_on() we do quite some work - for example unpacking
tail of a quota file. Thus we have to hold write lock until a moment
we call back into the quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/super.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2072,8 +2072,11 @@ static int reiserfs_quota_on(struct supe
 	struct inode *inode;
 	struct reiserfs_transaction_handle th;
 
-	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
-		return -EINVAL;
+	reiserfs_write_lock(sb);
+	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* Quotafile not on the same filesystem? */
 	if (path->mnt->mnt_sb != sb) {
@@ -2115,8 +2118,10 @@ static int reiserfs_quota_on(struct supe
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
 


