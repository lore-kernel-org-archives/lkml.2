Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2DCUYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:24:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34756 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2DCUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:24:40 -0400
Date: Tue, 3 Apr 2012 13:24:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: serio_raw - ensure we don't block in non-blocking read
Message-ID: <20120403202432.GA18564@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid calling wait_event_interruptible() if client requested non-blocking
read, since it is not guaranteed that another thread will not consume
event after we checked if serio_raw->head != serio_raw->tail.

Also ensure we do not return 0 but keep waiting instead in blocking case,
when another thread steals "our" byte.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/serio_raw.c |   43 ++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 4494233..094d6fb 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -165,31 +165,38 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 	struct serio_raw *serio_raw = client->serio_raw;
 	char uninitialized_var(c);
 	ssize_t read = 0;
-	int retval;
+	int error = 0;
 
-	if (serio_raw->dead)
-		return -ENODEV;
+	do {
+		if (serio_raw->dead)
+			return -ENODEV;
 
-	if (serio_raw->head == serio_raw->tail && (file->f_flags & O_NONBLOCK))
-		return -EAGAIN;
+		if (serio_raw->head == serio_raw->tail &&
+		    (file->f_flags & O_NONBLOCK))
+			return -EAGAIN;
 
-	retval = wait_event_interruptible(serio_raw->wait,
-			serio_raw->head != serio_raw->tail || serio_raw->dead);
-	if (retval)
-		return retval;
+		if (count == 0)
+			break;
 
-	if (serio_raw->dead)
-		return -ENODEV;
+		while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
+			if (put_user(c, buffer++)) {
+				error = -EFAULT;
+				goto out;
+			}
+			read++;
+		}
 
-	while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
-		if (put_user(c, buffer++)) {
-			retval = -EFAULT;
+		if (read)
 			break;
-		}
-		read++;
-	}
 
-	return read ?: retval;
+		if (!(file->f_flags & O_NONBLOCK))
+			error = wait_event_interruptible(serio_raw->wait,
+					serio_raw->head != serio_raw->tail ||
+					serio_raw->dead);
+	} while (!error);
+
+out:
+	return read ?: error;
 }
 
 static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
-- 
1.7.7.6


-- 
Dmitry
