Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab2EOCRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:48991 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2EOCQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 010/179] ext3: Fix fs corruption when make_indexed_dir() fails
Date: Mon, 14 May 2012 22:11:46 -0400
Message-ID: <1337048075-6132-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 86c4f6d85595cd7da635dc6985d27bfa43b1ae10 upstream.

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has allocated
block for index tree root, we did not properly mark all changed buffers dirty.
This lead to only some of these buffers being written out and thus effectively
corrupting the directory.

Fix the issue by marking all changed data dirty even in the error failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext3/namei.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 827b573..a97b96a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1425,10 +1425,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
+	/*
+	 * Mark buffers dirty here so that if do_split() fails we write a
+	 * consistent set of buffers to disk.
+	 */
+	ext3_journal_dirty_metadata(handle, frame->bh);
+	ext3_journal_dirty_metadata(handle, bh);
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		ext3_mark_inode_dirty(handle, dir);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }
@@ -2214,7 +2223,7 @@ retry:
 			drop_nlink(inode);
 			unlock_new_inode(inode);
 			ext3_mark_inode_dirty(handle, inode);
-			iput (inode);
+			iput(inode);
 			goto out_stop;
 		}
 	} else {
-- 
1.7.9.6

