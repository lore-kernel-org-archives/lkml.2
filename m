Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0ITQWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:22:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65308 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0ITQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:22:44 -0400
Date: Mon, 20 Sep 2010 09:20:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kay Sievers <kay.sievers@vrfy.org>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] driver core: fix build for CONFIG_BLOCK=n
Message-Id: <20100920092034.0b3f5898.randy.dunlap@oracle.com>
In-Reply-To: <20100920161239.f204a507.sfr@canb.auug.org.au>
References: <20100920161239.f204a507.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build when CONFIG_BLOCK is not enabled (since SEP-06).
Fixes these build errors:

drivers/base/core.c: In function 'get_device_parent':
drivers/base/core.c:622: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_add_class_symlinks':
drivers/base/core.c:712: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c: In function 'device_remove_class_symlinks':
drivers/base/core.c:742: error: 'block_class' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20100920.orig/drivers/base/core.c
+++ linux-next-20100920/drivers/base/core.c
@@ -618,6 +618,7 @@ static struct kobject *get_device_parent
 		struct kobject *k;
 
 #ifdef CONFIG_SYSFS_DEPRECATED
+#ifdef CONFIG_BLOCK
 		/* block disks show up in /sys/block */
 		if (dev->class == &block_class) {
 			if (parent && parent->class == &block_class)
@@ -625,6 +626,7 @@ static struct kobject *get_device_parent
 			return &block_class.p->class_subsys.kobj;
 		}
 #endif
+#endif
 		/*
 		 * If we have no parent, we live in "virtual".
 		 * Class-devices with a non class-device as parent, live
@@ -708,10 +710,12 @@ static int device_add_class_symlinks(str
 	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
+#ifdef CONFIG_BLOCK
 	/* /sys/block has directories and does not need symlinks */
 	if (dev->class == &block_class)
 		return 0;
 #endif
+#endif
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
@@ -739,9 +743,11 @@ static void device_remove_class_symlinks
 		sysfs_remove_link(&dev->kobj, "device");
 	sysfs_remove_link(&dev->kobj, "subsystem");
 #ifdef CONFIG_SYSFS_DEPRECATED
+#ifdef CONFIG_BLOCK
 	if (dev->class == &block_class)
 		return;
 #endif
+#endif
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
