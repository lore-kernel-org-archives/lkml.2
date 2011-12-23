Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab1LWNgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:36:48 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:48249 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1LWNgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:36:44 -0500
X-AuditID: b753bd60-9a062ba00000359c-95-4ef48309e8a8
X-AuditID: b753bd60-9a062ba00000359c-95-4ef48309e8a8
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 2/5][RESEND] livedump: Add the new misc device "livedump"
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, frank.rowand@am.sony.com, jan.kiszka@web.de,
        yrl.pp-manager.tt@hitachi.com,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Kevin Hilman <khilman@ti.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Dec 2011 22:14:41 +0900
Message-ID: <20111223131441.13217.21839.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
References: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces the new misc device "livedump".
The device only has open, close and empty ioctl operations.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/Kconfig  |   15 ++++++++++
 kernel/Makefile   |    1 +
 kernel/livedump.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 kernel/livedump.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efb4294..32bc16d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1702,6 +1702,21 @@ config CMDLINE_OVERRIDE
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
index e898c5b..7d858e4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_LIVEDUMP) += livedump.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/livedump.c b/kernel/livedump.c
new file mode 100644
index 0000000..198bda5
--- /dev/null
+++ b/kernel/livedump.c
@@ -0,0 +1,82 @@
+/* livedump.c - Live Dump's main
+ * Copyright (C) 2011 Hitachi, Ltd.
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
+	if (WARN(ret, "livedump: "
+			"Failed to register livedump on misc device.\n"))
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

