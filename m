Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1F1BWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:22:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab1F1BWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:22:40 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] char drivers: ramoops default platform device for module parameter use
Date: Mon, 27 Jun 2011 18:21:51 -0700
Message-Id: <1309224113-21818-2-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of platform data in ramoops resulted in the need to
define a platform device in order to use the ramoops module with module
parameters (without setting any platform data). Sadly this is not clear or
properly documented.

This patch checks if the module parameters are set and declares a platform
device if they are so that the module can be used with module parameters
without any aditional declarations out of the module.

Change-Id: I3cdb0f8e27852ac79e327e526645c9859f19efa8
Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/ramoops.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 1a9f5f6..0c3cb42 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -177,13 +177,33 @@ static struct platform_driver ramoops_driver = {
 	},
 };
 
+struct platform_device *ramoops_device;
+
 static int __init ramoops_init(void)
 {
+	/*
+	 * If mem_address and mem_size are set (i.e. the module parameters
+	 * are used) then a default platform driver is created
+	 * as there is no need to configure the platform data elsewhere.
+	 */
+	if (mem_address && mem_size) {
+		ramoops_device = platform_device_register_simple("ramoops",
+								 -1, NULL, 0);
+
+		if (IS_ERR(ramoops_device)) {
+			printk(KERN_ERR "Unable to register platform device\n");
+			return PTR_ERR(ramoops_device);
+		}
+	}
+
 	return platform_driver_probe(&ramoops_driver, ramoops_probe);
 }
 
 static void __exit ramoops_exit(void)
 {
+	/* Unregister the device if it was set */
+	if (ramoops_device)
+		platform_device_unregister(ramoops_device);
 	platform_driver_unregister(&ramoops_driver);
 }
 
-- 
1.7.3.1

