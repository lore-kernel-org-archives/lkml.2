Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab1E0UmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:42:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43512 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1E0Ulx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:41:53 -0400
From: Sage Weil <sage@newdream.net>
To: hch@infradead.org, viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/26] ncpfs: fix rename over directory with dangling references
Date: Fri, 27 May 2011 13:42:10 -0700
Message-Id: <1306528939-30636-18-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1306528939-30636-1-git-send-email-sage@newdream.net>
References: <1306528939-30636-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ncpfs does not handle references to unlinked directories (or so it would
seem given the ncp_rmdir check).  Since it is also possible to rename over
an empty directory, perform the same check here.

CC: Petr Vandrovec <petr@vandrovec.name>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ncpfs/dir.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 81c287d..9c51f62 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1144,8 +1144,16 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		new_dentry->d_parent->d_name.name, new_dentry->d_name.name);
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode)) {
+		/*
+		 * fail with EBUSY if there are still references to this
+		 * directory.
+		 */
 		dentry_unhash(new_dentry);
+		error = -EBUSY;
+		if (!d_unhashed(new_dentry))
+			goto out;
+	}
 
 	ncp_age_dentry(server, old_dentry);
 	ncp_age_dentry(server, new_dentry);
-- 
1.7.0

