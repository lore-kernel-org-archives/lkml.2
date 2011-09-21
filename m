Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1IUSKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:10:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33181 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1IUSK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:10:27 -0400
Subject: [PATCH] acpi: Fix possible recursive locking in hwregs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 00:09:49 +0600
Message-ID: <1316628589.7341.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status, 
acpi_os_release_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then 
without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which also tries to 
hold acpi_gbl_hardware_lock and thus causes possible recursive lock. 

Following patch fixes this scenario by just releasing acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.

[This patch was created against 3.0-rc3. Since kernel.org is down, I don't have the updated tree. So, before applying
it might require some adjustment.]

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 55accb7..e3110ac 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -269,6 +269,9 @@ acpi_status acpi_hw_clear_acpi_status(void)
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
+
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+
 	if (ACPI_FAILURE(status)) {
 		goto unlock_and_exit;
 	}
@@ -278,7 +281,6 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
 
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 


