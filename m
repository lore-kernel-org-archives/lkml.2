Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2BHDZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:25:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2BHDZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:41 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 3/5] Input: serio_raw - factor out common pattern of write
Date: Wed,  8 Feb 2012 11:24:55 +0800
Message-Id: <1328671497-20880-4-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As write to /dev/serio_raw* and to /sys/kernel/debug/serio_raw*/device
share a common pattern, this patch extracts that pattern and put it in
the serio_raw_write_mainloop() function.

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index bc2a8c7..5d13c64 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -269,12 +269,12 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 			serio_raw_fetch_byte);
 }
 
-static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
-			       size_t count, loff_t *ppos)
+static ssize_t serio_raw_write_mainloop(struct serio_raw *serio_raw,
+		const char __user *buffer, size_t count,
+		bool write_to_dev, struct queue *queue)
 {
-	struct serio_raw_client *client = file->private_data;
-	struct serio_raw *serio_raw = client->serio_raw;
 	ssize_t written = 0;
+	bool wakeup = false;
 	int retval;
 	unsigned char c;
 
@@ -293,20 +293,33 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
 	while (count--) {
 		if (get_user(c, buffer++)) {
 			retval = -EFAULT;
-			goto out;
+			break;
 		}
-		if (serio_write(serio_raw->serio, c)) {
+		if (write_to_dev && serio_write(serio_raw->serio, c)) {
 			retval = -EIO;
-			goto out;
+			break;
 		}
+		if (queue)
+			wakeup |= queue_write_byte(queue, c);
 		written++;
 	}
+	if (queue && wakeup)
+		queue_wakeup(queue);
 
 out:
 	mutex_unlock(&serio_raw_mutex);
 	return written ?: retval;
 }
 
+static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *ppos)
+{
+	struct serio_raw_client *client = file->private_data;
+	struct serio_raw *serio_raw = client->serio_raw;
+
+	return serio_raw_write_mainloop(serio_raw, buffer, count, true, NULL);
+}
+
 static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
 {
 	struct serio_raw_client *client = file->private_data;
-- 
1.7.7.3

