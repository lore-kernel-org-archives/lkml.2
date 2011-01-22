Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1AVUGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:06:47 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23303 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1AVUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:06:46 -0500
Date: Sat, 22 Jan 2011 21:07:16 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-cifs@vger.kernel.org
cc: Steve French <sfrench@samba.org>, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] CIFS: Remove pointless variable assignment in
 cifs_dfs_do_automount()
Message-ID: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/cifs/cifs_dfs_ref.c::cifs_dfs_do_automount() we have this code:

	...
	mnt = ERR_PTR(-EINVAL);
	if (IS_ERR(tlink)) {
		mnt = ERR_CAST(tlink);
		goto free_full_path;
	}
	ses = tlink_tcon(tlink)->ses;

	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
		&num_referrals, &referrals,
		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);

	cifs_put_tlink(tlink);

	mnt = ERR_PTR(-ENOENT);
	...

The assignment of 'mnt = ERR_PTR(-EINVAL);' is completely pointless. If we 
take the 'if (IS_ERR(tlink))' branch we'll set 'mnt' again and we'll also 
do so if we do not take the branch. There is no way we'll ever use 'mnt' 
with the assigned 'ERR_PTR(-EINVAL)' value, so we may as well just remove 
the pointless assignment.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 cifs_dfs_ref.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 7ed3653..f1c6862 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -297,7 +297,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 
 	cifs_sb = CIFS_SB(mntpt->d_inode->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
-	mnt = ERR_PTR(-EINVAL);
 	if (IS_ERR(tlink)) {
 		mnt = ERR_CAST(tlink);
 		goto free_full_path;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

