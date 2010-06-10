Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0FJIFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:05:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52212 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0FJIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hyuNKE+glECrmUCC0RN0PZ2cRMdbiB1BTDLmYgPiuGU1YXSQhZCt2eQ4ya+oJ0XUac
         5lmpBIw2ACaSx27TySjgttq/ogzKaeV4oz7OhB2wSL5GNZHrYySdEYbzQ2n9kcjgAe2r
         kWnppa7+CTA0Tt20zCWxjAC4pnEp/f+3Nb1ZI=
Subject: [PATCH] hp-wmi: add error handling for hp_wmi_init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "John W. Linville" <linville@tuxdriver.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 Jun 2010 16:06:40 +0800
Message-Id: <1276157200.29462.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation in hp_wmi_init does not check any error and always
return success.
This patch properly handles recource reclaim and return err in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/hp-wmi.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 51c07a0..2fa4577 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -585,23 +585,42 @@ static int __init hp_wmi_init(void)
 	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
 		err = wmi_install_notify_handler(HPWMI_EVENT_GUID,
 						 hp_wmi_notify, NULL);
-		if (ACPI_SUCCESS(err))
-			hp_wmi_input_setup();
+		if (ACPI_FAILURE(err))
+			return -EINVAL;
+		err = hp_wmi_input_setup();
+		if (err) {
+			wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+			return err;
+		}
 	}
 
 	if (wmi_has_guid(HPWMI_BIOS_GUID)) {
 		err = platform_driver_register(&hp_wmi_driver);
 		if (err)
-			return 0;
+			goto err_driver_reg;
 		hp_wmi_platform_dev = platform_device_alloc("hp-wmi", -1);
 		if (!hp_wmi_platform_dev) {
-			platform_driver_unregister(&hp_wmi_driver);
-			return 0;
+			err = -ENOMEM;
+			goto err_device_alloc;
 		}
-		platform_device_add(hp_wmi_platform_dev);
+		err = platform_device_add(hp_wmi_platform_dev);
+		if (err)
+			goto err_device_add;
 	}
 
 	return 0;
+
+err_device_add:
+	platform_device_put(hp_wmi_platform_dev);
+err_device_alloc:
+	platform_driver_unregister(&hp_wmi_driver);
+err_driver_reg:
+	if (wmi_has_guid(HPWMI_EVENT_GUID)) {
+		input_unregister_device(hp_wmi_input_dev);
+		wmi_remove_notify_handler(HPWMI_EVENT_GUID);
+	}
+
+	return err;
 }
 
 static void __exit hp_wmi_exit(void)
-- 
1.5.4.3



