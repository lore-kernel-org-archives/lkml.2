Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0ELPt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab0ELPt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:49:58 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Paris <eparis@redhat.com>
Subject: [PATCH] fsnotify: initialize mask in fsnotify_perm
Date: Wed, 12 May 2010 11:49:21 -0400
Message-Id: <1273679361-2346-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm got a warning the fsnotify_mask could be used uninitialized in
fsnotify_perm().  It's not actually possible but his compiler complained
about it.  This patch just initializes it to 0 to shut up the compiler.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 include/linux/fsnotify.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 64efda9..59d0df4 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -39,16 +39,18 @@ static inline int fsnotify_perm(struct file *file, int mask)
 {
 	struct path *path = &file->f_path;
 	struct inode *inode = path->dentry->d_inode;
-	__u32 fsnotify_mask;
+	__u32 fsnotify_mask = 0;
 
 	if (file->f_mode & FMODE_NONOTIFY)
 		return 0;
 	if (!(mask & (MAY_READ | MAY_OPEN)))
 		return 0;
-	if (mask & MAY_READ)
-		fsnotify_mask = FS_ACCESS_PERM;
 	if (mask & MAY_OPEN)
 		fsnotify_mask = FS_OPEN_PERM;
+	else if (mask & MAY_READ)
+		fsnotify_mask = FS_ACCESS_PERM;
+	else
+		BUG();
 
 	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
-- 
1.6.5.3

