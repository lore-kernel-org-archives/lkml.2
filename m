Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab0CZQse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:48:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:4233 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0CZQsd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 26 Mar 2010 12:48:33 -0400
Message-Id: <4BACF371020000780003738A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Mar 2010 16:48:33 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <u.kleine-koenig@pengutronix.de>, <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] vesafb: use platform_driver_probe() instead of
	 platform_driver_register()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b introduced a huge
amount of section mismatch warnings in vesafb code. Rather than
converting all of the annotations, do the obvious and revert the
__init -> __devinit change, and use the recommended (in that patch)
alternative to calling platform_driver_register(): vesafb depends on
information obtained from by kernel at boot time, cannot be a module,
and no post-boot devices can ever show up.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/video/vesafb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- linux-2.6.34-rc2/drivers/video/vesafb.c
+++ 2.6.34-rc2-vesafb-init/drivers/video/vesafb.c
@@ -226,7 +226,7 @@ static int __init vesafb_setup(char *opt
 	return 0;
 }
 
-static int __devinit vesafb_probe(struct platform_device *dev)
+static int __init vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int i, err;
@@ -477,7 +477,6 @@ err:
 }
 
 static struct platform_driver vesafb_driver = {
-	.probe	= vesafb_probe,
 	.driver	= {
 		.name	= "vesafb",
 	},
@@ -493,20 +492,21 @@ static int __init vesafb_init(void)
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
-	ret = platform_driver_register(&vesafb_driver);
 
+	vesafb_device = platform_device_alloc("vesafb", 0);
+	if (!vesafb_device)
+		return -ENOMEM;
+
+	ret = platform_device_add(vesafb_device);
 	if (!ret) {
-		vesafb_device = platform_device_alloc("vesafb", 0);
+		ret = platform_driver_probe(&vesafb_driver, vesafb_probe);
+		if (ret)
+			platform_device_del(vesafb_device);
+	}
 
-		if (vesafb_device)
-			ret = platform_device_add(vesafb_device);
-		else
-			ret = -ENOMEM;
-
-		if (ret) {
-			platform_device_put(vesafb_device);
-			platform_driver_unregister(&vesafb_driver);
-		}
+	if (ret) {
+		platform_device_put(vesafb_device);
+		vesafb_device = NULL;
 	}
 
 	return ret;



