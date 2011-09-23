Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1IWMKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:10:22 -0400
Received: from mx20.lb01.inode.at ([62.99.145.22]:45164 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753695Ab1IWMKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:10:15 -0400
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mx3fb: fix NULL pointer dereference in screen blanking.
Date: Fri, 23 Sep 2011 14:09:35 +0200
Message-Id: <1316779775-12730-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.6.2
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p8NCA7g4006562
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1317384608.20954@9yVOSmmxTRpWrl32mlb59A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Stering <wolfram.stering@hale.at>

When blanking an already blanked framebuffer, a kernel NULL pointer
dereference occurred, because mx3fb driver handles all kinds of screen
blanking (normal, vsync suspend, powerdown) in the same way.
Certain programs (Xorg X11 server) first do a normal blank, followed by
a powerdown blank, which triggered the bug.

Add an additional safeguard and make sdc_disable_channel() safe against
multiple calls independent of other logic.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/video/mx3fb.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7e3a490..286be99 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -382,6 +382,9 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 	uint32_t enabled;
 	unsigned long flags;
 
+	if (mx3_fbi->txd == NULL)
+		return;
+
 	spin_lock_irqsave(&mx3fb->lock, flags);
 
 	enabled = sdc_fb_uninit(mx3_fbi);
@@ -986,9 +989,19 @@ static void __blank(int blank, struct fb_info *fbi)
 {
 	struct mx3fb_info *mx3_fbi = fbi->par;
 	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	int was_blank = mx3_fbi->blank;
 
 	mx3_fbi->blank = blank;
 
+	/* Attention!
+	 * Do not call sdc_disable_channel() for a channel that is disabled
+	 * already! This will result in a kernel NULL pointer dereference
+	 * (mx3_fbi->txd is NULL). Hide the fact, that all blank modes are
+	 * handled equally by this driver.
+	 */
+	if (blank > FB_BLANK_UNBLANK && was_blank > FB_BLANK_UNBLANK)
+		return;
+
 	switch (blank) {
 	case FB_BLANK_POWERDOWN:
 	case FB_BLANK_VSYNC_SUSPEND:
-- 
1.7.6.2



--
Scanned by MailScanner.

