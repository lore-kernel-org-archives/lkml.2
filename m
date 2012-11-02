Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2KBGQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:16:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61804 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2KBGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:15:58 -0400
From: Luca Clementi <luca.clementi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luca Clementi <luca.clementi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>
Subject: [PATCH] Staging: Android: logger: module_exit implementation
Date: Thu,  1 Nov 2012 23:15:52 -0700
Message-Id: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Created the module_exit for the android logger so that
it can be loaded and unloaded as a module. Fixed
module_init and some other minor issues.

Signed-off-by: Luca Clementi <luca.clementi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Swetland <swetland@google.com>
---
 drivers/staging/android/logger.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 1d5ed47..050be01 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -676,4 +676,32 @@ static int __init logger_init(void)
 out:
 	return ret;
 }
-device_initcall(logger_init);
+
+static void __exit logger_exit(void)
+{
+	struct logger_log *current_log, *next_log;
+
+	list_for_each_entry_safe(current_log, next_log, &log_list, logs) {
+		/* we have to delete all the entry inside log_list */
+		ret = misc_deregister(&current_log->misc);
+		if (unlikely(ret)) {
+			pr_err("failed to deregister misc device for log '%s'!\n",
+					current_log->misc.name);
+		}
+		pr_info("removed loggger '%s'\n", current_log->misc.name);
+		vfree(current_log->buffer);
+		kfree(current_log->misc.name);
+		kfree(current_log);
+	}
+
+	return;
+}
+
+
+module_init(logger_init);
+module_exit(logger_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Brian Swetland, <swetland@google.com>");
+MODULE_DESCRIPTION("Android Logger");
+
+
-- 
1.7.9.5

