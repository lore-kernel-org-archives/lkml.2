Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2EYJbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:31:31 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:56043 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2EYJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:05 -0400
X-AuditID: b753bd60-9a705ba000007aa1-3b-4fbf4c987531
X-AuditID: b753bd60-9a705ba000007aa1-3b-4fbf4c987531
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 2/4 V2] livedump: Add the new misc device "livedump"
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Andy Lutomirski" <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@redhat.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Kees Cook" <keescook@chromium.org>, "Kevin Hilman" <khilman@ti.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Tejun Heo" <tj@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 25 May 2012 18:12:07 +0900
Message-ID: <20120525091207.10256.87298.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces the new misc device "livedump".
This device will be used as interface between livedump and user space.
Right now, the device only has empty ioctl operation.

***ATTENTION PLEASE***
I think debugfs is more suitable for this feature, but currently livedump
uses the misc device for simplicity. This will be fixed in the future.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/Kconfig  |   15 ++++++++++
 kernel/Makefile   |    1 +
 kernel/livedump.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 kernel/livedump.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9866b0..4c97583 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1729,6 +1729,21 @@ config CMDLINE_OVERRIDE
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+config LIVEDUMP
+	bool "Live Dump support"
+	depends on X86_64
+	---help---
+	  Set this option to 'Y' to allow the kernel support to acquire
+	  a consistent snapshot of kernel space without stopping system.
+
+	  This feature regularly causes small overhead on kernel.
+
+	  Once this feature is initialized by its special ioctl, it
+	  allocates huge memory for itself and causes much more overhead
+	  on kernel.
+
+	  If in doubt, say N.
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/kernel/Makefile b/kernel/Makefile
index cb41b95..f095e7a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_LIVEDUMP) += livedump.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/livedump.c b/kernel/livedump.c
new file mode 100644
index 0000000..3103292
--- /dev/null
+++ b/kernel/livedump.c
@@ -0,0 +1,83 @@
+/* livedump.c - Live Dump's main
+ * Copyright (C) 2012 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+
+#define DEVICE_NAME	"livedump"
+
+#define LIVEDUMP_IOC(x)	_IO(0xff, x)
+
+static long livedump_ioctl(
+		struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static int livedump_open(struct inode *inode, struct file *file)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENOENT;
+	return 0;
+}
+
+static int livedump_release(struct inode *inode, struct file *file)
+{
+	module_put(THIS_MODULE);
+	return 0;
+}
+
+static const struct file_operations livedump_fops = {
+	.unlocked_ioctl = livedump_ioctl,
+	.open = livedump_open,
+	.release = livedump_release,
+};
+static struct miscdevice livedump_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = DEVICE_NAME,
+	.fops = &livedump_fops,
+};
+
+static int livedump_module_init(void)
+{
+	int ret;
+
+	ret = misc_register(&livedump_misc);
+	if (WARN(ret,
+				"livedump: Failed to register livedump on misc device.\n"
+		))
+		return ret;
+
+	return 0;
+}
+module_init(livedump_module_init);
+
+static void livedump_module_exit(void)
+{
+	misc_deregister(&livedump_misc);
+}
+module_exit(livedump_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Livedump kernel module");

