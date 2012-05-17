Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2EQIm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:42:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2EQImp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:42:45 -0400
Date: Thu, 17 May 2012 01:41:16 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 5/6] staging/android: Remove ram_console driver
Message-ID: <20120517084115.GE31753@lizard>
References: <20120517083740.GA25627@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120517083740.GA25627@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the functionality is now supported by pstore and pstore_ram drivers.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/Kconfig       |    5 -
 drivers/staging/android/Makefile      |    1 -
 drivers/staging/android/ram_console.c |  179 ---------------------------------
 3 files changed, 185 deletions(-)
 delete mode 100644 drivers/staging/android/ram_console.c

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 63f9822..df42c6b 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -25,11 +25,6 @@ config ANDROID_LOGGER
 	tristate "Android log driver"
 	default n
 
-config ANDROID_RAM_CONSOLE
-	bool "Android RAM buffer console"
-	depends on !S390 && !UML && HAVE_MEMBLOCK && PSTORE_RAM=y
-	default n
-
 config ANDROID_TIMED_OUTPUT
 	bool "Timed output class driver"
 	default y
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 4677e7b..5f3ef2e 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
 obj-$(CONFIG_ANDROID_LOGGER)		+= logger.o
-obj-$(CONFIG_ANDROID_RAM_CONSOLE)	+= ram_console.o
 obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
 obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
 obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
deleted file mode 100644
index 82323bb..0000000
--- a/drivers/staging/android/ram_console.c
+++ /dev/null
@@ -1,179 +0,0 @@
-/* drivers/android/ram_console.c
- *
- * Copyright (C) 2007-2008 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/proc_fs.h>
-#include <linux/string.h>
-#include <linux/uaccess.h>
-#include <linux/io.h>
-#include <linux/pstore_ram.h>
-#include "ram_console.h"
-
-static struct persistent_ram_zone *ram_console_zone;
-static const char *bootinfo;
-static size_t bootinfo_size;
-
-static void
-ram_console_write(struct console *console, const char *s, unsigned int count)
-{
-	struct persistent_ram_zone *prz = console->data;
-	persistent_ram_write(prz, s, count);
-}
-
-static struct console ram_console = {
-	.name	= "ram",
-	.write	= ram_console_write,
-	.flags	= CON_PRINTBUFFER | CON_ENABLED | CON_ANYTIME,
-	.index	= -1,
-};
-
-void ram_console_enable_console(int enabled)
-{
-	if (enabled)
-		ram_console.flags |= CON_ENABLED;
-	else
-		ram_console.flags &= ~CON_ENABLED;
-}
-
-static int __init ram_console_probe(struct platform_device *pdev)
-{
-	struct ram_console_platform_data *pdata = pdev->dev.platform_data;
-	struct persistent_ram_zone *prz;
-
-	prz = persistent_ram_init_ringbuffer(&pdev->dev, true);
-	if (IS_ERR(prz))
-		return PTR_ERR(prz);
-
-
-	if (pdata) {
-		bootinfo = kstrdup(pdata->bootinfo, GFP_KERNEL);
-		if (bootinfo)
-			bootinfo_size = strlen(bootinfo);
-	}
-
-	ram_console_zone = prz;
-	ram_console.data = prz;
-
-	register_console(&ram_console);
-
-	return 0;
-}
-
-static struct platform_driver ram_console_driver = {
-	.driver		= {
-		.name	= "ram_console",
-	},
-};
-
-static int __init ram_console_module_init(void)
-{
-	return platform_driver_probe(&ram_console_driver, ram_console_probe);
-}
-
-#ifndef CONFIG_PRINTK
-#define dmesg_restrict	0
-#endif
-
-static ssize_t ram_console_read_old(struct file *file, char __user *buf,
-				    size_t len, loff_t *offset)
-{
-	loff_t pos = *offset;
-	ssize_t count;
-	struct persistent_ram_zone *prz = ram_console_zone;
-	size_t old_log_size = persistent_ram_old_size(prz);
-	const char *old_log = persistent_ram_old(prz);
-	char *str;
-	int ret;
-
-	if (dmesg_restrict && !capable(CAP_SYSLOG))
-		return -EPERM;
-
-	/* Main last_kmsg log */
-	if (pos < old_log_size) {
-		count = min(len, (size_t)(old_log_size - pos));
-		if (copy_to_user(buf, old_log + pos, count))
-			return -EFAULT;
-		goto out;
-	}
-
-	/* ECC correction notice */
-	pos -= old_log_size;
-	count = persistent_ram_ecc_string(prz, NULL, 0);
-	if (pos < count) {
-		str = kmalloc(count, GFP_KERNEL);
-		if (!str)
-			return -ENOMEM;
-		persistent_ram_ecc_string(prz, str, count + 1);
-		count = min(len, (size_t)(count - pos));
-		ret = copy_to_user(buf, str + pos, count);
-		kfree(str);
-		if (ret)
-			return -EFAULT;
-		goto out;
-	}
-
-	/* Boot info passed through pdata */
-	pos -= count;
-	if (pos < bootinfo_size) {
-		count = min(len, (size_t)(bootinfo_size - pos));
-		if (copy_to_user(buf, bootinfo + pos, count))
-			return -EFAULT;
-		goto out;
-	}
-
-	/* EOF */
-	return 0;
-
-out:
-	*offset += count;
-	return count;
-}
-
-static const struct file_operations ram_console_file_ops = {
-	.owner = THIS_MODULE,
-	.read = ram_console_read_old,
-};
-
-static int __init ram_console_late_init(void)
-{
-	struct proc_dir_entry *entry;
-	struct persistent_ram_zone *prz = ram_console_zone;
-
-	if (!prz)
-		return 0;
-
-	if (persistent_ram_old_size(prz) == 0)
-		return 0;
-
-	entry = create_proc_entry("last_kmsg", S_IFREG | S_IRUGO, NULL);
-	if (!entry) {
-		printk(KERN_ERR "ram_console: failed to create proc entry\n");
-		persistent_ram_free_old(prz);
-		return 0;
-	}
-
-	entry->proc_fops = &ram_console_file_ops;
-	entry->size = persistent_ram_old_size(prz) +
-		persistent_ram_ecc_string(prz, NULL, 0) +
-		bootinfo_size;
-
-	return 0;
-}
-
-late_initcall(ram_console_late_init);
-postcore_initcall(ram_console_module_init);
-- 
1.7.9.2

