Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab2CGV6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:58:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38072 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2CGV6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:36 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 04/13] android: ram_console: drop early buffer support
Date: Wed,  7 Mar 2012 13:58:14 -0800
Message-Id: <1331157503-3413-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-5930-0000-0000-000005E42C2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Early ramconsole is not very useful, an early crash will prevent
getting the logged data out on the next boot, and CONFIG_DEBUG_LL=y
will get the same information.  Drop it to simplify a future
refactoring.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: Ifc306db9a8cceec4ca980cf24783c3fe764eb1fb
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig       |   16 ----------------
 drivers/staging/android/ram_console.c |   29 -----------------------------
 2 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index f3b7c75..20034e6 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -39,7 +39,6 @@ menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	bool "Android RAM Console Enable error correction"
 	default n
 	depends on ANDROID_RAM_CONSOLE
-	depends on !ANDROID_RAM_CONSOLE_EARLY_INIT
 	select REED_SOLOMON
 	select REED_SOLOMON_ENC8
 	select REED_SOLOMON_DEC8
@@ -70,21 +69,6 @@ config ANDROID_RAM_CONSOLE_ERROR_CORRECTION_POLYNOMIAL
 
 endif # ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 
-config ANDROID_RAM_CONSOLE_EARLY_INIT
-	bool "Start Android RAM console early"
-	default n
-	depends on ANDROID_RAM_CONSOLE
-
-config ANDROID_RAM_CONSOLE_EARLY_ADDR
-	hex "Android RAM console virtual address"
-	default 0
-	depends on ANDROID_RAM_CONSOLE_EARLY_INIT
-
-config ANDROID_RAM_CONSOLE_EARLY_SIZE
-	hex "Android RAM console buffer size"
-	default 0
-	depends on ANDROID_RAM_CONSOLE_EARLY_INIT
-
 config ANDROID_TIMED_OUTPUT
 	bool "Timed output class driver"
 	default y
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 2310a79..ed7827b 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -36,10 +36,6 @@ struct ram_console_buffer {
 
 #define RAM_CONSOLE_SIG (0x43474244) /* DBGC */
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT
-static char __initdata
-	ram_console_old_log_init_buffer[CONFIG_ANDROID_RAM_CONSOLE_EARLY_SIZE];
-#endif
 static char *ram_console_old_log;
 static size_t ram_console_old_log_size;
 static const char *bootinfo;
@@ -313,16 +309,6 @@ static ssize_t ram_console_ecc_string(char *str, size_t len)
 #endif
 }
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT
-static int __init ram_console_early_init(void)
-{
-	return ram_console_init((struct ram_console_buffer *)
-		CONFIG_ANDROID_RAM_CONSOLE_EARLY_ADDR,
-		CONFIG_ANDROID_RAM_CONSOLE_EARLY_SIZE,
-		NULL,
-		ram_console_old_log_init_buffer);
-}
-#else
 static int ram_console_driver_probe(struct platform_device *pdev)
 {
 	struct resource *res = pdev->resource;
@@ -369,7 +355,6 @@ static int __init ram_console_module_init(void)
 	err = platform_driver_register(&ram_console_driver);
 	return err;
 }
-#endif
 
 static ssize_t ram_console_read_old(struct file *file, char __user *buf,
 				    size_t len, loff_t *offset)
@@ -431,16 +416,6 @@ static int __init ram_console_late_init(void)
 
 	if (ram_console_old_log == NULL)
 		return 0;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT
-	ram_console_old_log = kmemdup(ram_console_old_log_init_buffer,
-					ram_console_old_log_size, GFP_KERNEL);
-	if (ram_console_old_log == NULL) {
-		printk(KERN_ERR
-		       "ram_console: failed to allocate buffer for old log\n");
-		ram_console_old_log_size = 0;
-		return 0;
-	}
-#endif
 	entry = create_proc_entry("last_kmsg", S_IFREG | S_IRUGO, NULL);
 	if (!entry) {
 		printk(KERN_ERR "ram_console: failed to create proc entry\n");
@@ -454,10 +429,6 @@ static int __init ram_console_late_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT
-console_initcall(ram_console_early_init);
-#else
 postcore_initcall(ram_console_module_init);
-#endif
 late_initcall(ram_console_late_init);
 
-- 
1.7.3.2.146.gca209

