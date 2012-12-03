Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2LCOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:49:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932234Ab2LCOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:21 -0500
Message-Id: <20121203143156.193480726@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 62/89] reiserfs: Protect reiserfs_quota_on() with write lock
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit b9e06ef2e8706fe669b51f4364e3aeed58639eb2 upstream.

In reiserfs_quota_on() we do quite some work - for example unpacking
tail of a quota file. Thus we have to hold write lock until a moment
we call back into the quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.2: there is no distinction between USRQUOTA and
 GRPQUOTA mount options here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/super.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2073,8 +2073,11 @@ static int reiserfs_quota_on(struct supe
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
@@ -2116,8 +2119,10 @@ static int reiserfs_quota_on(struct supe
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
 


