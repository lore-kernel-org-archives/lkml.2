Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2CHTlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:41:18 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58245 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2CHTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:41:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6643"; a="168445719"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] staging: ram_console: Fix section mismatches
Date: Thu,  8 Mar 2012 11:41:14 -0800
Message-Id: <1331235674-16570-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <20120308184320.GA29273@kroah.com>
References: <20120308184320.GA29273@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0xfcf6e): Section mismatch in reference
from the function ram_console_driver_probe() to the function
.init.text:persistent_ram_init_ringbuffer()
The function ram_console_driver_probe() references
the function __init persistent_ram_init_ringbuffer().
This is often because ram_console_driver_probe lacks a __init
annotation or the annotation of persistent_ram_init_ringbuffer is
wrong.

Move this driver to platform_driver_probe() because ram console
devices aren't going to be added and removed at runtime. Also
shorten the probe function name since driver is redundant and
makes the function name long.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/staging/android/ram_console.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index b242be2..2918bc1 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -50,7 +50,7 @@ void ram_console_enable_console(int enabled)
 		ram_console.flags &= ~CON_ENABLED;
 }
 
-static int ram_console_driver_probe(struct platform_device *pdev)
+static int __init ram_console_probe(struct platform_device *pdev)
 {
 	struct ram_console_platform_data *pdata = pdev->dev.platform_data;
 	struct persistent_ram_zone *prz;
@@ -75,7 +75,6 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 }
 
 static struct platform_driver ram_console_driver = {
-	.probe = ram_console_driver_probe,
 	.driver		= {
 		.name	= "ram_console",
 	},
@@ -83,9 +82,7 @@ static struct platform_driver ram_console_driver = {
 
 static int __init ram_console_module_init(void)
 {
-	int err;
-	err = platform_driver_register(&ram_console_driver);
-	return err;
+	return platform_driver_probe(&ram_console_driver, ram_console_probe);
 }
 
 static ssize_t ram_console_read_old(struct file *file, char __user *buf,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

