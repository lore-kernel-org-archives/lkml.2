Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1JMKmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:42:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35213 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1JMKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:42:01 -0400
MIME-Version: 1.0
Date: Thu, 13 Oct 2011 06:42:01 -0400
Message-ID: <CAPjEYUJ6YtJGdhgxZioDaUbBm0-GWe4j1D5viE3S1zY+Pp+fjA@mail.gmail.com>
Subject: [PATCH] Platform: Detect samsung laptop quirk when initial level is zero
From: John Serock <john.serock@gmail.com>
To: gregkh@suse.de
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasonbstubbs@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Serock <john.serock@gmail.com>

This patch depends on the "Platform: Brightness quirk for samsung
laptop driver" patch from Jason Stubbs. This patch adds a check for an
initial brightness level of 0; if the level is 0, this patch changes
the brightness level to 1 before the driver attempts to detect the
brightness quirk.

The Samsung N150 netbook experiences the brightness quirk. Without
Jason's patch, the only brightness levels available on the N150 are 0,
1, and 8. This patch ensures that, when the initial brightness level
is 0, the samsang-laptop driver detects the brightness quirk on the
N150, thereby making brightness levels 0 through 8 available.

Signed-off-by: John Serock <john.serock@gmail.com>

---
diff -uprN a/drivers/platform/x86/samsung-laptop.c
b/drivers/platform/x86/samsung-laptop.c
--- a/drivers/platform/x86/samsung-laptop.c	2011-10-12 13:51:15.030779179 -0400
+++ b/drivers/platform/x86/samsung-laptop.c	2011-10-12 13:51:32.746867045 -0400
@@ -404,8 +404,9 @@ static int get_brightness(struct backlig

 static void check_for_stepping_quirk(void)
 {
-	u8 initial_level = read_brightness();
+	u8 initial_level;
 	u8 check_level;
+	u8 orig_level = read_brightness();

 	/*
 	 * Some laptops exhibit the strange behaviour of stepping toward
@@ -414,6 +415,11 @@ static void check_for_stepping_quirk(voi
 	 * around in set_brightness.
 	 */

+	if (orig_level == 0)
+		set_brightness(1);
+
+	initial_level = read_brightness();
+
 	if (initial_level <= 2)
 		check_level = initial_level + 2;
 	else
@@ -427,7 +433,7 @@ static void check_for_stepping_quirk(voi
 		pr_info("enabled workaround for brightness stepping quirk\n");
 	}

-	set_brightness(initial_level);
+	set_brightness(orig_level);
 }

 static int update_status(struct backlight_device *bd)
