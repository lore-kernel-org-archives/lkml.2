Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1GBPbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 11:31:39 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:37654 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1GBPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 11:31:38 -0400
From: Andrea Righi <andrea@betterlinux.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: fix acpi_power_off lockdep splat
Date: Sat,  2 Jul 2011 17:31:21 +0200
Message-Id: <1309620681-25173-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_os_create_lock() as a C-preprocessor macro to assign
unique lock_class_key to dynamically allocated locks and suppress wrong
lockdep warnings.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=38152

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 drivers/acpi/osl.c      |    2 +-
 include/acpi/acpiosxf.h |   12 +++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 52ca964..2a67602 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1336,7 +1336,7 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
  * Create and initialize a spinlock.
  */
 acpi_status
-acpi_os_create_lock(acpi_spinlock *out_handle)
+__acpi_os_create_lock(acpi_spinlock *out_handle)
 {
 	spinlock_t *lock;
 
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index a756bc8..4a0385d 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -99,7 +99,17 @@ acpi_os_table_override(struct acpi_table_header *existing_table,
  * Spinlock primitives
  */
 acpi_status
-acpi_os_create_lock(acpi_spinlock *out_handle);
+__acpi_os_create_lock(acpi_spinlock *out_handle);
+
+#define acpi_os_create_lock(__handle)			\
+({							\
+	acpi_status ret;				\
+							\
+	ret = __acpi_os_create_lock(__handle);		\
+	if (ret == AE_OK)				\
+		spin_lock_init(*(__handle));		\
+	ret;						\
+})
 
 void acpi_os_delete_lock(acpi_spinlock handle);
 
-- 
1.7.4.1

