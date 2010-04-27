Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0D0Q2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:28:21 -0400
Received: from liberdade.minaslivre.org ([72.232.254.139]:40383 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab0D0Q2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:28:15 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] ACPI: fix fan module removal when ACPI_PROCFS is disabled
Date: Tue, 27 Apr 2010 13:19:18 -0300
Message-Id: <1272385158-4080-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ACPI_PROCFS is disabled, /proc/acpi/fan/ directory is not created.
So, it should not be removed during the module removal either.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/acpi/fan.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index acf2ab2..d92c035 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -355,12 +355,13 @@ static int __init acpi_fan_init(void)
 #endif
 
 	result = acpi_bus_register_driver(&acpi_fan_driver);
-	if (result < 0) {
+
+#ifdef CONFIG_ACPI_PROCFS
+	if (result < 0)
 		remove_proc_entry(ACPI_FAN_CLASS, acpi_root_dir);
-		return -ENODEV;
-	}
+#endif
 
-	return 0;
+	return result;
 }
 
 static void __exit acpi_fan_exit(void)
@@ -368,7 +369,9 @@ static void __exit acpi_fan_exit(void)
 
 	acpi_bus_unregister_driver(&acpi_fan_driver);
 
+#ifdef CONFIG_ACPI_PROCFS
 	remove_proc_entry(ACPI_FAN_CLASS, acpi_root_dir);
+#endif
 
 	return;
 }
-- 
1.6.6.1

