Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1AFJTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:19:12 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:46651 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834Ab1AFJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:19:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: [PATCH 1/1] PM: fix oops in suspend/hibernate code
Date: Thu,  6 Jan 2011 10:18:24 +0100
Message-Id: <1294305504-5787-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <201101060028.43342.rjw@sisk.pl>
References: <201101060028.43342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ioremap fails (which might happen for some reason), we nicely
oops in suspend_nvs_save due to NULL dereference by memcpy in there.
Fail gracefully instead.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 drivers/acpi/sleep.c    |    5 ++---
 include/linux/suspend.h |    4 ++--
 kernel/power/nvs.c      |    8 +++++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index c423231..f94c9a9 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -124,8 +124,7 @@ static int acpi_pm_freeze(void)
 static int acpi_pm_pre_suspend(void)
 {
 	acpi_pm_freeze();
-	suspend_nvs_save();
-	return 0;
+	return suspend_nvs_save();
 }
 
 /**
@@ -151,7 +150,7 @@ static int acpi_pm_prepare(void)
 {
 	int error = __acpi_pm_prepare();
 	if (!error)
-		acpi_pm_pre_suspend();
+		error = acpi_pm_pre_suspend();
 
 	return error;
 }
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index c1f4998..3ac2551 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -262,7 +262,7 @@ static inline bool system_entering_hibernation(void) { return false; }
 extern int suspend_nvs_register(unsigned long start, unsigned long size);
 extern int suspend_nvs_alloc(void);
 extern void suspend_nvs_free(void);
-extern void suspend_nvs_save(void);
+extern int suspend_nvs_save(void);
 extern void suspend_nvs_restore(void);
 #else /* CONFIG_SUSPEND_NVS */
 static inline int suspend_nvs_register(unsigned long a, unsigned long b)
@@ -271,7 +271,7 @@ static inline int suspend_nvs_register(unsigned long a, unsigned long b)
 }
 static inline int suspend_nvs_alloc(void) { return 0; }
 static inline void suspend_nvs_free(void) {}
-static inline void suspend_nvs_save(void) {}
+static inline int suspend_nvs_save(void) {}
 static inline void suspend_nvs_restore(void) {}
 #endif /* CONFIG_SUSPEND_NVS */
 
diff --git a/kernel/power/nvs.c b/kernel/power/nvs.c
index 1836db6..57c6fab 100644
--- a/kernel/power/nvs.c
+++ b/kernel/power/nvs.c
@@ -105,7 +105,7 @@ int suspend_nvs_alloc(void)
 /**
  *	suspend_nvs_save - save NVS memory regions
  */
-void suspend_nvs_save(void)
+int suspend_nvs_save(void)
 {
 	struct nvs_page *entry;
 
@@ -114,8 +114,14 @@ void suspend_nvs_save(void)
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data) {
 			entry->kaddr = ioremap(entry->phys_start, entry->size);
+			if (!entry->kaddr) {
+				suspend_nvs_free();
+				return -ENOMEM;
+			}
 			memcpy(entry->data, entry->kaddr, entry->size);
 		}
+
+	return 0;
 }
 
 /**
-- 
1.7.3.4


