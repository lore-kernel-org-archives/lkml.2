Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2FPWGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:06:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33059 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2FPWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:04:56 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 07/10] fblog: forward kernel log messages to all framebuffers
Date: Sun, 17 Jun 2012 00:04:23 +0200
Message-Id: <1339884266-9201-8-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a console-driver that forwards all log messages to all
framebuffers and redraws them.

To avoid redrawing multiple times in short intervals, we could use a
work-queue here by simply pushing the task onto the system work-queue.
However, fblog is not performance critical and only used for debugging so
we avoid the complexity for now. This may change in the future, though.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 9b05c56..5297eca 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -449,6 +449,25 @@ static void fblog_deactivate(void)
 	fblog_unregister_all();
 }
 
+static void fblog_con_write(struct console *con, const char *buf,
+			    unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < FB_MAX; ++i) {
+		if (fblog_fbs[i]) {
+			fblog_buf_write(&fblog_fbs[i]->buf, buf, len);
+			fblog_redraw(fblog_fbs[i]);
+		}
+	}
+}
+
+static struct console fblog_con_driver = {
+	.name = "fblog",
+	.write = fblog_con_write,
+	.flags = CON_PRINTBUFFER | CON_ENABLED,
+};
+
 static ssize_t fblog_dev_active_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
-- 
1.7.10.4

