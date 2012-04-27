Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab2D0Oy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760336Ab2D0OyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:54:24 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: pjones@redhat.com, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] efifb: Skip DMI checks if the bootloader knows what it's doing
Date: Fri, 27 Apr 2012 10:54:11 -0400
Message-Id: <1335538451-4395-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of the DMI checks in efifb are for cases where the bootloader
has provided invalid information. However, on some machines the overrides
may do more harm than good due to configuration differences between machines
with the same machine identifier. It turns out that it's possible for the
bootloader to get the correct information on GOP-based systems, but we
can't guarantee that the kernel's being booted with one that's been updated
to do so. Add support for a capabilities flag that can be set by the
bootloader, and skip the DMI checks in that case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/efifb.c       |    4 +++-
 include/linux/screen_info.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index b4a632a..932abaa 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -553,7 +553,9 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
-	dmi_check_system(dmi_system_table);
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
+	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
+		dmi_check_system(dmi_system_table);
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 899fbb4..fb3c5a8 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -68,6 +68,8 @@ struct screen_info {
 
 #define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
 
+#define VIDEO_CAPABILITY_SKIP_QUIRKS	(1 << 0)
+
 #ifdef __KERNEL__
 extern struct screen_info screen_info;
 
-- 
1.7.10

