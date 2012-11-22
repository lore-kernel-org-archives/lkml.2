Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2KVWCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 052/171] reiserfs: Protect reiserfs_quota_on() with write lock
Date: Wed, 21 Nov 2012 16:39:58 -0800
Message-Id: <20121122004038.591718962@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2170,8 +2170,11 @@ static int reiserfs_quota_on(struct supe
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
@@ -2213,8 +2216,10 @@ static int reiserfs_quota_on(struct supe
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
 


