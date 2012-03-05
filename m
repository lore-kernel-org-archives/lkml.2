Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2CEJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:10:58 -0500
Received: from fb1.tech.numericable.fr ([82.216.111.51]:60239 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2CEJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:10:56 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2012 04:10:55 EST
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / Video: blacklist some samsung laptops
Date: Mon,  5 Mar 2012 10:01:20 +0100
Message-Id: <1330938083-10873-1-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvddtucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
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
---
 drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

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
1.7.3.4

