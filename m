Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2JOQmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:42:11 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:15674 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2JOQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:42:09 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, isimatu.yasuaki@jp.fujitsu.com,
        liuj97@gmail.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] ACPI: Fix stale pointer access to flags.lockable
Date: Mon, 15 Oct 2012 10:34:29 -0600
Message-Id: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During hot-remove, acpi_bus_hot_remove_device() calls ACPI _LCK
method when device->flags.lockable is set. However, this device
pointer is stale since the target acpi_device object has been
already kfree'd by acpi_bus_trim().

The flags.lockable indicates whether or not this ACPI object
implements _LCK method. Fix the stable pointer access by replacing
it with acpi_get_handle() to check if _LCK is implemented.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 1fcb867..ed87f43 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -97,6 +97,7 @@ void acpi_bus_hot_remove_device(void *context)
 	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
 	struct acpi_device *device;
 	acpi_handle handle = ej_event->handle;
+	acpi_handle temp;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status = AE_OK;
@@ -117,13 +118,16 @@ void acpi_bus_hot_remove_device(void *context)
 		goto err_out;
 	}
 
+	/* device has been freed */
+	device = NULL;
+
 	/* power off device */
 	status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
 		printk(KERN_WARNING PREFIX
 				"Power-off device failed\n");
 
-	if (device->flags.lockable) {
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
 		arg_list.count = 1;
 		arg_list.pointer = &arg;
 		arg.type = ACPI_TYPE_INTEGER;
-- 
1.7.11.7

