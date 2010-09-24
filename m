Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0IXViK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:38:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab0IXViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:38:09 -0400
Date: Fri, 24 Sep 2010 14:36:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] driver core: fix build for CONFIG_BLOCK not enabled
Message-Id: <20100924143649.59f0572a.randy.dunlap@oracle.com>
In-Reply-To: <20100924145537.bd092bfb.sfr@canb.auug.org.au>
References: <20100924145537.bd092bfb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
---
 drivers/base/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20100924.orig/drivers/base/core.c
+++ linux-next-20100924/drivers/base/core.c
@@ -630,12 +630,14 @@ static struct kobject *get_device_parent
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
@@ -719,9 +721,11 @@ static int device_add_class_symlinks(str
 			goto out_subsys;
 	}
 
+#ifdef CONFIG_BLOCK
 	/* /sys/block has directories and does not need symlinks */
 	if (sysfs_deprecated && dev->class == &block_class)
 		return 0;
+#endif
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
@@ -748,8 +752,10 @@ static void device_remove_class_symlinks
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 	sysfs_remove_link(&dev->kobj, "subsystem");
+#ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		return;
+#endif
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
