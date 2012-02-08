Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2BHDZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:25:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2BHDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:38 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 1/5] Input: serio_raw - return proper result when serio_raw_read fails
Date: Wed,  8 Feb 2012 11:24:53 +0800
Message-Id: <1328671497-20880-2-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio_raw_read now returns (sometimes partially) successful number of
bytes transferred to the caller, and only returns error code to the
caller on completely failed transfers.

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 8250299..4494233 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -164,7 +164,8 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
 	char uninitialized_var(c);
-	ssize_t retval = 0;
+	ssize_t read = 0;
+	int retval;
 
 	if (serio_raw->dead)
 		return -ENODEV;
@@ -180,13 +181,15 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 	if (serio_raw->dead)
 		return -ENODEV;
 
-	while (retval < count && serio_raw_fetch_byte(serio_raw, &c)) {
-		if (put_user(c, buffer++))
-			return -EFAULT;
-		retval++;
+	while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
+		if (put_user(c, buffer++)) {
+			retval = -EFAULT;
+			break;
+		}
+		read++;
 	}
 
-	return retval;
+	return read ?: retval;
 }
 
 static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
-- 
1.7.7.3

