Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1AWRnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:43:39 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:50157 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab1AWRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:43:36 -0500
X-Greylist: delayed 1256 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2011 12:43:36 EST
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Probe for output switch method when searching video devices.
Date: Sun, 23 Jan 2011 18:22:34 +0100
Message-Id: <1295803354-5298-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 87.123.113.19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts one hunk of 677bd810eedce61edf15452491781ff046b92edc
"ACPI video: remove output switching control", namely the removal of
probing for _DOS/_DOD when searching for video devices.

This is needed on some Fujitsu Laptops (at least S7110, P8010) for the
ACPI backlight interface to work, as an these machines, neither ROM nor
posting methods are available, and after removal of output switching,
none of the caps triggers, which prevents the backlight search from
being entered.

Tested on a Fujitsu Lifebook S7110 and Fujitsu Lifebook P8010.
This probably fixes https://bugzilla.kernel.org/show_bug.cgi?id=27312
for the people who have no entry in /sys/class/backlight.

This is the complete list of public (starting with "_") methods implemented
on the S7110, BIOS rev 1.34:

\_SB_.PCI0.GFX0._ADR
\_SB_.PCI0.GFX0._DOS
\_SB_.PCI0.GFX0._DOD
\_SB_.PCI0.GFX0.CRT._ADR
\_SB_.PCI0.GFX0.CRT._DCS
\_SB_.PCI0.GFX0.CRT._DGS
\_SB_.PCI0.GFX0.CRT._DSS
\_SB_.PCI0.GFX0.LCD._ADR
\_SB_.PCI0.GFX0.LCD._BCL
\_SB_.PCI0.GFX0.LCD._BCM
\_SB_.PCI0.GFX0.LCD._BQC
\_SB_.PCI0.GFX0.LCD._DCS
\_SB_.PCI0.GFX0.LCD._DGS
\_SB_.PCI0.GFX0.LCD._DSS
\_SB_.PCI0.GFX0.LCD._PS0
\_SB_.PCI0.GFX0.LCD._PS3
\_SB_.PCI0.GFX0.TV._ADR
\_SB_.PCI0.GFX0.TV._DCS
\_SB_.PCI0.GFX0.TV._DGS
\_SB_.PCI0.GFX0.TV._DSS
\_SB_.PCI0.GFX0.DVI._ADR
\_SB_.PCI0.GFX0.DVI._DCS
\_SB_.PCI0.GFX0.DVI._DGS
\_SB_.PCI0.GFX0.DVI._DSS

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 drivers/acpi/video_detect.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 42d3d72..5af3479 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -82,6 +82,11 @@ long acpi_is_video_device(struct acpi_device *device)
 	if (!device)
 		return 0;
 
+	/* Is this device able to support video switching ? */
+	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOD", &h_dummy)) ||
+	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOS", &h_dummy)))
+		video_caps |= ACPI_VIDEO_OUTPUT_SWITCHING;
+
 	/* Is this device able to retrieve a video ROM ? */
 	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_ROM", &h_dummy)))
 		video_caps |= ACPI_VIDEO_ROM_AVAILABLE;
-- 
1.7.2.3

