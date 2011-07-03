Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1GCJOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 05:14:49 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:40002 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1GCJOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 05:14:46 -0400
From: Andrea Righi <andrea@betterlinux.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ACPI: fix acpi_power_off lockdep splat
Date: Sun,  3 Jul 2011 11:14:09 +0200
Message-Id: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_os_create_lock() as a C-preprocessor macro to suppress
lockdep false positive.

When lockdep is enabled the spin_lock_init macro stringifies it's
argument and uses that as a name for the lock in the debugging.

By executing spin_lock_init in a macro the key changes from "lock" for
all locks to the actual argument of acpi_os_create_lock()
("&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
"&acpi_gbl_hardware_lock" for now).

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=38152

ChangeLog (v1 -> v2):
 - avoid to call spin_lock_init multiple times on the same lock
 - rewrite patch description (thanks to Florian for providing a better
   description of the patch)

Reported-by: Borislav Petkov <bp@alien8.de>
CC: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 drivers/acpi/osl.c      |    3 +--
 include/acpi/acpiosxf.h |   12 +++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 52ca964..4c985d3 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1336,14 +1336,13 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
  * Create and initialize a spinlock.
  */
 acpi_status
-acpi_os_create_lock(acpi_spinlock *out_handle)
+__acpi_os_create_lock(acpi_spinlock *out_handle)
 {
 	spinlock_t *lock;
 
 	lock = ACPI_ALLOCATE(sizeof(spinlock_t));
 	if (!lock)
 		return AE_NO_MEMORY;
-	spin_lock_init(lock);
 	*out_handle = lock;
 
 	return AE_OK;
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

