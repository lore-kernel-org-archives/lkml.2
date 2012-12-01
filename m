Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab2LAB4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:56:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2LAB4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:56:08 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/6] f2fs: check read only condition before beginning write out
Date: Sat,  1 Dec 2012 10:56:01 +0900
Message-Id: <1354326961-6758-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

If the filesystem is mounted as read-only then return from that point itself
instead of first doing a writeout/wait and then checking for read-only
condition.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c1a108f..89241c5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -132,14 +132,15 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		.for_reclaim = 0,
 	};
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
 
 	mutex_lock(&inode->i_mutex);
 
-	if (inode->i_sb->s_flags & MS_RDONLY)
-		goto out;
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		goto out;
 
-- 
1.7.9.5

