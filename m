Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2L1Tjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:39:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55374 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab2L1TSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:45 -0500
Message-Id: <20121228190349.266405443@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 091/173] acpi/video_detect: blacklist samsung x360
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Chary <corentin.chary@gmail.com>

commit 084940d5b101e9ca91a689eb5048151b14076839 upstream.

On Samsung X360, the BIOS will set a flag (VDRV) if the generic
ACPI backlight device is used. This flag will definitively break
the backlight interface (even the vendor interface) untill next
reboot. It's why we should prevent video.ko from being used here
and we can't rely on a later call to acpi_video_unregister().

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video_detect.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 942fa2a..b728880 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,33 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
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
+	/* On Samsung X360, the BIOS will set a flag (VDRV) if generic
+	 * ACPI backlight device is used. This flag will definitively break
+	 * the backlight interface (even the vendor interface) untill next
+	 * reboot. It's why we should prevent video.ko from being used here
+	 * and we can't rely on a later call to acpi_video_unregister().
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "X360",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
+		DMI_MATCH(DMI_BOARD_NAME, "X360"),
+		},
+	},
+	{ },
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +191,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {


