Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0ENELj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:11:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35277 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0ENELc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:11:32 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Date: Thu, 13 May 2010 21:11:07 -0700
Message-Id: <1273810273-3039-3-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1273810273-3039-2-git-send-email-arve@android.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
 <1273810273-3039-2-git-send-email-arve@android.com>
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
 Documentation/power/opportunistic-suspend.txt |   27 +++++
 include/linux/suspend_ioctls.h                |    4 +
 kernel/power/Kconfig                          |    7 ++
 kernel/power/Makefile                         |    1 +
 kernel/power/user_suspend_blocker.c           |  143 +++++++++++++++++++++++++
 6 files changed, 184 insertions(+), 1 deletions(-)
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
index 4bee7bc..93f4c24 100644
--- a/Documentation/power/opportunistic-suspend.txt
+++ b/Documentation/power/opportunistic-suspend.txt
@@ -127,3 +127,30 @@ if (list_empty(&state->pending_work))
 	suspend_unblock(&state->suspend_blocker);
 else
 	suspend_block(&state->suspend_blocker);
+
+User space API
+==============
+
+To create a suspend blocker from user space, open the suspend_blocker special
+device file:
+
+    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
+
+then optionally call:
+
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
+
+To activate the suspend blocker call:
+
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
+
+To deactivate it call:
+
+    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
+
+To destroy the suspend blocker, close the device:
+
+    close(fd);
+
+If the first ioctl called is not SUSPEND_BLOCKER_IOCTL_SET_NAME the suspend
+blocker will get the default name "(userspace)".
diff --git a/include/linux/suspend_ioctls.h b/include/linux/suspend_ioctls.h
index 0b30382..b95a6b2 100644
--- a/include/linux/suspend_ioctls.h
+++ b/include/linux/suspend_ioctls.h
@@ -30,4 +30,8 @@ struct resume_swap_area {
 #define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
 #define SNAPSHOT_IOC_MAXNR	20
 
+#define SUSPEND_BLOCKER_IOCTL_SET_NAME(len)	_IOC(_IOC_WRITE, 's', 0, len)
+#define SUSPEND_BLOCKER_IOCTL_BLOCK		_IO('s', 1)
+#define SUSPEND_BLOCKER_IOCTL_UNBLOCK		_IO('s', 2)
+
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 6d11a45..2e665cd 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -146,6 +146,13 @@ config OPPORTUNISTIC_SUSPEND
 	  determines the sleep state the system will be put into when there are
 	  no active suspend blockers.
 
+config USER_SUSPEND_BLOCKERS
+	bool "User space suspend blockers"
+	depends on OPPORTUNISTIC_SUSPEND
+	---help---
+	  User space suspend blockers API.  Creates a misc device allowing user
+	  space to create, use and destroy suspend blockers.
+
 config HIBERNATION_NVS
 	bool
 
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 95d8e6d..2015594 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_OPPORTUNISTIC_SUSPEND)	+= opportunistic_suspend.o
+obj-$(CONFIG_USER_SUSPEND_BLOCKERS)	+= user_suspend_blocker.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
diff --git a/kernel/power/user_suspend_blocker.c b/kernel/power/user_suspend_blocker.c
new file mode 100644
index 0000000..d53f939
--- /dev/null
+++ b/kernel/power/user_suspend_blocker.c
@@ -0,0 +1,143 @@
+/*
+ * kernel/power/user_suspend_blocker.c
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
+#include <linux/suspend.h>
+#include <linux/suspend_ioctls.h>
+
+enum {
+	DEBUG_FAILURE	= BIT(0),
+};
+static int debug_mask = DEBUG_FAILURE;
+module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
+
+static DEFINE_MUTEX(ioctl_lock);
+
+#define USER_SUSPEND_BLOCKER_NAME_LEN 31
+
+struct user_suspend_blocker {
+	struct suspend_blocker	blocker;
+	char			name[USER_SUSPEND_BLOCKER_NAME_LEN + 1];
+	bool			registered;
+};
+
+static int user_suspend_blocker_open(struct inode *inode, struct file *filp)
+{
+	struct user_suspend_blocker *blocker;
+
+	blocker = kzalloc(sizeof(*blocker), GFP_KERNEL);
+	if (!blocker)
+		return -ENOMEM;
+
+	nonseekable_open(inode, filp);
+	strcpy(blocker->name, "(userspace)");
+	blocker->blocker.name = blocker->name;
+	filp->private_data = blocker;
+
+	return 0;
+}
+
+static int suspend_blocker_set_name(struct user_suspend_blocker *blocker,
+				    void __user *name, size_t name_len)
+{
+	if (blocker->registered)
+		return -EBUSY;
+
+	if (name_len > USER_SUSPEND_BLOCKER_NAME_LEN)
+		name_len = USER_SUSPEND_BLOCKER_NAME_LEN;
+
+	if (copy_from_user(blocker->name, name, name_len))
+		return -EFAULT;
+	blocker->name[name_len] = '\0';
+
+	return 0;
+}
+
+static long user_suspend_blocker_ioctl(struct file *filp, unsigned int cmd,
+					unsigned long _arg)
+{
+	void __user *arg = (void __user *)_arg;
+	struct user_suspend_blocker *blocker = filp->private_data;
+	long ret = 0;
+
+	mutex_lock(&ioctl_lock);
+	if ((cmd & ~IOCSIZE_MASK) == SUSPEND_BLOCKER_IOCTL_SET_NAME(0)) {
+		ret = suspend_blocker_set_name(blocker, arg, _IOC_SIZE(cmd));
+		goto done;
+	}
+	if (!blocker->registered) {
+		suspend_blocker_register(&blocker->blocker);
+		blocker->registered = true;
+	}
+	switch (cmd) {
+	case SUSPEND_BLOCKER_IOCTL_BLOCK:
+		suspend_block(&blocker->blocker);
+		break;
+
+	case SUSPEND_BLOCKER_IOCTL_UNBLOCK:
+		suspend_unblock(&blocker->blocker);
+		break;
+
+	default:
+		ret = -ENOTTY;
+	}
+done:
+	if (ret && (debug_mask & DEBUG_FAILURE))
+		pr_err("user_suspend_blocker_ioctl: cmd %x failed, %ld\n",
+			cmd, ret);
+	mutex_unlock(&ioctl_lock);
+	return ret;
+}
+
+static int user_suspend_blocker_release(struct inode *inode, struct file *filp)
+{
+	struct user_suspend_blocker *blocker = filp->private_data;
+
+	if (blocker->registered)
+		suspend_blocker_unregister(&blocker->blocker);
+	kfree(blocker);
+
+	return 0;
+}
+
+const struct file_operations user_suspend_blocker_fops = {
+	.open = user_suspend_blocker_open,
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

