Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab2C3LSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:18:50 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab2C3LSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 57/76] ACPI / Video: blacklist some samsung laptops
Date: Fri, 30 Mar 2012 06:14:00 -0400
Message-id: <0e569b120d19c35dcc4f5549956cd884c3241270.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentincj@iksaif.net>

On these laptops, the ACPI video is not functional, and very unlikely
to be fixed by the vendor. Note that intel_backlight works for some
of these laptops, and the backlight from samsung-laptop always work.

The good news is that newer laptops have functional ACPI video device
and won't end up growing this list.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f3f0fe7..b6f6979 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,53 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
+/* Force to use vendor driver when the ACPI device is known to be
+ * buggy */
+static int video_detect_force_vendor(const struct dmi_system_id *d)
+{
+	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+	return 0;
+}
+
+static struct dmi_system_id video_detect_dmi_table[] = {
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "N150P",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
+		DMI_MATCH(DMI_BOARD_NAME, "N150P"),
+		},
+	},
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "N145P/N250P/N260P",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
+		DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
+		},
+	},
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "N150/N210/N220",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
+		DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
+		},
+	},
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "NF110/NF210/NF310",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
+		DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
+		},
+	},
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +211,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {
-- 
1.7.10.rc2.19.gfae9d

