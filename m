Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab1ANTZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:25:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210Ab1ANTZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:25:19 -0500
From: Matthew Garrett <mjg@redhat.com>
To: akpm@linux-foundation.org
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if possible
Date: Fri, 14 Jan 2011 14:24:25 -0500
Message-Id: <1295033065-13450-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1295033065-13450-1-git-send-email-mjg@redhat.com>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dual-GPU machines may provide more than one ACPI backlight interface. Tie
the backlight device to the GPU in order to allow userspace to identify
the correct interface.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/video.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index a9eec8c..a18e497 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -782,6 +782,9 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 
 	if (acpi_video_backlight_support()) {
 		struct backlight_properties props;
+		struct pci_dev *pdev;
+		acpi_handle acpi_parent;
+		struct device *parent = NULL;
 		int result;
 		static int count = 0;
 		char *name;
@@ -794,10 +797,20 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 			return;
 		count++;
 
+		acpi_get_parent(device->dev->handle, &acpi_parent);
+
+		pdev = acpi_get_pci_dev(acpi_parent);
+		if (pdev) {
+			parent = &pdev->dev;
+			pci_dev_put(pdev);
+		}
+
 		memset(&props, 0, sizeof(struct backlight_properties));
 		props.type = BACKLIGHT_FIRMWARE;
 		props.max_brightness = device->brightness->count - 3;
-		device->backlight = backlight_device_register(name, NULL, device,
+		device->backlight = backlight_device_register(name,
+							      parent,
+							      device,
 							      &acpi_backlight_ops,
 							      &props);
 		kfree(name);
-- 
1.7.3.4

