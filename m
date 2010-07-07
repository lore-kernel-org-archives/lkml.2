Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab0GGGDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:03:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45249 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0GGGDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cZpB6M44dcJaRA6h8wSo8gpcsH4B80hpvYMzjTAD1B2rI7sE2Cgu9aQbtrhSWRlR+a
         4i89MnQgPIUgcKS2Kl7yUSpcjVET0lmhsgsWl9wVi2l7SMxJumeIkXg9KP/aE8fNuLvH
         1nMIFf8tMHsGtwB/8AmwsJootvNhDLK3Dj9BA=
Subject: [PATCH 1/2] toshiba_acpi: make remove_device() and add_device()
	void
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Wed, 07 Jul 2010 14:03:50 +0800
Message-Id: <1278482630.12801.30.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove_device() and add_device() are not related to ACPI APIs,
it does not make sense to return acpi_status for both functions.

Current implementation of add_device() always AE_OK, thus the return
value checking for add_device() always return false for ACPI_FAILURE(status).
This patch makes add_device() to be void and remove the unnecessary
return value checking.

remove_proc_entry() won't fail, thus change remove_device() to be void.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 37aa147..702869a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -720,25 +720,22 @@ static const struct file_operations version_proc_fops = {
 
 #define PROC_TOSHIBA		"toshiba"
 
-static acpi_status __init add_device(void)
+static void __init add_device(void)
 {
 	proc_create("lcd", S_IRUGO | S_IWUSR, toshiba_proc_dir, &lcd_proc_fops);
 	proc_create("video", S_IRUGO | S_IWUSR, toshiba_proc_dir, &video_proc_fops);
 	proc_create("fan", S_IRUGO | S_IWUSR, toshiba_proc_dir, &fan_proc_fops);
 	proc_create("keys", S_IRUGO | S_IWUSR, toshiba_proc_dir, &keys_proc_fops);
 	proc_create("version", S_IRUGO, toshiba_proc_dir, &version_proc_fops);
-
-	return AE_OK;
 }
 
-static acpi_status remove_device(void)
+static void remove_device(void)
 {
 	remove_proc_entry("lcd", toshiba_proc_dir);
 	remove_proc_entry("video", toshiba_proc_dir);
 	remove_proc_entry("fan", toshiba_proc_dir);
 	remove_proc_entry("keys", toshiba_proc_dir);
 	remove_proc_entry("version", toshiba_proc_dir);
-	return AE_OK;
 }
 
 static struct backlight_ops toshiba_backlight_data = {
@@ -921,7 +918,6 @@ static void toshiba_acpi_exit(void)
 
 static int __init toshiba_acpi_init(void)
 {
-	acpi_status status = AE_OK;
 	u32 hci_result;
 	bool bt_present;
 	int ret = 0;
@@ -969,11 +965,7 @@ static int __init toshiba_acpi_init(void)
 		toshiba_acpi_exit();
 		return -ENODEV;
 	} else {
-		status = add_device();
-		if (ACPI_FAILURE(status)) {
-			toshiba_acpi_exit();
-			return -ENODEV;
-		}
+		add_device();
 	}
 
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
-- 
1.5.4.3



