Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582Ab2CGV7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:59:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47726 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503Ab2CGV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/13] android: ram_console: move footer strings
Date: Wed,  7 Mar 2012 13:58:13 -0800
Message-Id: <1331157503-3413-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-3270-0000-0000-0000049FA00C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Don't store the bootinfo string and the ecc status string with
the recovered old log data.  This will simplify refactoring the
persistent ram code out of the ram console code later.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I883bb6eec5bad5c1b1247da807e982e744fe40ba
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ram_console.c |  115 +++++++++++++++++++-------------
 1 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index f01a0c4..2310a79 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -42,6 +42,8 @@ static char __initdata
 #endif
 static char *ram_console_old_log;
 static size_t ram_console_old_log_size;
+static const char *bootinfo;
+static size_t bootinfo_size;
 
 static struct ram_console_buffer *ram_console_buffer;
 static size_t ram_console_buffer_size;
@@ -156,20 +158,13 @@ void ram_console_enable_console(int enabled)
 }
 
 static void __init
-ram_console_save_old(struct ram_console_buffer *buffer, const char *bootinfo,
-	char *dest)
+ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
 {
 	size_t old_log_size = buffer->size;
-	size_t bootinfo_size = 0;
-	size_t total_size = old_log_size;
-	char *ptr;
-	const char *bootinfo_label = "Boot info:\n";
 
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	uint8_t *block;
 	uint8_t *par;
-	char strbuf[80];
-	int strbuf_len = 0;
 
 	block = buffer->data;
 	par = ram_console_par_buffer;
@@ -195,24 +190,10 @@ ram_console_save_old(struct ram_console_buffer *buffer, const char *bootinfo,
 		block += ECC_BLOCK_SIZE;
 		par += ECC_SIZE;
 	}
-	if (ram_console_corrected_bytes || ram_console_bad_blocks)
-		strbuf_len = snprintf(strbuf, sizeof(strbuf),
-			"\n%d Corrected bytes, %d unrecoverable blocks\n",
-			ram_console_corrected_bytes, ram_console_bad_blocks);
-	else
-		strbuf_len = snprintf(strbuf, sizeof(strbuf),
-				      "\nNo errors detected\n");
-	if (strbuf_len >= sizeof(strbuf))
-		strbuf_len = sizeof(strbuf) - 1;
-	total_size += strbuf_len;
 #endif
 
-	if (bootinfo)
-		bootinfo_size = strlen(bootinfo) + strlen(bootinfo_label);
-	total_size += bootinfo_size;
-
 	if (dest == NULL) {
-		dest = kmalloc(total_size, GFP_KERNEL);
+		dest = kmalloc(old_log_size, GFP_KERNEL);
 		if (dest == NULL) {
 			printk(KERN_ERR
 			       "ram_console: failed to allocate buffer\n");
@@ -221,27 +202,15 @@ ram_console_save_old(struct ram_console_buffer *buffer, const char *bootinfo,
 	}
 
 	ram_console_old_log = dest;
-	ram_console_old_log_size = total_size;
+	ram_console_old_log_size = old_log_size;
 	memcpy(ram_console_old_log,
 	       &buffer->data[buffer->start], buffer->size - buffer->start);
 	memcpy(ram_console_old_log + buffer->size - buffer->start,
 	       &buffer->data[0], buffer->start);
-	ptr = ram_console_old_log + old_log_size;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	memcpy(ptr, strbuf, strbuf_len);
-	ptr += strbuf_len;
-#endif
-	if (bootinfo) {
-		memcpy(ptr, bootinfo_label, strlen(bootinfo_label));
-		ptr += strlen(bootinfo_label);
-		memcpy(ptr, bootinfo, bootinfo_size);
-		ptr += bootinfo_size;
-	}
 }
 
 static int __init ram_console_init(struct ram_console_buffer *buffer,
-				   size_t buffer_size, const char *bootinfo,
-				   char *old_buf)
+				   size_t buffer_size, char *old_buf)
 {
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	int numerr;
@@ -308,7 +277,7 @@ static int __init ram_console_init(struct ram_console_buffer *buffer,
 			printk(KERN_INFO "ram_console: found existing buffer, "
 			       "size %d, start %d\n",
 			       buffer->size, buffer->start);
-			ram_console_save_old(buffer, bootinfo, old_buf);
+			ram_console_save_old(buffer, old_buf);
 		}
 	} else {
 		printk(KERN_INFO "ram_console: no valid data in buffer "
@@ -326,6 +295,24 @@ static int __init ram_console_init(struct ram_console_buffer *buffer,
 	return 0;
 }
 
+static ssize_t ram_console_ecc_string(char *str, size_t len)
+{
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	ssize_t ret;
+
+	if (ram_console_corrected_bytes || ram_console_bad_blocks)
+		ret = snprintf(str, len, ""
+			"\n%d Corrected bytes, %d unrecoverable blocks\n",
+			ram_console_corrected_bytes, ram_console_bad_blocks);
+	else
+		ret = snprintf(str, len, "\nNo errors detected\n");
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT
 static int __init ram_console_early_init(void)
 {
@@ -342,7 +329,6 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 	size_t start;
 	size_t buffer_size;
 	void *buffer;
-	const char *bootinfo = NULL;
 	struct ram_console_platform_data *pdata = pdev->dev.platform_data;
 
 	if (res == NULL || pdev->num_resources != 1 ||
@@ -361,10 +347,13 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (pdata)
-		bootinfo = pdata->bootinfo;
+	if (pdata) {
+		bootinfo = kstrdup(pdata->bootinfo, GFP_KERNEL);
+		if (bootinfo)
+			bootinfo_size = strlen(bootinfo);
+	}
 
-	return ram_console_init(buffer, buffer_size, bootinfo, NULL/* allocate */);
+	return ram_console_init(buffer, buffer_size, NULL/* allocate */);
 }
 
 static struct platform_driver ram_console_driver = {
@@ -387,14 +376,46 @@ static ssize_t ram_console_read_old(struct file *file, char __user *buf,
 {
 	loff_t pos = *offset;
 	ssize_t count;
+	char *str;
+	int ret;
+
+	/* Main last_kmsg log */
+	if (pos < ram_console_old_log_size) {
+		count = min(len, (size_t)(ram_console_old_log_size - pos));
+		if (copy_to_user(buf, ram_console_old_log + pos, count))
+			return -EFAULT;
+		goto out;
+	}
 
-	if (pos >= ram_console_old_log_size)
-		return 0;
+	/* ECC correction notice */
+	pos -= ram_console_old_log_size;
+	count = ram_console_ecc_string(NULL, 0);
+	if (pos < count) {
+		str = kmalloc(count, GFP_KERNEL);
+		if (!str)
+			return -ENOMEM;
+		ram_console_ecc_string(str, count + 1);
+		count = min(len, (size_t)(count - pos));
+		ret = copy_to_user(buf, str + pos, count);
+		kfree(str);
+		if (ret)
+			return -EFAULT;
+		goto out;
+	}
 
-	count = min(len, (size_t)(ram_console_old_log_size - pos));
-	if (copy_to_user(buf, ram_console_old_log + pos, count))
-		return -EFAULT;
+	/* Boot info passed through pdata */
+	pos -= count;
+	if (pos < bootinfo_size) {
+		count = min(len, (size_t)(bootinfo_size - pos));
+		if (copy_to_user(buf, bootinfo + pos, count))
+			return -EFAULT;
+		goto out;
+	}
+
+	/* EOF */
+	return 0;
 
+out:
 	*offset += count;
 	return count;
 }
-- 
1.7.3.2.146.gca209

