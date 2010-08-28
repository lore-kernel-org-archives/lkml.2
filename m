Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0H1TZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:25:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0H1TZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CjY3KEomzyx2P6nfKxgmuudnSNtMtN5Dtiw9kdNANVu0HfMrF5YXDVhs1sZ43U2OL3
         VhA1ZmYp7xVZIMAuKC9tIJBbuS1eI8a0B12k+MrZNm8lwyl84ECUjTGYPOV7AtOoMt/e
         2BITGFF1a4DXgyiDZjxKhtDQzkmR2qF4KaZT0=
From: Csaba Henk <csaba@gluster.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Csaba Henk <csaba@gluster.com>
Subject: [PATCH 1/2] fsnotify: fix NULL dereference in send_to_group()
Date: Sun, 29 Aug 2010 00:55:41 +0530
Message-Id: <1283023542-1251-1-git-send-email-csaba@gluster.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fanotify is triggered via a vfsmount mark (so that there is
no inode mark, group in send_to_group() is set from a structure
member where the struct pointer is NULL.

This can be tested with the fanotify utility available from
http://people.redhat.com/eparis/fanotify/:

 # fanotify -m / & touch /x

Signed-off-by: Csaba Henk <csaba@gluster.com>
---
 fs/notify/fsnotify.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 3970392..6657315 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -148,13 +148,21 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 const unsigned char *file_name,
 			 struct fsnotify_event **event)
 {
-	struct fsnotify_group *group = inode_mark->group;
+	struct fsnotify_group *group;
 	__u32 inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 	__u32 vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
-	pr_debug("%s: group=%p to_tell=%p mnt=%p mark=%p mask=%x data=%p"
-		 " data_is=%d cookie=%d event=%p\n", __func__, group, to_tell,
-		 mnt, inode_mark, mask, data, data_is, cookie, *event);
+	if (inode_mark)
+		group = inode_mark->group;
+	else if (vfsmount_mark)
+		group = vfsmount_mark->group;
+	else
+		BUG();
+
+	pr_debug("%s: group=%p to_tell=%p mnt=%p inode_mark=%p vfsmount_mark=%p"
+		 " mask=%x data=%p data_is=%d cookie=%d event=%p\n",
+		 __func__, group, to_tell, mnt, inode_mark, vfsmount_mark, mask,
+		 data, data_is, cookie, *event);
 
 	/* clear ignored on inode modification */
 	if (mask & FS_MODIFY) {
-- 
1.7.2.2

