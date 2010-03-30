Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0C3XYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:24:46 -0400
Received: from kroah.org ([198.145.64.141]:46852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0C3XWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:22 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:00 2010
Message-Id: <20100330224900.183976449@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [154/156] classmate-laptop: use a single MODULE_DEVICE_TABLE to get correct aliases
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit 02e77a55f7b7e36888e39c62439fedb90ae4e808 upstream.

Instead of a MODULE_DEVICE_TABLE for every acpi_driver ids table, we
create a table containing all ids to export to get a module alias for
each one.

This will fix automatic loading of the driver when one of the ACPI
devices is not present (like the accelerometer, which is not present in
some models).

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/classmate-laptop.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -34,6 +34,11 @@ struct cmpc_accel {
 #define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
 
 
+#define CMPC_ACCEL_HID		"ACCE0000"
+#define CMPC_TABLET_HID		"TBLT0000"
+#define CMPC_BL_HID		"IPML200"
+#define CMPC_KEYS_HID		"FnBT0000"
+
 /*
  * Generic input device code.
  */
@@ -282,10 +287,9 @@ static int cmpc_accel_remove(struct acpi
 }
 
 static const struct acpi_device_id cmpc_accel_device_ids[] = {
-	{"ACCE0000", 0},
+	{CMPC_ACCEL_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
 
 static struct acpi_driver cmpc_accel_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -366,10 +370,9 @@ static int cmpc_tablet_resume(struct acp
 }
 
 static const struct acpi_device_id cmpc_tablet_device_ids[] = {
-	{"TBLT0000", 0},
+	{CMPC_TABLET_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
 
 static struct acpi_driver cmpc_tablet_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -477,17 +480,16 @@ static int cmpc_bl_remove(struct acpi_de
 	return 0;
 }
 
-static const struct acpi_device_id cmpc_device_ids[] = {
-	{"IPML200", 0},
+static const struct acpi_device_id cmpc_bl_device_ids[] = {
+	{CMPC_BL_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
 
 static struct acpi_driver cmpc_bl_acpi_driver = {
 	.owner = THIS_MODULE,
 	.name = "cmpc",
 	.class = "cmpc",
-	.ids = cmpc_device_ids,
+	.ids = cmpc_bl_device_ids,
 	.ops = {
 		.add = cmpc_bl_add,
 		.remove = cmpc_bl_remove
@@ -540,10 +542,9 @@ static int cmpc_keys_remove(struct acpi_
 }
 
 static const struct acpi_device_id cmpc_keys_device_ids[] = {
-	{"FnBT0000", 0},
+	{CMPC_KEYS_HID, 0},
 	{"", 0}
 };
-MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
 
 static struct acpi_driver cmpc_keys_acpi_driver = {
 	.owner = THIS_MODULE,
@@ -607,3 +608,13 @@ static void cmpc_exit(void)
 
 module_init(cmpc_init);
 module_exit(cmpc_exit);
+
+static const struct acpi_device_id cmpc_device_ids[] = {
+	{CMPC_ACCEL_HID, 0},
+	{CMPC_TABLET_HID, 0},
+	{CMPC_BL_HID, 0},
+	{CMPC_KEYS_HID, 0},
+	{"", 0}
+};
+
+MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);


