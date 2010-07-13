Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0GMJar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:30:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33765 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0GMJao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NHjE+Pqltc+tx2QA6ALjz5js+j8vjVbPHgVzwAVszYgrnv+HKvMNRv6eh8Ki63b+bm
         B324NKqZY4OGjMFsTWfl6vRZ+1zR13K2moqXQ0N9/yE3NW5qiZEhWjpKiG9fCxead6R4
         Kqpd9/wv8vmOSb5mffhFH4OLM00SZMU2JBXxQ=
Subject: [PATCH] atlas_btns: fix mixing acpi_status and int for return value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Jul 2010 17:31:15 +0800
Message-Id: <1279013475.28550.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve readability, this patch fixes mixing acpi_status
and int for return value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/atlas_btns.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 7d53608..ea14800 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -60,12 +60,12 @@ static acpi_status acpi_atlas_button_handler(u32 function,
 		input_report_key(input_dev, atlas_keymap[code], key_down);
 		input_sync(input_dev);
 
-		status = 0;
+		status = AE_OK;
 	} else {
 		printk(KERN_WARNING "atlas: shrugged on unexpected function"
 			":function=%x,address=%lx,value=%x\n",
 			function, (unsigned long)address, (u32)*value);
-		status = -EINVAL;
+		status = AE_BAD_PARAMETER;
 	}
 
 	return status;
@@ -114,26 +114,27 @@ static int atlas_acpi_button_add(struct acpi_device *device)
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR "Atlas: Error installing addr spc handler\n");
 		input_unregister_device(input_dev);
-		status = -EINVAL;
+		err = -EINVAL;
 	}
 
-	return status;
+	return err;
 }
 
 static int atlas_acpi_button_remove(struct acpi_device *device, int type)
 {
 	acpi_status status;
+	int err = 0;
 
 	status = acpi_remove_address_space_handler(device->handle,
 				0x81, &acpi_atlas_button_handler);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR "Atlas: Error removing addr spc handler\n");
-		status = -EINVAL;
+		err = -EINVAL;
 	}
 
 	input_unregister_device(input_dev);
 
-	return status;
+	return err;
 }
 
 static const struct acpi_device_id atlas_device_ids[] = {
-- 
1.5.4.3



