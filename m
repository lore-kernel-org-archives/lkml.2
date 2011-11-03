Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1KCKtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:49:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33455 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab1KCKtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:49:00 -0400
Subject: [PATCH -v1] acpi: Fix possible recursive locking in hwregs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 16:48:42 +0600
Message-ID: <1320317323.5711.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status, 
acpi_os_acquire_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then 
without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which tries to hold 
acpi_gbl_gpe_lock and thus might causes possible recursive lock.

Following patch fixes this scenario by just releasing acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.

 Changes since v0(https://lkml.org/lkml/2011/9/21/355):
	- Fix changelog, thanks to Lin Ming.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>
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
 


