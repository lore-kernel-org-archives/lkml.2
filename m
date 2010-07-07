Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0GGCWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:22:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34094 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0GGCWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Zz3sQyPF3GSUaDjAOLdfMJKeFy9t/kkFEMXs+JfKb0xfvcU4DTun4I4auqunUm7b0U
         IHP+5zfO7bZfNA8S1WVAXCt80FCfrQ0k3KrkZNmp1rWUqpV1LSVRQipWILYWq38EmuIG
         uNiIR4fbvWmUR9Fg9voQ8aNBbY4SeGmpuoALY=
Subject: [PATCH] acerhdf: fix resource reclaim in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Borislav Petkov <petkovbb@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Wed, 07 Jul 2010 10:22:19 +0800
Message-Id: <1278469339.12801.27.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix resource reclaim in below cases:
1. acerhdf_register_platform() does not properly handle
   platform_device_alloc() failure and platform_device_add() failure.
   This patch adds error handling for acerhdf_register_platform().
2. acerhdf_register_platform() return err with acerhdf_dev == NULL.
   as a result, acerhdf_unregister_platform() does not do resource
   reclaim in acerhdf_init() error path.
   This patch adds error handing for acerhdf_register_platform(),
   thus correct the error handing path in acerhdf_init().
   goto out_err instead of err_unreg if acerhdf_register_platform() fail.
3. platform_device_del() should be only used in error handling.
   Current implementation missed a platform_device_put() in acerhdf_exit.
   This patch fixes it by using platform_device_unregister() instead of
   platform_device_del() in acerhdf_unregister_platform().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 7b2384d..e938a86 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -579,9 +579,21 @@ static int acerhdf_register_platform(void)
 		return err;
 
 	acerhdf_dev = platform_device_alloc("acerhdf", -1);
-	platform_device_add(acerhdf_dev);
+	if (!acerhdf_dev) {
+		err = -ENOMEM;
+		goto err_device_alloc;
+	}
+	err = platform_device_add(acerhdf_dev);
+	if (err)
+		goto err_device_add;
 
 	return 0;
+
+err_device_add:
+	platform_device_put(acerhdf_dev);
+err_device_alloc:
+	platform_driver_unregister(&acerhdf_driver);
+	return err;
 }
 
 static void acerhdf_unregister_platform(void)
@@ -589,7 +601,7 @@ static void acerhdf_unregister_platform(void)
 	if (!acerhdf_dev)
 		return;
 
-	platform_device_del(acerhdf_dev);
+	platform_device_unregister(acerhdf_dev);
 	platform_driver_unregister(&acerhdf_driver);
 }
 
@@ -633,7 +645,7 @@ static int __init acerhdf_init(void)
 
 	err = acerhdf_register_platform();
 	if (err)
-		goto err_unreg;
+		goto out_err;
 
 	err = acerhdf_register_thermal();
 	if (err)
@@ -646,7 +658,7 @@ err_unreg:
 	acerhdf_unregister_platform();
 
 out_err:
-	return -ENODEV;
+	return err;
 }
 
 static void __exit acerhdf_exit(void)
-- 
1.5.4.3



