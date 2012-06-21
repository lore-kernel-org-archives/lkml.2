Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2FUKzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:55:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44787 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2FUKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:55:36 -0400
Date: Thu, 21 Jun 2012 12:55:28 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [RFC 1/2] fs: configfs: add check_rmdir operation
In-reply-to: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1340276129-20023-2-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic behind a subsystem which uses configfs might be that it is not
desired to allow removing the pseudo directories (items or groups) in a
mounted configfs while some criterion is not met, e.g. while some
actions are in progress. This patch adds a check_rmdir operation to
configfs_item_operations and to configfs_group_operations. The operation,
if provided, is called before actual remove takes place and if the result
is nonzero, the remove is not done and the error it returns is reported.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/configfs/dir.c        |   20 ++++++++++++++++++++
 include/linux/configfs.h |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7e6c52d..de2680f 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1408,12 +1408,32 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		dead_item_owner = item->ci_type->ct_owner;
 
 	if (sd->s_type & CONFIGFS_USET_DIR) {
+		if (item->ci_type && item->ci_type->ct_group_ops &&
+		    item->ci_type->ct_group_ops->check_rmdir) {
+		    	ret = item->ci_type->ct_group_ops->check_rmdir(
+				to_config_group(parent_item), item);
+			if (ret) {
+				config_item_put(item);
+				configfs_detach_rollback(dentry);
+				return ret;
+			}
+		}
 		configfs_detach_group(item);
 
 		mutex_lock(&subsys->su_mutex);
 		client_disconnect_notify(parent_item, item);
 		unlink_group(to_config_group(item));
 	} else {
+		if (item->ci_type && item->ci_type->ct_item_ops &&
+		    item->ci_type->ct_item_ops->check_rmdir) {
+		    	ret = item->ci_type->ct_item_ops->check_rmdir(
+				to_config_group(parent_item), item);
+			if (ret) {
+				config_item_put(item);
+				configfs_detach_rollback(dentry);
+				return ret;
+			}
+		}
 		configfs_detach_item(item);
 
 		mutex_lock(&subsys->su_mutex);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..f356a55 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -225,6 +225,7 @@ struct configfs_item_operations {
 	void (*release)(struct config_item *);
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
+	int (*check_rmdir)(struct config_group *group, struct config_item *item);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
@@ -233,6 +234,7 @@ struct configfs_group_operations {
 	struct config_item *(*make_item)(struct config_group *group, const char *name);
 	struct config_group *(*make_group)(struct config_group *group, const char *name);
 	int (*commit_item)(struct config_item *item);
+	int (*check_rmdir)(struct config_group *group, struct config_item *item);
 	void (*disconnect_notify)(struct config_group *group, struct config_item *item);
 	void (*drop_item)(struct config_group *group, struct config_item *item);
 };
-- 
1.7.0.4

