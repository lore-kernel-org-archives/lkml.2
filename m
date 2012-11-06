Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2KFPKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:10:19 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11517 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2KFPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:10:15 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        imammedo@redhat.com, prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
Date: Tue,  6 Nov 2012 08:02:06 -0700
Message-Id: <1352214130-12055-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces acpi_pr_<level>(), where <level> is a kernel
message level such as err/warn/info, to support improved logging
messages for ACPI, esp. for hotplug operations.  acpi_pr_<level>()
appends "ACPI" prefix and ACPI object path to the messages.  This
improves diagnosis of hotplug operations since an error message in
a log file identifies an object that caused an issue.

acpi_pr_<level>() takes acpi_handle as an argument, which is passed
to ACPI hotplug notify handlers from the ACPICA.  Therefore, it is
always available unlike other kernel objects, such as device.

For example:
  acpi_pr_err(handle, "Device don't exist, dropping EJECT\n");
logs an error message like this at KERN_ERR.
  ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT

ACPI drivers can use acpi_pr_<level>() when they need to identify
a target ACPI object path in their messages, such as error cases.
The usage model is similar to dev_<level>().  acpi_pr_<level>() can
be used when device is not created/valid, which may be the case in
ACPI hotplug handlers.  ACPI object path is also consistent on the
platform, unlike device name that changes over hotplug operations.

ACPI drivers should use dev_<level>() when device is valid and
acpi_pr_<level>() is already used by the caller in its error path.
Device name provides more user friendly information.

ACPI drivers also continue to use pr_<level>() when messages do not
need to specify device information, such as boot-up messages.

Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
are not associated with the kernel message level.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/acpi/utils.c    | 34 ++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 462f7e3..4eade7d 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -457,3 +457,37 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 #endif
 }
 EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
+
+/**
+ * acpi_printk: Print messages with ACPI prefix and object path
+ *
+ * This function is intended to be called through acpi_pr_<level> macros.
+ */
+void
+acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...)
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
+EXPORT_SYMBOL(acpi_printk);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2242c10..93d5852 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -56,6 +56,37 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 
 acpi_status
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
+
+void acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...);
+
+#define acpi_pr_emerg(handle, fmt, ...)				\
+	acpi_printk(KERN_EMERG, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_alert(handle, fmt, ...)				\
+	acpi_printk(KERN_ALERT, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_crit(handle, fmt, ...)				\
+	acpi_printk(KERN_CRIT, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_err(handle, fmt, ...)				\
+	acpi_printk(KERN_ERR, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_warn(handle, fmt, ...)				\
+	acpi_printk(KERN_WARNING, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_notice(handle, fmt, ...)			\
+	acpi_printk(KERN_NOTICE, handle, fmt, ##__VA_ARGS__)
+#define acpi_pr_info(handle, fmt, ...)				\
+	acpi_printk(KERN_INFO, handle, fmt, ##__VA_ARGS__)
+
+/* REVISIT: Support CONFIG_DYNAMIC_DEBUG when necessary */
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
+#define acpi_pr_debug(handle, fmt, ...)					\
+	acpi_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__)
+#else
+#define acpi_pr_debug(handle, fmt, ...)					\
+({									\
+	if (0)								\
+		acpi_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__);	\
+	0;								\
+})
+#endif
+
 #ifdef CONFIG_ACPI
 
 #include <linux/proc_fs.h>
-- 
1.7.11.7

