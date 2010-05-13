Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab0EMKx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:53:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:43608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab0EMKxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:53:24 -0400
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing slashes
Date: Thu, 13 May 2010 12:52:57 +0200
Message-Id: <1273747977-4579-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to specification
mkdir d; ln -s d a; open("a/", O_NOFOLLOW | O_RDONLY)
should return success but currently it did return ELOOP. Fix the code to ignore
O_NOFOLLOW in case the provided path has trailing slashes. This is a regression
caused by path lookup cleanup patch series.

CC: stable@kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: tolzmann@molgen.mpg.de
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Since Al doesn't seem to react for a few days and this is kind of nasty bug,
I'm sending it directly...

 fs/namei.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a7dce91..16df727 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1641,7 +1641,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (nd->last.name[nd->last.len]) {
 		if (open_flag & O_CREAT)
 			goto exit;
-		nd->flags |= LOOKUP_DIRECTORY;
+		nd->flags |= LOOKUP_DIRECTORY | LOOKUP_FOLLOW;
 	}
 
 	/* just plain open? */
@@ -1830,6 +1830,8 @@ reval:
 	}
 	if (open_flag & O_DIRECTORY)
 		nd.flags |= LOOKUP_DIRECTORY;
+	if (!(open_flag & O_NOFOLLOW))
+		nd.flags |= LOOKUP_FOLLOW;
 	filp = do_last(&nd, &path, open_flag, acc_mode, mode, pathname);
 	while (unlikely(!filp)) { /* trailing symlink */
 		struct path holder;
@@ -1837,7 +1839,7 @@ reval:
 		void *cookie;
 		error = -ELOOP;
 		/* S_ISDIR part is a temporary automount kludge */
-		if ((open_flag & O_NOFOLLOW) && !S_ISDIR(inode->i_mode))
+		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(inode->i_mode))
 			goto exit_dput;
 		if (count++ == 32)
 			goto exit_dput;
-- 
1.6.4.2

