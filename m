Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab2AGOM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 09:12:59 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:59849 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2AGOM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 09:12:57 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        =?UTF-8?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH] ACPI / Video: blacklist some samsung laptops
Date: Sat,  7 Jan 2012 15:12:38 +0100
Message-Id: <1325945558-4661-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120105150832.GA25386@ubuntu-macmini>
References: <20120105150832.GA25386@ubuntu-macmini>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On these laptops, the ACPI video is not functional, and very unlikely
to be fixed by the vendor. Note that intel_backlight works for some
of these laptops, and the backlight from samsung-laptop always work.

The good news is that newer laptops have functional ACPI video device
and won't end up growing this list.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---

Could the concerned people test this patch and check that it correctly
disable the acpi_video backlight ?

 drivers/acpi/video_detect.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 45d8097..376bce2 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,44 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
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
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +202,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {
-- 
1.7.5.4

