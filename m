Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0HCKFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:05:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab0HCKFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:05:07 -0400
Date: Tue, 3 Aug 2010 12:05:05 +0200
From: Matthias Hopf <mhopf@suse.de>
To: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, oneukum@suse.de
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / PM: Traverse video_device_list for backlight
	restoration
Message-ID: <20100803100505.GA26948@suse.de>
Mail-Followup-To: Zhang Rui <rui.zhang@intel.com>,
	Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Julia Lawall <julia@diku.dk>, oneukum@suse.de,
	linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ACPI-PM-Traverse-video_device_list-for-backlight.patch"
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.bind_info in active_list[] is NULL by construction - and used to determine
the acpi_video_device pointer during backlight restoration during resume.

Using the list instead fixes backlight restoration for systems where the BIOS
doesn't do this by itself already.

Signed-off-by: Matthias Hopf <mhopf@suse.de>
---
 drivers/acpi/video.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 9865d46..887ac2b 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -2346,7 +2346,6 @@ static int acpi_video_resume(struct notifier_block *nb,
 {
 	struct acpi_video_bus *video;
 	struct acpi_video_device *video_device;
-	int i;
 
 	switch (val) {
 	case PM_HIBERNATION_PREPARE:
@@ -2359,11 +2358,12 @@ static int acpi_video_resume(struct notifier_block *nb,
 
 	dev_info(&video->device->dev, "Restoring backlight state\n");
 
-	for (i = 0; i < video->attached_count; i++) {
-		video_device = video->attached_array[i].bind_info;
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(video_device, &video->video_device_list, entry) {
 		if (video_device && video_device->backlight)
 			acpi_video_set_brightness(video_device->backlight);
 	}
+	mutex_unlock(&video->device_list_lock);
 
 	return NOTIFY_OK;
 }
-- 
1.6.0.2

