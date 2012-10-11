Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2JKF5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:57:43 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39015 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab2JKF5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:57:42 -0400
X-AuditID: b753bd60-914c2ba0000047ca-c7-50765f3aaab6
X-AuditID: b753bd60-914c2ba0000047ca-c7-50765f3aaab6
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 1/3 V3] livedump: Add the new misc device "livedump"
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "Khalid Aziz" <khalid.aziz@hp.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 11 Oct 2012 14:53:56 +0900
Message-ID: <20121011055356.6719.5640.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
References: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/Kconfig  |   15 +++++++++++
 kernel/Makefile   |    1 +
 kernel/livedump.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 kernel/livedump.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50a1d1f..39c0813 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1734,6 +1734,21 @@ config CMDLINE_OVERRIDE
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
index c0cc67a..c8bd09b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_LIVEDUMP) += livedump.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/livedump.c b/kernel/livedump.c
new file mode 100644
index 0000000..409f7ed
--- /dev/null
+++ b/kernel/livedump.c
@@ -0,0 +1,73 @@
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
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
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
+static const struct file_operations livedump_fops = {
+	.unlocked_ioctl = livedump_ioctl,
+};
+static struct miscdevice livedump_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = DEVICE_NAME,
+	.fops = &livedump_fops,
+};
+
+static int livedump_exit(struct notifier_block *_, unsigned long __, void *___)
+{
+	misc_deregister(&livedump_misc);
+	return NOTIFY_DONE;
+}
+static struct notifier_block livedump_nb = {
+	.notifier_call = livedump_exit
+};
+
+static int __init livedump_init(void)
+{
+	int ret;
+
+	ret = misc_register(&livedump_misc);
+	if (WARN_ON(ret))
+		return ret;
+
+	ret = register_reboot_notifier(&livedump_nb);
+	if (WARN_ON(ret)) {
+		livedump_exit(NULL, 0, NULL);
+		return ret;
+	}
+
+	return 0;
+}
+device_initcall(livedump_init);

