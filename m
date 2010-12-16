Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0LPPOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:14:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325Ab0LPPOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:14:46 -0500
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] mbp_nvidia_bl: Check that the backlight control functions
Date: Thu, 16 Dec 2010 10:13:49 -0500
Message-Id: <1292512430-13291-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1292512430-13291-1-git-send-email-mjg@redhat.com>
References: <1292512430-13291-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMI-based backlight control functionality may fail to work if the
system is running under EFI rather than BIOS. Check that the hardware
responds as expected, and exit if it doesn't.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 984699b..11f6c47 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -143,6 +143,7 @@ static int __devinit mb_bl_add(struct acpi_device *dev)
 {
 	struct backlight_properties props;
 	struct pci_dev *host;
+	int intensity;
 
 	host = pci_get_bus_and_slot(0, 0);
 
@@ -163,6 +164,18 @@ static int __devinit mb_bl_add(struct acpi_device *dev)
 		return -ENODEV;
 	}
 
+	/* Check that the hardware responds - this may not work under EFI */
+
+	intensity = hw_data->backlight_ops.get_brightness(NULL);
+
+	if (!intensity) {
+		hw_data->set_brightness(1);
+		if (!hw_data->backlight_ops.get_brightness(NULL))
+			return -ENODEV;
+
+		hw_data->set_brightness(0);
+	}
+
 	if (!request_region(hw_data->iostart, hw_data->iolen,
 			    "Macbook backlight"))
 		return -ENXIO;
-- 
1.7.3.3

