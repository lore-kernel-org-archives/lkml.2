Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2FYLuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:50:15 -0400
Received: from mail19.svc.cra.dublin.eircom.net ([159.134.118.218]:43665 "HELO
	mail19.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756079Ab2FYLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:50:14 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 07:50:14 EDT
From: Dave Airlie <airlied@redhat.com>
To: len.brown@intel.com, torvalds@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: Igor Murzov <intergalactic.anonymous@gmail.com>, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Still use ACPI backlight control if _DOS doesn't exist
Date: Mon, 25 Jun 2012 12:38:56 +0100
Message-Id: <1340624336-15048-1-git-send-email-airlied@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a regression introduced by commit
ea9f8856bd6d4ed45885b06a338f7362cd6c60e5

https://bugzilla.kernel.org/show_bug.cgi?id=43168

Some platforms don't have _DOS control method, but the ACPI
backlight still works.
We do not want to lose the backlight control ability on these platforms.

[airlied: this is breaking nouveau really badly on 3.4 and after and there is
no movement on sending it upstream, so please apply]

Cc: Igor Murzov <intergalactic.anonymous@gmail.com>
Cc: stable@vger.kernel.org
Cc: len.brown@intel.com
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/video.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: rtd3/drivers/acpi/video.c
===================================================================
--- rtd3.orig/drivers/acpi/video.c
+++ rtd3/drivers/acpi/video.c
@@ -565,8 +565,14 @@ acpi_video_bus_DOS(struct acpi_video_bus
 	video->dos_setting = arg0.integer.value;
 	status = acpi_evaluate_object(video->device->handle, "_DOS",
 		&args, NULL);
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	if (ACPI_FAILURE(status)) {
+		/*
+		 * some platforms don't have _DOS, but the ACPI
+		 * backlight control still works
+		 */
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No _DOS\n"));
+		return 0;
+	}
 
 	return 0;
 }
