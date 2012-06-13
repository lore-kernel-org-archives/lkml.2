Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2FMHcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:32:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60350 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2FMHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:32:16 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] acpi: add a way to promote/demote vendor backlight drivers
Date: Wed, 13 Jun 2012 09:32:01 +0200
Message-Id: <1339572727-24744-2-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
References: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of adding a big blacklist in video_detect.c to set
ACPI_VIDEO_BACKLIGHT_DMI_VENDOR correctly, let external modules
promote or demote themselves when they know the generic video
module won't work.

Currently drivers where using acpi_video_unregister() directly
but:
- That didn't respect any acpi_backlight=[video|vendor] parameter
  provided by the user.
- Any later call to acpi_video_register() would still re-load the
  generic video module (and some gpu drivers are doing that).

This patch fix those two issues.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/acpi/video_detect.c |   31 +++++++++++++++++++++++++++++--
 include/linux/acpi.h        |   10 ++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 45d8097..942fa2a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -182,8 +182,7 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 }
 EXPORT_SYMBOL(acpi_video_get_capabilities);
 
-/* Returns true if video.ko can do backlight switching */
-int acpi_video_backlight_support(void)
+static void acpi_video_caps_check(void)
 {
 	/*
 	 * We must check whether the ACPI graphics device is physically plugged
@@ -191,6 +190,34 @@ int acpi_video_backlight_support(void)
 	 */
 	if (!acpi_video_caps_checked)
 		acpi_video_get_capabilities(NULL);
+}
+
+/* Promote the vendor interface instead of the generic video module.
+ * This function allow DMI blacklists to be implemented by externals
+ * platform drivers instead of putting a big blacklist in video_detect.c
+ * After calling this function you will probably want to call
+ * acpi_video_unregister() to make sure the video module is not loaded
+ */
+void acpi_video_dmi_promote_vendor(void)
+{
+	acpi_video_caps_check();
+	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+}
+EXPORT_SYMBOL(acpi_video_dmi_promote_vendor);
+
+/* To be called when a driver who previously promoted the vendor
+ * interface */
+void acpi_video_dmi_demote_vendor(void)
+{
+	acpi_video_caps_check();
+	acpi_video_support &= ~ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+}
+EXPORT_SYMBOL(acpi_video_dmi_demote_vendor);
+
+/* Returns true if video.ko can do backlight switching */
+int acpi_video_backlight_support(void)
+{
+	acpi_video_caps_check();
 
 	/* First check for boot param -> highest prio */
 	if (acpi_video_support & ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f421dd8..27ab201 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -190,6 +190,8 @@ extern bool wmi_has_guid(const char *guid);
 
 extern long acpi_video_get_capabilities(acpi_handle graphics_dev_handle);
 extern long acpi_is_video_device(struct acpi_device *device);
+extern void acpi_video_dmi_promote_vendor(void);
+extern void acpi_video_dmi_demote_vendor(void);
 extern int acpi_video_backlight_support(void);
 extern int acpi_video_display_switch_support(void);
 
@@ -205,6 +207,14 @@ static inline long acpi_is_video_device(struct acpi_device *device)
 	return 0;
 }
 
+static inline void acpi_video_dmi_promote_vendor(void)
+{
+}
+
+static inline void acpi_video_dmi_demote_vendor(void)
+{
+}
+
 static inline int acpi_video_backlight_support(void)
 {
 	return 0;
-- 
1.7.9.5

