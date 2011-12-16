Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab1LPSH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:07:28 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51142 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348Ab1LPSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:07:13 -0500
From: Dima Zavin <dima@android.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>, Jeff Brown <jeffbrown@android.com>
Subject: [PATCH 3/3] input: evdev: do not block waiting for an event if fd is nonblock
Date: Fri, 16 Dec 2011 10:07:06 -0800
Message-Id: <1324058826-12891-3-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324058826-12891-1-git-send-email-dima@android.com>
References: <1324058826-12891-1-git-send-email-dima@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a full packet in the buffer, and we overflow that buffer
right after checking for that condition, it would have been possible
for us to block indefinitely (rather, until the next full packet) even if
the file was marked as O_NONBLOCK.

Cc: Jeff Brown <jeffbrown@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 drivers/input/evdev.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2e563af..2fb77e1 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -391,14 +391,12 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	if (count < input_event_size())
 		return -EINVAL;
 
-	if (client->packet_head == client->tail && evdev->exist &&
-	    (file->f_flags & O_NONBLOCK))
-		return -EAGAIN;
-
-	retval = wait_event_interruptible(evdev->wait,
-		client->packet_head != client->tail || !evdev->exist);
-	if (retval)
-		return retval;
+	if (!(file->f_flags & O_NONBLOCK)) {
+		retval = wait_event_interruptible(evdev->wait,
+			 client->packet_head != client->tail || !evdev->exist);
+		if (retval)
+			return retval;
+	}
 
 	if (!evdev->exist)
 		return -ENODEV;
-- 
1.7.3.1

