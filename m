Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab0J1TGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:06:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37339 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757152Ab0J1TGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:06:30 -0400
X-Sasl-enc: Gf2VV47IxZxy5sxkSK4YNFjy03unN2CAGqT/Sl6Gufhg 1288292787
From: jwjstone@fastmail.fm
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com
Cc: Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH] acpi: Fix the build when the video output switcher is disabled
Date: Thu, 28 Oct 2010 20:06:18 +0100
Message-Id: <1288292779-23347-1-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.7.3.2.145.g7ebee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Stone <jwjstone@fastmail.fm>

When CONFIG_ACPI_VIDEO is enabled and CONFIG_VIDEO_OUTPUT_CONTROL is disabled
the following errors occur:

drivers/built-in.o: In function `acpi_video_bus_put_one_device':
/home/jwjs/projects/linux.trees.git/drivers/acpi/video.c:1455: undefined reference to `video_output_unregister'
drivers/built-in.o: In function `acpi_video_device_find_cap':
/home/jwjs/projects/linux.trees.git/drivers/acpi/video.c:917: undefined reference to `video_output_register'

Fix this by adding ifdefs around the offending calls in acpi video.

Signed-off-by: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/acpi/video.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5cd0228..a3ec29e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -905,6 +905,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 
 	}
 
+#ifdef CONFIG_VIDEO_OUTPUT_CONTROL
 	if (acpi_video_display_switch_support()) {
 
 		if (device->cap._DCS && device->cap._DSS) {
@@ -919,6 +920,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 			kfree(name);
 		}
 	}
+#endif
 }
 
 /*
@@ -1452,7 +1454,9 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 		thermal_cooling_device_unregister(device->cooling_dev);
 		device->cooling_dev = NULL;
 	}
+#ifdef CONFIG_VIDEO_OUTPUT_CONTROL
 	video_output_unregister(device->output_dev);
+#endif
 
 	return 0;
 }
-- 
1.7.3.2.145.g7ebee

