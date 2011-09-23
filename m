Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1IWXD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:03:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1IWXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:03:56 -0400
From: Simon Glass <sjg@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Da Zheng <zhengda@chromium.org>,
        Da Zheng <zhengda@chromium.com>
Subject: [RFC PATCH 1/3] bootstage: Add bootstages to record timing in the kernel.
Date: Fri, 23 Sep 2011 16:03:16 -0700
Message-Id: <1316818998-30711-2-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Da Zheng <zhengda@chromium.org>

From: Da Zheng <zhengda@chromium.org>

We can record timing in the kernel by invoking bootstage_mark() or
bootstage_mark_early for early stages before memory and timekeeping
are initialized. It also uses debugfs to interact with the user space.

Signed-off-by: Da Zheng <zhengda@chromium.com>
---
 include/linux/bootstage.h |   18 ++++
 include/linux/timer.h     |    3 +
 init/Kconfig              |    9 ++
 init/Makefile             |    1 +
 init/bootstage.c          |  228 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c            |    9 ++
 6 files changed, 268 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/bootstage.h
 create mode 100644 init/bootstage.c

diff --git a/include/linux/bootstage.h b/include/linux/bootstage.h
new file mode 100644
index 0000000..08df102
--- /dev/null
+++ b/include/linux/bootstage.h
@@ -0,0 +1,18 @@
+#ifndef __BOOTSTAGE_H
+#define __BOOTSTAGE_H
+
+#ifdef CONFIG_BOOTSTAGE
+unsigned long bootstage_mark(const char *name);
+unsigned long bootstage_mark_early(const char *name);
+#else
+static inline unsigned long bootstage_mark(const char *name)
+{
+	return 0;
+}
+static inline unsigned long bootstage_mark_early(const char *name)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6abd913..970e283 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -299,4 +299,7 @@ unsigned long __round_jiffies_up_relative(unsigned long j, int cpu);
 unsigned long round_jiffies_up(unsigned long j);
 unsigned long round_jiffies_up_relative(unsigned long j);
 
+/* Timer for bootstage, for now */
+unsigned long timer_get_us(void);
+
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index d627783..f0f40ea 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1399,3 +1399,12 @@ config PADATA
 	bool
 
 source "kernel/Kconfig.locks"
+
+config BOOTSTAGE
+	bool "Enable timing of boot stages"
+	help
+	  This enables to record the timing of different stages during boot.
+	  The timing in the kernel can be recorded by invoking bootstage_mark().
+	  The timing in the user space can be recorded by writing the stage name
+	  to /sys/kernel/debug/bootstage/mark. A report of information collected
+	  to date is available from /sys/kernel/debug/bootstage/report.
diff --git a/init/Makefile b/init/Makefile
index 0bf677a..7bfc047 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -8,6 +8,7 @@ obj-y                          += noinitramfs.o
 else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
+obj-$(CONFIG_BOOTSTAGE)		+= bootstage.o
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 
 mounts-y			:= do_mounts.o
diff --git a/init/bootstage.c b/init/bootstage.c
new file mode 100644
index 0000000..79e9761
--- /dev/null
+++ b/init/bootstage.c
@@ -0,0 +1,228 @@
+#include <linux/debugfs.h>
+#include <linux/mutex.h>
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/ktime.h>
+
+#include "linux/bootstage.h"
+
+#define BOOTSTAGE_COUNT 8
+#define MAX_NAME 32
+
+struct bootstage_record {
+	unsigned long time;
+	const char name[MAX_NAME];
+};
+
+static DEFINE_MUTEX(bootstage_mutex);
+
+/*
+ * this array is to record the bootstages at the beginning of
+ * kernel initialization, before memory is initialized.
+ */
+static struct bootstage_record bootstages[BOOTSTAGE_COUNT];
+
+/* the number of timing recorded in the bootstages array */
+static int num_bootstages;
+
+/* the space size of the bootstages array */
+static int cap_bootstages = BOOTSTAGE_COUNT;
+static struct bootstage_record *full_bootstages = bootstages;
+
+static unsigned long __bootstage_mark_early(int idx, const char *name)
+{
+	unsigned long curr = timer_get_us();
+
+	strlcpy(full_bootstages[idx].name, name, MAX_NAME);
+
+	/* this records timing in microseconds. */
+	full_bootstages[idx].time = curr;
+	return full_bootstages[idx].time;
+}
+
+static unsigned long __bootstage_mark(int idx, const char *name)
+{
+	struct timespec ts;
+
+	/* this function can be used only after timekeeping is called. */
+	ktime_get_ts(&ts);
+	strlcpy(full_bootstages[idx].name, name, MAX_NAME);
+
+	/* this records timing in microseconds. */
+	full_bootstages[idx].time = ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
+	return full_bootstages[idx].time;
+}
+
+static inline int __inc_bootstages(void)
+{
+	struct bootstage_record *tmp;
+
+	cap_bootstages *= 2;
+	tmp = kmalloc(sizeof(*tmp) * cap_bootstages, GFP_KERNEL);
+	if (!tmp)
+		return -1;
+	memcpy(tmp, full_bootstages, sizeof(*tmp) * num_bootstages);
+
+	/*
+	 * full_bootstages first points to bootstages,
+	 * which is a static array.
+	 */
+	if (full_bootstages != bootstages)
+		kfree(full_bootstages);
+	full_bootstages = tmp;
+	return 0;
+}
+
+/*
+ * This is used during the initialization of the kernel.
+ */
+unsigned long bootstage_mark(const char *name)
+{
+	unsigned long ret;
+
+	mutex_lock(&bootstage_mutex);
+
+	if (num_bootstages == cap_bootstages) {
+		if (__inc_bootstages() < 0) {
+			mutex_unlock(&bootstage_mutex);
+			return -1;
+		}
+	}
+
+	ret = __bootstage_mark(num_bootstages, name);
+	num_bootstages++;
+
+	mutex_unlock(&bootstage_mutex);
+	return ret;
+}
+
+/*
+ * This is the same as bootstage_mark, but it can be used
+ * before memory and even timekeeping are initialized.
+ */
+unsigned long bootstage_mark_early(const char *name)
+{
+	unsigned long ret = 0;
+
+	mutex_lock(&bootstage_mutex);
+
+	if (num_bootstages < cap_bootstages) {
+		ret = __bootstage_mark_early(num_bootstages, name);
+		num_bootstages++;
+	}
+
+	mutex_unlock(&bootstage_mutex);
+	return ret;
+}
+
+static int get_bootstage_text(char *buf, int size)
+{
+	int i;
+	int written = 0;
+
+	for (i = 0; i < num_bootstages; i++) {
+		int ret = scnprintf(buf + written, size - written, "%s\t%ld\n",
+				full_bootstages[i].name,
+				full_bootstages[i].time);
+		written += ret;
+		if (written == size && i < num_bootstages - 1) {
+			printk(KERN_WARNING "bootstage: buffer exhausted");
+			break;
+		}
+	}
+	return written;
+}
+
+static ssize_t bootstage_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	int err = 0;
+	char *lbuf;
+	int written = 0;
+	int size = (MAX_NAME + 10) * num_bootstages;
+
+	/*
+	 * If the user tries to continue reading,
+	 * return 0 to notify the user all content has been read.
+	 */
+	if (*ppos)
+		return 0;
+
+	lbuf = kmalloc(size, GFP_KERNEL);
+	if (!lbuf)
+		return -ENOMEM;
+
+	mutex_lock(&bootstage_mutex);
+	err = -EFAULT;
+	written = get_bootstage_text(lbuf, size);
+	if (count > written)
+		count = written;
+	if (!copy_to_user(buf, lbuf, count)) {
+		err = count;
+		*ppos += count;
+	}
+
+	mutex_unlock(&bootstage_mutex);
+	kfree(lbuf);
+	return err;
+}
+
+static ssize_t bootstage_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	char *lbuf;
+	int err = 0;
+
+	lbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!lbuf)
+		return -ENOMEM;
+	if (copy_from_user(lbuf, buf, count)) {
+		kfree(lbuf);
+		return -EFAULT;
+	}
+
+	/* The input string might end with \n or not end with null. */
+	if (lbuf[count - 1] == '\n')
+		lbuf[count - 1] = '\0';
+	else
+		lbuf[count] = '\0';
+
+	mutex_lock(&bootstage_mutex);
+	if (num_bootstages == cap_bootstages) {
+		if (__inc_bootstages() < 0)
+			err = -EFAULT;
+	}
+	if (err == 0) {
+		__bootstage_mark(num_bootstages, lbuf);
+		num_bootstages++;
+		err = count;
+	}
+	mutex_unlock(&bootstage_mutex);
+	kfree(lbuf);
+	return err;
+}
+
+static const struct file_operations report_operations = {
+	.read	= bootstage_read,
+};
+
+static const struct file_operations mark_operations = {
+	.write	= bootstage_write,
+};
+
+static int __init bootstage_init(void)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("bootstage", NULL);
+	if (dir && !IS_ERR(dir)) {
+		debugfs_create_file("report", S_IFREG|S_IRUSR|S_IRGRP|S_IROTH,
+				dir, NULL, &report_operations);
+		debugfs_create_file("mark", S_IFREG|S_IWUSR,
+				dir, NULL, &mark_operations);
+	}
+	return 0;
+}
+
+postcore_initcall(bootstage_init);
diff --git a/kernel/timer.c b/kernel/timer.c
index 8cff361..cb49e0c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1790,3 +1790,12 @@ void usleep_range(unsigned long min, unsigned long max)
 	do_usleep_range(min, max);
 }
 EXPORT_SYMBOL(usleep_range);
+
+/**
+ * A platform-specific timer to get the time since reset.
+ * It returns the time in microseconds.
+ */
+unsigned long __attribute__((weak)) timer_get_us(void)
+{
+	return 0;
+}
-- 
1.7.3.1

