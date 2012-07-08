Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2GHV6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:58:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2GHV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:57:05 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de,
        linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, bonbons@linux-vserver.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 08/11] fblog: cache framebuffer BLANK and SUSPEND states
Date: Sun,  8 Jul 2012 23:56:51 +0200
Message-Id: <1341784614-2797-9-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must cache these states so we will never draw to the framebuffer while
it is suspended or blanked.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index b490dba..fd1f3d6 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -31,6 +31,8 @@
 enum fblog_flags {
 	FBLOG_KILLED,
 	FBLOG_OPEN,
+	FBLOG_SUSPENDED,
+	FBLOG_BLANKED,
 };
 
 struct fblog_fb {
@@ -255,6 +257,7 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 	struct fb_event *event = data;
 	struct fb_info *info = event->info;
 	struct fblog_fb *fb;
+	int *blank;
 
 	switch(action) {
 	case FB_EVENT_FB_REGISTERED:
@@ -280,6 +283,44 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 		if (fb)
 			fblog_close(fb, true, true);
 		break;
+	case FB_EVENT_SUSPEND:
+		/* This is called when the low-level display driver suspends the
+		 * video system. We should not access the video system while it
+		 * is suspended. This is called with the console lock held. */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (fb)
+			set_bit(FBLOG_SUSPENDED, &fb->flags);
+		break;
+	case FB_EVENT_RESUME:
+		/* This is called when the low-level display driver resumes
+		 * operating. It is called with the console lock held. */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (fb)
+			clear_bit(FBLOG_SUSPENDED, &fb->flags);
+		break;
+	case FB_EVENT_BLANK:
+		/* This gets called _after_ the framebuffer was successfully
+		 * blanked. The console-lock is always held while fb_blank is
+		 * called and during this callback. */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (!fb)
+			break;
+
+		blank = (int*)event->data;
+		if (*blank == FB_BLANK_UNBLANK)
+			clear_bit(FBLOG_BLANKED, &fb->flags);
+		else
+			set_bit(FBLOG_BLANKED, &fb->flags);
+		break;
 	}
 
 	return 0;
-- 
1.7.11.1

