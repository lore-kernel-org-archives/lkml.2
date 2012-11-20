Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2KTUxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:53:33 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:21098 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2KTUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:53:31 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v6 1/5] ACPI: Add acpi_handle_<level>() interfaces
Date: Tue, 20 Nov 2012 13:44:50 -0700
Message-Id: <1353444294-25575-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces acpi_handle_<level>(), where <level> is
a kernel message level such as err/warn/info, to support improved
logging messages for ACPI, esp. hot-plug operations.
acpi_handle_<level>() appends "ACPI" prefix and ACPI object path
to the messages.  This improves diagnosis of hotplug operations
since an error message in a log file identifies an object that
caused an issue.  This interface acquires the global namespace
mutex and may not be called from interrupt context.

acpi_handle_<level>() takes acpi_handle as an argument, which is
passed to ACPI hotplug notify handlers from the ACPICA.  Therefore,
it is always available unlike other kernel objects, such as device.

For example:
  acpi_handle_err(handle, "Device don't exist, dropping EJECT\n");
logs an error message like this at KERN_ERR.
  ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT

ACPI hot-plug drivers can use acpi_handle_<level>() when they need
to identify a target ACPI object path in their messages, such as
error cases.  The usage model is similar to dev_<level>().
acpi_handle_<level>() can be used when a device is not created or
is invalid during hot-plug operations.  ACPI object path is also
consistent on the platform, unlike device name that gets incremented
over hotplug operations.

ACPI drivers should use dev_<level>() when a device object is valid.
Device name provides more user friendly information, and avoids
acquiring the global ACPI namespace mutex.  ACPI drivers also
continue to use pr_<level>() when they do not need to specify device
information, such as boot-up messages.

Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
are not associated with the kernel message level.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/acpi/utils.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 462f7e3..c1f1072 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -457,3 +458,39 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 #endif
 }
 EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
+
+/**
+ * acpi_handle_printk: Print message with ACPI prefix and object path
+ *
+ * This function is called through acpi_handle_<level> macros and prints
+ * a message with ACPI prefix and object path.  This function acquires
+ * the global namespace mutex and may not be called from interrupt context.
+ */
+void
+acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	struct acpi_buffer buffer = {
+		.length = ACPI_ALLOCATE_BUFFER,
+		.pointer = NULL
+	};
+	const char *path;
+	acpi_status ret;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	if (ret == AE_OK)
+		path = buffer.pointer;
+	else
+		path = "<n/a>";
+
+	printk("%sACPI: %s: %pV", level, path, &vaf);
+
+	va_end(args);
+	kfree(buffer.pointer);
+}
+EXPORT_SYMBOL(acpi_handle_printk);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 0bb2070..e96753e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -517,4 +517,47 @@ static inline int acpi_dev_pm_attach(struct device *dev) { return -ENODEV; }
 static inline void acpi_dev_pm_detach(struct device *dev) {}
 #endif
 
+#ifdef CONFIG_ACPI
+__printf(3, 4)
+void acpi_handle_printk(const char *level, acpi_handle handle,
+			const char *fmt, ...);
+#else	/* !CONFIG_ACPI */
+static inline __printf(3, 4) void
+acpi_handle_printk(const char *level, void *handle, const char *fmt, ...) {}
+#endif	/* !CONFIG_ACPI */
+
+/*
+ * acpi_handle_<level>: Print message with ACPI prefix and object path
+ * 
+ * These interfaces acquire the global namespace mutex and may not be
+ * called from interrupt context.
+ */
+#define acpi_handle_emerg(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_EMERG, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_alert(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_ALERT, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_crit(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_CRIT, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_err(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_ERR, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_warn(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_WARNING, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_notice(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_NOTICE, handle, fmt, ##__VA_ARGS__)
+#define acpi_handle_info(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_INFO, handle, fmt, ##__VA_ARGS__)
+
+/* REVISIT: Support CONFIG_DYNAMIC_DEBUG when necessary */
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
+#define acpi_handle_debug(handle, fmt, ...)				\
+	acpi_handle_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__)
+#else
+#define acpi_handle_debug(handle, fmt, ...)				\
+({									\
+	if (0)								\
+		acpi_handle_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__); \
+	0;								\
+})
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.7.11.7

