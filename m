Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LVDPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:15:35 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40715 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2LVDPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:15:33 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/5] f2fs: handle error from f2fs_iget_nowait
Date: Sat, 22 Dec 2012 12:09:43 +0900
Message-Id: <1356145783-19980-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In case f2fs_iget_nowait returns error, it results in truncate_hole being
called with 'error' value as inode pointer. There is no check in truncate_hole
for valid inode, so it could result in crash due "invalid access to memory".
Avoid this by handling error condition properly.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/recovery.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b07e9b6..632e679 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -228,6 +228,9 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 
 	/* Deallocate previous index in the node page */
 	inode = f2fs_iget_nowait(sbi->sb, ino);
+	if (IS_ERR(inode))
+		return;
+
 	truncate_hole(inode, bidx, bidx + 1);
 	iput(inode);
 }
-- 
1.7.9.5

