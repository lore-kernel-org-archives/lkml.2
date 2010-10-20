Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0JTBhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:37:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0JTBhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620652"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 6/9] Hardware error record persistent support
Date: Wed, 20 Oct 2010 09:36:57 +0800
Message-Id: <1287538620-7442-7-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, corrected hardware error records will go through the kernel
processing and be logged to disk or network finally.  But for
uncorrected errors, system may go panic directly for better error
containment, disk or network is not usable in this half-working
system.  To avoid losing these valuable hardware error records, the
error records are saved into some kind of simple persistent storage
such as flash before panic, so that they can be read out after system
reboot successfully.

Different kind of simple persistent storage implementation mechanisms
are provided on different platforms, so an abstract interface for
persistent storage is defined.  Different implementations of the
interface can be registered.

This patch is designed by Andi Kleen and Huang Ying.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/char/herror/Makefile        |    2 
 drivers/char/herror/herr-core.c     |   39 +++++++-
 drivers/char/herror/herr-internal.h |   12 ++
 drivers/char/herror/herr-persist.c  |  174 ++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild                |    1 
 include/linux/herror.h              |   48 +++++++++
 6 files changed, 271 insertions(+), 5 deletions(-)
 create mode 100644 drivers/char/herror/herr-internal.h
 create mode 100644 drivers/char/herror/herr-persist.c

--- a/drivers/char/herror/Makefile
+++ b/drivers/char/herror/Makefile
@@ -1 +1 @@
-obj-y				+= herr-core.o
+obj-y				+= herr-core.o herr-persist.o
--- a/drivers/char/herror/herr-core.c
+++ b/drivers/char/herror/herr-core.c
@@ -43,9 +43,9 @@
 #include <linux/llalloc.h>
 #include <linux/herror.h>
 
-#define HERR_NOTIFY_BIT			0
+#include "herr-internal.h"
 
-static unsigned long herr_flags;
+unsigned long herr_flags;
 
 /*
  * Record list management and error reporting
@@ -524,6 +524,7 @@ static ssize_t herr_mix_read(struct file
 {
 	int rc;
 	static DEFINE_MUTEX(read_mutex);
+	u64 record_id;
 
 	if (*off != 0)
 		return -EINVAL;
@@ -531,7 +532,14 @@ static ssize_t herr_mix_read(struct file
 	rc = mutex_lock_interruptible(&read_mutex);
 	if (rc)
 		return rc;
+	rc = herr_persist_peek_user(&record_id, ubuf, usize);
+	if (rc > 0) {
+		herr_persist_clear(record_id);
+		goto out;
+	}
+
 	rc = herr_rcd_lists_read(ubuf, usize, &read_mutex);
+out:
 	mutex_unlock(&read_mutex);
 
 	return rc;
@@ -540,15 +548,40 @@ static ssize_t herr_mix_read(struct file
 static unsigned int herr_mix_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &herr_mix_wait, wait);
-	if (!herr_rcd_lists_is_empty())
+	if (!herr_rcd_lists_is_empty() || !herr_persist_read_done())
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
+static long herr_mix_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	void __user *p = (void __user *)arg;
+	int rc;
+	u64 record_id;
+	struct herr_persist_buffer buf;
+
+	switch (cmd) {
+	case HERR_PERSIST_PEEK:
+		rc = copy_from_user(&buf, p, sizeof(buf));
+		if (rc)
+			return -EFAULT;
+		return herr_persist_peek_user(&record_id, buf.buf,
+					      buf.buf_size);
+	case HERR_PERSIST_CLEAR:
+		rc = copy_from_user(&record_id, p, sizeof(record_id));
+		if (rc)
+			return -EFAULT;
+		return herr_persist_clear(record_id);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static const struct file_operations herr_mix_dev_fops = {
 	.owner		= THIS_MODULE,
 	.read		= herr_mix_read,
 	.poll		= herr_mix_poll,
+	.unlocked_ioctl	= herr_mix_ioctl,
 };
 
 static int __init herr_mix_dev_init(void)
--- /dev/null
+++ b/drivers/char/herror/herr-internal.h
@@ -0,0 +1,12 @@
+#ifndef HERR_INTERNAL_H
+#define HERR_INTERNAL_H
+
+#define HERR_NOTIFY_BIT			0
+
+extern unsigned long herr_flags;
+
+int herr_persist_read_done(void);
+ssize_t herr_persist_peek_user(u64 *record_id, char __user *ercd,
+			       size_t bufsiz);
+int herr_persist_clear(u64 record_id);
+#endif /* HERR_INTERNAL_H */
--- /dev/null
+++ b/drivers/char/herror/herr-persist.c
@@ -0,0 +1,174 @@
+/*
+ * Hardware error record persistent support
+ *
+ * Normally, corrected hardware error records will go through the
+ * kernel processing and be logged to disk or network finally.  But
+ * for uncorrected errors, system may go panic directly for better
+ * error containment, disk or network is not usable in this
+ * half-working system.  To avoid losing these valuable hardware error
+ * records, the error records are saved into some kind of simple
+ * persistent storage such as flash before panic, so that they can be
+ * read out after system reboot successfully.
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rculist.h>
+#include <linux/mutex.h>
+
+#include <linux/herror.h>
+
+#include "herr-internal.h"
+
+/*
+ * Simple persistent storage provider list, herr_persists_mutex is
+ * used for writer side mutual exclusion, RCU is used to implement
+ * lock-less reader side.
+ */
+static LIST_HEAD(herr_persists);
+static DEFINE_MUTEX(herr_persists_mutex);
+
+int herr_persist_register(struct herr_persist *persist)
+{
+	if (!persist->peek_user)
+		return -EINVAL;
+	persist->read_done = 0;
+	if (mutex_lock_interruptible(&herr_persists_mutex))
+		return -EINTR;
+	list_add_rcu(&persist->list, &herr_persists);
+	mutex_unlock(&herr_persists_mutex);
+	/*
+	 * There may be hardware error records of previous boot in
+	 * persistent storage, notify the user space error daemon to
+	 * check.
+	 */
+	set_bit(HERR_NOTIFY_BIT, &herr_flags);
+	herr_notify();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(herr_persist_register);
+
+void herr_persist_unregister(struct herr_persist *persist)
+{
+	mutex_lock(&herr_persists_mutex);
+	list_del_rcu(&persist->list);
+	mutex_unlock(&herr_persists_mutex);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(herr_persist_unregister);
+
+/* Can be used in atomic context including NMI */
+int herr_persist_in(const struct herr_record *ercd)
+{
+	struct herr_persist *persist;
+	int rc = -ENODEV;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(persist, &herr_persists, list) {
+		if (!persist->in)
+			continue;
+		rc = persist->in(ercd);
+		if (!rc)
+			break;
+	}
+	rcu_read_unlock();
+	return rc;
+}
+EXPORT_SYMBOL_GPL(herr_persist_in);
+
+int herr_persist_read_done(void)
+{
+	struct herr_persist *persist;
+	int rc = 1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(persist, &herr_persists, list) {
+		if (!persist->read_done) {
+			rc = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return rc;
+}
+
+/* Read next error record from persist storage, don't remove it */
+ssize_t herr_persist_peek_user(u64 *record_id, char __user *ercd,
+			       size_t bufsiz)
+{
+	struct herr_persist *persist;
+	ssize_t rc = 0;
+
+	if (mutex_lock_interruptible(&herr_persists_mutex))
+		return -EINTR;
+	list_for_each_entry(persist, &herr_persists, list) {
+		if (persist->read_done)
+			continue;
+		rc = persist->peek_user(record_id, ercd, bufsiz);
+		if (rc > 0)
+			break;
+		else if (rc != -EINTR && rc != -EAGAIN && rc != -EINVAL)
+			persist->read_done = 1;
+	}
+	mutex_unlock(&herr_persists_mutex);
+	return rc;
+}
+
+/* Clear specified error record from persist storage */
+int herr_persist_clear(u64 record_id)
+{
+	struct herr_persist *persist;
+	int rc = -ENOENT;
+
+	if (mutex_lock_interruptible(&herr_persists_mutex))
+		return -EINTR;
+	list_for_each_entry(persist, &herr_persists, list) {
+		if (!persist->clear)
+			continue;
+		rc = persist->clear(record_id);
+		if (!rc)
+			break;
+		/*
+		 * Failed to clear, mark as read_done, because we can
+		 * not skip this one
+		 */
+		else if (rc != -EINTR && rc != -EAGAIN && rc != -ENOENT)
+			persist->read_done = 1;
+	}
+	mutex_unlock(&herr_persists_mutex);
+	return rc;
+}
+
+static int herr_persist_record(struct herr_record *ercd, void *data)
+{
+	int *severity = data;
+
+	if (ercd->severity == *severity)
+		return herr_persist_in(ercd);
+	return 0;
+}
+
+void herr_persist_all_records(void)
+{
+	int severity;
+
+	for (severity = HERR_SEV_FATAL; severity >= HERR_SEV_NONE; severity--)
+		herr_for_each_record(herr_persist_record, &severity);
+}
+EXPORT_SYMBOL_GPL(herr_persist_all_records);
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -141,6 +141,7 @@ header-y += hdlc.h
 header-y += hdlcdrv.h
 header-y += hdreg.h
 header-y += herror_record.h
+header-y += herror.h
 header-y += hid.h
 header-y += hiddev.h
 header-y += hidraw.h
--- a/include/linux/herror.h
+++ b/include/linux/herror.h
@@ -1,10 +1,22 @@
 #ifndef LINUX_HERROR_H
 #define LINUX_HERROR_H
 
+#include <linux/ioctl.h>
+#include <linux/herror_record.h>
+
+struct herr_persist_buffer {
+	void __user *buf;
+	unsigned int buf_size;
+};
+
+#define HERR_PERSIST_PEEK	_IOW('H', 1, struct herr_persist_buffer)
+#define HERR_PERSIST_CLEAR	_IOW('H', 2, u64)
+
+#ifdef __KERNEL__
+
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/device.h>
-#include <linux/herror_record.h>
 
 /*
  * Hardware error reporting
@@ -66,4 +78,38 @@ static inline void herr_dev_put(struct h
 
 int herr_dev_register(struct herr_dev *dev);
 void herr_dev_unregister(struct herr_dev *dev);
+
+
+/*
+ * Simple Persistent Storage
+ */
+
+struct herr_persist;
+/* Put an error record into simple persistent storage */
+int herr_persist_in(const struct herr_record *ercd);
+/* Save all error records not yet consumed in persistent storage */
+void herr_persist_all_records(void);
+
+/*
+ * Simple Persistent Storage Provider Management
+ */
+struct herr_persist {
+	struct list_head list;
+	char *name;
+	unsigned int read_done:1;
+	/* Put an error record into storage, must be NMI-safe */
+	int (*in)(const struct herr_record *ercd);
+	/*
+	 * Read out an error record from storage to user space, don't
+	 * remove it, the HERR_RCD_PERSIST must be set in record flags
+	 */
+	ssize_t (*peek_user)(u64 *record_id, char __user *ubuf, size_t usize);
+	/* Clear an error record */
+	int (*clear)(u64 record_id);
+};
+
+/* Register (un-register) simple persistent storage provider */
+int herr_persist_register(struct herr_persist *persist);
+void herr_persist_unregister(struct herr_persist *persist);
+#endif
 #endif
