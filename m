Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1ABHma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:42:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:36505 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1ABHYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Joel Becker <joel.becker@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 186/260] ocfs2: Don't walk off the end of fast symlinks.
Date: Sun,  2 Jan 2011 02:18:02 -0500
Message-Id: <1293952756-15010-187-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:34.0776 (UTC) FILETIME=[F7430780:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

commit 1fc8a117865b54590acd773a55fbac9221b018f0 upstream.

ocfs2 fast symlinks are NUL terminated strings stored inline in the
inode data area.  However, disk corruption or a local attacker could, in
theory, remove that NUL.  Because we're using strlen() (my fault,
introduced in a731d1 when removing vfs_follow_link()), we could walk off
the end of that string.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ocfs2/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 32499d21..9975457 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -128,7 +128,7 @@ static void *ocfs2_fast_follow_link(struct dentry *dentry,
 	}
 
 	/* Fast symlinks can't be large */
-	len = strlen(target);
+	len = strnlen(target, ocfs2_fast_symlink_chars(inode->i_sb));
 	link = kzalloc(len + 1, GFP_NOFS);
 	if (!link) {
 		status = -ENOMEM;
-- 
1.7.3.3

