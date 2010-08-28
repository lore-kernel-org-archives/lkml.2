Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0H1Bul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0H1Buk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:50:40 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] fsnotify: drop two useless bools in the fnsotify main loop
Date: Fri, 27 Aug 2010 21:50:25 -0400
Message-Id: <1282960225-22146-2-git-send-email-eparis@redhat.com>
In-Reply-To: <1282960225-22146-1-git-send-email-eparis@redhat.com>
References: <1282960225-22146-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsnotify main loop has 2 bools which indicated if we processed the
inode or vfsmount mark in that particular pass through the loop.  These
bool can we replaced with the inode_group and vfsmount_group variables
and actually make the code a little easier to understand.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fsnotify.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 2169aa5..3680242 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -225,7 +225,6 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	struct fsnotify_event *event = NULL;
 	struct vfsmount *mnt;
 	int idx, ret = 0;
-	bool used_inode, used_vfsmount;
 	/* global tests shouldn't care about events on child only the specific event */
 	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
@@ -260,7 +259,6 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	}
 
 	while (inode_node || vfsmount_node) {
-		used_inode = used_vfsmount = false;
 		inode_group = vfsmount_group = NULL;
 
 		if (inode_node) {
@@ -279,23 +277,22 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 			/* handle inode */
 			send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
 				      data_is, cookie, file_name, &event);
-			used_inode = true;
+			/* we didn't use the vfsmount_mark */
+			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
 			send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
 				      data_is, cookie, file_name, &event);
-			used_vfsmount = true;
+			inode_group = NULL;
 		} else {
 			send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
 				      mask, data, data_is, cookie, file_name,
 				      &event);
-			used_vfsmount = true;
-			used_inode = true;
 		}
 
-		if (used_inode)
+		if (inode_group)
 			inode_node = srcu_dereference(inode_node->next,
 						      &fsnotify_mark_srcu);
-		if (used_vfsmount)
+		if (vfsmount_group)
 			vfsmount_node = srcu_dereference(vfsmount_node->next,
 							 &fsnotify_mark_srcu);
 	}
-- 
1.7.1

