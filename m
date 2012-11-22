Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233Ab2KVUAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:00:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2KVUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:00:02 -0500
From: Luca Clementi <luca.clementi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luca Clementi <luca.clementi@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>, Robert Love <rlove@google.com>
Subject: [PATCH] Staging: Android: logger: module_exit implementation
Date: Wed, 21 Nov 2012 19:43:17 -0800
Message-Id: <1353555797-4284-1-git-send-email-luca.clementi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates the module_exit for the android logger
so that it can be loaded and unloaded as a module.

The android logger is already declared as a tristate in the
Kconfig but the module_exit function was missing.

device_initcall works also with modprobe since include/linux/init.h:

 #define module_init(x)  __initcall(x);
 ...
 #define __initcall(fn) device_initcall(fn)

Tested against f4a75d2eb7b1e2206094b901be09adb31ba63681 Linux 3.7-rc6

Signed-off-by: Luca Clementi <luca.clementi@gmail.com>
---
 drivers/staging/android/logger.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 1d5ed47..dbc63cb 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -676,4 +676,25 @@ static int __init logger_init(void)
 out:
 	return ret;
 }
+
+static void __exit logger_exit(void)
+{
+	struct logger_log *current_log, *next_log;
+
+	list_for_each_entry_safe(current_log, next_log, &log_list, logs) {
+		/* we have to delete all the entry inside log_list */
+		misc_deregister(&current_log->misc);
+		vfree(current_log->buffer);
+		kfree(current_log->misc.name);
+		list_del(&current_log->logs);
+		kfree(current_log);
+	}
+}
+
+
 device_initcall(logger_init);
+module_exit(logger_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Robert Love, <rlove@google.com>");
+MODULE_DESCRIPTION("Android Logger");
-- 
1.7.9.5

