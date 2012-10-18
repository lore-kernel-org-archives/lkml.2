Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2JRLDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:03:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:54470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab2JRLDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="157620889"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v3 9/9] pstore: add android log dumping
Date: Thu, 18 Oct 2012 14:06:07 +0300
Message-Id: <1350558367-31801-10-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

Dump android binary logs to pstore on panic.

Change-Id: I8ba59d498eae252f4c3844ece8be2a9c4979ecd2
Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 drivers/staging/android/Kconfig  |   12 ++++++
 drivers/staging/android/logger.c |   87 ++++++++++++++++++++++++++++++++++++++
 fs/pstore/inode.c                |   12 ++++++
 include/linux/pstore.h           |   16 ++++---
 4 files changed, 121 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 0ce50d1..72b0de3 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -49,6 +49,18 @@ config ANDROID_INTF_ALARM_DEV
 	  elapsed realtime, and a non-wakeup alarm on the monotonic clock.
 	  Also exports the alarm interface to user-space.
 
+config ANDROID_LOGGER_PANIC_DUMP
+	bool "Panic dump to pstore"
+	default n
+	depends on ANDROID_LOGGER
+	depends on PSTORE
+	help
+	  This options allows the panic dumping of log data to persistent
+	  storage. If the 'enabled' parameter is non-zero, during a panic
+	  each log will be copied in binary format to pstore and, after
+	  the next boot, will appear as files in the pstore file system.
+
+
 endif # if ANDROID
 
 endmenu
diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 1d5ed47..f7f9c09 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/pstore.h>
 #include "logger.h"
 
 #include <asm/ioctls.h>
@@ -653,6 +654,88 @@ out_free_buffer:
 	return ret;
 }
 
+static int panic_dump;
+module_param(panic_dump, int,  S_IRUSR | S_IWUSR);
+
+#ifdef CONFIG_ANDROID_LOGGER_PANIC_DUMP
+
+static void logger_pstore_dump(struct pstore_info *psinfo,
+			       enum pstore_type_id type,
+			       struct logger_log *log)
+{
+	size_t len1, len2, offs, w_offs;
+
+	/* Ignoring buffer locks because:
+	 * - we are in an oops and it won't make any difference
+	 * - it's just a read access so no danger of corrupting
+	 * anything
+	 */
+	offs = log->head;
+	w_offs = log->w_off;
+
+	if (offs < w_offs) {
+		len1 = w_offs - offs;
+		len2 = 0;
+	} else {
+		len1 = log->size - offs;
+		len2 = w_offs;
+	}
+
+	pstore_write(type, log->buffer + offs, len1);
+	pstore_write(type, log->buffer, len2);
+}
+
+static enum pstore_type_id get_pstore_log_type(const struct logger_log *log)
+{
+	enum pstore_type_id type = PSTORE_TYPE_UNKNOWN;
+
+	if (!strcmp(log->misc.name, LOGGER_LOG_MAIN))
+		type = PSTORE_TYPE_ANDROID_LOG_MAIN;
+	else if (!strcmp(log->misc.name, LOGGER_LOG_EVENTS))
+		type = PSTORE_TYPE_ANDROID_LOG_EVENTS;
+	else if (!strcmp(log->misc.name, LOGGER_LOG_RADIO))
+		type = PSTORE_TYPE_ANDROID_LOG_RADIO;
+	else if (!strcmp(log->misc.name, LOGGER_LOG_SYSTEM))
+		type = PSTORE_TYPE_ANDROID_LOG_SYSTEM;
+
+	return type;
+}
+
+static int pstore_notifier_cb(struct notifier_block *nb, unsigned long event,
+			      void *_psinfo)
+{
+	struct pstore_info *psinfo = _psinfo;
+
+	if (!panic_dump || psinfo->ext_reason != KMSG_DUMP_PANIC)
+		return NOTIFY_DONE;
+
+	switch (event) {
+		case PSTORE_DUMP: {
+			struct logger_log *log;
+			list_for_each_entry(log, &log_list, logs) {
+				logger_pstore_dump(psinfo,
+						   get_pstore_log_type(log),
+						   log);
+			}
+			break;
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block pstore_notifier = {
+	.notifier_call = pstore_notifier_cb,
+};
+
+MODULE_PARM_DESC(panic_dump, "set to 1 to enable panic dump, 0 to disable (default 0)");
+
+#else
+
+MODULE_PARM_DESC(panic_dump, "panic dump is not supported");
+
+#endif
+
 static int __init logger_init(void)
 {
 	int ret;
@@ -673,6 +756,10 @@ static int __init logger_init(void)
 	if (unlikely(ret))
 		goto out;
 
+#ifdef CONFIG_ANDROID_LOGGER_PANIC_DUMP
+	pstore_notifier_register(&pstore_notifier);
+#endif
+
 out:
 	return ret;
 }
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 5e20a8d..8b1179d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -324,6 +324,18 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	case PSTORE_TYPE_TASK_DUMP:
 		sprintf(name, "tasks-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_ANDROID_LOG_MAIN:
+		sprintf(name, "android_log_main-%s-%lld", psname, id);
+		break;
+	case PSTORE_TYPE_ANDROID_LOG_EVENTS:
+		sprintf(name, "android_log_events-%s-%lld", psname, id);
+		break;
+	case PSTORE_TYPE_ANDROID_LOG_RADIO:
+		sprintf(name, "android_log_radio-%s-%lld", psname, id);
+		break;
+	case PSTORE_TYPE_ANDROID_LOG_SYSTEM:
+		sprintf(name, "android_log_system-%s-%lld", psname, id);
+		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 48dcafb..08b496a 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -31,12 +31,16 @@
 
 /* types */
 enum pstore_type_id {
-	PSTORE_TYPE_DMESG	= 0,
-	PSTORE_TYPE_MCE		= 1,
-	PSTORE_TYPE_CONSOLE	= 2,
-	PSTORE_TYPE_FTRACE	= 3,
-	PSTORE_TYPE_TASK_DUMP	= 4,
-	PSTORE_TYPE_UNKNOWN	= 255
+	PSTORE_TYPE_DMESG		= 0,
+	PSTORE_TYPE_MCE			= 1,
+	PSTORE_TYPE_CONSOLE		= 2,
+	PSTORE_TYPE_FTRACE		= 3,
+	PSTORE_TYPE_TASK_DUMP		= 4,
+	PSTORE_TYPE_ANDROID_LOG_MAIN	= 5,
+	PSTORE_TYPE_ANDROID_LOG_EVENTS	= 6,
+	PSTORE_TYPE_ANDROID_LOG_RADIO	= 7,
+	PSTORE_TYPE_ANDROID_LOG_SYSTEM	= 8,
+	PSTORE_TYPE_UNKNOWN		= 255
 };
 
 struct module;
-- 
1.7.9.5

