Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2L3Fwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:52:49 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41229 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2L3Fwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:52:47 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/4] f2fs: fix time update in case of f2fs fallocate
Date: Sun, 30 Dec 2012 14:52:37 +0900
Message-Id: <1356846757-7678-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

After doing a punch hole or expanding inode doing fallocation.
The change and modification time are not update for the file.
So, update time after no issue is observed in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/file.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7f9ea92..88593c5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -545,6 +545,11 @@ static long f2fs_fallocate(struct file *file, int mode,
 	else
 		ret = expand_inode_data(inode, offset, len, mode);
 
+	if (!ret) {
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		mark_inode_dirty(inode);
+	}
+
 	f2fs_balance_fs(sbi);
 	return ret;
 }
-- 
1.7.9.5

