Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2GJDk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 23:40:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57924 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2GJDk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 23:40:58 -0400
From: Arun Raghavan <arun.raghavan@collabora.co.uk>
To: Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>
Subject: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Date: Tue, 10 Jul 2012 09:09:53 +0530
Message-Id: <1341891593-6485-1-git-send-email-arun.raghavan@collabora.co.uk>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After suspend and resume, the values of these registers seem to change
from what they were at suspend time, potentially preventing the actual
output lines from being enabled post-resume. This saves relevant state
at suspend and restores it when resumed.

This is at least required on the MacBook Pro 8.2 when the Intel GPU is
manually selected in GRUB config before the kernel is loaded.

Signed-off-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
---
 drivers/platform/x86/apple-gmux.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 694a15a..5a5d005 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -26,6 +26,11 @@ struct apple_gmux_data {
 	unsigned long iolen;
 
 	struct backlight_device *bdev;
+
+	bool was_suspended;
+	u8 save_switch_ddc;
+	u8 save_switch_disp;
+	u8 save_switch_ext;
 };
 
 /*
@@ -87,8 +92,30 @@ static int gmux_update_status(struct backlight_device *bd)
 	struct apple_gmux_data *gmux_data = bl_get_data(bd);
 	u32 brightness = bd->props.brightness;
 
-	if (bd->props.state & BL_CORE_SUSPENDED)
+	if (bd->props.state & BL_CORE_SUSPENDED) {
+		/* Save mux settings for output lines since they get reset on
+		 * suspend */
+		gmux_data->was_suspended = TRUE;
+		gmux_data->save_switch_ddc = gmux_read8(gmux_data,
+				GMUX_PORT_SWITCH_DDC);
+		gmux_data->save_switch_disp = gmux_read8(gmux_data,
+				GMUX_PORT_SWITCH_DISPLAY);
+		gmux_data->save_switch_ext = gmux_read8(gmux_data,
+				GMUX_PORT_SWITCH_EXTERNAL);
+
 		return 0;
+	}
+
+	if (gmux_data->was_suspended) {
+		/* Restore pre-suspend values for output lines */
+		gmux_data->was_suspended = FALSE;
+		gmux_write8(gmux_data, GMUX_PORT_SWITCH_DDC,
+				gmux_data->save_switch_ddc);
+		gmux_write8(gmux_data, GMUX_PORT_SWITCH_DISPLAY,
+				gmux_data->save_switch_disp);
+		gmux_write8(gmux_data, GMUX_PORT_SWITCH_EXTERNAL,
+				gmux_data->save_switch_ext);
+	}
 
 	/*
 	 * Older gmux versions require writing out lower bytes first then
-- 
1.7.8.6

