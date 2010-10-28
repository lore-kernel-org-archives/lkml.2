Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab0J1Vcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741Ab0J1VcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:07 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 05/20] fsnotify: correctly handle return codes from listeners
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:03 -0400
Message-ID: <20101028213203.24810.30772.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fsnotify groups return errors they are ignored.  For permissions
events these should be passed back up the stack, but for most events these
should continue to be ignored.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |   20 ++++++++++++--------
 include/linux/fsnotify_backend.h |    2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4498a20..57ecadd 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -252,20 +252,23 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 
 		if (inode_group > vfsmount_group) {
 			/* handle inode */
-			send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
-				      data_is, cookie, file_name, &event);
+			ret = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
+					    data_is, cookie, file_name, &event);
 			/* we didn't use the vfsmount_mark */
 			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
-			send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
-				      data_is, cookie, file_name, &event);
+			ret = send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
+					    data_is, cookie, file_name, &event);
 			inode_group = NULL;
 		} else {
-			send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
-				      mask, data, data_is, cookie, file_name,
-				      &event);
+			ret = send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
+					    mask, data, data_is, cookie, file_name,
+					    &event);
 		}
 
+		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
+			goto out;
+
 		if (inode_group)
 			inode_node = srcu_dereference(inode_node->next,
 						      &fsnotify_mark_srcu);
@@ -273,7 +276,8 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 			vfsmount_node = srcu_dereference(vfsmount_node->next,
 							 &fsnotify_mark_srcu);
 	}
-
+	ret = 0;
+out:
 	srcu_read_unlock(&fsnotify_mark_srcu, idx);
 	/*
 	 * fsnotify_create_event() took a reference so the event can't be cleaned
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 8253295..0268921 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -64,6 +64,8 @@
 
 #define FS_MOVE			(FS_MOVED_FROM | FS_MOVED_TO)
 
+#define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM)
+
 #define ALL_FSNOTIFY_EVENTS (FS_ACCESS | FS_MODIFY | FS_ATTRIB | \
 			     FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN | \
 			     FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE | \

