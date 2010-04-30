Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab0D3Whe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:37:34 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:43528 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab0D3WhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:37:20 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Fri, 30 Apr 2010 15:36:55 -0700
Message-Id: <1272667021-21312-3-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1272667021-21312-2-git-send-email-arve@android.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <1272667021-21312-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a misc device, "suspend_blocker", that allows user-space processes
to block auto suspend. The device has ioctls to create a suspend_blocker,
and to block and unblock suspend. To delete the suspend_blocker, close
the device.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 Documentation/ioctl/ioctl-number.txt          |    3 +-
 Documentation/power/opportunistic-suspend.txt |   17 ++++
 include/linux/suspend_block_dev.h             |   25 +++++
 kernel/power/Kconfig                          |    9 ++
 kernel/power/Makefile                         |    1 +
 kernel/power/user_suspend_blocker.c           |  128 +++++++++++++++++++++++++
 6 files changed, 182 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/suspend_block_dev.h
 create mode 100644 kernel/power/user_suspend_blocker.c

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index dd5806f..e2458f7 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -254,7 +254,8 @@ Code  Seq#(hex)	Include File		Comments
 'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
 		linux/ixjuser.h		<http://www.quicknet.net>
 'r'	00-1F	linux/msdos_fs.h and fs/fat/dir.c
-'s'	all	linux/cdk.h
+'s'	all	linux/cdk.h	conflict!
+'s'	all	linux/suspend_block_dev.h	conflict!
 't'	00-7F	linux/if_ppp.h
 't'	80-8F	linux/isdn_ppp.h
 't'	90	linux/toshiba.h
diff --git a/Documentation/power/opportunistic-suspend.txt b/Documentation/power/opportunistic-suspend.txt
index 3d060e8..f2b145e 100644
--- a/Documentation/power/opportunistic-suspend.txt
+++ b/Documentation/power/opportunistic-suspend.txt
@@ -117,3 +117,20 @@ if (list_empty(&state->pending_work))
 else
 	suspend_block(&state->suspend_blocker);
 
+User-space API
+==============
+
+To create a suspend_blocker from user-space, open the suspend_blocker device:
+    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
+then call:
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
+
+To activate a suspend_blocker call:
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
+
+To unblock call:
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
+
+To destroy the suspend_blocker, close the device:
+    close(fd);
+
diff --git a/include/linux/suspend_block_dev.h b/include/linux/suspend_block_dev.h
new file mode 100644
index 0000000..24bc5c7
--- /dev/null
+++ b/include/linux/suspend_block_dev.h
@@ -0,0 +1,25 @@
+/* include/linux/suspend_block_dev.h
+ *
+ * Copyright (C) 2009 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_SUSPEND_BLOCK_DEV_H
+#define _LINUX_SUSPEND_BLOCK_DEV_H
+
+#include <linux/ioctl.h>
+
+#define SUSPEND_BLOCKER_IOCTL_INIT(len)		_IOC(_IOC_WRITE, 's', 0, len)
+#define SUSPEND_BLOCKER_IOCTL_BLOCK		_IO('s', 1)
+#define SUSPEND_BLOCKER_IOCTL_UNBLOCK		_IO('s', 2)
+
+#endif
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 55a06a1..fe5a2f2 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -146,6 +146,15 @@ config OPPORTUNISTIC_SUSPEND
 	  determines the sleep state the system will be put into when there are
 	  no active suspend blockers.
 
+config USER_SUSPEND_BLOCKERS
+	bool "Userspace suspend blockers"
+	depends on OPPORTUNISTIC_SUSPEND
+	default y
+	---help---
+	  User-space suspend block api. Creates a misc device with ioctls
+	  to create, block and unblock a suspend_blocker. The suspend_blocker
+	  will be deleted when the device is closed.
+
 config HIBERNATION_NVS
 	bool
 
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index ee5276d..78f703b 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_OPPORTUNISTIC_SUSPEND)	+= suspend_blocker.o
+obj-$(CONFIG_USER_SUSPEND_BLOCKERS)	+= user_suspend_blocker.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
diff --git a/kernel/power/user_suspend_blocker.c b/kernel/power/user_suspend_blocker.c
new file mode 100644
index 0000000..dc1d06f
--- /dev/null
+++ b/kernel/power/user_suspend_blocker.c
@@ -0,0 +1,128 @@
+/* kernel/power/user_suspend_block.c
+ *
+ * Copyright (C) 2009-2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/suspend_blocker.h>
+#include <linux/suspend_block_dev.h>
+
+enum {
+	DEBUG_FAILURE	= BIT(0),
+};
+static int debug_mask = DEBUG_FAILURE;
+module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
+
+static DEFINE_MUTEX(ioctl_lock);
+
+struct user_suspend_blocker {
+	struct suspend_blocker	blocker;
+	char			name[0];
+};
+
+static int create_user_suspend_blocker(struct file *file, void __user *name,
+				 size_t name_len)
+{
+	struct user_suspend_blocker *bl;
+	if (file->private_data)
+		return -EBUSY;
+	if (name_len > NAME_MAX)
+		return -ENAMETOOLONG;
+	bl = kzalloc(sizeof(*bl) + name_len + 1, GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
+	if (copy_from_user(bl->name, name, name_len))
+		goto err_fault;
+	suspend_blocker_init(&bl->blocker, bl->name);
+	file->private_data = bl;
+	return 0;
+
+err_fault:
+	kfree(bl);
+	return -EFAULT;
+}
+
+static long user_suspend_blocker_ioctl(struct file *file, unsigned int cmd,
+				unsigned long _arg)
+{
+	void __user *arg = (void __user *)_arg;
+	struct user_suspend_blocker *bl;
+	long ret;
+
+	mutex_lock(&ioctl_lock);
+	if ((cmd & ~IOCSIZE_MASK) == SUSPEND_BLOCKER_IOCTL_INIT(0)) {
+		ret = create_user_suspend_blocker(file, arg, _IOC_SIZE(cmd));
+		goto done;
+	}
+	bl = file->private_data;
+	if (!bl) {
+		ret = -ENOENT;
+		goto done;
+	}
+	switch (cmd) {
+	case SUSPEND_BLOCKER_IOCTL_BLOCK:
+		suspend_block(&bl->blocker);
+		ret = 0;
+		break;
+	case SUSPEND_BLOCKER_IOCTL_UNBLOCK:
+		suspend_unblock(&bl->blocker);
+		ret = 0;
+		break;
+	default:
+		ret = -ENOTSUPP;
+	}
+done:
+	if (ret && (debug_mask & DEBUG_FAILURE))
+		pr_err("user_suspend_blocker_ioctl: cmd %x failed, %ld\n",
+			cmd, ret);
+	mutex_unlock(&ioctl_lock);
+	return ret;
+}
+
+static int user_suspend_blocker_release(struct inode *inode, struct file *file)
+{
+	struct user_suspend_blocker *bl = file->private_data;
+	if (!bl)
+		return 0;
+	suspend_blocker_destroy(&bl->blocker);
+	kfree(bl);
+	return 0;
+}
+
+const struct file_operations user_suspend_blocker_fops = {
+	.release = user_suspend_blocker_release,
+	.unlocked_ioctl = user_suspend_blocker_ioctl,
+};
+
+struct miscdevice user_suspend_blocker_device = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "suspend_blocker",
+	.fops = &user_suspend_blocker_fops,
+};
+
+static int __init user_suspend_blocker_init(void)
+{
+	return misc_register(&user_suspend_blocker_device);
+}
+
+static void __exit user_suspend_blocker_exit(void)
+{
+	misc_deregister(&user_suspend_blocker_device);
+}
+
+module_init(user_suspend_blocker_init);
+module_exit(user_suspend_blocker_exit);
-- 
1.6.5.1

