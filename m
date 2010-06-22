Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab0FVIP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:15:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57412 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282Ab0FVIPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OaIE4YTuZP1OM+Q7uqALZpWezdBE+ZZpUGRPKKDkZ6ywIDlkybNLqnxdag+ufMQ7el
         0GG4dCzp8BM1rqUPRMxwr7SJsIMZ77VtN66Y5WnVLD3WiJDcGrwYYeu6LcB9JDm+xhR7
         s308BsvugMueGHg+eVPUpNIOGjRh0isjQ0XyU=
Subject: [PATCH] acer-wmi: fix resource reclaim in acer_wmi_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Tue, 22 Jun 2010 16:17:38 +0800
Message-Id: <1277194658.7248.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the resource reclaim in acer_wmi_init error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1ea6c43..1415d97 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1327,22 +1327,31 @@ static int __init acer_wmi_init(void)
 		       "generic video driver\n");
 	}
 
-	if (platform_driver_register(&acer_platform_driver)) {
+	err = platform_driver_register(&acer_platform_driver);
+	if (err) {
 		printk(ACER_ERR "Unable to register platform driver.\n");
 		goto error_platform_register;
 	}
+
 	acer_platform_device = platform_device_alloc("acer-wmi", -1);
-	platform_device_add(acer_platform_device);
+	if (!acer_platform_device) {
+		err = -ENOMEM;
+		goto error_device_alloc;
+	}
+
+	err = platform_device_add(acer_platform_device);
+	if (err)
+		goto error_device_add;
 
 	err = create_sysfs();
 	if (err)
-		return err;
+		goto error_create_sys;
 
 	if (wmi_has_guid(WMID_GUID2)) {
 		interface->debug.wmid_devices = get_wmid_devices();
 		err = create_debugfs();
 		if (err)
-			return err;
+			goto error_create_debugfs;
 	}
 
 	/* Override any initial settings with values from the commandline */
@@ -1350,8 +1359,16 @@ static int __init acer_wmi_init(void)
 
 	return 0;
 
+error_create_debugfs:
+	remove_sysfs(acer_platform_device);
+error_create_sys:
+	platform_device_del(acer_platform_device);
+error_device_add:
+	platform_device_put(acer_platform_device);
+error_device_alloc:
+	platform_driver_unregister(&acer_platform_driver);
 error_platform_register:
-	return -ENODEV;
+	return err;
 }
 
 static void __exit acer_wmi_exit(void)
-- 
1.5.4.3



