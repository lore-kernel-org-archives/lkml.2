Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab0JVSZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:46 -0400
Received: from kroah.org ([198.145.64.141]:37839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab0JVSZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/31] driver core: fix build for CONFIG_BLOCK not enabled
Date: Fri, 22 Oct 2010 11:25:08 -0700
Message-Id: <1287771916-15016-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when CONFIG_BLOCK is not enabled:

drivers/base/core.c: In function 'get_device_parent':
drivers/base/core.c:634: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_add_class_symlinks':
drivers/base/core.c:723: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_remove_class_symlinks':
drivers/base/core.c:751: error: 'block_class' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f7f906f..2cb49a9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -630,12 +630,14 @@ static struct kobject *get_device_parent(struct device *dev,
 		struct kobject *parent_kobj;
 		struct kobject *k;
 
+#ifdef CONFIG_BLOCK
 		/* block disks show up in /sys/block */
 		if (sysfs_deprecated && dev->class == &block_class) {
 			if (parent && parent->class == &block_class)
 				return &parent->kobj;
 			return &block_class.p->class_subsys.kobj;
 		}
+#endif
 
 		/*
 		 * If we have no parent, we live in "virtual".
@@ -719,9 +721,11 @@ static int device_add_class_symlinks(struct device *dev)
 			goto out_subsys;
 	}
 
+#ifdef CONFIG_BLOCK
 	/* /sys/block has directories and does not need symlinks */
 	if (sysfs_deprecated && dev->class == &block_class)
 		return 0;
+#endif
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
@@ -748,8 +752,10 @@ static void device_remove_class_symlinks(struct device *dev)
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 	sysfs_remove_link(&dev->kobj, "subsystem");
+#ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		return;
+#endif
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
-- 
1.7.2

