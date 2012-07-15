Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab2GOTHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:07:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64757 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2GOTFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:31 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 08/11] fblog: cache framebuffer BLANK and SUSPEND states
Date: Sun, 15 Jul 2012 21:04:43 +0200
Message-Id: <1342379086-7583-9-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
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
index 5519f91..9b975bc 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -33,6 +33,8 @@
 enum fblog_flags {
 	FBLOG_KILLED,
 	FBLOG_OPEN,
+	FBLOG_SUSPENDED,
+	FBLOG_BLANKED,
 };
 
 struct fblog_fb {
@@ -257,6 +259,7 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 	struct fb_event *event = data;
 	struct fb_info *info = event->info;
 	struct fblog_fb *fb;
+	int *blank;
 
 	switch(action) {
 	case FB_EVENT_FB_REGISTERED:
@@ -284,6 +287,44 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 		if (fb)
 			fblog_close(fb, true);
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
1.7.11.2

