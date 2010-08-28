Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0H1Buf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0H1Bue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:50:34 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] fsnotify: fix list walk order
Date: Fri, 27 Aug 2010 21:50:24 -0400
Message-Id: <1282960225-22146-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marks were stored on the inode and vfsmonut mark list in order from
highest memory address to lowest memory address.  The code to walk those
lists thought they were in order from lowest to highest with
unpredictable results when trying to match up marks from each.  It was
possible that extra events would be sent to userspace when inode
marks ignoring events wouldn't get matched with the vfsmount marks.

This problem only affected fanotify when using both vfsmount and inode
marks simultaneously.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fsnotify.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 6f2777c..2169aa5 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -261,27 +261,26 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 
 	while (inode_node || vfsmount_node) {
 		used_inode = used_vfsmount = false;
+		inode_group = vfsmount_group = NULL;
 
 		if (inode_node) {
 			inode_mark = hlist_entry(srcu_dereference(inode_node, &fsnotify_mark_srcu),
 						 struct fsnotify_mark, i.i_list);
 			inode_group = inode_mark->group;
-		} else
-			inode_group = (void *)-1;
+		}
 
 		if (vfsmount_node) {
 			vfsmount_mark = hlist_entry(srcu_dereference(vfsmount_node, &fsnotify_mark_srcu),
 							struct fsnotify_mark, m.m_list);
 			vfsmount_group = vfsmount_mark->group;
-		} else
-			vfsmount_group = (void *)-1;
+		}
 
-		if (inode_group < vfsmount_group) {
+		if (inode_group > vfsmount_group) {
 			/* handle inode */
 			send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
 				      data_is, cookie, file_name, &event);
 			used_inode = true;
-		} else if (vfsmount_group < inode_group) {
+		} else if (vfsmount_group > inode_group) {
 			send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
 				      data_is, cookie, file_name, &event);
 			used_vfsmount = true;
-- 
1.7.1

